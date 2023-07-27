package valueObjects.world {
	
	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	import valueObjects.ValueObject;
	
	public class MoveUnitsVO implements IExternalizable, ValueObject{
		
		private static const ALIAS:* = registerClassAlias( "MoveUnitsVO", MoveUnitsVO );
		private var _offenerID:uint;
		private var _offenerPlatoonID:uint;
		private var _offenerRegionID:uint;
		private var _defenderID:uint;
		private var _defenderRegionID:uint;
		private var _soldiers:uint;
		private var _tanks:uint;
		private var _artilleries:uint;
		private var _aircrafts:uint;
		private var _mechs:uint;
		private var _flags:uint;

		public function MoveUnitsVO(offenerID:uint=0, offenerPlatoonID:uint=0, offenerRegionID:uint=0,defenderID:uint=0, defenderRegionID:uint=0, 
									soldiers:uint=0,tanks:uint=0,artilleries:uint=0,aircrafts:uint=0,mechs:uint=0,flags:uint=0) {
			
			_offenerID 		  = offenerID;
			_offenerPlatoonID = offenerPlatoonID;
			_offenerRegionID  = offenerRegionID;
			_defenderID		  = defenderID;
			_defenderRegionID = defenderRegionID;
			_soldiers		  = soldiers;
			_tanks 			  = tanks;
			_artilleries	  = artilleries;
			_aircrafts 		  = aircrafts;
			_mechs 			  = mechs;
			_flags 			  = flags;
		}
		
		public function get offenerID():uint{
			return _offenerID;
		}
		
		public function get offenerPlatoonID():uint{
			return _offenerPlatoonID;
		}

		public function get offenerRegionID():uint{
			return _offenerRegionID;
		}
		
		public function get defenderID():uint{
			return _defenderID;
		}
		
		public function get defenderRegionID():uint{
			return _defenderRegionID;
		}

		public function get soldiers():uint{
			return _soldiers;
		}
		
		public function set soldiers(value:uint):void{
			_soldiers = value;
		}

		public function get tanks():uint{
			return _tanks;
		}
		
		public function set tanks(value:uint):void{
			_tanks = value;
		}

		public function get artilleries():uint{
			return _artilleries;
		}
		
		public function set artilleries(value:uint):void{
			_artilleries = value;
		}

		public function get aircrafts():uint{
			return _aircrafts;
		}
		
		public function set aircrafts(value:uint):void{
			_aircrafts = value;
		}

		public function get mechs():uint{
			return _mechs;
		}
		
		public function set mechs(value:uint):void{
			_mechs = value;
		}

		public function get flags():uint{
			return _flags;
		}
		
		public function set flags(value:uint):void{
			_flags = value;
		}

		public function readExternal(input:IDataInput):void {
			_offenerID 		  = input.readUnsignedInt();
			_offenerPlatoonID = input.readUnsignedInt();
			_offenerRegionID  = input.readUnsignedInt();
			_defenderID 	  = input.readUnsignedInt();
			_defenderRegionID = input.readUnsignedInt();
			_soldiers		  = input.readUnsignedInt();
			_tanks 			  = input.readUnsignedInt();
			_artilleries	  = input.readUnsignedInt();
			_aircrafts 		  = input.readUnsignedInt();
			_mechs 			  = input.readUnsignedInt();
			_flags 			  = input.readUnsignedInt();
		}
		
		public function writeExternal(output:IDataOutput):void{
			output.writeInt(_offenerID);
			output.writeInt(_offenerPlatoonID);
			output.writeInt(_offenerRegionID);
			output.writeInt(_defenderID);
			output.writeInt(_defenderRegionID);
			output.writeInt(_soldiers);
			output.writeInt(_tanks);
			output.writeInt(_artilleries);
			output.writeInt(_aircrafts);
			output.writeInt(_mechs);
			output.writeInt(_flags);
		}
	}
}