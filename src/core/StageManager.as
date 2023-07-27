package core {

	public class StageManager {

		private var _width:uint;
		private var _height:uint;
		static private var _instance:StageManager;

		public function StageManager(singletonEnforcer:SingletonEnforcer) {
			_width=0;
			_height=0;
		}

		public static function get instance():StageManager {
			if (StageManager._instance == null) {
				StageManager._instance=new StageManager(new SingletonEnforcer());
			}
			return StageManager._instance;
		}

		public function get width():uint {
			return _width;
		}

		public function set width(value:uint):void {
			_width=value;
		}

		public function get height():uint {
			return _height;
		}

		public function set height(value:uint):void {
			_height=value;
		}
	}
}

class SingletonEnforcer {
}