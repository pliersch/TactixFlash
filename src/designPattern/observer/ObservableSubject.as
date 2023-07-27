package designPattern.observer {
	
	public class ObservableSubject implements IObservable {
		
		private var changed:Boolean;
		private var observers:Array;
		
		public function ObservableSubject(){
			super();
			changed = false;
			observers = new Array();
		}
		
		public function addObserver(o:IObserver):Boolean {
			if(o == null){
				return false;
			}
			for(var i:uint = 0;i<observers.length;i++){
				if(observers[i] == o){
					return false;
				}
			}
			observers.push(o);
			return true;
		}
		
		public function removeObserver(o:IObserver):Boolean {
			for(var i:uint = 0;i<observers.length;i++){
				if(observers[i] == o){
					observers.splice(i,1);
					return true;
				}
			}
			return false;
		}
		
		public function notifyObservers(infoObj:Object):void{
//			if(infoObj == undefined){
//				infoObj = null;
//			}
//			if(!changed){
//				return;
//			}
			var observersSnapshot:Array = observers.slice(0);
			clearChanged();
			for(var i:uint = 0;i<observers.length;i++){
				observers[i].update(this,infoObj);
			}
		}
		
		public function clearObservers():void{
			observers = new Array();
		}
		
		public function hasChanged():Boolean{
			return changed;
		}
		
		public function setChanged():void{
			changed = true;
		}
		
		public function clearChanged():void	{
			changed = false;
		}
		
		public function countObservers():uint{
			return observers.length;
		}
	}
}