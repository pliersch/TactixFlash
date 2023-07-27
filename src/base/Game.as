package base{
	import components.BattleWindow;
	
	import core.Platoon;
	import core.Player;
	import core.Players;
	import core.StageManager;
	import core.onlineStatus.UserLogger;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import game.battlefield.Battlefield;
	import game.world.WorldMap;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.events.FlexEvent;

	public class Game extends Canvas {
		public var console_comp:Console;
//		[Bindable]
//		public var stageWidth:uint;
//		[Bindable]
//		public var stageHeight:uint;
		[Bindable]
		public var battleWindow:BattleWindow;
		[Bindable]
		public var worldCanvas:Canvas;
		public var newState:Event;
		public var _players:Players;
		public var _worldMap:WorldMap;
		public var _id:uint;
		public var endturnBtn:Button;
		public var _battlefield:Battlefield;

		public function Game(){
			super();
			_players = Players.instance;
			initRegions();
			_worldMap = new WorldMap(this);							
			
// !!!!!!!!!!!!!!!!!!! _id !!!!!!
			_id = 0;
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function init(e:FlexEvent):void	{	
			
			worldCanvas.rawChildren.addChild(_worldMap.sprite);
		}
		
		private function endturn(e:MouseEvent):void	{	
			_battlefield.sendEndTurn(e);
		}
						
		public function changeToBattle(battlefield:Battlefield):void{
			_battlefield = battlefield;
			currentState = "battle";
			endturnBtn.addEventListener(MouseEvent.CLICK,endturn);
			battleWindow.openBattlefield(_battlefield);
		}
				
		private function initRegions():void	{
			var player:Player;
			for(var j:uint=0;j<Pref.REGIONS;j++){
				player = _players.getPlayerByID(j%_players.length);
				player.addPlatoon(new Platoon(player,player.getUniquePlatoonID(),1,1,1,1,0,0));
			}
		}			
	}
}