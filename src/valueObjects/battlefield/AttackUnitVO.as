package valueObjects.battlefield {
	
	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	import valueObjects.ValueObject;
	
	public class AttackUnitVO implements IExternalizable, ValueObject{
		
		private static const ALIAS:* = registerClassAlias( "AttackUnitVO", AttackUnitVO );
		private var _offenerUnitID:uint;
		private var _defenderPlatoonID:uint;
		private var _defenderUnitID:uint;
		
		public function AttackUnitVO(offenerUnitID:uint=0, defenderPlatoonID:uint=0, defenderUnitID:uint=0) {
			_offenerUnitID     = offenerUnitID;
			_defenderPlatoonID = defenderPlatoonID;
			_defenderUnitID    = defenderUnitID;
		}
	
		public function get defenderPlatoonID():uint{
			return _defenderPlatoonID;
		}

		public function get offenerUnitID():uint{
			return _offenerUnitID;
		}
		
		public function get defenderUnitID():uint{
			return _defenderUnitID;
		}
		
		public function readExternal(input:IDataInput):void {
			_offenerUnitID     = input.readInt();
			_defenderPlatoonID = input.readInt();
			_defenderUnitID    = input.readInt();
		}
		
		public function writeExternal(output:IDataOutput):void{
			output.writeInt(_offenerUnitID);
			output.writeInt(_defenderPlatoonID);
			output.writeInt(_defenderUnitID);
		}
	}
}