package base {
	
	import mx.collections.ArrayCollection;

	public class UserList {

		private var _list:ArrayCollection;
		static private var _instance:UserList;

		public function UserList(singletonEnforcer:SingletonEnforcer) {
		}

		public static function get instance():UserList {
			if (UserList._instance == null) {
				UserList._instance=new UserList(new SingletonEnforcer());
			}
			return UserList._instance;
		}

		public function get list():ArrayCollection {
			return _list;
		}

		public function set list(value:ArrayCollection):void {
			_list=value;
		}
	}
}

class SingletonEnforcer {
}