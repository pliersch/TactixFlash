package game.world {
	import animatedDisplayObjects.AnimatedSprite;
	
	import base.Game;
	
	import core.Platoon;
	import core.Player;
	import core.Players;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.sampler.NewObjectSample;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import game.battlefield.Battlefield;
	
	import util.SimpleShapes;
	import util.Tools;

	public class Region {
		private var _ownerPlatoon:Platoon;
		private var _offeners:Vector.<Platoon>;
		private var _container:Sprite;
		private var _battlefield:Battlefield;
		private var _regionInfo:TextField;
		private var _regions:Regions;
		private var _unitsOnRegion:uint;
		private var _newUnitsOnRegion:uint;
//		private var _xPos:uint;
//		private var _yPos:uint;
		private var _id:uint;
		private var _radius:uint;
		private var _isSelected:Boolean;
		private var _foreground:Sprite;
		private var _background:Shape;
		private var _circle:Shape;
		private var _glow:GlowFilter;
		private var _dragable:Boolean;
		private var _ownerColor:uint;
		private var _neighbours:Array;
		private var _battleIcon:Sprite;
		private var _newUnitsInfo:AnimatedSprite;

		public function Region(id:uint, regions:Regions, ownerPlatoon:Platoon) {
			_id=id;
			_ownerPlatoon=ownerPlatoon;
			_ownerColor=_ownerPlatoon.owner.color;
			_regions=regions;
			_radius=140;
			_unitsOnRegion=_ownerPlatoon.platoonCount;
			_newUnitsOnRegion=0;
			_container=new Sprite();
			_battleIcon = new Sprite();
			_ownerPlatoon.region=this;
			_isSelected=false;
			_neighbours=new Array();
			_offeners = new Vector.<Platoon>;
			init();
		}

		private function init():void {
			_regionInfo=new TextField();
			_background=new Shape();
			_foreground=new Sprite();
			_circle=new Shape();
			_container.buttonMode=true;
			_container.doubleClickEnabled=true;
			_foreground.doubleClickEnabled=true;
			_dragable=false;
			_regionInfo.autoSize=TextFieldAutoSize.LEFT;
			_regionInfo.selectable=false;
			_battleIcon.x = - 20;
			_battleIcon.y = 10;
			_container.addChild(_background);
			_container.addChild(_regionInfo);
			_container.addChild(_battleIcon);
			_container.addChild(_foreground);
			_container.addChild(_circle);
			//createFlag();
			_container.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			_container.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			_container.addEventListener(MouseEvent.CLICK, onClick);
			//_sprite.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			_container.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_container.addEventListener(MouseEvent.MOUSE_UP, onUp);
			_container.addEventListener("battleEnd", handleBattleEnd);
			_battleIcon.addEventListener(MouseEvent.CLICK, openBattlefield);
		}

		public function showRegion(show:Boolean):void {
			_foreground.graphics.clear();
			if (show) {
				_background.graphics.beginFill(_ownerPlatoon.owner.color, 1);
				_background.graphics.lineStyle(2, 0);
				_background.graphics.drawRect(-10, -10, 20, 20);
				_background.graphics.endFill();
				_foreground.graphics.beginFill(1, 0.001);
				_foreground.graphics.lineStyle(2, 0);
				_foreground.graphics.drawRect(-10, -10, 20, 20);
				_foreground.graphics.endFill();
				refreshCurrentTurn();
			}
		}
		
		//TODO: kann das evtl. doch über platoonCount erledigt werden?
		public function addUnitsOnRegion(count:uint):void {
			_unitsOnRegion+=count;
			_newUnitsOnRegion+=count;
			showNewUnits(_newUnitsOnRegion);
			refreshCurrentTurn();
		}

		public function removeUnitsOnRegion(units:uint):void {
			_unitsOnRegion-=units;
			glow(true);
			refreshCurrentTurn();
		}

		private function refreshCurrentTurn():void {
			_regionInfo.text="  " + _unitsOnRegion;
			_regionInfo.filters=[Tools.glow(0xFFFFFF, 1, 8, 8)];
			_regionInfo.textColor=0;
			_regionInfo.x=-11;
			_regionInfo.y=-10;
		}

		private function showNewUnits(count:uint):void {
			_newUnitsInfo=new AnimatedSprite(_container);
			var txt:TextField=new TextField();
			txt.text="+" + count;
			txt.textColor=0;
			txt.backgroundColor=0xFFFFFF;
			txt.background=true;
			txt.autoSize=TextFieldAutoSize.LEFT;
			txt.selectable=false;
			_newUnitsInfo.x=-26;
			_newUnitsInfo.y=-10;
			_newUnitsInfo.addChild(txt);
			_container.addChild(_newUnitsInfo);
			_newUnitsInfo.fadeOut(4000);
		}

		public function showRadius(show:Boolean):void {
			_circle.graphics.clear();
			if (show) {
				_circle.graphics.beginFill(0xffffff, 0.05);
				_circle.graphics.lineStyle(2, 0);
				_circle.graphics.drawCircle(0, 0, _radius);
				_circle.graphics.endFill();
			}
		}

		public function createFlag():void {
			if (_ownerPlatoon.owner.id == 0)
				_container.addChild(util.SimpleShapes.circle(0, 0, 8, 0X00FF00, 1, 0, 2, 1));
			else if (_ownerPlatoon.owner.id == 1)
				_container.addChild(util.SimpleShapes.rectangle(16, 0, 12, 8, 0, 0x0000FF, 1, 0, 0, 1));
			else if (_ownerPlatoon.owner.id == 2)
				_container.addChild(util.SimpleShapes.cross(16, 0, 8, 8, 4, _ownerColor, 1, 0, 0, 1));
			else
				_container.addChild(util.SimpleShapes.rectangle(16, 0, 4, 8, 0, _ownerColor, 1, 0, 0, 1));
		}

		private function onDoubleClick(event:MouseEvent):void {
			_dragable=true;
		}

		private function onClick(event:MouseEvent):void {
			if (_regions.worldMap.currentPhase == WorldMap.PHASE_BUY) {
				openSupply();
			}
			if (_regions.worldMap.currentPhase == WorldMap.PHASE_MOVE) {
				if (Players.instance.myPlayer == _ownerPlatoon.owner && unitsOnRegion > 0) {
					_regions.handleWayToNeighbours(this);
				}
			}
		}
		
		public function addPlatoon(platoon:Platoon):void {
			_offeners.push(platoon);
		}		
		
		public function handleConflicts():void {
			var isSimpleMove:Boolean = true;
			if(_unitsOnRegion  == 0){
				var currentNewOwnerPlatoon:Platoon =_offeners[0];
				for(var i:uint=1;i<_offeners.length;i++){
					if(_offeners[i].owner != currentNewOwnerPlatoon.owner){
						isSimpleMove = false;
					}
				}
			} else {
				for(i=0;i<_offeners.length;i++){
					if(_offeners[i].owner != _ownerPlatoon.owner){
						isSimpleMove = false;
					}
				}
			}
			if(!isSimpleMove){
				showBattleIcon();
			} else {
				var animatedSprite:AnimatedSprite;
				for each(var newPlatoon:Platoon in _offeners){
					var owner:Player = newPlatoon.owner;
					if(_unitsOnRegion > 0){
						_ownerPlatoon = newPlatoon;
					} else {
						owner.mergePlatoons(_ownerPlatoon, newPlatoon);
					}
					addUnitsOnRegion(newPlatoon.platoonCount);
//					id = currentMove.offenerRegionID  + "." + currentMove.defenderRegionID;
//					animatedSprite = _platoonMoves.getChildByName(id) as AnimatedSprite;
//					animatedSprite.fadeOut(5000);
				}
			}
		}
		
		//TODO: wird nicht erreicht!
		private function handleBattleEnd(e:Event):void{
			_battleIcon.visible = false;
			_battleIcon.removeChildAt(1);
			trace(_offeners.length);
			_regions.worldMap.game.currentState = "world";
		}
				
		private function showBattleIcon():void{
			_battleIcon.visible = true;
			var coloredRectangle:Shape = new Shape();
			var x:uint = 0;
			if(_unitsOnRegion > 0){
				_offeners.unshift(_ownerPlatoon);
			}
			for each(var newPlatoon:Platoon in _offeners){
				coloredRectangle.graphics.beginFill(newPlatoon.owner.color);
				//coloredRectangle.graphics.lineStyle(0, 0, borderAlpha);
				coloredRectangle.graphics.drawRect(x,0,10,10);
				coloredRectangle.graphics.endFill();
				x += 10;
			}
			_battleIcon.addChild(coloredRectangle);
		}

		private function openBattlefield(e:MouseEvent):void {
			_battlefield=new Battlefield(_offeners, _regions.worldMap.game);
			//_container.parent.addChild(_battlefield.sprite);
			//TODO: grausam!
			_regions.worldMap.game.changeToBattle(_battlefield);
		}

		private function openSupply():void {
			if (Players.instance.myPlayer.name == _ownerPlatoon.owner.name) {
				_ownerPlatoon.owner.activePlatoon=_ownerPlatoon;
				_regions.activePlayerRegion=this;
				_container.dispatchEvent(new Event("openSupply", true));
			}
		}

		private function onDown(event:MouseEvent):void {
			if (_dragable) {
				_container.startDrag();
			}
		}

		private function onUp(event:MouseEvent):void {
			if (_dragable) {
				_container.stopDrag();
			}
		}

		private function glow(glow:Boolean):void {
			var glowColor:uint;
			if (this._ownerPlatoon.owner == Players.instance.myPlayer) {
				glowColor=0xFFFFFF;
			} else {
				glowColor=0xFF0000;
			}
			_glow=Tools.glow(glowColor, 0.5, 20, 20);
			if (glow) {
				_glow.alpha=1;
				_background.filters=[_glow];
			} else {
				_glow.alpha=0;
				_background.filters=[_glow];
			}
		}

		private function mouseOverHandler(event:MouseEvent):void {
			if(_unitsOnRegion > 0){
				_regions.showRegionInfo(this._ownerPlatoon, true);
				glow(true);
			}
		}

		private function mouseOutHandler(event:MouseEvent):void {
			if(_unitsOnRegion > 0){
				_regions.showRegionInfo(this._ownerPlatoon, false);
				glow(false);
			}
		}

		/*------------------------------------------------------------------------------------------*/
		/*----------------------------------- Getter und Setter ------------------------------------*/
		/*------------------------------------------------------------------------------------------*/

		public function get neighbours():Array {
			return _neighbours;
		}

		public function set neighbours(value:Array):void {
			_neighbours=value;
		}

		public function get ownerPlatoon():Platoon {
			return _ownerPlatoon;
		}

		public function get radius():uint {
			return _radius;
		}

		public function get id():uint {
			return _id;
		}

		public function get battlefield():Battlefield {
			return _battlefield;
		}

		public function get container():Sprite {
			return _container;
		}

		public function get unitsOnRegion():uint {
			return _unitsOnRegion;
		}

		public function set dragable(drag:Boolean):void {
			_dragable=drag;
		}
	}
}