package core.onlineStatus {
	
	public interface IBrowserReceiver {
		
		function handleBrowserEvent(eventName:String):void;
	}
}