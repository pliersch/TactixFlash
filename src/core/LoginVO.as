package core {
	
	[Bindable]
	[RemoteClass(alias="tactix.LoginVO")]
	
	public class LoginVO {
		public var name:String;
		public var password:String;
		public var online:Boolean;
		
		public function LoginVO()
		{
		}
	}
}