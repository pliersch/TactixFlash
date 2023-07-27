package core {
	
	public class MyUser { 
		
		private var _name:String;
		private var _myPeerID:String;
		static private var _instance:MyUser;
		
		public function MyUser(singletonEnforcer:SingletonEnforcer){
	
		}
		
		public static function get instance():MyUser {
			if(MyUser._instance == null) {
				MyUser._instance = new MyUser(new SingletonEnforcer());
			}
			return MyUser._instance;
		} 
		
		public function set name(name:String):void{
			_name = name;
		}		
		
		public function get name():String{
			return _name;
		}

		public function get myPeerID():String{
			return _myPeerID;
		}

		public function set myPeerID(value:String):void{
			_myPeerID = value;
		}
	}
}

class SingletonEnforcer{}