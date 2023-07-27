package valueObjects.world {

	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;

	import valueObjects.ValueObject;

	public class WorldEndTurnVO implements IExternalizable, ValueObject {

		private var _playerID:uint;
		private static const ALIAS:*=registerClassAlias("EndTurnVO", WorldEndTurnVO);

		public function WorldEndTurnVO(playerID:uint=0) {
			_playerID = playerID;
		}

		public function get playerID():uint {
			return _playerID;
		}

		public function readExternal(input:IDataInput):void {
			_playerID = input.readUnsignedInt();
		}

		public function writeExternal(output:IDataOutput):void {
			output.writeInt(_playerID);
		}
	}
}