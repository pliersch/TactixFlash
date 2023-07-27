package game.world {
	import animatedDisplayObjects.AnimatedSprite;
	
	import core.Platoon;
	import core.Player;
	import core.Players;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import game.battlefield.Battlefield;
	
	import valueObjects.VO_Manager;
	import valueObjects.ValueObject;
	import valueObjects.world.MoveUnitsVO;

	public class Regions {
		private var _players:Players;
		private var _myPlayer:Player;
		private var _regions:Vector.<Region>;
		private var _myRegions:Vector.<Region>;
		private var _arrows:Array;
		private var newState:Event;
		private var _sprite:Sprite;
		private var _ways:Sprite;
		private var _platoonMoves:Sprite;
		private var _ownerInfo:TextField;
		private var _activePlayerRegion:Region;
		private var _activeEnemyRegion:Region;
		private var _voManager:VO_Manager;
		private var _allMoves:Vector.<MoveUnitsVO>;
		private var _moves:String;
		private var _battleArray:Array;
		private var _transferAndAttackWindow:TransferAndAttackWindow;
		private var _worldMap:WorldMap;
		private var _waysToNeighbours:Sprite;
		private var _transferTargets:Array;
		private var _transferTargetsContainer:Sprite;

		public function Regions(worldMap:WorldMap) {
			_worldMap=worldMap;
			_players=Players.instance;
			_myPlayer=_players.myPlayer;
			init();
		}

		private function init():void {
			_regions=new Vector.<Region>();
			_myRegions=new Vector.<Region>();
			_battleArray=new Array();
			_arrows=new Array();
			_sprite=new Sprite();
			_ways=new Sprite();
			_platoonMoves=new Sprite();
			_allMoves=new Vector.<MoveUnitsVO>();
			_voManager=VO_Manager.instance;
			_moves="moves: ";
			_waysToNeighbours=new Sprite();
			_transferTargetsContainer=new Sprite();
			_sprite.addChild(_ways);
			_sprite.addChild(_platoonMoves);
			_sprite.addChild(_waysToNeighbours);
			_sprite.addChild(_transferTargetsContainer);
			_sprite.addEventListener("transferEvent", transferUnits);
			initRegions();

			//FIXME: was soll das ????			
			showAllRegions(false);
			showMyRegions(false);
			showReachableRegions();
			showMyRegions(false);

			_ownerInfo=new TextField();
			_ownerInfo.autoSize=TextFieldAutoSize.LEFT;
			_ownerInfo.selectable=false;
			_ownerInfo.visible=false;
			_sprite.addChild(_ownerInfo);
		}

		private function initRegions():void {
			var owner:Player;
			var currentRegion:Region;
			var regionCounter:uint=0;
			var platoonCounter:uint=0;

			var regionPos:Array=new Array(108, 201, 250, 128, 90, 85, 202, 286, 238, 416, 802, 78, 391, 256, 435, 135, 545, 187, 294, 336, 223, 
										  74, 487, 65, 165, 147, 624, 149, 672, 220, 771, 205, 800, 395, 866, 320, 340, 56, 555, 283, 884, 399, 
										  722, 141, 754, 300, 475, 325, 667, 68, 509, 399, 477, 212, 542, 113);

			for (var j:uint=0; j < (Pref.REGIONS); j++) {
				owner=_players.getPlayerByID(j % _players.length);
				currentRegion=new Region(regionCounter, this, owner.getPlatoon(platoonCounter));
				_regions.push(currentRegion);
				currentRegion.container.x=regionPos[regionCounter * 2];
				currentRegion.container.y=regionPos[(regionCounter * 2 + 1)];
				owner.addRegion(currentRegion);
				_sprite.addChild(currentRegion.container);
				regionCounter++;
				if (j > 0 && j % _players.length == 0)
					platoonCounter++;
			}
			for (j=0; j < _regions.length; j++) {
				setNeighbours(_regions[j]);
			}
		}

		private function showAllRegions(visible:Boolean):void {
			for (var i:uint=0; i < _regions.length; i++) {
				_regions[i].container.visible=visible;
			}
		}

		private function showMyRegions(radius:Boolean):void {
			_myRegions=new Vector.<Region>;
			for (var i:uint=0; i < _regions.length; i++) {
				if (_regions[i].ownerPlatoon.owner == _myPlayer) {
					_regions[i].container.visible=true;
					_regions[i].showRegion(true);
					_regions[i].showRadius(radius);
					_myRegions.push(_regions[i]);
				}
			}
		}

		//TODO: visible:Boolean ist uncool und voll daneben
		public function showRegionInfo(ownerPlatoon:Platoon, visible:Boolean):void {
			_ownerInfo.text="Owner: " + ownerPlatoon.owner.name + "\n" + 
							"PlatoonID: " + ownerPlatoon.id + "\n" + 
							"RegionID: " + ownerPlatoon.region.id + "\n" + 
							"Sodiers: " + ownerPlatoon.getNumbersOfUnit(Platoon.SOLDIER_ID) + "\n" + 
							"Tanks: " + ownerPlatoon.getNumbersOfUnit(Platoon.TANK_ID) + "\n" + 
							"Artilleries: " + ownerPlatoon.getNumbersOfUnit(Platoon.ARTILLERIE_ID) + "\n" + 
							"Aircrafts: " + ownerPlatoon.getNumbersOfUnit(Platoon.AIRCRAFT_ID) + "\n" + 
							"Flaks: " + ownerPlatoon.getNumbersOfUnit(Platoon.FLAK_ID) + "\n" + 
							"Mechs: " + ownerPlatoon.getNumbersOfUnit(Platoon.MECH_ID);
			_ownerInfo.textColor=0xCCCCCC;
			_ownerInfo.background=true;
			_ownerInfo.backgroundColor=0;
			_ownerInfo.x=ownerPlatoon.region.container.x + 20;
			_ownerInfo.y=ownerPlatoon.region.container.y - 20;
			_ownerInfo.visible=visible;
		}

		private function showMoveAndAttackWindow():void {
			_transferAndAttackWindow=new TransferAndAttackWindow(this);
			_sprite.addChild(_transferAndAttackWindow.sprite);
			_transferAndAttackWindow.show(_activePlayerRegion.ownerPlatoon, _activeEnemyRegion.ownerPlatoon);
		}

		private function setNeighbours(region:Region):void {
			var distance:uint=0;
			for (var j:uint=0; j < _regions.length; j++) {
				distance=getDistance(region, _regions[j]);
				if (distance < 140 && region != _regions[j]) {
					region.neighbours.push(_regions[j]);
				}
			}
		}

		private function getDistance(region1:Region, region2:Region):uint {
			var x1:uint=region1.container.x;
			var x2:uint=region2.container.x;
			var y1:uint=region1.container.y;
			var y2:uint=region2.container.y;
			var height:uint=Math.abs(y1 - y2);
			var width:uint=Math.abs(x1 - x2);
			return Math.sqrt(width * width + height * height);
		}

		private function showReachableRegions():void {
			var myCurrentRegion:Region;
			var currentNeighbourRegion:Region;
			for (var i:uint=0; i < _myRegions.length; i++) {
				myCurrentRegion=_myRegions[i];
				for (var j:uint=0; j < myCurrentRegion.neighbours.length; j++) {
					currentNeighbourRegion=myCurrentRegion.neighbours[j];
					currentNeighbourRegion.container.visible=true;
					currentNeighbourRegion.showRegion(true);
					drawReachableWay(myCurrentRegion, currentNeighbourRegion, 0x666666, 5);
				}
			}
		}

		private function removeWayToNeighbours():void {
			if (_waysToNeighbours.numChildren > 0) {
				_waysToNeighbours.removeChildAt(0);
				for (var i:uint=0; i < _transferTargets.length; i++) {
					_transferTargetsContainer.removeChild(_transferTargets[i]);
				}
				_transferTargets=new Array();
			}
		}

		public function handleWayToNeighbours(region:Region):void {
			removeWayToNeighbours();
			_activePlayerRegion=region;
			var ways:Sprite=new Sprite();
			ways.graphics.lineStyle(3, 0xFFFFFF);
			for (var i:uint=0; i < region.neighbours.length; i++) {
				ways.graphics.moveTo(region.container.x, region.container.y);
				ways.graphics.lineTo(region.neighbours[i].container.x, region.neighbours[i].container.y);
			}
			_waysToNeighbours.addChild(ways);
			_transferTargets=new Array();
			for (i=0; i < region.neighbours.length; i++) {
				var oldWidth:int=(region.neighbours[i].container.x - region.container.x);
				var oldHeight:int=(region.neighbours[i].container.y - region.container.y);
				var lenght:uint=Math.sqrt(oldWidth * oldWidth + oldHeight * oldHeight);
				var symbolDistanceToRegion:uint=lenght - 30;
				var factor:Number=symbolDistanceToRegion / lenght;
				var transferSymbol:TransferSymbol=new TransferSymbol(region.neighbours[i].id);
				transferSymbol.x=oldWidth * factor + region.container.x;
				transferSymbol.y=oldHeight * factor + region.container.y;
				_transferTargetsContainer.addChild(transferSymbol);
				_transferTargets.push(transferSymbol);
			}
		}

		public function addMyMoves(soldiers:uint, tanks:uint, artilleries:uint, aircrafts:uint, mechs:uint, flags:uint):void {
			var newUnits:uint=soldiers + tanks + aircrafts + artilleries + mechs + flags;
			var allUnits:uint=0;
			if (newUnits != _activePlayerRegion.ownerPlatoon.platoonCount) {
				var isNewMove:Boolean=true;
				var vo:MoveUnitsVO;
				for (var i:uint=0; i < _voManager.length; i++) {
					vo=_voManager.getElementAt(i) as MoveUnitsVO;
					if (_activePlayerRegion.id == vo.offenerRegionID && _activeEnemyRegion.id == vo.defenderRegionID) {
						vo.soldiers+=soldiers;
						vo.tanks+=tanks;
						vo.artilleries+=artilleries;
						vo.aircrafts+=aircrafts;
						vo.mechs+=mechs;
						vo.flags+=flags;
						allUnits=vo.soldiers + vo.tanks + vo.artilleries + vo.aircrafts + vo.flags + vo.mechs;
						isNewMove=false;
					}
				}
				if (isNewMove) {
					var tmpPlatoon:Platoon=new Platoon(_myPlayer, _myPlayer.getUniquePlatoonID(), soldiers, tanks, artilleries, aircrafts, mechs, flags);
					_myPlayer.addPlatoon(tmpPlatoon);
					tmpPlatoon.region=_activePlayerRegion;
					allUnits = newUnits;
					_voManager.addVO(new MoveUnitsVO(_myPlayer.id, tmpPlatoon.id, _activePlayerRegion.id, _activeEnemyRegion.ownerPlatoon.owner.id, 
														_activeEnemyRegion.id, soldiers, tanks, artilleries, aircrafts, mechs, flags));
				}
			} else {
				allUnits = newUnits;
				_voManager.addVO(new MoveUnitsVO(_myPlayer.id, activePlayerRegion.ownerPlatoon.id, _activePlayerRegion.id, _activeEnemyRegion.ownerPlatoon.owner.id,
													_activeEnemyRegion.id, soldiers, tanks, artilleries, aircrafts, mechs, flags));
			}
			_platoonMoves.addChild(new TransferAndAttackArrow(_platoonMoves, activePlayerRegion, activeEnemyRegion, allUnits));
			_activePlayerRegion.removeUnitsOnRegion(newUnits);
			_sprite.removeChild(_transferAndAttackWindow.sprite);
			removeWayToNeighbours();
		}

		public function addAllMoves(moveUnitsVO:MoveUnitsVO):void {
			_allMoves.push(moveUnitsVO);
		}

		public function handleMoves():void {
			var offener:Player;
			var offenerPlatoon:Platoon;
			var offenerPlatoonID:uint;
			var defender:Player;
			var offenerRegion:Region;
			var defenderRegion:Region;
			var count:uint;
			var moveUnitsVO:MoveUnitsVO;
			var battlefields:Vector.<Battlefield>; 
			var regionConflicts:Vector.<Region> = new Vector.<Region>();
			
			for (var i:uint=0; i < _allMoves.length; i++) {
				moveUnitsVO=_allMoves[i];
				offener=_players.getPlayerByID(moveUnitsVO.offenerID);
				offenerPlatoonID=moveUnitsVO.offenerPlatoonID;
				offenerRegion=offener.getRegionByID(moveUnitsVO.offenerRegionID);
				if (offenerRegion.ownerPlatoon.id != offenerPlatoonID) {
					offenerPlatoon=new Platoon(offener, offenerPlatoonID, moveUnitsVO.soldiers, moveUnitsVO.tanks, moveUnitsVO.artilleries, 
												moveUnitsVO.aircrafts, moveUnitsVO.mechs, moveUnitsVO.flags);
				} else {
					offenerPlatoon=offenerRegion.ownerPlatoon;
				}
				defender=_regions[_allMoves[i].defenderRegionID].ownerPlatoon.owner;
				defenderRegion=defender.getRegionByID(moveUnitsVO.defenderRegionID);
				count=moveUnitsVO.soldiers + moveUnitsVO.tanks + moveUnitsVO.artilleries + moveUnitsVO.aircrafts + moveUnitsVO.mechs + moveUnitsVO.flags;
				if (offener != _myPlayer) {
					_platoonMoves.addChild(new TransferAndAttackArrow(_platoonMoves, offenerRegion, defenderRegion, count));
					offenerRegion.removeUnitsOnRegion(count);
				}
				defenderRegion.addPlatoon(offenerPlatoon);
				if(regionConflicts.indexOf(defenderRegion) < 0){
					regionConflicts.push(defenderRegion);
				}
			}
			for each(var region:Region in regionConflicts){
				region.handleConflicts();
			}
			
			var animatedSprite:AnimatedSprite;
			for(i=0;i<_platoonMoves.numChildren;i++){
				animatedSprite = _platoonMoves.getChildAt(i) as AnimatedSprite; 
				animatedSprite.fadeOut(5000);
			}			
			_allMoves = new Vector.<MoveUnitsVO>();
		}

		public function transferUnits(e:TextEvent):void {
			_activeEnemyRegion=_regions[int(e.text)];
			showMoveAndAttackWindow();
		}

		private function drawReachableWay(offenerRegion:Region, defenderRegion:Region, color:uint, width:uint):void {
			var way:Sprite=new Sprite();
			way.graphics.lineStyle(width, color);
			way.graphics.moveTo(offenerRegion.container.x, offenerRegion.container.y);
			way.graphics.lineTo(defenderRegion.container.x, defenderRegion.container.y);
			_ways.addChild(way);
		}

		public function getRegionByID(id:uint):Region {
			for (var i:uint=0; i < _regions.length; i++) {
				if (_regions[i].id == id)
					return _regions[i];
			}
			return null;
		}

		/*------------------------------------------------------------------------------------------*/
		/*----------------------------------- Getter und Setter ------------------------------------*/
		/*------------------------------------------------------------------------------------------*/

		public function get sprite():Sprite {
			return _sprite;
		}

		public function get worldMap():WorldMap {
			return _worldMap;
		}

		public function set worldMap(w:WorldMap):void {
			_worldMap=w;
		}

		public function get regions():Vector.<Region> {
			return _regions;
		}

		public function set activePlayerRegion(region:Region):void {
			_activePlayerRegion=region;
		}

		public function get activePlayerRegion():Region {
			return _activePlayerRegion;
		}

		public function set activeEnemyRegion(region:Region):void {
			_activeEnemyRegion=region;
		}

		public function get activeEnemyRegion():Region {
			return _activeEnemyRegion;
		}

		public function get allMoves():Vector.<MoveUnitsVO> {
			return _allMoves;
		}

		public function get platoonMoves():Sprite {
			return _platoonMoves;
		}
	}
}

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.TextEvent;

class TransferSymbol extends Sprite {

	private var _regionID:uint;

	public function TransferSymbol(regionID:uint) {
		super();
		_regionID=regionID;
		this.graphics.beginFill(0xFFFFFF);
		this.graphics.drawCircle(0, 0, 10);
		addEventListener(MouseEvent.CLICK, transferToRegion);
	}

	private function transferToRegion(e:MouseEvent):void {
		var transferEvent:TextEvent=new TextEvent("transferEvent", true);
		transferEvent.text=String(_regionID);
		dispatchEvent(transferEvent);
	}
}
