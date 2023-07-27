package valueObjects.battlefield {
	
	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	import valueObjects.ValueObject;
	
	public class MoveUnitVO implements IExternalizable, ValueObject{
		
		private static const ALIAS:* = registerClassAlias( "MoveUnitVO", MoveUnitVO );
		//private var _platoonID:uint;
		private var _unitID:uint;
		private var _oldXPos:uint;
		private var _oldYPos:uint;
		private var _newXPos:uint;
		private var _newYPos:uint;
		
		public function MoveUnitVO(unitID:uint=0, oldXPos:uint=0, oldYPos:uint=0, newXPos:uint=0, newYPos:uint=0) {
			//_platoonID = platoonId;
			_unitID = unitID;
			_oldXPos = oldXPos;
			_oldYPos = oldYPos;
			_newXPos = newXPos;
			_newYPos = newYPos;
		}
		
//		public function get platoonID():uint{
//			return _platoonID;
//		}
		
		public function get unitID():uint{
			return _unitID;
		}
		
		public function get oldXPos():uint{
			return _oldXPos;
		}
		
		public function get oldYPos():uint{
			return _oldYPos;
		}
		
		public function get newXPos():uint{
			return _newXPos;
		}
		
		public function get newYPos():uint{
			return _newYPos;
		}
		
		public function readExternal(input:IDataInput):void {
			//_platoonID = input.readInt();
			_unitID = input.readInt();
			_oldXPos = input.readInt();
			_oldYPos = input.readInt();
			_newXPos = input.readInt();
			_newYPos = input.readInt();
		}
		
		public function writeExternal(output:IDataOutput):void{
			//output.writeInt(_platoonID);
			output.writeInt(_unitID);
			output.writeInt(_oldXPos);
			output.writeInt(_oldYPos);
			output.writeInt(_newXPos);
			output.writeInt(_newYPos);
		}
	}
}