package core.onlineStatus {
	import core.User;
	import core.UserInfo;
	import designPattern.observer.IObservable;
	import designPattern.observer.IObserver;
	import designPattern.observer.ObservableSubject;
	
	public class UserLogger implements IObservable {
		
		private var subj:ObservableSubject;
		static private var _instance:UserLogger;
		
		public function UserLogger(singletonEnforcer:SingletonEnforcer){
			subj = new ObservableSubject();
		}
		
		public static function get instance():UserLogger {
			if(UserLogger._instance == null){
				UserLogger._instance = new UserLogger(new SingletonEnforcer());
			}
			return UserLogger._instance;
		} 
		
		public function logChange(userStatus:UserInfo):void{
			notifyObservers(userStatus);
		}	
		
		public function addObserver(o:IObserver):Boolean {
			return subj.addObserver(o);
		}
		
		public function removeObserver(o:IObserver):Boolean	{
			return subj.removeObserver(o);
		}
		
		public function notifyObservers(infoObj:Object):void {
			subj.notifyObservers(infoObj);
		}
		
		public function clearObservers():void {
			subj.clearObservers();
		}
		
		public function hasChanged():Boolean {
			return subj.hasChanged();
		}
		
		public function setChanged():void {
			subj.setChanged();
		}
		
		public function clearChanged():void {
			subj.clearChanged();
		}
		
		public function countObservers():uint {
			return subj.countObservers();
		}
	}
}

class SingletonEnforcer{}