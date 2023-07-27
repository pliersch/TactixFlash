package game.battlefield {
		
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	import game.units.Unit;
	
	public class BattlePiece {
		
		private var _battlefield:Battlefield;
		private var _hexField:HexField;
		private var _unit:Unit;
		private var _innerMC:MovieClip;
		private var _circleMovable:Shape;
		private var _isActUnit:Boolean;
		private var _isInReichweite:Boolean;
		private var _fightResultTF :TextField;
		private var _unitInfoTF :TextField;
		private var _remainingPointsTF :TextField;
		private var _ways:Array;
		private var _counter:uint;
		private var _timer:Timer;
		private var _sprite:Sprite;
		private var _overSprite:Sprite;
		
		public static var CIRLCE_COLOR_GREEN:uint = 0x00FF00;
		public static var CIRLCE_COLOR_LIGHTBLUE:uint = 0x23A9FE;
		public static var CIRLCE_COLOR_RED:uint = 0xFF0000;

		public function BattlePiece(unit:Unit, battlefield:Battlefield, hexField:HexField){
			_battlefield = battlefield;
			_hexField = hexField;
			_isActUnit = false;
			_isInReichweite = false;
			_sprite = new Sprite();
			_unit = unit;
			_overSprite = getOverSprite();
	
			_fightResultTF = new TextField();
			_fightResultTF.autoSize = TextFieldAutoSize.LEFT;
			_fightResultTF.selectable = false;
			
			_unitInfoTF = new TextField();
			_unitInfoTF.autoSize = TextFieldAutoSize.LEFT;
			_unitInfoTF.selectable = false;

			_remainingPointsTF = new TextField();
			_remainingPointsTF.autoSize = TextFieldAutoSize.LEFT;
			_remainingPointsTF.selectable = false;
			
			if(_unit.typ==0)	{
				[Embed(source = '../media/GameAssetsOld.swf#SoldierMC')]
				var SoldierMC:Class;
				_innerMC = new SoldierMC();
				_innerMC.scaleX = 0.2;
				_innerMC.scaleY = 0.2;
			} else if(_unit.typ==1){
				[Embed(source = '../media/GameAssetsOld.swf#TankMC')]
				var TankMC:Class;
				_innerMC = new TankMC();	
				_innerMC.scaleX = 0.2;
				_innerMC.scaleY = 0.2;				
			} else if(_unit.typ==2){
				[Embed(source = '../media/GameAssetsOld.swf#ArtillerieMC')]
				var ArtillerieMC:Class;
				_innerMC = new ArtillerieMC();
				_innerMC.scaleX = 0.3;
				_innerMC.scaleY = 0.3;				
			} else if(_unit.typ==3){
				[Embed(source = '../media/GameAssetsOld.swf#FliegerMC')]
				var FliegerMC:Class;
				_innerMC = new FliegerMC();
				_innerMC.scaleX = 0.3;
				_innerMC.scaleY = 0.3;				
			} else if(_unit.typ==4){
				[Embed(source = '../media/GameAssetsOld.swf#MechMC')]
				var MechMC:Class;
				_innerMC = new MechMC();
				_innerMC.scaleX = 0.3;
				_innerMC.scaleY = 0.3;				
			} else {
				[Embed(source = '../media/GameAssetsOld.swf#FlakMC')]
				var FlakMC:Class;
				_innerMC = new FlakMC();
				_innerMC.scaleX = 0.3;
				_innerMC.scaleY = 0.3;				
			}		
			_innerMC.gotoAndStop(1);
//			_innerMC.useHandCursor = true;
//			_sprite.useHandCursor = true;
			_sprite.buttonMode = true;
			_innerMC.buttonMode = true;
			_circleMovable = new Shape();
			
			_sprite.addChild(_innerMC);
			_sprite.addChild(_fightResultTF);
			_sprite.addChild(_unitInfoTF);
			_sprite.addChild(_remainingPointsTF);
			_sprite.addChild(_circleMovable);
			_sprite.addChild(_overSprite);
			_sprite.addEventListener(MouseEvent.CLICK, battlePieceClickHandler);
			_sprite.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_sprite.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		
		private function battlePieceClickHandler(event:MouseEvent):void {
			if(_battlefield.iAmActivePlatoon && _battlefield.isKampfPhase){
				if(iAmOwner) {
					showReachableFields();
				} else {
					attackThisUnit();
				}
			} 
		}
		
		public function onOver(event:MouseEvent):void {
			if (iAmOwner){
				showMiniUnitInfo(true);
				_battlefield.infobar.showMyUnitInfo(_unit);
			} else {
				_battlefield.infobar.showEnemyUnitInfo(_unit);
				if(_battlefield.isKampfPhase && _battlefield.activePlatoon.activeUnit.canFire){
					if(_battlefield.canFire(_battlefield.activePlatoon.activeUnit, this._unit))	{
						_isInReichweite = true;		
						_fightResultTF.visible = true;
						if(_battlefield.canFire(this._unit,_battlefield.activePlatoon.activeUnit) && _battlefield.activePlatoon.activeUnit.angriff < this.unit.lebenspunkte)
						_fightResultTF.text = _battlefield.activePlatoon.activeUnit.angriff + " | " + this.unit.verteidigung;
						else _fightResultTF.text = _battlefield.activePlatoon.activeUnit.angriff + " | 0";
						_fightResultTF.x = _sprite.x - _fightResultTF.width / 2;
						_fightResultTF.y = _sprite.y -15;
						_fightResultTF.textColor = 0xFFFF00;
						_fightResultTF.background = true;
						_fightResultTF.backgroundColor = 0;	
					}
				}
			}
		}

		public function onOut(event:MouseEvent):void {
			_isInReichweite = false;
			_fightResultTF.visible = false;
			showMiniUnitInfo(false);
			if (iAmOwner) _battlefield.infobar.hideMyUnitInfo();
			else _battlefield.infobar.hideEnemyInfo();
		}
		
		private function showReachableFields():void {
			_unit.setActive();
			_battlefield.clearBackground();
			_unit.aktionsRadius = BFSMoore.getFields(_hexField.xPos,_hexField.yPos,_unit.reichweite);					
			if (_unit.movable)	{
				_battlefield.showReachableFields(_unit);
				_hexField.setBackground(HexField.BG_COLOR_GRAY);
			}
		}
		
		private function attackThisUnit():void {
			//TODO: scheint von hinten durch die brust zu sein, kürzer?
			_battlefield.passivePlatoon = this.unit.platoon;
			_battlefield.passivePlatoon.activeUnit = this.unit;					
			if(_isInReichweite && _battlefield.activePlatoon.activeUnit.canFire){
				var fightEvent: Event = new Event("fight", true);
				_sprite.dispatchEvent(fightEvent);		
			}			
		}		
			
		private function showMiniUnitInfo(visible:Boolean):void {
			_unitInfoTF.visible = visible;
			_unitInfoTF.text = _unit.typ + "|" + _unit.id;
			_unitInfoTF.x = -_unitInfoTF.width / 2;
			_unitInfoTF.y = -30;
			_unitInfoTF.textColor = 0xFFFF00;
			_unitInfoTF.background = true;
			_unitInfoTF.backgroundColor = 0;
			_remainingPointsTF.visible = visible;
			_remainingPointsTF.text = String(_unit.restAktionspunkte);
			_remainingPointsTF.x = -_unitInfoTF.width / 2;
			_remainingPointsTF.y = 10;
			_remainingPointsTF.textColor = 0xFFFF00;
			_remainingPointsTF.background = true;
			_remainingPointsTF.backgroundColor = 0;			
		}
		
		private function getOverSprite():Sprite{
			var overSprite:Sprite = new Sprite();
			overSprite.graphics.clear();
			overSprite.graphics.beginFill(0xFFFFFF,0.01);
			overSprite.graphics.lineStyle(1, 0);
			overSprite.graphics.drawCircle(0, 0, 30);
			overSprite.graphics.endFill();
			return overSprite;
		}		
		
        public function setCircleColor(color:uint):void {
        	_circleMovable.graphics.clear();
            _circleMovable.graphics.beginFill(color);
            _circleMovable.graphics.lineStyle(1, 0);
            _circleMovable.graphics.drawCircle(-16, -16, 5);
            _circleMovable.graphics.endFill();
        }
		
		private function get iAmOwner():Boolean	{
			return _battlefield.myPlatoon == _unit.platoon;
        }	
				
		public function moveUnit(ways:Array):void{
			_ways = ways;
			_timer = new Timer(20,10*_ways.length);
			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
            _timer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
        }

        private function timerHandler(e:TimerEvent):void {
			this.changeDirection(_ways[0]);
			_sprite.x += _ways[0][0] / 10; 
			_sprite.y += _ways[0][1] / 10;
			_counter++;			
			if(_counter == 10){
				_ways.shift();				
				_counter = 0;
			}
        }
       
        private function completeHandler(e:TimerEvent):void {
			_sprite.x = 0;
			_sprite.y = 0;
			_hexField.addUnit(this);
		}
		
		public function changeDirection(nextField:Array):void{
			if(nextField[0] == 0 && nextField[1] < 0){
				_innerMC.gotoAndStop(1);
			} 
			else if (nextField[0] > 0 && nextField[1] < 0){
				_innerMC.gotoAndStop(2);
			} 
			else if (nextField[0] > 0 && nextField[1] > 0){
				_innerMC.gotoAndStop(3);
			} 
			else if (nextField[0] == 0 && nextField[1] > 0){
				_innerMC.gotoAndStop(4);
			} 
			else if (nextField[0] < 0 && nextField[1] > 0){
				_innerMC.gotoAndStop(5);
			} 
			else if (nextField[0] < 0 && nextField[1] < 0){
				_innerMC.gotoAndStop(6);
			} 
		}
		
//		public function turnToOpponent(enemy:BattlePiece):void{	
//			var distanceX:int = enemy.hexField.x - this.hexField.x;
//			var distanceY:int = enemy.hexField.y - this.hexField.y;
//			var angle:Number = Math.atan(distanceY / distanceX)  * 180 / Math.PI;
//			trace("Winkel: " + angle);
//			_sprite.rotation = angle;
//		}		
		
		public function turnToEnemy(enemy:BattlePiece):void{
			var distanceX:int = enemy.hexField.x - this.hexField.x;
			var distanceY:int = enemy.hexField.y - this.hexField.y;
			if(distanceX == 0 && distanceY < 0){
				_innerMC.gotoAndStop(1);
			} 
			else if (distanceX > 0 && distanceY < 0){
				_innerMC.gotoAndStop(2);
			} 
			else if (distanceX > 0 && distanceY > 0){
				_innerMC.gotoAndStop(3);
			} 
			else if (distanceX == 0 && distanceY > 0){
				_innerMC.gotoAndStop(4);
			} 
			else if (distanceX < 0 && distanceY > 0){
				_innerMC.gotoAndStop(5);
			} 
			else if (distanceX < 0 && distanceY < 0){
				_innerMC.gotoAndStop(6);
			} 
		}

/*------------------------------------------------------------------------------------------*/
/*----------------------------------- Getter und Setter ------------------------------------*/
/*------------------------------------------------------------------------------------------*/

		public function get unit():Unit	{
			return _unit;
		}

		public function get hexField():HexField	{
			return _hexField;
		}
		
		public function set hexField(hf:HexField):void{
			_hexField = hf;
		}
		
		public function get id():String	{
			return _unit.typ + "." + _unit.id;
		}	
		
		public function get sprite():Sprite{
			return _sprite;
		}								
	}
}
