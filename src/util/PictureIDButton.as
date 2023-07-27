package util {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import util.GraphicLoader;
	
	public class PictureIDButton extends PictureButton	{	
		private var _id:uint;
					
		public function PictureIDButton(id:uint, overSkinPath:String, outSkinPath:String, downSkinPath:String) {
			super(overSkinPath, outSkinPath, downSkinPath);
			_id = id;						
		}
		
		public function get id() : uint	{
			return _id;
		}	
	}
}