package core {
	import core.onlineStatus.UserLogger;

	public class UserInfo {

		private var _playerName:String;
		private var _status:uint;
		private var _hasTurnReady:Boolean;

		public static var USER_IN_LOBBY:uint=0;
		public static var USER_IN_GAME:uint=1;
		public static var USER_LOGGED_OUT:uint=2;

		public function UserInfo(playerName:String) {
			_playerName=playerName;
			_status=USER_IN_LOBBY;
			_hasTurnReady=false;
		}

		public function get hasTurnReady():Boolean {
			return _hasTurnReady;
		}

		public function set hasTurnReady(value:Boolean):void {
			_hasTurnReady=value;
			UserLogger.instance.notifyObservers(this);
		}

		public function get status():uint {
			return _status;
		}

		public function set status(status:uint):void {
			_status=status;
		}

		public function getStatusInfo():String {
			if (_status == 0)
				return "in Lobby";
			else if (_status == 1)
				return "in Game";
			else
				return "Logged out";
		}
		
		public function get playerName():String {
			return _playerName;
		}
	}
}