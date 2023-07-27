package designPattern.observer {
	
	public interface IObservable{
		
		function addObserver(o:IObserver):Boolean;
		function removeObserver(o:IObserver):Boolean;
		function notifyObservers(infoObj:Object):void;
		function clearObservers():void;
		function hasChanged():Boolean;
		function setChanged():void;
		function clearChanged():void;
		function countObservers():uint;
	}
}