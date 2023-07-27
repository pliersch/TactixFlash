package util
{
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	public class Tools
	{
		public static function setTextForm(_font:String, _size:Number, _color:Number, _align:String, _bold:Boolean):TextFormat
		{
			var textForm:TextFormat = new TextFormat();
			textForm.font = _font;
			textForm.align = _align;
			textForm.size = _size;
			textForm.color = _color;
			textForm.bold = _bold;
			return textForm;
		}
		
		public static function glow(_color:uint, _alpha:Number, _blurX:uint, _blurY:uint):GlowFilter
		{
			var glow:GlowFilter = new GlowFilter();
			glow.color = _color;
			glow.alpha = _alpha;
			glow.blurX = _blurX;
			glow.blurY = _blurY;
			glow.quality = BitmapFilterQuality.MEDIUM;
			return glow;				
		}
		
//		public static function getRandomColor():int
//		{
//			
//		}
	}
}