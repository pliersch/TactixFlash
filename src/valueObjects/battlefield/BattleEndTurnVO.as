package valueObjects.battlefield {

	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;

	import valueObjects.ValueObject;

	public class BattleEndTurnVO implements IExternalizable, ValueObject {

		private static const ALIAS:*=registerClassAlias("EndTurnVO", BattleEndTurnVO);

		public function BattleEndTurnVO() {
		}

		public function readExternal(input:IDataInput):void {
		}

		public function writeExternal(output:IDataOutput):void {
		}
	}
}