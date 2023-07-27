package game.world{
	import animatedDisplayObjects.AnimatedSprite;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import util.SimpleShapes;
	import util.Tools;
	
	public class TransferAndAttackArrow extends AnimatedSprite{
		private var infoTF:TextField;	
//		private var transferPieces:uint;	
//		private var transferMessage:String;
		//TODO: notwendig oder gleich name? (_platoonmoves.getchildByName)
		private var _id:String;
		private var _infoTF_BG:Shape;
		private var _infoPosX:Number;
		private var _infoPosY:Number;
				
		public function TransferAndAttackArrow(parent:Sprite, offenerRegion:Region, defenderRegion:Region, count:uint)	{
			super(parent);
			drawArrow(offenerRegion, defenderRegion);
			_infoPosX = (offenerRegion.container.x + defenderRegion.container.x) / 2;
			_infoPosY = (offenerRegion.container.y + defenderRegion.container.y) / 2;
			_infoTF_BG = SimpleShapes.circle(_infoPosX,_infoPosY,5,0xFFFFFF,1,0,0,0);
			_id = offenerRegion.id + "." + defenderRegion.id;
			this.name = _id;
			infoTF = new TextField();
			infoTF.autoSize = TextFieldAutoSize.LEFT;
			infoTF.selectable = false;
			infoTF.text = " " + count + " ";
			infoTF.x = (offenerRegion.container.x + defenderRegion.container.x - infoTF.width) / 2;
			infoTF.y = (offenerRegion.container.y + defenderRegion.container.y - infoTF.height) / 2;
			addChild(_infoTF_BG);
			addChild(infoTF); 			
		}
						
		private function drawArrow(offenerRegion:Region, defenderRegion:Region):void{
			graphics.lineStyle(4,0xffffff);			
			graphics.moveTo(offenerRegion.container.x,offenerRegion.container.y);
			graphics.lineTo(defenderRegion.container.x,defenderRegion.container.y);
			filters = [Tools.glow(0xFFFFFF,1,8,8)];						
			graphics.lineStyle(2,offenerRegion.ownerPlatoon.owner.color);			
			graphics.moveTo(offenerRegion.container.x,offenerRegion.container.y);
			graphics.lineTo(defenderRegion.container.x,defenderRegion.container.y);
		}	
		
		public function get id():String {
			return _id; 
		}
	}
}