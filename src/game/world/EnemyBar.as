package game.world {
	import core.Players;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class EnemyBar {
		private var _sprite:Sprite;
		private var _enemyWindows:Array;
		
		public function EnemyBar() {
			_sprite       = new Sprite();
			_sprite.addEventListener(Event.ADDED_TO_STAGE, addEnemyWindows);
		}
						
		private function addEnemyWindows(e:Event):void{
			var margin:uint = 50;
			//var width:uint = _sprite.stage.stageWidth - margin * 2;
			var width:uint = 1024 - margin * 2;
			var spaceForWindow:uint = width / (Players.instance.length - 1); 
			var window:EnemyWindow;
			var windowWidth:uint = 210;
			var pos1:uint = margin + (spaceForWindow - windowWidth) / 2;
			_enemyWindows = new Array();			
			
			for(var i:uint = 0;i<Players.instance.length;i++)	{
				if(Players.instance.myPlayer != Players.instance.getPlayerByID(i)){
					window = new EnemyWindow(Players.instance.getPlayerByID(i));
					_enemyWindows.push(window);
					window.sprite.x = (pos1 + spaceForWindow * (_enemyWindows.length - 1));
					_sprite.addChild(window.sprite);
				}
			}
		}		
		
		public function get sprite():Sprite	{
        	return _sprite;
        }
	}
}