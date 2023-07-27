package util {
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	public class PictureButton extends Sprite {
		private var overSkin:Sprite;
		private var outSkin:Sprite;
		private var downSkin:Sprite;
				
		public function PictureButton(overSkinPath:String, outSkinPath:String, downSkinPath:String)	{
			overSkin = new Sprite;
			outSkin  = new Sprite;
			downSkin = new Sprite;
			overSkin.addChild(new GraphicLoader(overSkinPath));
			outSkin.addChild(new GraphicLoader(outSkinPath));
			downSkin.addChild(new GraphicLoader(downSkinPath));
			addChild(overSkin);
			addChild(outSkin);
			addChild(downSkin);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			addEventListener(KeyboardEvent.KEY_DOWN, onEnterDown);
			outSkin.visible  = true;
			overSkin.visible = false;
			downSkin.visible = false;							
		}
		
		public function onEnterDown(e:KeyboardEvent):void {
			if(e.charCode == (Keyboard.ENTER|| Keyboard.SPACE)){
				outSkin.visible  = false;
				overSkin.visible = false;
				downSkin.visible = true;			
			}
		}
		
		public function onDown(e:MouseEvent):void {
			outSkin.visible  = false;
			overSkin.visible = false;
			downSkin.visible = true;
		}

		public function onOver(e:MouseEvent):void {
			outSkin.visible  = false;
			overSkin.visible = true;
			downSkin.visible = false;
		}
		
		public function onOut(e:MouseEvent):void {
			outSkin.visible  = true;
			overSkin.visible = false;
			downSkin.visible = false;
		}
	}
}