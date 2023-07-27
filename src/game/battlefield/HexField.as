
package game.battlefield {
	
	import core.Platoon;
	import core.Players;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import game.units.*;
	
	import util.Tools;
	
	public class HexField extends Sprite {
		
		private var _xPos				:uint;
		private var _yPos				:uint;
		private var typ					:uint;
		//private var counter				:uint;	
		private var _remainingWayPoints	:uint;		
		private var parentX				:uint = 0;
		private var parentY				:uint = 0;
		private var _isChecked			:Boolean;
		private var _isStartField		:Boolean;
		private var _isInClosedField	:Boolean;
		private var _isEnemyInField		:Boolean;
		private var _isFree				:Boolean;
		private var innerMC				:MovieClip;
		private var _battlePiece			:BattlePiece;
		//private var ways				:Array;
		private var xyTF				:TextField;
		private var typTF				:TextField;		
				
		public static var STREET:uint   = 1;
		public static var WOOD:uint     = 2;
		public static var MOUNTAIN:uint = 3;		
		public static var BG_COLOR_GRAY:uint   = 1;		
		public static var BG_COLOR_RED:uint    = 2;
		public static var BG_COLOR_YELLOW:uint = 3;
		public static var BG_COLOR_ALPHA:uint  = 5;
		
		public function HexField(xPos:uint, yPos:uint,_typ:uint){	
			_xPos        = xPos;
			_yPos        = yPos;
			typ         = _typ;
			init();
			//showPosition();
			//showCost();
			//showCenter();
		}

		public function init():void{
			[Embed(source = '../media/GameAssets.swf#KachelKlein')]
			var kachel:Class;
			innerMC = new kachel();	
			innerMC.gotoAndStop(5);
			addChild(innerMC);
			_isStartField = false;
			_isEnemyInField = false;
			_isFree = true;
			this.buttonMode = false;
			_remainingWayPoints = 20;
			xyTF = new TextField();
			typTF = new TextField();
			typTF.setTextFormat(Tools.setTextForm("babylon5Credits",20,0x00FFFF,"left", false));
		}
		
		public function setStartField():void{
			_isStartField = true;
			innerMC.gotoAndStop(1);
			this.buttonMode = true;
		}
		
		private function showPosition():void{
			xyTF.autoSize = TextFieldAutoSize.LEFT;
			xyTF.selectable = false;
			xyTF.text = _xPos + "/" + _yPos;
			xyTF.x = -15;
			xyTF.y = -20;
			addChild(xyTF);
		}
		
		private function showCenter():void{
			var center:Shape = new Shape();
			center.graphics.clear();
            center.graphics.beginFill(0xFF0000);
            center.graphics.lineStyle(1, 0);
            center.graphics.drawCircle(5, 5, 5);
            center.graphics.endFill();
			addChild(center);
		}		
		
		private function showCost():void{
			typTF.autoSize = TextFieldAutoSize.LEFT;
			typTF.textColor = 0x0000FF;
			typTF.selectable = false;
			typTF.text = " " + typ;
			typTF.x = -15;
			typTF.y = -8;
			addChild(typTF);
		}
		
		public function setText(txt:String):void{
			typTF.text = txt;
			typTF.autoSize = TextFieldAutoSize.LEFT;
			typTF.selectable = false;
			typTF.setTextFormat(Tools.setTextForm("babylon5Credits", 20, 0x00FF00,"left",true));
			typTF.x = -15;
			typTF.y = -8;
			addChild(typTF);
		}
						
		public function isEnemyInField():Boolean{
			return _isEnemyInField;
		}
				
		public function addUnit(battlePiece:BattlePiece):void{
			_battlePiece = battlePiece;
			addChild(_battlePiece.sprite);
			this.free = false;
		}
						
		public function removeUnit():void{
			removeChild(_battlePiece.sprite);
			_battlePiece = null;
			this.free = true;
		}
				
		public function setBackground(_color:uint):void{
			innerMC.gotoAndStop(_color);			
		}
		
		public function reset():void{
			innerMC.gotoAndStop(5);
			_isChecked = false;
			_remainingWayPoints = 20;
			this.buttonMode = false;
		}
		
		public function setChecked():void{
			innerMC.gotoAndStop(1);
			_isChecked = true;
			this.buttonMode = true;
		}
				
		public function setRemainingWayPoints(remainingWayPoints:uint):void	{
			_remainingWayPoints = remainingWayPoints;
		}
		
		public function getRemainingWayPoints():uint{
			return _remainingWayPoints;
		}
		
		public function setInClosedFields(close:Boolean):void{
			_isInClosedField = close;
		}
		
		public function isInClosedFields():Boolean{
			return _isInClosedField;
		}				
		
		public function isChecked():Boolean{
			return _isChecked;
		}
		
		public function getParent():Array{
			var parent:Array = new Array(2);
			parent[0] = parentX;
			parent[1] = parentY;
			return parent;
		}		
				
/*------------------------------------------------------------------------------------------*/
/*----------------------------------- Getter und Setter ------------------------------------*/
/*------------------------------------------------------------------------------------------*/		

		public function get xPos():uint	{
			return _xPos;
		}
		
		public function get yPos():uint	{
			return _yPos;
		}
		
		public function get remainingWayPoints():uint{
			return _remainingWayPoints;
		}
		
		public function get _parentX():uint	{
			return parentX;
		}
		
		public function get _parentY():uint	{
			return parentY;
		}		
				
		public function get isStartField():Boolean	{
			return _isStartField && _isFree;
		}
		
		public function get free():Boolean{
			return _isFree;
		}
		
		public function set free(free:Boolean):void	{
			_isFree = free;
		}	
		
		public function set battlePiece(battlePiece:BattlePiece):void{
			_battlePiece = battlePiece;
		}
		
		public function get battlePiece():BattlePiece{
			return _battlePiece;
		}	

		public function setParent(_parentX:uint, _parentY:uint):void{
			parentX = _parentX;
			parentY = _parentY;
		}
		
		public function getTyp():uint{
			return typ;
		}
		
		public function setTyp(_typ:uint):void{
			typ = _typ;
		}		
		
		public function getFieldCost():uint{
			return typ;
		}
	}
}