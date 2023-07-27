package game.battlefield {
	
	import animatedDisplayObjects.AnimatedSprite;
	
	import base.Game;
	
	import core.Platoon;
	import core.Players;
	import core.onlineStatus.P2P_Manager;
	
	import designPattern.observer.IObservable;
	import designPattern.observer.IObserver;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import game.TruppenArray;
	import game.units.*;
	
	import valueObjects.battlefield.*;
	
	public class Battlefield implements IObserver{
		private var _game:Game;
		private var _platoons    	 :Vector.<Platoon>;
		private var _activePlatoon   :Platoon;
		private var _passivePlatoon  :Platoon;
		private var _myPlatoon		 :Platoon;
		private var truppArray       :TruppenArray;
		private var _sprite	       :Sprite;
		private var _infoBar	   :InfoBar
		private var _lastField     :HexField;
		private var _newField      :HexField;
		private var hexFields     :Vector.<Vector.<HexField>>;
		private var closedFields  :Array;
		private var way           :Array;	
		private var ways		  :Array;
		private var col                :uint;
		private var rows               :uint;
		private var movableKampfFiguren:uint;
		private var enterFrameCounter  :uint;
		private var roundCounter	   :uint;
		private var hoehe        :Number;
		private var breite       :Number;
		private var cos30        :Number;
		private var seitenlaenge :Number;	
		private var _iAmRegionOwner :Boolean;
		private var einsatzPhase    :Boolean;
		private var kampfPhase      :Boolean;			
		private var count:uint = 0;
		private static var EINSATZ:uint = 0;
		private static var KAMPF  :uint = 1;
		private var _p2pManager:P2P_Manager;
		
		private static var _link1:Array = [valueObjects.battlefield.AddUnitVO];
		private static var _link2:Array = [valueObjects.battlefield.MoveUnitVO];
		private static var _link3:Array = [valueObjects.battlefield.AttackUnitVO];
		private static var _link4:Array = [valueObjects.battlefield.BattleEndTurnVO];
				
		public function Battlefield(platoons:Vector.<Platoon>, game:Game){
			_platoons = platoons;
			_game = game;
			init();
			initLogic();
			initGraphic();
			setPhase(Battlefield.EINSATZ);
		}

		private function init():void {
			col                 = 21;//Pref.BATTLEFIELD_COL;
			rows                = 53;//Pref.BATTLEFIELD_ROWS;		
			hexFields           = new Vector.<Vector.<HexField>>(rows);
			hoehe               = Pref.BATTLEFIELD_HOEHE;
			breite              = Pref.BATTLEFIELD_BREITE;
			cos30               = Math.cos(30*Math.PI/180);
			seitenlaenge        = hoehe/cos30/2;
			einsatzPhase        = true;
			kampfPhase          = false;	
			movableKampfFiguren = 0;
			enterFrameCounter   = 0;
			roundCounter        = 0;	
			_p2pManager		    = P2P_Manager.instance;
			_p2pManager.addObserver(this);
		}
		
		private function initGraphic():void	{
			_sprite = new Sprite();	
			initHexfields();
			truppArray = new TruppenArray();
			truppArray.platoon = _myPlatoon;
			truppArray.createArray();
			truppArray.x = (_sprite.width - truppArray.width)/2;
			truppArray.y = 10;	
			_infoBar = new InfoBar();
			_infoBar.sprite.x = (_sprite.width - _infoBar.sprite.width)/2;
			_infoBar.sprite.y = _sprite.height - 50;					
			_sprite.addChild(truppArray);
			_sprite.addChild(_infoBar.sprite);
			_sprite.graphics.lineStyle(2,0xFF0000);
			_sprite.graphics.drawRect(0,0,_sprite.width,_sprite.height);
			_sprite.addEventListener("fight",sendFight);
			initStartFelder();
		}
				
		private function initLogic():void {
			for(var i:uint=0;i<_platoons.length;i++){
				_platoons[i].active = false;
				_platoons[i].resetMovablePieces();
				_platoons[i].setActiveUnit(0);
				_platoons[i].battleID = i; 
				if(_platoons[i].owner == Players.instance.myPlayer){
					_myPlatoon = _platoons[i];
				}
			}
			_activePlatoon	= _platoons[0];
			_iAmRegionOwner	= (_myPlatoon == _activePlatoon);								
			_activePlatoon.active = true;
		}
		
		private function initStartFelder():void {
			if (_iAmRegionOwner){
				hexFields[2][5].setStartField();
				hexFields[3][5].setStartField();
				hexFields[4][5].setStartField();
				hexFields[5][5].setStartField();
				hexFields[6][5].setStartField();
				hexFields[7][5].setStartField();
				hexFields[4][6].setStartField();
				hexFields[5][6].setStartField();
				hexFields[6][6].setStartField();
				hexFields[7][6].setStartField();	
				hexFields[8][6].setStartField();
				hexFields[9][6].setStartField();	
				//hexFields[6][6].setStartField();
				hexFields[4][7].setStartField();	
				hexFields[6][7].setStartField();
				hexFields[8][7].setStartField();	
			} else {
				hexFields[16][10].setStartField();
				hexFields[17][10].setStartField();
				hexFields[18][10].setStartField();
				hexFields[19][10].setStartField();
				hexFields[20][10].setStartField();
				hexFields[21][10].setStartField();
				hexFields[22][10].setStartField();
				hexFields[23][10].setStartField();
				hexFields[16][11].setStartField();
				hexFields[17][11].setStartField();
				hexFields[18][11].setStartField();
				hexFields[19][11].setStartField();
				hexFields[20][11].setStartField();
				hexFields[21][11].setStartField();
				hexFields[22][11].setStartField();
				hexFields[23][11].setStartField();
			}		
		}
		
		private function initHexfields():void {
			var costTxt:String = "2.2.2.2.2.20.2.2.20.20.2.2.2.2.2.2.1.1.2.2.2.2.2.2.2.20.20.2.20.2.2.2.2.2.2.2.1.1.2.2.2.2.2.2.2.2.2." +
				"2.20.20.2.2.2.2.2.2.2.2.1.1.2.2.2.2.2.2.2.20.2.20.20.2.2.2.2.2.2.2.2.1.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2." +
				"2.2.2.2.2.2.2.2.2.20.2.20.1.1.2.2.2.2.2.2.2.2.2.1.2.2.2.2.20.20.20.20.20.2.1.1.2.2.2.2.2.2.2.2.1.1.2.2.2.20." +
				"20.2.20.20.1.1.2.2.2.2.2.2.2.2.1.2.1.2.2.2.2.2.2.2.2.2.1.1.2.2.2.2.2.2.2.1.2.2.1.2.2.2.2.2.2.2.2.1.2.2.2.2.2" +
				".2.2.1.2.2.2.1.2.2.2.2.2.2.2.2.2.1.2.2.2.2.2.2.2.2.2.2.2.1.1.2.2.2.2.2.2.2.1.2.2.2.2.2.2.1.2.2.2.2.1.1.20.2" +
				".2.2.2.2.2.2.1.2.2.2.2.2.2.2.2.2.2.1.1.20.20.2.2.2.2.2.2.1.2.2.2.2.2.1.2.2.2.2.1.1.2.20.20.2.2.2.2.2.2.1.2.2" +
				".2.2.2.1.2.2.2.2.1.2.2.20.2.2.2.2.2.2.1.2.2.2.2.1.1.2.2.2.2.2.2.2.2.20.2.2.2.2.2.2.1.2.2.2.1.1.2.2.2.2.2.2.2" +
				".2.20.2.2.2.2.2.2.2.2.2.1.1.1.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1.2.2.1.2.2.2.2.2.2.2.2.2.2.20.2.2.2.2.2.2.1.2.1" +
				".2.2.1.2.2.2.2.3.2.2.2.2.20.2.2.2.2.2.1.1.1.2.2.2.2.2.2.2.3.2.2.2.2.20.2.2.2.2.2.1.1.2.2.2.1.2.2.2.3.3.2.2.2" +
				".2.2.20.2.2.2.2.1.1.2.2.2.2.2.2.2.3.3.2.2.2.2.2.2.2.2.2.1.1.2.2.2.2.1.2.2.3.3.3.2.2.2.2.2.20.2.2.2.1.2.2.2.2" +
				".2.2.2.2.2.3.3.2.2.2.2.2.20.2.2.1.2.2.2.2.2.2.1.2.2.3.3.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.3.3.2.2.2.2.2.2" +
				".20.2.2.1.2.2.2.2.2.2.1.2.3.3.3.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.3.3.3.2.2.2.2.2.2.20.2.2.1.2.2.2.2.2.2.1.2" +
				".3.3.2.2.2.2.2.2.2.20.2.2.2.2.2.2.2.2.2.2.2.3.3.3.2.2.2.2.2.2.2.2.2.1.2.2.2.2.2.2.1.2.3.3.2.2.2.2.2.2.2.20.2.2" +
				".1.2.2.2.2.2.2.2.2.2.3.3.2.2.2.2.2.2.2.2.1.2.2.2.2.2.2.2.1.2.2.3.2.2.2.2.2.2.2.20.2.1.1.2.2.2.2.2.2.1.1.1.2.2.2" +
				".2.20.2.2.2.2.2.1.1.2.2.2.2.1.1.2.1.1.2.2.20.20.20.20.20.20.20.2.1.1.2.2.2.2.1.1.2.2.1.2.2.20.20.2.20.20.20.2.2" +
				".1.1.1.1.1.1.2.2.2.1.1.2.20.2.2.2.2.2.2.2.3.1.1.1.1.1.1.20.20.20.20.2.2.20.2.2.2.2.2.2.3.1.2.2.2.2.2.2.20.20.20" +
				".20.20.20.2.2.2.2.2.2.2.2.1.3.3.3.2.2.2.20.2.2.2.20.20.2.2.1.1.2.2.2.1.3.3.3.3.3.2.2.2.2.2.2.2.2.2.2.1.1.1.1.2.1" +
				".3.3.3.3.3.3.2.20.2.2.2.2.2.2.2.1.1.1.1.1.2.2.3.3.3.3.2.2.2.2.2.2.2.2.2.2.1.1.2.2.1.2.2.2.2.2.3.2.2.20.2.2.2.2.2" +
				".2.2.1.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.20.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2" +
				".20.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.20.2.2.2.2.2.2.2.2.2.2.3.2.2.2.2.2.2.2.2.20.2.2.2.2.2.2.2.2.2.2.2.3.3" +
				".2.2.2.2.2.2.20.20.2.2.2.2.2.2.2.2.2.2.3.3.3.2.2.3.3.3.20.20.2.2.2.2.2.2.2.2.2.2.2.3.3.3.3.2.3.3.3.20.2.2.2.2.2.2.2.2.2.2.2.";
			
			var costArray:Array = costTxt.split(".");
			
			for(var n:uint = 0;n<rows;n++) {
				hexFields[n] = new Vector.<HexField>(col);
			}
			for (var j:uint = 0; j < rows; j++)	{
				for (var i:uint = 0; i < col; i++) {
					hexFields[j][i] = new HexField(j,i,2);
					hexFields[j][i].x = i * breite + i * seitenlaenge +(j%2)* (breite - seitenlaenge/2);
					hexFields[j][i].y = j * hoehe /2;	
					hexFields[j][i].addEventListener(MouseEvent.CLICK, hexfieldClicked);
					_sprite.addChild(hexFields[j][i]);
				}
			}
			
			var hf:HexField;
			for (j=0; j < rows; j++) {
				for (i=0; i < col; i++) {
					hf=hexFields[j][i];
					hf.setTyp(costArray[(j * col + i)]);
				}
			}
		}
		
		public function update(observerable:IObservable, infoObj:Object):void {
			if(infoObj is AddUnitVO){
				var addUnitVO:AddUnitVO = infoObj as AddUnitVO;
				addUnit(addUnitVO.unitID, addUnitVO.xPos, addUnitVO.yPos);
			}
			else if(infoObj is MoveUnitVO){
				var moveUnitVO:MoveUnitVO = infoObj as MoveUnitVO;
				moveUnit(moveUnitVO.unitID, moveUnitVO.oldXPos, moveUnitVO.oldYPos, moveUnitVO.newXPos, moveUnitVO.newYPos);
			}
			else if(infoObj is AttackUnitVO){
				var attackUnitVO:AttackUnitVO = infoObj as AttackUnitVO;
				_activePlatoon.setActiveUnit(attackUnitVO.offenerUnitID);
				_passivePlatoon = _platoons[attackUnitVO.defenderPlatoonID];
				_passivePlatoon.setActiveUnit(attackUnitVO.defenderUnitID);
				
				fight(_activePlatoon.activeUnit, _passivePlatoon.activeUnit);
			}
			else if(infoObj is BattleEndTurnVO){
				setEndTurn();				
			}
		}

		private function hexfieldClicked(e:MouseEvent):void {
			if(e.target.parent is HexField ){
				var hexfield:HexField = e.target.parent as HexField;
				if(hexfield.isStartField && isEinsatzPhase && iAmActivePlatoon)	{
					sendAddUnit(hexfield);
				} else if(hexfield.isChecked())	{
					sendMoveUnit(hexfield);
				} 	
			}
		}	
			
		public function clearBackground():void{
			for (var j:uint = 0; j < rows; j++)	{
				for (var i:uint = 0; i < col; i++){	
					hexFields[j][i].reset();
				}
			}
		}
										
		private function setEndTurn():void{
			//_passivePlatoon.resetMovablePieces();
			//_passivePlatoon.resetRestAktionspunkte();
			_activePlatoon.resetRestAktionspunkte();
			_activePlatoon.resetMovablePieces();
			_activePlatoon.setCircleColor(0XCCCCCC);
			_activePlatoon.active = false;
			roundCounter++;
			// wegen einer einsatzphase pro runde immer 1x if grrr!!!! 
			if(roundCounter==_platoons.length) setPhase(KAMPF);
			_activePlatoon = _platoons[roundCounter%_platoons.length];
			_activePlatoon.active = true;
			if (kampfPhase) _activePlatoon.setCircleColor(0X00FF00);
		}

		public function checkEndGame():void	{
			var destroyedPlatoons:uint=0;
			for each(var p:Platoon in _platoons){
				if(p.platoonCount == 0){
					destroyedPlatoons++;
					if(destroyedPlatoons == _platoons.length - 1){
						_sprite.parent.removeChild(_sprite);
						_sprite.dispatchEvent(new Event("battleEnd",true));
						_game.currentState = "world";
					}
				}
			}
		}
				
		public function setPhase(phase:uint):void{
			if (phase == EINSATZ){
				einsatzPhase = true;
				kampfPhase   = false;
			}  else {
				einsatzPhase = false;
				kampfPhase   = true;
			}
		}

		public function addUnit(unitID:uint, xPos:uint,yPos:uint):void{
			var hexField:HexField = getField(xPos,yPos);			
			var unit:Unit = _activePlatoon.getUnit(unitID);
			var battlePiece:BattlePiece = new BattlePiece(unit,this,hexField);
			hexField.battlePiece = battlePiece;
			hexField.addUnit(battlePiece);
			_activePlatoon.activeUnit.inField = true;
			_activePlatoon.activeUnit.movable = true;
			_activePlatoon.activeUnit.battlePiece = battlePiece;
			_activePlatoon.activeUnit.battlePiece.hexField = hexField;
			_activePlatoon.decreaseMovablePieces();
			_activePlatoon.setNextActive();
			
			// das alles wegen einmal einsatzphase
			if(iAmActivePlatoon){ 
				truppArray.createArray();	
			}			
			if (_activePlatoon.movablePieces == 0){				
				if(iAmActivePlatoon) {
					truppArray.visible = false;
					clearBackground();
				}
				setEndTurn();
			}
		}
		
		public function moveUnit(id:uint, xOld:uint, yOld:uint, xNew:uint, yNew:uint):void{
			_activePlatoon.setActiveUnit(id);
			_lastField = getField(xOld,yOld);
			_newField  = getField(xNew,yNew);
			showReachableFields(_activePlatoon.activeUnit);
			showWay(xNew, yNew);
			_activePlatoon.activeUnit.battlePiece.hexField = _newField;
			_activePlatoon.activeUnit.movable = false;
			_activePlatoon.activeUnit.setRestAktionspunkte(_newField.remainingWayPoints);
			_activePlatoon.activeUnit.aktionsRadius = BFSMoore.getFields(xNew,yNew,_activePlatoon.activeUnit.reichweite);	
			// weg damit, bessere prüfung!! 			
			_activePlatoon.decreaseMovablePieces();
			if(_activePlatoon.activeUnit.canFire) _activePlatoon.activeUnit.battlePiece.setCircleColor(BattlePiece.CIRLCE_COLOR_LIGHTBLUE);
			else 	_activePlatoon.activeUnit.battlePiece.setCircleColor(BattlePiece.CIRLCE_COLOR_RED);
			checkTurnEnd();
			_lastField.free = true;
			_newField.free = false;	
			clearBackground();
		}
								
		public function checkTurnEnd():void	{
			for(var i:uint=0;i<_activePlatoon.platoonCount;i++){
				if(!_activePlatoon.anyUnitCanFire()){
					setEndTurn();				
				}
			} 			
		}							

/*------------------------------------------------------------------------------------------*/
/*-------------------------------------- Messaging -----------------------------------------*/
/*------------------------------------------------------------------------------------------*/
		
		private function sendAddUnit(hexfield:HexField):void {
			var addUnitVO:AddUnitVO = new AddUnitVO(_activePlatoon.activeUnit.id,hexfield.xPos,hexfield.yPos);
			_p2pManager.sendObject(addUnitVO);
			addUnit(_activePlatoon.activeUnit.id,hexfield.xPos,hexfield.yPos);
		}
		
		private function sendMoveUnit(hexfield:HexField):void {
			var moveUnitVO:MoveUnitVO = new MoveUnitVO(_activePlatoon.activeUnit.id,
				_activePlatoon.activeUnit.battlePiece.hexField.xPos,
				_activePlatoon.activeUnit.battlePiece.hexField.yPos,
				hexfield.xPos,hexfield.yPos);
			_p2pManager.sendObject(moveUnitVO);
			moveUnit(_activePlatoon.activeUnit.id,
				_activePlatoon.activeUnit.battlePiece.hexField.xPos,
				_activePlatoon.activeUnit.battlePiece.hexField.yPos,
				hexfield.xPos,hexfield.yPos);
		}
		
		public function sendFight(e:Event):void {
			var attackUnitVO:AttackUnitVO = new AttackUnitVO(
											_activePlatoon.activeUnit.id,
											_passivePlatoon.battleID ,
											_passivePlatoon.activeUnit.id);
			_p2pManager.sendObject(attackUnitVO);	
			fight(_activePlatoon.activeUnit, _passivePlatoon.activeUnit);
		}
		
		public function sendEndTurn(e:MouseEvent):void {
			var endTurnVO:BattleEndTurnVO = new BattleEndTurnVO();
			_p2pManager.sendObject(endTurnVO);
			setEndTurn();
		}			

		/*------------------------------------------------------------------------------------------*/
		/*------------------------------------ Kampf austragen -------------------------------------*/
		/*------------------------------------------------------------------------------------------*/		
		
		// showReachableFields, setcolor nicht in fight !!!!
		private function fight(offener:Unit, defender:Unit):void {	
			clearBackground();
			var defenderCanFire:Boolean = canFire(defender, offener) && defender.munition > 0;	
			var defenderPlatoon:Platoon = defender.platoon;
			// 1) Angreifer feuert
			offener.battlePiece.turnToEnemy(defender.battlePiece);
			showAttack(offener, defender);
			offener.decreaseMunition();
			offener.decreaseRestAktionspunkte(offener.angriffskosten);
			if(offener.angriff >= defender.lebenspunkte){	
				defender.platoon.removeUnit(defender);
				defender = null;
			} else {
				defender.decreaseLebenspunkte(offener.angriff);
				if(offener.lebenspunkte <= defender.verteidigung){
					offener.platoon.removeUnit(offener);
					offener = null;
				}
			}
			// 2) indirekte Verteidigung v. VerteidigerPlatoon 
			if(offener != null) indirectDefence(offener,defenderPlatoon);				
			// 3) direkte Verteidigung
			if((offener && defender) != null && defenderCanFire){
				defender.battlePiece.turnToEnemy(offener.battlePiece);
				defender.decreaseLebenspunkte(offener.angriff);
				defender.decreaseMunition();
				if(offener.lebenspunkte <= defender.verteidigung){
					offener.platoon.removeUnit(offener);
					offener = null;
				} else {
					offener.decreaseLebenspunkte(defender.verteidigung);
				}
			}
			// 4) Kampfende behandeln
			if(offener != null){
				if (offener.canFire) offener.battlePiece.setCircleColor(BattlePiece.CIRLCE_COLOR_LIGHTBLUE);
				else offener.battlePiece.setCircleColor(BattlePiece.CIRLCE_COLOR_RED);
				if (offener.movable && _myPlatoon == offener.platoon) {
					showReachableFields(offener);
				} 
			}
			checkEndGame();
		}
		
		private function showAttack(offener:Unit, defender:Unit):void{
			var offenerXPos:uint = offener.battlePiece.hexField.x;
			var offenerYPos:uint = offener.battlePiece.hexField.y;
			var defenderXPos:uint = defender.battlePiece.hexField.x;
			var defenderYPos:uint = defender.battlePiece.hexField.y;
			var attackAnimation:AnimatedSprite = new AnimatedSprite(_sprite);
			attackAnimation.graphics.lineStyle(1,0xFF0000);			
			attackAnimation.graphics.moveTo(offenerXPos,offenerYPos);
			attackAnimation.graphics.lineTo(defenderXPos,defenderYPos);
			_sprite.addChild(attackAnimation);
			attackAnimation.fadeOut(2000);
		}
		
		private function indirectDefence(offener:Unit, defenderPlatoon:Platoon):void{
			var possibleFields:Array = BFSMoore.getFields(offener.battlePiece.hexField.xPos,offener.battlePiece.hexField.yPos,Pref.UNITS_MAX_REICHWEITE);
			var chckField:HexField;
			var defender:Unit;
			for(var i:uint = 0; i < possibleFields.length; i++){ 
				chckField = getField(possibleFields[i][0],possibleFields[i][1]);
				if(!chckField.free) {
					defender = chckField.battlePiece.unit;
					if(defender is Artillerie && defender.platoon == defenderPlatoon  && defender.munition > 0){
						defender.decreaseMunition();
						showAttack(defender, offener);
						if (defender.angriff > offener.lebenspunkte){
							offener.platoon.removeUnit(offener);
							offener = null;
						} else {
							offener.decreaseLebenspunkte(defender.angriff);
						}
					}
				}
			}
		}
		
		public function canFire(shooter:Unit,target:Unit):Boolean {
			var aktionsRadius:Array = BFSMoore.getFields(shooter.battlePiece.hexField.xPos,shooter.battlePiece.hexField.yPos,shooter.reichweite);
			var targetXPos:uint = target.battlePiece.hexField.xPos;
			var targetYPos:uint = target.battlePiece.hexField.yPos;
			for(var i:uint = 0; i < aktionsRadius.length; i++){ 
				if(targetXPos == aktionsRadius[i][0] && targetYPos == aktionsRadius[i][1])
					return true;
			}
			return false;
		}
		
/*------------------------------------------------------------------------------------------*/
/*---------------------------- Wege finden und anzeigen ------------------------------------*/
/*------------------------------------------------------------------------------------------*/
		
		private function getReachableFieldWayCost(hexField:HexField):uint{
			for(var i:uint = 0; i<closedFields.length;i++){						
				if(closedFields[i][1] == hexField.xPos && closedFields[i][2] == hexField.yPos){
					return closedFields[i][5];
				}
			}
			return null;
		}
		
		private function setWays():void	{
			ways = new Array(way.length - 1);
			var nextField:HexField;
			var startField:HexField = _lastField;
			var diffX:Number;
			var diffY:Number;
			
			for (var i:uint = 0;i<ways.length;i++){
				ways[i] = new Array(2);
				nextField = hexFields[way[i+1][0]][way[i+1][1]];
				diffX = nextField.x - startField.x;
				diffY = nextField.y - startField.y;
				ways[i][0] = diffX;
				ways[i][1] = diffY;
				startField = nextField;
			}
			_activePlatoon.activeUnit.battlePiece.moveUnit(ways);	
		}
		
		public function showWay(xPosition:uint, yPosition:uint):void{
			var childField:HexField;
			var parentField:HexField;
			var count:uint = 1;
			way = new Array();
			way[0] = new Array(2);
			way[0][0] = xPosition;
			way[0][1] = yPosition;
			childField = getField(xPosition, yPosition);
			while(childField != _lastField){	
				parentField = getField(childField._parentX, childField._parentY);
				way[count] = new Array();
				way[count][0] = parentField.xPos;
				way[count][1] = parentField.yPos;
				count++;
				childField = parentField;
			}
			way.reverse();
			setWays();
		}
		
		public function showReachableFields(unit:Unit):void{
			var openFields:Array = new Array();
			var reachableNeighbours:Array;
			closedFields = new Array();
			var chckField:HexField;
			var currentField:HexField;
			var xPos:uint = unit.battlePiece.hexField.xPos;
			var yPos:uint = unit.battlePiece.hexField.yPos;
			
			currentField = hexFields[xPos][yPos];
			reachableNeighbours = getReachableNeighbours(xPos, yPos, unit.restAktionspunkte);
			if (reachableNeighbours.length > 0)	{
				for (var i:uint=0;i<reachableNeighbours.length;i++)	{
					chckField = hexFields[reachableNeighbours[i][0]][reachableNeighbours[i][1]];
					chckField.setChecked();
					chckField.setParent(xPos, yPos);
					chckField.setRemainingWayPoints(unit.restAktionspunkte - chckField.getFieldCost());
					fillArray(openFields,xPos,yPos,chckField.xPos, chckField.yPos);
				}
			}
			while(openFields.length > 0){
				currentField = hexFields[openFields[0][0]][openFields[0][1]];
				reachableNeighbours = getReachableNeighbours(currentField.xPos, currentField.yPos, currentField.getRemainingWayPoints());
				for (var j:uint=0;j<reachableNeighbours.length;j++)	{
					chckField = hexFields[reachableNeighbours[j][0]][reachableNeighbours[j][1]];
					if(!chckField.isChecked()){
						chckField.setChecked();
						chckField.setParent(currentField.xPos, currentField.yPos);
						chckField.setRemainingWayPoints(currentField.getRemainingWayPoints() - chckField.getFieldCost());
						fillArray(openFields, currentField.xPos, currentField.yPos, chckField.xPos, chckField.yPos);
					} else {								
						if(currentField.getRemainingWayPoints() - chckField.getFieldCost() > chckField.getRemainingWayPoints())	{
							chckField.setRemainingWayPoints(currentField.getRemainingWayPoints() - chckField.getFieldCost());
							if (chckField.isInClosedFields()){
								chckField.setInClosedFields(false);
								chckField.setParent(currentField.xPos, currentField.yPos);
								chckField.setRemainingWayPoints(currentField.getRemainingWayPoints() - chckField.getFieldCost());
								swapToOpenFields(chckField, currentField, openFields);
							} else {
								chckField.setParent(currentField.xPos, currentField.yPos);
								openFields = correctParent(chckField, currentField, openFields);
							}
						}					
					}
				}
				currentField.setInClosedFields(true);
				closedFields.push(openFields[0]);
				openFields.shift();
			}
		}
		
		private	function getFieldCost(unit:Unit, chckField:HexField):uint{
			if (unit is Flieger){
				return 1;
			}
			return chckField.getFieldCost();
		}
		
		private	function fillArray(fields:Array, xOld:uint, yOld:uint, xNew:uint, yNew:uint):void{
			var fieldInfo:Array = new Array();
			fieldInfo[0] = xNew;
			fieldInfo[1] = yNew;
			fieldInfo[2] = xOld;
			fieldInfo[3] = yOld;
			fields.push(fieldInfo);									
		}
		
		private	function swapToOpenFields(chckField:HexField, currentField:HexField, openFields:Array):void{
			var x:uint = chckField.xPos;
			var y:uint = chckField.yPos;
			for(var i:uint = 0; i<closedFields.length;i++){
				if(x == closedFields[i][0] && y == closedFields[i][1])	{
					closedFields[i][2] = currentField.xPos;
					closedFields[i][3] = currentField.yPos;
					openFields.unshift(closedFields[i]);
					closedFields.splice(i,1);
					break;
				}
			}
		}
		
		private	function correctParent(chckField:HexField, currentField:HexField, openFields:Array):Array {
			var x:uint = chckField.xPos;
			var y:uint = chckField.yPos;
			for(var i:uint = 0; i<openFields.length;i++){
				if(x == openFields[i][0] && y == openFields[i][1])	{
					openFields[i][2] = currentField.xPos;
					openFields[i][3] = currentField.yPos;
					return openFields;
				}
			}
			// nicht gut  !!! 
			return null;
		}		
		
		private	function getReachableNeighbours(xKachel:uint, yKachel:uint, restPunkte:uint):Array {
			var reachableNeighbours:Array = new Array();
			var neighbours:Array = getNeighbours(xKachel,yKachel);
			var chckField:HexField;
			for (var i:uint=0;i<neighbours.length;i++){
				if(0 <= neighbours[i][0] && neighbours[i][0] < rows && 0 <= neighbours[i][1] && neighbours[i][1]< col) {
					chckField = hexFields[neighbours[i][0]][neighbours[i][1]];
					if(chckField.free &&  restPunkte >= chckField.getFieldCost()){
						reachableNeighbours.push(neighbours[i]);
					}
				}
			}
			return reachableNeighbours;
		}
		
		private	function getNeighbours(xKachel:uint, yKachel:uint):Array{
			var neighbours:Array = new Array(6);
			var top:Array   = new Array(2);
			var topR:Array  = new Array(2);
			var downR:Array = new Array(2);
			var down:Array  = new Array(2);
			var downL:Array = new Array(2);
			var topL:Array  = new Array(2);
			top[0]   = xKachel - 2;
			top[1]   = yKachel;
			topR[0]  = xKachel - 1;
			topR[1]  = yKachel + (xKachel%2);
			downR[0] = xKachel+ 1;
			downR[1] = yKachel  + (xKachel%2);
			down[0]  = xKachel + 2;
			down[1]  = yKachel;
			downL[0] = xKachel + 1;
			downL[1] = yKachel -1 + (xKachel%2);
			topL[0]  = xKachel - 1;
			topL[1]  = yKachel  -1 + (xKachel%2);
			neighbours[0] = top;
			neighbours[1] = topR;
			neighbours[2] = downR;
			neighbours[3] = down;
			neighbours[4] = downL;
			neighbours[5] = topL;
			return neighbours;
		}
/*------------------------------------------------------------------------------------------*/
/*----------------------------------- Getter und Setter ------------------------------------*/
/*------------------------------------------------------------------------------------------*/

		public function getField(x:uint , y:uint):HexField{
			return hexFields[x][y];
		}
		
		public function get isKampfPhase():Boolean {
			return kampfPhase;
		}
				
		public function get iAmActivePlatoon():Boolean{
			return _myPlatoon == _activePlatoon;
		}
		
		public function get myPlatoon():Platoon{
			return _myPlatoon;
		}	
		
		public function get activePlatoon():Platoon	{
			return _activePlatoon;
		}
		
		public function set activePlatoon(platoon:Platoon):void	{
			_activePlatoon = platoon;
		}
		
		public function get passivePlatoon():Platoon{
			return _passivePlatoon;
		}
		
		public function set passivePlatoon(platoon:Platoon):void{
			_passivePlatoon = platoon;
		}	
				
		public function get infobar():InfoBar{
			return _infoBar;
		}		
		
		public function get isEinsatzPhase():Boolean{
			return einsatzPhase;
		}			
		
		public function get sprite():Sprite{
			return _sprite;
		}							
	}
}
