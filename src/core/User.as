package core {
	
	public class User {
		
		private var _userName:String;
		private var _peerID:String;
		
		public function User(userName:String) {
			_userName = userName;
		}
		
		public function get userName():String {
			return _userName;
		}

		public function set userName(value:String):void {
			_userName = value;
		}

		public function get peerID():String	{
			return _peerID;
		}

		public function set peerID(value:String):void {
			_peerID = value;
		}
	}
}