package util
{
	import flash.display.Shape;
	
	public class SimpleShapes
	{				
		public static function circle(x:Number, y:Number, radius:Number, 
									  fillColor:uint, fillAlpha:Number, 
									  borderColor:uint, borderThickness:Number, borderAlpha:Number):Shape
		{
			var circle:Shape = new Shape();
			circle.graphics.clear();
            circle.graphics.beginFill(fillColor,fillAlpha);
            circle.graphics.lineStyle(borderThickness, borderColor, borderAlpha);
            circle.graphics.drawCircle(/*x - radius/2, y - radius/2*/x,y, radius);
            circle.graphics.endFill();
            return circle;			
		}
		
		public static function rectangle(x:Number, y:Number, width:Number, height:Number, ellipse:Number,
									  fillColor:uint, fillAlpha:Number, 
									  borderColor:uint, borderThickness:Number, borderAlpha:Number):Shape
		{
			var rectangle:Shape = new Shape();
			rectangle.graphics.clear();
            rectangle.graphics.beginFill(fillColor,fillAlpha);
            rectangle.graphics.lineStyle(borderThickness, borderColor, borderAlpha);
            rectangle.graphics.drawRoundRect(x - width/2, y - height/2, width, height, ellipse, ellipse);
            rectangle.graphics.endFill();
            return rectangle;			
		}
		
		public static function cross(x:Number, y:Number, width:Number, height:Number, crossWidth:Number,
									  fillColor:uint, fillAlpha:Number, 
									  borderColor:uint, borderThickness:Number, borderAlpha:Number):Shape
		{
			var rectangle:Shape = new Shape();
			rectangle.graphics.clear();
            rectangle.graphics.beginFill(fillColor,fillAlpha);
            rectangle.graphics.lineStyle(borderThickness, borderColor, borderAlpha);
            rectangle.graphics.drawRect(-width/2, -height/2,width,height);
            rectangle.graphics.drawRect(-height/2, -width/2,height,width);
            rectangle.graphics.endFill();
            return rectangle;			
		}
		
	}
}