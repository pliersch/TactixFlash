package valueObjects.battlefield {

	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;

	import valueObjects.ValueObject;

	public class AddUnitVO implements IExternalizable, ValueObject {

		private static const ALIAS:*=registerClassAlias("AddUnitVO", AddUnitVO);
		//private var _platoonID:uint;
		private var _unitID:uint;
		private var _xPos:uint;
		private var _yPos:uint;

		public function AddUnitVO(unitID:uint=0, xPos:uint=0, yPos:uint=0) {
			//_platoonID = platoonId;
			_unitID=unitID;
			_xPos=xPos;
			_yPos=yPos;
		}

//		public function get platoonID():uint{
//			return _platoonID;
//		}

		public function get unitID():uint {
			return _unitID;
		}

		public function get xPos():uint {
			return _xPos;
		}

		public function get yPos():uint {
			return _yPos;
		}

		public function readExternal(input:IDataInput):void {
			//_platoonID = input.readInt();
			_unitID=input.readInt();
			_xPos=input.readInt();
			_yPos=input.readInt();
		}

		public function writeExternal(output:IDataOutput):void {
			//output.writeInt(_platoonID);
			output.writeInt(_unitID);
			output.writeInt(_xPos);
			output.writeInt(_yPos);
		}
	}
}