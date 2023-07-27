package designPattern.observer {
	
	public interface IObserver{
		
		function update(observerable:IObservable, infoObj:Object):void;
	}
}