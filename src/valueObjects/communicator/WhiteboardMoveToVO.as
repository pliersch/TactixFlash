package valueObjects.communicator {
	
	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	import valueObjects.ValueObject;
	
	public class WhiteboardMoveToVO implements IExternalizable, ValueObject{
		
		private static const ALIAS:* = registerClassAlias( "WhiteboardMoveToVO", WhiteboardMoveToVO );
		private var _xCoord:int;
		private var _yCoord:int;

		public function WhiteboardMoveToVO(xCoord:int=0,yCoord:int=0) {
			_xCoord = xCoord;
			_yCoord = yCoord;
		}
		
		public function get xCoord():int{
			return _xCoord;
		}
		
		public function set xCoord(value:int):void{
			_xCoord = value;
		}
		
		public function get yCoord():int{
			return _yCoord;
		}
		
		public function set yCoord(value:int):void{
			_yCoord = value;
		}

		public function readExternal(input:IDataInput):void {
			_xCoord = input.readInt();
			_yCoord = input.readInt();
		}
		
		public function writeExternal(output:IDataOutput):void{
			output.writeInt(_xCoord);
			output.writeInt(_yCoord);
		}
	}
}