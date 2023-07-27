package components.leveleditor {	
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	
	public class Field extends Sprite{		
		private var _xPos:uint;
		private var _yPos:uint;
		private var _cost:uint;
		private var _kachel:MovieClip;
		private var xyTF:TextField;
		private var _levelEditor:LevelEditor;
		private var _hasMoney:Boolean;
		private var _money:uint;
			
		public static var WOOD_ID:uint = 1; 
		public static var WATER_ID:uint = 2;
		public static var MOUNTAIN_ID:uint = 3;
		public static var GRASS_ID:uint = 4;
		public static var TOWN_ID:uint = 5;
		public static var ROAD_ID:uint   = 6;
		public static var START_ID:uint   = 7;
		
		public function Field(levelEditor:LevelEditor, xPos:uint, yPos:uint){	
			_xPos = xPos;
			_yPos = yPos;
			_levelEditor = levelEditor;
			_kachel = new Kachel();
			_kachel.gotoAndStop(1);
			addChild(_kachel as MovieClip);
			buttonMode = true;
			xyTF = new TextField();
			addEventListener(MouseEvent.MOUSE_DOWN, onClick);		
			showPosition();
		}	
		
		public function setStartField():void{

		}
		
		private function showPosition():void{
			xyTF.autoSize = TextFieldAutoSize.LEFT;
			xyTF.selectable = false;
			xyTF.text = _xPos + "/" + _yPos;
			xyTF.x = 5;
			xyTF.y = 5;
			addChild(xyTF);
		}
		
		private function onClick(e:MouseEvent):void {								      
			_levelEditor.getCoordinates(this._xPos, this._yPos);
			setItem(_levelEditor.currentItemID);
		}

		public function setItem(item:uint):void{
			switch(item){
				case TOWN_ID: 
					_kachel.gotoAndStop(TOWN_ID);
					_cost = 1;
				break; 
				case WOOD_ID: 
					_kachel.gotoAndStop(WOOD_ID);
					_cost = 2;
				break;
				case MOUNTAIN_ID: 
					_kachel.gotoAndStop(MOUNTAIN_ID);
					_cost = 3;
					break;
				case WATER_ID: 
					_kachel.gotoAndStop(WATER_ID);
					_cost = 20;
					break;
				case GRASS_ID: 
					_kachel.gotoAndStop(GRASS_ID);
					_cost = 2;
					break;
				case ROAD_ID: 
					_kachel.gotoAndStop(ROAD_ID);
					_cost = 1;
					break;
			}
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

		public function get typ():uint {
			return _cost;
		}

		public function get cost():uint {
			return _cost;
		}

		public function set cost(value:uint):void {
			_cost = value;
		}
	}
}