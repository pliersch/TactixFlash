package core.onlineStatus {
	
	[Bindable]
	[RemoteClass(alias="tactix.OnlineStatusVO")]
	
	public class OnlineStatusVO {
		public var name:String;
		public var id:String;
		
		public function OnlineStatusVO()
		{
		}
	}
}