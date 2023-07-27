package valueObjects.user {
	
	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	import valueObjects.ValueObject;
	
	public class LogoutVO implements IExternalizable, ValueObject{
		
		private static const ALIAS:* = registerClassAlias( "LogoutVO", LogoutVO );
		private var _name:String;

		public function LogoutVO(name:String="") {
			_name 	= name;
		}
		
		public function get name():String{
			return _name;
		}

		public function readExternal(input:IDataInput):void {
			_name	 = input.readUTF();
		}
		
		public function writeExternal(output:IDataOutput):void{
			output.writeUTF(_name);
		}
	}
}