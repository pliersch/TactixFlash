package base{
	
	import components.BattleWindow;
	
	import core.MyUser;
	import core.Player;
	import core.Players;
	import core.StageManager;
	import core.User;
	import core.UserInfo;
	import core.onlineStatus.IBrowserReceiver;
	import core.onlineStatus.JS_Communicator;
	import core.onlineStatus.OnlineStatus;
	import core.onlineStatus.P2P_Manager;
	import core.onlineStatus.UserLogger;
	
	import designPattern.observer.IObservable;
	import designPattern.observer.IObserver;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.external.ExternalInterface;
	
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.events.BrowserChangeEvent;
	import mx.events.FlexEvent;
	import mx.managers.BrowserManager;
	import mx.managers.IBrowserManager;
	import mx.messaging.Consumer;
	import mx.messaging.Producer;
	import mx.messaging.events.MessageEvent;
	import mx.messaging.events.MessageFaultEvent;
	import mx.messaging.messages.AsyncMessage;
	import mx.messaging.messages.IMessage;
	import mx.rpc.remoting.mxml.RemoteObject;
	import mx.states.State;
	
	import valueObjects.user.LogoutVO;
	
	public class TactixApp extends Application implements IBrowserReceiver, IObserver{
		
		public var loginRO:RemoteObject
		public var game_comp:Game;
		public var login_comp:Login;
		public var start_screen:Overview;
		public var register_comp:RegisterForm;
		public var battle_comp:BattleWindow;
		public var loggedin:State;
		public var startscreen:State;
		public var register:State;
		public var debugMap:Text;
		public var myProducer:Producer;
		public var myConsumer:Consumer;
		public var output:Label;
		private var jsCommunicator:JS_Communicator;
		private static var _link1:Array = [valueObjects.user.LogoutVO];
		
		public function TactixApp(){
			super();
			register_comp = new RegisterForm();
			currentState = "startscreen";
			addEventListener(FlexEvent.CREATION_COMPLETE, init);	
		}
		
		private function init(e:FlexEvent):void{
			addEventListener(Event.ADDED_TO_STAGE, setWidthHeight);
			addEventListener(Event.RESIZE,setWidthHeight);
			addEventListener("regPressed", changeToReg);
			addEventListener("loginValid", changeToOverview);
			addEventListener("toLobbyEvent", changeToOverview);
			addEventListener("regValid", changeToStart);
			addEventListener("logout", changeToStart);
			addEventListener("levelEditorEvent", changeToLevelEditor);
			addEventListener("toGame", changeToGame);
			addEventListener("toStratus", changeToStratus);
			addEventListener("noGameSel", backToOverview);
			addEventListener("overViewEvent", sendMessage);		
			addEventListener("userOnlineEvent", sendMessage);
			myConsumer.subscribe();
			jsCommunicator = new JS_Communicator(this);
			P2P_Manager.instance.addObserver(this);
		}
		
		private function setWidthHeight(eventName:String):void {
			StageManager.instance.width = stage.stageWidth;
			StageManager.instance.height = stage.stageHeight;
		}
		
		public function handleBrowserEvent(eventName:String):void {
			if (eventName == "logout"){
				logout();
			}
		}
		
		public function update(observerable:IObservable, infoObj:Object):void {
			if(infoObj is LogoutVO){
				handleLogout(infoObj as LogoutVO);
			}
		}
		
		private function handleLogout(logoutVO:LogoutVO):void	{
			var player:Player;
			for(var i:uint=0;i<Players.instance.length;i++){
				if(Players.instance.getPlayerByID(i).name == logoutVO.name){
					player = Players.instance.getPlayerByID(i);
					player.userStatus.status = UserInfo.USER_LOGGED_OUT;
					UserLogger.instance.notifyObservers(player.userStatus);
				}
			}
		}

		private function logout():void	{
			OnlineStatus.instance.setOffline(MyUser.instance.name);
			P2P_Manager.instance.sendObject(new LogoutVO(MyUser.instance.name));
			// redundant, logoutVO und userOnlineEvent machen letzten endes dasselbe!
			var userOnlineEvent: TextEvent = new TextEvent("userOnlineEvent", true);
			userOnlineEvent.text = "userOnlineEvent";
			sendMessage(userOnlineEvent);
		}		
		
		public function changeToReg(e:Event):void{
			currentState = "register";
		}
		
		public function changeToOverview(e:Event):void{
			currentState = "logged";
		}
		
		public function changeToLevelEditor(e:Event):void{
			currentState = "levelEditorState";
		}
		
		public function backToOverview(e:Event):void{
			currentState = "logged";
			mx.controls.Alert.show("Kein Spiel ausgewählt");
		}
		
		public function changeToStart(e:Event):void{
			currentState = "startscreen";
		}
		
		public function changeToStratus(e:Event):void{
			currentState = "stratus";
		}

		public function changeToGame(e:Event):void{
			currentState = "ingame";
		}
					
		public function sendMessage(e:TextEvent) : void {
			var message:IMessage = new AsyncMessage();
			message.body.text = e.text;
			myProducer.send(message);
		}	
		
		public function incomingMessage(e:MessageEvent) : void {
			var message:String = e.message.body.text;
			if(message.match("userOnlineEvent")) OnlineStatus.instance.getList();
		}	
		
		public function handleUserStatus(message:String):void {
			var results:Array = message.split(".");
			var player:Player;
			for(var i:uint=0;i<Players.instance.length;i++){
				if(Players.instance.getPlayerByID(i).name == results[1]){
					player = Players.instance.getPlayerByID(i);
					player.userStatus.status = results[2];
					UserLogger.instance.notifyObservers(player.userStatus);
				}
			}
		}		
					
		public function fault(e:MessageFaultEvent) : void {
			mx.controls.Alert.show("FAULT: " + e.toString());
		}	
	}
}