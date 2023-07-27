package game {
	import core.Platoon;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import game.units.*;
	
	public class TruppenArray extends Sprite{		
		private var _platoon:Platoon;
		private var container :Array;
		private var counter:uint;
		private var _margin:uint;
		private var aktuelleContainerEinheit:uint;
		private var activeArrayFigure:ArrayFigure;
		private var length:uint;
		private var background:Shape;
		private var border:Sprite;
		
		public function TruppenArray(){
			aktuelleContainerEinheit = 0;
			_margin = 60;
			[Embed(source = '../media/tmp.swf#TruppArray')]
			var TruppArray:Class;
			border = new TruppArray() as Sprite;
			border.scale9Grid = new Rectangle(10, 10, 40, 20);
			background = new Shape;
			background.graphics.beginFill(0,0.5);
			background.graphics.drawRect( 0, 0, border.width, border.height);
			background.graphics.endFill();
			addChild(background);
			addChild(border);
			container  = new Array();
		}
		
		public function set platoon(platoon:Platoon):void{
			_platoon = platoon;
		}

		public function showBorder(show:Boolean):void {
			border.visible = show;
		}
		
		public function showBG(show:Boolean):void{
			background.visible = show;
		}	
		
		public function set margin(m:uint):void {
			_margin = m;
		}			
		
		public function createArray():void 	{
			length = _platoon.platoonCount * _margin + 4;
			scaleContainer();
			for (var n:uint=0;n<counter;n++){
				removeChildAt(2);
			}
			counter = 0;
			for(var i:uint=0;i<_platoon.platoonCount;i++){
				if(_platoon.getUnit(i).inField == false)	{
					container[counter] = new ArrayFigure(_platoon.getUnit(i));
					container[counter].addEventListener(MouseEvent.MOUSE_DOWN, onPress);
					container[counter].setArrayElem(counter);
					container[counter].x = length = 4 + counter * _margin;
					container[counter].y = 4;
					addChild(container[counter]);
					counter++;
				}					
			}
		}
		
		private function onPress(event:MouseEvent):void {
			activeArrayFigure = event.target.parent as ArrayFigure;
			_platoon.activeUnit = activeArrayFigure.unit;
			unhighlightUnits();
			activeArrayFigure.highlight();
		}		
		
		private function scaleContainer():void{
			background.graphics.clear();
			background.graphics.beginFill(0,0.5);
			background.graphics.drawRect( 0, 0, length + 6, border.height);
			background.graphics.endFill();
			border.scaleX *= (length+12) / border.width;
		}	
			
		public function unhighlightUnits():void	{
			for(var k:uint=0;k<_platoon.platoonCount;k++){
				container[k].unhighlight();
			}
		}
	}
}