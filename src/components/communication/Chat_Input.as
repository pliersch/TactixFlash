package base
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.ui.Keyboard;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.ColorPicker;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.messaging.Producer;
	import mx.messaging.events.MessageFaultEvent;
	import mx.messaging.messages.AsyncMessage;
	import mx.messaging.messages.IMessage;

	public class Chat_Input extends Canvas
	{
		public var myProducer:Producer;
		public var myColorPicker:ColorPicker;
		public var myMessage:TextInput;
		public var sendMessage:Button;
		public var sharedObj:SharedObject;
		
		public function Chat_Input()
		{
			super();
			sharedObj = SharedObject.getLocal("tactix");
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		private function init(e:FlexEvent):void{
			myProducer.addEventListener(MessageFaultEvent.FAULT, fault);
			sendMessage.addEventListener(MouseEvent.CLICK, sendMessage_Handler);
			myMessage.addEventListener(KeyboardEvent.KEY_DOWN, enterPressed);
		}
		private function sendMessage_Handler(e:MouseEvent) : void {
			if(myMessage.text != "") {
				var message:IMessage = new AsyncMessage();
				message.body.text = sharedObj.data.general+": "+myMessage.text;
				message.body.color = myColorPicker.selectedColor;
				myProducer.send(message);
				myMessage.text = "";
			}
		}
		private function enterPressed(e:KeyboardEvent) : void {
			trace(e.keyCode);
			if(e.keyCode == Keyboard.ENTER){
				trace("enter hit");
				if(myMessage.text != "") {
					var message:IMessage = new AsyncMessage();
					message.body.text = sharedObj.data.general+": "+myMessage.text;
					message.body.color = myColorPicker.selectedColor;
					myProducer.send(message);
					myMessage.text = "";
				}
			}
		}
		private function fault(event:MessageFaultEvent) : void {
			mx.controls.Alert.show("FAULT: " + event.toString());
		}
		
	}
}