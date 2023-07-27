package game.world{
	import base.Game;
	
	import core.Platoon;
	import core.Player;
	import core.Players;
	import designPattern.observer.IObservable;
	import designPattern.observer.IObserver;
	import core.onlineStatus.P2P_Manager;
	import core.onlineStatus.UserLogger;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import util.GraphicLoader;
	import util.Tools;
	
	import valueObjects.VO_Manager;
	import valueObjects.world.AddUnitsVO;
	import valueObjects.world.MoveUnitsVO;
	import valueObjects.world.WorldEndTurnVO;
	
	public class WorldMap implements IObserver {
				
		private var _players:Players;
		private var _myPlayer:Player;
		private var _game:Game;
		private var _regions:Regions;
		//private var _regionInfo:Sprite; 
		private var _supplyMenu:SupplyMenu;
		private var _sprite:Sprite;
		private var _playersInfo:Shape;
		private var phaseBuyTF:TextField;
		private var phaseMoveTF:TextField;
		private var phaseBattleTF:TextField;
		private var ownerInfoTF:TextField;
		private var debugInfo:TextField;			
		private var _currentPhase:uint;
		private var _incomingCounter:uint;
		private var _roundCounter:uint;
		private var _myPlayerHasMoved:Boolean;
		private var _endShape:Sprite;
		private var _blackBG:Shape;
		private var _newUnits:Array;
		private var _message:String;
		private var _enemyBar:EnemyBar;	
		private var _voManager:VO_Manager;
		private var _p2pManager:P2P_Manager;
		
		public static var PHASE_BUY : uint = 0;
		public static var PHASE_MOVE: uint = 1;
		public static var PHASE_BATTLE: uint = 2;
		
		private static var _link1:Array = [valueObjects.world.AddUnitsVO];
		private static var _link2:Array = [valueObjects.world.MoveUnitsVO];
		private static var _link3:Array = [valueObjects.world.WorldEndTurnVO];
		
		public function WorldMap(game:Game){
			_players = Players.instance;
			_game = game;
			init();
		}
	
		private function init():void{
			_myPlayer = _players.myPlayer;
			_myPlayer.activePlatoon = _myPlayer.getPlatoon(0);
			_regions = new Regions(this);
			_enemyBar = new EnemyBar();	
			_roundCounter = 0;
			_incomingCounter = 0;
			_message = "";
			_myPlayerHasMoved = false;
			_newUnits = new Array();
			_voManager = VO_Manager.instance;
			_p2pManager = P2P_Manager.instance;
			_p2pManager.addObserver(this);
			initGraphic();
			handlePhase(PHASE_BUY);
			refresh();
		}
		
		private function initGraphic():void{
			_blackBG = getBG();
			_blackBG.visible = false;
			debugInfo = new TextField();
			debugInfo.autoSize = TextFieldAutoSize.LEFT;
			debugInfo.selectable = false;
			debugInfo.x = 10;
			debugInfo.y = 400;
			debugInfo.setTextFormat(Tools.setTextForm("babylon5Credits",18,0xFFFFFF,"left", false));
			debugInfo.text = "incomingCounter: " + _incomingCounter;
			phaseBuyTF = new TextField();
			phaseBuyTF.autoSize = TextFieldAutoSize.LEFT;
			phaseBuyTF.selectable = false;
			phaseBuyTF.x = 10;
			phaseBuyTF.y = 440;
			//phaseBuyTF.setTextFormat(Tools.setTextForm("babylon5Credits",20,0xFFFFFF,"left", false));
			phaseBuyTF.text = "Einsatz";
			phaseMoveTF = new TextField();
			phaseMoveTF.autoSize = TextFieldAutoSize.LEFT;
			phaseMoveTF.selectable = false;
			phaseMoveTF.x = 7;
			phaseMoveTF.y = 480;
			phaseMoveTF.text = "Transfer";
			//phaseMoveTF.setTextFormat(Tools.setTextForm("babylon5Credits",20,0x666666,"left", false));	
			phaseBattleTF = new TextField();
			phaseBattleTF.autoSize = TextFieldAutoSize.LEFT;
			phaseBattleTF.selectable = false;
			phaseBattleTF.x = 11;
			phaseBattleTF.y = 520;
			phaseBattleTF.text = "Kampf";
			//phaseBattleTF.setTextFormat(Tools.setTextForm("babylon5Credits",20,0x666666,"left", false));	
			ownerInfoTF = new TextField();
			ownerInfoTF.autoSize = TextFieldAutoSize.LEFT;
			ownerInfoTF.selectable = false;
			ownerInfoTF.x = 100;
			ownerInfoTF.y = 590;
			_endShape = new Sprite();
			_endShape.x = 10;
			_endShape.y = 450;
			_endShape.graphics.beginFill(1,0.1);
			_endShape.graphics.drawRect(0,0,80,123);
			_endShape.graphics.endFill();
			_endShape.buttonMode = true;
			_endShape.addEventListener(MouseEvent.CLICK, endTurn);												
			_sprite = new Sprite();
			var bg:Sprite = new Sprite();
			bg.addChild(new GraphicLoader("../media/hq/worldBlack.png"));
			_sprite.addChild(bg);	
			_sprite.addChild(_enemyBar.sprite);
			_sprite.addChild(phaseMoveTF);
			_sprite.addChild(phaseBuyTF);
			_sprite.addChild(phaseBattleTF);
			_sprite.addChild(ownerInfoTF);
			_sprite.addChild(debugInfo);
			_sprite.addChild(_endShape);
			_playersInfo = new Shape(); 			
			_playersInfo.x = 730;
			_playersInfo.y = 596;
			_sprite.addChild(_playersInfo);	
			_regions.sprite.y = 70;			
			_sprite.addChild(_regions.sprite);		
			_sprite.addEventListener("openSupply",openSupply);
			_sprite.addEventListener("closeSupply",closeSupply);
			_supplyMenu = new SupplyMenu(_myPlayer);
			_supplyMenu.window.visible = false;
			_supplyMenu.window.x = (1024-892)/2;  // 1024-892 noch dynamisch machen!!
			_supplyMenu.window.y = 50;
			_sprite.addChild(_supplyMenu.window);	
			_sprite.addChild(_blackBG);	
		}
		
		public function update(observerable:IObservable, infoObj:Object):void {
			if(infoObj is AddUnitsVO){
				var addUnitsVO:AddUnitsVO = infoObj as AddUnitsVO;
				_newUnits.push(addUnitsVO);
			} else if(infoObj is MoveUnitsVO){
				var moveUnitsVO:MoveUnitsVO = infoObj as MoveUnitsVO;
				_regions.addAllMoves(moveUnitsVO);
			} else if(infoObj is WorldEndTurnVO){
				var worldEndTurnVO:WorldEndTurnVO = infoObj as WorldEndTurnVO;
				var sender:Player = _players.getPlayerByID(worldEndTurnVO.playerID);
				sender.userStatus.hasTurnReady = true;
				_incomingCounter++;
				debugInfo.text = "incomingCounter: " + _incomingCounter;
				debugInfo.setTextFormat(Tools.setTextForm("babylon5Credits",24,0xFFFFFF,"left", false));
				checkEndTurn();
			}
		}
				
		public function refresh():void{		
			drawPlayersInfo();
			drawOwnerInfo();
		}
		
		private function getBG():Shape{
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0,0.4);
            bg.graphics.lineStyle(2, 0);
            bg.graphics.drawRect(0,0,1024,700);
            bg.graphics.endFill();	
			return bg;
		}		
		
		private function endTurn(e:MouseEvent):void{
			//TODO: unterschiedliche Ansätze für Kauf bzw. Bewegung von Einheiten 
			//		ändern und einen gemeinsamen finden!
			if(_currentPhase == PHASE_MOVE){
				for(var i:uint=0;i<_voManager.length;i++){
					_regions.addAllMoves(_voManager.getElementAt(i) as MoveUnitsVO);
				}
			}
			_voManager.sendContainer();
			//bei Handshake neu behandeln!
			_voManager.clearContainer();
			_myPlayerHasMoved = true;
			_blackBG.visible = true;
			sendEndTurn();
			checkEndTurn();
		}
		
		private function checkEndTurn():void{
			debugInfo.text = "incomingCounter: " + _incomingCounter;
			debugInfo.setTextFormat(Tools.setTextForm("babylon5Credits",24,0xFFFFFF,"left", false));
			if(_incomingCounter == _players.length - 1 && _myPlayerHasMoved) {
				_incomingCounter = 0;
				_blackBG.visible = false;
				if(_currentPhase == PHASE_BUY){
					var addUnitsVO:AddUnitsVO;
					for(var i:uint=0;i<_newUnits.length;i++){
						addUnitsVO = _newUnits[i];
						addUnits(addUnitsVO.regionID,addUnitsVO.soldiers,addUnitsVO.tanks,addUnitsVO.artilleries, 
							addUnitsVO.aircrafts,addUnitsVO.mechs,addUnitsVO.flags);
					}
				}
				if(_currentPhase == PHASE_MOVE){
					_regions.handleMoves();
				}
//				if(_currentPhase == PHASE_BATTLE){
//					var addUnitsVO:AddUnitsVO;
//					for(var i:uint=0;i<_newUnits.length;i++){
//						addUnitsVO = _newUnits[i];
//						addUnits(addUnitsVO.regionID,addUnitsVO.soldiers,addUnitsVO.tanks,addUnitsVO.artilleries, 
//							addUnitsVO.aircrafts,addUnitsVO.mechs,addUnitsVO.flags);
//					}
//				}
				_players.setTurnEnd();
				_roundCounter++;
				_myPlayerHasMoved = false;
				trace(_roundCounter%3);
				if(_roundCounter%3 == 0) _currentPhase = PHASE_BUY;
				if(_roundCounter%3 == 1) _currentPhase = PHASE_MOVE;
				if(_roundCounter%3 == 2) _currentPhase = PHASE_BATTLE;
				handlePhase(_currentPhase);
			}	
		}

		private function handlePhase(phase:uint):void{
			switch (phase){ 
		    case PHASE_BUY:
		    	phaseBuyTF.setTextFormat(Tools.setTextForm("babylon5Credits",20,0xFFFFFF,"left", false));	
		    	phaseBuyTF.filters = [Tools.glow(0x00FF00,1,15,25)];
		    	phaseMoveTF.setTextFormat(Tools.setTextForm("babylon5Credits",20,0x666666,"left", false));	
		    	phaseMoveTF.filters = [Tools.glow(0xFF0000,1,15,25)];
		    	phaseBattleTF.setTextFormat(Tools.setTextForm("babylon5Credits",20,0x666666,"left", false));	
		    	phaseBattleTF.filters = [Tools.glow(0xFF0000,1,15,25)];
		    	break; 
		    case PHASE_MOVE:
				_newUnits = new Array();
				_regions.activePlayerRegion = null;
		    	phaseBuyTF.setTextFormat(Tools.setTextForm("babylon5Credits",20,0x666666,"left", false));	
		    	phaseBuyTF.filters = [Tools.glow(0xFF0000,1,15,25)];
		    	phaseMoveTF.setTextFormat(Tools.setTextForm("babylon5Credits",20,0xFFFFFF,"left", false));	
		    	phaseMoveTF.filters = [Tools.glow(0x00FF00,1,15,25)];
		    	phaseBattleTF.setTextFormat(Tools.setTextForm("babylon5Credits",20,0x666666,"left", false));	
		    	phaseBattleTF.filters = [Tools.glow(0xFF0000,1,15,25)];		
				//sendPhaseMoveEnd();
		    	break; 
		    case PHASE_BATTLE:
		    	
		    	phaseBuyTF.setTextFormat(Tools.setTextForm("babylon5Credits",20,0x666666,"left", false));	
		    	phaseBuyTF.filters = [Tools.glow(0xFF0000,1,15,25)];
		    	phaseMoveTF.setTextFormat(Tools.setTextForm("babylon5Credits",20,0x666666,"left", false));	
		    	phaseMoveTF.filters = [Tools.glow(0xFF0000,1,15,25)];
		    	phaseBattleTF.setTextFormat(Tools.setTextForm("babylon5Credits",20,0xFFFFFF,"left", false));	
		    	phaseBattleTF.filters = [Tools.glow(0x00FF00,1,15,25)];				    
		    	break; 
			}
		}
	
		private function drawPlayersInfo():void{
			_playersInfo.graphics.clear();
			for(var i:uint=0;i<_players.length;i++){
				_playersInfo.graphics.beginFill(_players.getPlayerByID(i).color);
				_playersInfo.graphics.drawRect(0,i*14,_players.getPlayerByID(i).getRegionCount()*2,12);
				_playersInfo.graphics.drawRect(0,i*14+65,_players.getPlayerByID(i).allUnitsCount*2,12);
			}			
		}
		
		private function drawOwnerInfo():void{
			ownerInfoTF.text = _myPlayer.name + "\nCredits: " + _myPlayer.credit;
			ownerInfoTF.setTextFormat(Tools.setTextForm("babylon5Credits",24,0xCCCCCC,"left", false));	
		}							
		
		public function openSupply(e:Event):void{
			_supplyMenu.openMenu();
		}			
		
		public function closeSupply(e:Event):void{
			_supplyMenu.closeMenu();
			if(_supplyMenu.platoonCountChanged){ 
				//TODO: schon in Supply das VO erstellen? hier dann lesbarer!
				_voManager.addVO(new AddUnitsVO(_myPlayer.id,_regions.activePlayerRegion.id,_supplyMenu.newUnits[0],_supplyMenu.newUnits[1],_supplyMenu.newUnits[2],
					_supplyMenu.newUnits[3],_supplyMenu.newUnits[4],_supplyMenu.newUnits[5]));
			}
			refresh();
		}

		//TODO: hier wäre dann auch mit VO übersichtlicher
		public function addUnits(regionID:uint,soldiers:uint, tanks:uint, artilleries:uint, aircrafts:uint, mechs:uint, flaks:uint):void{
			var units:Array = new Array(soldiers,tanks,artilleries,aircrafts,mechs,flaks);
			var region:Region = _regions.getRegionByID(regionID);
			var platoon:Platoon = region.ownerPlatoon;
			for(var i:uint=0;i<6;i++){
				for(var j:uint=0;j<units[i];j++){
					platoon.addUnitByTyp(i);
				} 
			}
			region.addUnitsOnRegion(soldiers+tanks+aircrafts+artilleries+mechs+flaks);
		}

/*------------------------------------------------------------------------------------------*/
/*-------------------------------------- Messaging -----------------------------------------*/
/*------------------------------------------------------------------------------------------*/
		
		private function sendEndTurn():void{
			_p2pManager.sendObject(new WorldEndTurnVO(_myPlayer.id));
		}
		
/*------------------------------------------------------------------------------------------*/
/*----------------------------------- Getter und Setter ------------------------------------*/
/*------------------------------------------------------------------------------------------*/
		
		public function get sprite():Sprite{
			return _sprite;
		}	
		
		public function get player():Player{
			return _myPlayer;
		}
		
		public function get currentPhase():uint{
			return _currentPhase;
		}						

		public function get game():Game	{
			return _game;
		}

	}
}