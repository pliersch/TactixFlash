package {
	[Bindable]
	[RemoteClass(alias="tactix.Message")]
	public class Message {
		private var _text:String;
		private var _color:uint;
		public function Message() {
		}
		public function get text():String { return _text; }
		public function set text(newVal:String) : void { _text = newVal; }
		public function get color():uint { return _color; }
		public function set color(newVal:uint) : void { _color = newVal; }
	}
}