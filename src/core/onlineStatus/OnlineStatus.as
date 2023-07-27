package core.onlineStatus {
	
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	import designPattern.observer.IObservable;
	import designPattern.observer.IObserver;
	import designPattern.observer.ObservableSubject;
	
	public class OnlineStatus implements IObservable{
		
		private var oldUserCount:uint;
		private var newUserOnline:Boolean;
		private var subj:ObservableSubject;
		public var onlineStatusRO:RemoteObject;
		static private var _instance:OnlineStatus;
		
		public function OnlineStatus(singletonEnforcer:SingletonEnforcer) {
			oldUserCount = 0;
			subj = new ObservableSubject();
			onlineStatusRO = new RemoteObject("onlineStatus");
			onlineStatusRO.addEventListener(ResultEvent.RESULT, gotOnlineList);
		}
		
		public static function get instance():OnlineStatus {
			if(OnlineStatus._instance == null) {
				OnlineStatus._instance = new OnlineStatus(new SingletonEnforcer());
			}
			return OnlineStatus._instance;
		} 
		
		public function setOnline(name:String, stratusID:String):void{
			onlineStatusRO.setOnline(name, stratusID);
		}
		
		public function setOffline(name:String):void{
			onlineStatusRO.setOffline(name);
		}
		
		public function getList():void{
			onlineStatusRO.getList();
		}
		
		private function gotOnlineList(e:ResultEvent):void{
			var ac:ArrayCollection = e.result as ArrayCollection;
			if(ac != null){
				if(ac.length > oldUserCount){
					newUserOnline = true;
				} else {
					newUserOnline = false;
				}
				notifyObservers(ac);
				oldUserCount = ac.length;
			}
		}	
		
		public function isNewUserOnline():Boolean{
			return newUserOnline;
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