package game.world {
	internal class TransferContainer {
		private var _soldiers:uint;
		private var _tanks:uint;
		private var _artilleries:uint;
		private var _aircrafts:uint;
		private var _mechs:uint;
		private var _flags:uint;
		
		public function TransferContainer(soldiers:uint, tanks:uint, artilleries:uint, aircrafts:uint,mechs:uint, flags:uint){
			_soldiers = soldiers;
			_tanks = tanks;
			_artilleries = artilleries;
			_aircrafts = aircrafts;
			_mechs = mechs;
			_flags = flags;
		}
		
		public function get flags():uint{
			return _flags;
		}
		
		public function get aircrafts():uint{
			return _aircrafts;
		}
		
		public function get artilleries():uint{
			return _artilleries;
		}
		
		public function get tanks():uint{
			return _tanks;
		}
		
		public function get soldiers():uint{
			return _soldiers;
		}
		
		public function get mechs():uint{
			return _mechs;
		}
		
		public function get unitCount():uint{
			return _soldiers + _tanks + _artilleries + _aircrafts + _flags +_mechs;
		}	
	}
}