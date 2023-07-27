package base
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Form;
	import mx.containers.FormItem;
	import mx.containers.Panel;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	public class RegisterForm extends Panel
	{
		public var regform:Form;
		public var regformitem1:FormItem;
		public var regformpw:FormItem;
		public var regformconfirm:FormItem;
		public var regname:TextInput;
		public var regpw:TextInput;
		public var confirmpw:TextInput;
		public var registerMeNow:Button;
		public var newState:Event;
		public var regRO:RemoteObject;
	
		
		public function RegisterForm()
		{
			super();
			regRO = new RemoteObject("toLogin");
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		private function init(e:FlexEvent):void{
			registerMeNow.addEventListener(MouseEvent.CLICK, registerMe);
			regRO.addEventListener(ResultEvent.RESULT, registerHandler);
		}
		private function registerHandler(e:ResultEvent):void{
			if(e.result == 0){
				mx.controls.Alert.show("Vielen Dank, Sie werden jetzt zum Login geleitet");
				newState = new Event("regValid",true);
				dispatchEvent(newState);
			}
			if(e.result == 1)
			{
				mx.controls.Alert.show("Username bereits in Benutzung");
			}	
		}
		private function registerMe(e:MouseEvent):void{
			if(regpw.text != confirmpw.text)
			{
				mx.controls.Alert.show("Passwörter stimmen nicht überein");
				return;
			}else{
				regRO.register(regname.text, regpw.text);
			}	
		}

	}
}