package base{
//	import core.onlineStatus.UserLogger;
//	import core.onlineStatus.UserStatus;
	
	import core.MyUser;
	import core.onlineStatus.P2P_Manager;
	import core.User;
	import designPattern.observer.IObservable;
	import designPattern.observer.IObserver;
	import core.onlineStatus.OnlineStatus;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.FormItem;
	import mx.controls.Button;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	public class Login extends Canvas{
		public var logname:TextInput;
		public var logpw:TextInput;
		public var logBtn:Button;
		public var regBtn:Button;
		public var loginRO:RemoteObject;
		public var newState:Event;
		
		public var player1:Button;
		public var player2:Button;
		public var player3:Button;
		public var player4:Button;	
		
		public function Login()	{
			super();
			loginRO = new RemoteObject("toLogin");
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}

		private function init(e:FlexEvent):void{
			player1.visible = false;
			player2.visible = false;
			player3.visible = false;
			player4.visible = false;
			player1.addEventListener(MouseEvent.CLICK, addP1);
			player2.addEventListener(MouseEvent.CLICK, addP2);
			player3.addEventListener(MouseEvent.CLICK, addP3);
			player4.addEventListener(MouseEvent.CLICK, addP4);	
			logBtn.addEventListener(MouseEvent.CLICK, logMeIn);
			regBtn.addEventListener(MouseEvent.CLICK, register);
			loginRO.addEventListener(ResultEvent.RESULT, logHandler);
			P2P_Manager.instance.initConnection();
			P2P_Manager.instance.nc.addEventListener(NetStatusEvent.NET_STATUS,receivedMyPeerID);
		}
		
		private function addP1(e:MouseEvent):void{
			MyUser.instance.name = "Alpha";
			MyUser.instance.myPeerID = P2P_Manager.instance.myPeerID;
			OnlineStatus.instance.setOnline(MyUser.instance.name,MyUser.instance.myPeerID);	
			changeToOverview();
		}
		
		private function addP2(e:MouseEvent):void{
			MyUser.instance.name = "Beta";
			MyUser.instance.myPeerID = P2P_Manager.instance.myPeerID;
			OnlineStatus.instance.setOnline(MyUser.instance.name,MyUser.instance.myPeerID);	
			changeToOverview();
		}
		
		private function addP3(e:MouseEvent):void{
			MyUser.instance.name = "Gamma";
			MyUser.instance.myPeerID = P2P_Manager.instance.myPeerID;
			OnlineStatus.instance.setOnline(MyUser.instance.name,MyUser.instance.myPeerID);	
			changeToOverview();
		}
		
		private function addP4(e:MouseEvent):void{
			MyUser.instance.name = "Delta";
			MyUser.instance.myPeerID = P2P_Manager.instance.myPeerID;
			OnlineStatus.instance.setOnline(MyUser.instance.name,MyUser.instance.myPeerID);	
			changeToOverview();
		}
		
		private function receivedMyPeerID(e:NetStatusEvent):void{
			player1.visible = true;
			player2.visible = true;
			player3.visible = true;
			player4.visible = true;

		}
		
		private function changeToOverview():void{
			newState = new Event("loginValid",true);
			dispatchEvent(newState);	
		}
				
		private function logMeIn(e:Event):void{
			loginRO.checkLogin(logname.text, logpw.text);
		}
		
		private function register(e:MouseEvent):void{
			newState = new Event("regPressed",true);
			dispatchEvent(newState);
		}
		
		public function logHandler(e:ResultEvent):void{
			if(e.result == 1){
				newState = new Event("loginValid",true);
				dispatchEvent(newState);
			}
			if(e.result == 0){
				mx.controls.Alert.show("Invalid username/password");
			}	
		}
	}
}