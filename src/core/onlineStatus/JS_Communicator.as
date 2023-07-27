package core.onlineStatus {
	import core.User;
	import core.onlineStatus.UserLogger;
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.utils.Timer;
	
	import mx.managers.IBrowserManager;
	
	public class JS_Communicator{
		
		private var _iBrowserReceiver:IBrowserReceiver;
		
		public function JS_Communicator(iBrowserReceiver:IBrowserReceiver) {
			_iBrowserReceiver = iBrowserReceiver;
			init();
		}
				
		private function init():void{			
			trace( "Initializing...\n");			
			if (ExternalInterface.available) {
				try {
					trace("Adding callback...\n");
					ExternalInterface.addCallback("sendToActionScript", receivedFromJavaScript);
					if (checkJavaScriptReady()) {
						trace("JavaScript is ready.\n");
					} else {
						trace("JavaScript is not ready, creating timer.\n");
						var readyTimer:Timer = new Timer(100, 0);
						readyTimer.addEventListener(TimerEvent.TIMER, timerHandler);
						readyTimer.start();
					}
				} catch (error:SecurityError) {
					trace("A SecurityError occurred: " + error.message + "\n");
				} catch (error:Error) {
					trace("An Error occurred: " + error.message + "\n");
				}
			} else {
				trace("External interface is not available for this container.");
			}
		}
		
		private function receivedFromJavaScript(value:String):void {
			trace("JavaScript says: " + value + "\n");
			_iBrowserReceiver.handleBrowserEvent("logout");
		}
		
		private function checkJavaScriptReady():Boolean {
			var isReady:Boolean = ExternalInterface.call("isReady");
			return isReady;
		}
		
		private function timerHandler(event:TimerEvent):void {
			trace("Checking JavaScript status...\n");
			var isReady:Boolean = checkJavaScriptReady();
			if (isReady) {
				trace("JavaScript is ready.\n");
				Timer(event.target).stop();
			}
		}
	}
}
