package valueObjects.player {
	
	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	import valueObjects.ValueObject;
	
	public class PlayerVO implements IExternalizable, ValueObject{
		
		private static const ALIAS:* = registerClassAlias( "PlayerVO", PlayerVO );
		private var _id:uint;
		private var _name:String;
		private var _color:uint;
		private var _peerID:String;

		public function PlayerVO(id:uint=0,name:String="",color:uint=0,peerID:String="") {
			_id	    = id;
			_name 	= name;
			_color  = color;
			_peerID = peerID;
		}
		
		public function get id():uint{
			return _id;
		}

		public function get name():String{
			return _name;
		}

		public function get color():uint{
			return _color;
		}

		public function get peerID():String{
			return _peerID;
		}

		public function readExternal(input:IDataInput):void {
			_id		 = input.readUnsignedInt();
			_name	 = input.readUTF();
			_color	 = input.readUnsignedInt();
			_peerID  = input.readUTF();
		}
		
		public function writeExternal(output:IDataOutput):void{
			output.writeInt(_id);
			output.writeUTF(_name);
			output.writeInt(_color);
			output.writeUTF(_peerID);
		}
	}
}