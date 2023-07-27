package util
{
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	public class GraphicLoader extends Loader
	{
		public function GraphicLoader(url:String)
		{
			load(new URLRequest(url)); 
		}
	}
}