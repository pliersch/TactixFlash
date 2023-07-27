package valueObjects.world {
	
	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	import valueObjects.ValueObject;
	
	public class AddUnitsVO implements IExternalizable, ValueObject{
		
		private static const ALIAS:* = registerClassAlias( "AddUnitsVO", AddUnitsVO );
		//TODO: _playerID kann wieder weg, über EndTurn gelöst 
		private var _playerID:uint;
		private var _regionID:uint;
		private var _soldiers:uint;
		private var _tanks:uint;
		private var _artilleries:uint;
		private var _aircrafts:uint;
		private var _mechs:uint;
		private var _flags:uint;

		public function AddUnitsVO(playerID:uint=0,regionID:uint=0,soldiers:uint=0,tanks:uint=0,
								   artilleries:uint=0,aircrafts:uint=0,mechs:uint=0,flags:uint=0) {
			_playerID	 = playerID;
			_regionID 	 = regionID;
			_soldiers	 = soldiers;
			_tanks 		 = tanks;
			_artilleries = artilleries;
			_aircrafts 	 = aircrafts;
			_mechs 		 = mechs;
			_flags 		 = flags;
		}
		
		public function get playerID():uint{
			return _playerID;
		}

		public function get regionID():uint{
			return _regionID;
		}

		public function get soldiers():uint{
			return _soldiers;
		}

		public function get tanks():uint{
			return _tanks;
		}

		public function get artilleries():uint{
			return _artilleries;
		}

		public function get aircrafts():uint{
			return _aircrafts;
		}

		public function get mechs():uint{
			return _mechs;
		}

		public function get flags():uint{
			return _flags;
		}

		public function readExternal(input:IDataInput):void {
			_playerID	 = input.readUnsignedInt();
			_regionID 	 = input.readUnsignedInt();
			_soldiers	 = input.readUnsignedInt();
			_tanks 		 = input.readUnsignedInt();
			_artilleries = input.readUnsignedInt();
			_aircrafts 	 = input.readUnsignedInt();
			_mechs 		 = input.readUnsignedInt();
			_flags 		 = input.readUnsignedInt();
		}
		
		public function writeExternal(output:IDataOutput):void{
			output.writeInt(_playerID);
			output.writeInt(_regionID);
			output.writeInt(_soldiers);
			output.writeInt(_tanks);
			output.writeInt(_artilleries);
			output.writeInt(_aircrafts);
			output.writeInt(_mechs);
			output.writeInt(_flags);
		}
	}
}