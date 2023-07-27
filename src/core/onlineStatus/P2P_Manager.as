package core.onlineStatus{
		
	import base.Overview;
	
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import designPattern.observer.IObservable;
	import designPattern.observer.IObserver;
	import designPattern.observer.ObservableSubject;
	
	public class P2P_Manager implements IObservable{
		
		static private var _instance:P2P_Manager;
		private var subj:ObservableSubject;
		private const SERVER_ADDRESS:String = "rtmfp://stratus.adobe.com/";
		private const DEVELOPER_KEY:String = "b239b38ba0c69f0d3cb69aef-fe881de8052c";
		private var _nc:NetConnection;
		private var _myPeerID:String;
		private var _farPeerID:String;
		private var sendStream:NetStream;
		private var recvStream:NetStream;
		
		public function P2P_Manager(singletonEnforcer:SingletonEnforcer){
			subj = new ObservableSubject();
		}
		
		public static function get instance():P2P_Manager{
			if(P2P_Manager._instance == null){
				P2P_Manager._instance = new P2P_Manager(new SingletonEnforcer());
			}
			return P2P_Manager._instance;
		} 
		
		public function initConnection():void{			
			_nc = new NetConnection();
			_nc.addEventListener(NetStatusEvent.NET_STATUS,ncStatus);
			_nc.connect(SERVER_ADDRESS+DEVELOPER_KEY);
		}
		
		private function ncStatus(event:NetStatusEvent):void{
			_myPeerID = _nc.nearID;
			trace(event.info.code);
		}	
		
		public function initSendStream():void{		
			sendStream = new NetStream(_nc,NetStream.DIRECT_CONNECTIONS);
			sendStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			var sendStreamClient:Object = new Object();
			sendStreamClient.onPeerConnect = function(callerns:NetStream):Boolean{					
				_farPeerID = callerns.farID;			
				return true;
			}			
			sendStream.client = this;
			sendStream.publish("media");
		}
		
		public function initRecvStream(_farPeerID:String):void{
			recvStream = new NetStream(_nc,_farPeerID);
			recvStream.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);
			recvStream.client = this;
			recvStream.play("media");
		}	
		
		public function initReceiveStreamByArray(userOnline:ArrayCollection):void{
			var farPeerID:String;
			var onlinePlayer:Array = userOnline.source;
			for (var i:uint=0;i<onlinePlayer.length;i++){
				if(onlinePlayer[i].stratusID != _myPeerID){
					initRecvStream(onlinePlayer[i].stratusID);
				}
			}
		}
		
		public function receiveObject(o:Object):void{
			notifyObservers(o);
		}
		
		public function sendObject(o:Object):void{
			sendStream.send("receiveObject",o);
		}
				
		private function netStatusHandler(event:NetStatusEvent):void{
			trace(event.info.code);
		}	

		public function get nc():NetConnection{
			return _nc;
		}		
		
		public function get myPeerID():String{
			return _myPeerID;
		}
		
		public function addObserver(o:IObserver):Boolean{
			return subj.addObserver(o);
		}
		
		public function removeObserver(o:IObserver):Boolean{
			return subj.removeObserver(o);
		}
		
		public function notifyObservers(infoObj:Object):void{
			subj.notifyObservers(infoObj);
		}
		
		public function clearObservers():void{
			subj.clearObservers();
		}
		
		public function hasChanged():Boolean{
			return subj.hasChanged();
		}
		
		public function setChanged():void{
			subj.setChanged();
		}
		
		public function clearChanged():void{
			subj.clearChanged();
		}
		
		public function countObservers():uint{
			return subj.countObservers();
		}
	}
}

class SingletonEnforcer{}