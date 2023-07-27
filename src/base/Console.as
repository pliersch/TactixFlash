package base {
	import core.Players;
	import core.UserInfo;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.events.FlexEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	public class Console extends Canvas	{
		public var logmeout:Button;
		public var battle:Button;
		public var toLobby:Button;
		public var console_lbl:Label;
		public var newState:Event;
		public var loginRO:RemoteObject;
		public var gamename:Label;

		public function Console(){
			super();
			loginRO = new RemoteObject("toLogin");
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function init(e:FlexEvent):void{
			logmeout.addEventListener(MouseEvent.CLICK, logout);
			toLobby.addEventListener(MouseEvent.CLICK, gotoLobby);
			battle.addEventListener(MouseEvent.CLICK, gotoBattle);
		}

		private function logout(e:MouseEvent):void{
//			var userStatusEvent: TextEvent = new TextEvent("userStatusEvent", true);
//			userStatusEvent.text = "userStatusEvent." + Players.instance.myPlayer.name + "." + UserInfo.USER_LOGGED_OUT;
//			dispatchEvent(userStatusEvent);
//			loginRO.logMeOut(sharedObj.data.general);
		}
		
		private function gotoLobby(e:MouseEvent):void {
			var userStatusEvent: TextEvent = new TextEvent("userStatusEvent", true);
			userStatusEvent.text = "userStatusEvent." + Players.instance.myPlayer.name + "." + UserInfo.USER_IN_LOBBY;
			dispatchEvent(userStatusEvent);
			newState = new Event("loginValid",true);
			dispatchEvent(newState);
		}
		
		private function gotoBattle(e:MouseEvent):void{
			newState = new Event("toBattle",true);
			dispatchEvent(newState);
		}		
	}
}