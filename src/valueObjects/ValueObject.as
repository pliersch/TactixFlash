package valueObjects {
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;

	public interface ValueObject {
		function readExternal(input:IDataInput):void;
		function writeExternal(output:IDataOutput):void;
	}
}