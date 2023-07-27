package game {
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import game.units.Unit;

	public class ArrayFigure extends Sprite {
		private var _unit:Unit;
		private var arrayElem:uint;
		private var innerMC:MovieClip;
		private var _isActivated:Boolean;	
		
		public function ArrayFigure(unit:Unit) {
			_unit = unit;
			var typ:uint = _unit.typ;
			_isActivated = false;
			if(typ==0){
				[Embed(source = '../../media/assets.swf#ASoldier')]
				var ASoldier:Class;
				innerMC = new ASoldier();				
			} else if (typ==1) {
				[Embed(source = '../../media/assets.swf#APanzer')]
				var APanzer:Class;
				innerMC = new APanzer();					
			} else if (typ==2) {
				[Embed(source = '../../media/assets.swf#AArtillerie')]
				var AArtillerie:Class;
				innerMC = new AArtillerie();					
			} else if (typ==3) {
				[Embed(source = '../../media/assets.swf#AFlieger')]
				var AFlieger:Class;
				innerMC = new AFlieger();					
			} else if (typ==4) {
				[Embed(source = '../../media/assets.swf#AMech')]
				var AMech:Class;
				innerMC = new AMech();					
			} else if (typ==5) {
				[Embed(source = '../../media/assets.swf#AFlak')]
				var AFlak:Class;
				innerMC = new AFlak();					
			}
			innerMC.gotoAndStop(1);
			addChild(innerMC);
			this.buttonMode = true;
		}
		
		public function get unit():Unit{
			return _unit;
		}	
		
		public function get isActivated():Boolean{
			return _isActivated;
		}	
		
//		public function set isActivated(activated:Boolean):void{
//			_isActivated = isActivated;
//		}					
		
		public function setArrayElem(nr:uint):void{
			arrayElem = nr;
		}	

		public function getArrayElem():uint{
			return arrayElem;
		}
		
		public function unhighlight():void{
			innerMC.gotoAndStop(1);
			_isActivated = false;
		}
		
		public function highlight():void{
			innerMC.gotoAndStop(2);
			_isActivated = true;
		}
	}
}

