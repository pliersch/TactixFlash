package base
{
	import mx.containers.Canvas;
	import mx.core.Repeater;
	import mx.events.FlexEvent;
	import mx.messaging.Consumer;
	import mx.messaging.events.MessageEvent;
	import mx.messaging.events.MessageFaultEvent;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;

	public class Chat_Content extends Canvas
	{
		public var myConsumer:Consumer;
		[Bindable]
		public var chatRepeater:Repeater;
		[Bindable]
		public var repeaterCollection:ArrayCollection = new ArrayCollection();
		
		public function Chat_Content()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		private function init(e:FlexEvent):void{
			myConsumer.subscribe();
			trace(myConsumer.subscribed);
			myConsumer.addEventListener(MessageFaultEvent.FAULT, fault);
			myConsumer.addEventListener(MessageEvent.MESSAGE, incomingMessage);
		}
		private function incomingMessage(event:MessageEvent) : void {
			if(event.message.body.text != "") {
				repeaterCollection.addItem(event.message.body);
			}
			verticalScrollPosition = maxVerticalScrollPosition + 20;
		}
		
		private function fault(event:MessageFaultEvent) : void {
			mx.controls.Alert.show("Fault: " + event.toString());
		}
		
	}
}