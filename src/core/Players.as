package core {
	import core.onlineStatus.UserLogger;
	
	public class Players { 
		
		private var _players:Array;
		private var _activePlayer:Player;
		private var _myPlayer:Player;
		private var counter:uint;
		static private var _instance:Players;
		
		public function Players(singletonEnforcer:SingletonEnforcer){
			_players = new Array();
			counter = 0;		
		}
		
		public static function get instance():Players {
			if(Players._instance == null) {
				Players._instance = new Players(new SingletonEnforcer());
			}
			return Players._instance;
		} 
		
		public function addPlayer(player:Player):void{
			_players.push(player);
		}
		
		public function removeAllPlayers():void{
			_players = new Array();
			counter = 0;
		}		
		
		public function set myPlayer(player:Player):void{
			_myPlayer = player;
		}		
		
		public function get myPlayer():Player{
			return _myPlayer;
		}		
		
		public function get activePlayer():Player{
			return _activePlayer;
		}
		
		public function get players():Array {
			return _players;
		}
		
		public function get length():uint{
			return _players.length;
		}		
		
		public function getPlayerByID(id:uint):Player{
			return _players[id];
		}
		
		public function setNextActivePlayer():void	{
			_activePlayer =  _players[counter++ % _players.length];
		}
		
		public function setTurnEnd():void	{
			for(var i:uint=0;i<_players.length;i++){
				_players[i].userStatus.hasTurnReady = false;
			}
		}
	}
}

class SingletonEnforcer{}