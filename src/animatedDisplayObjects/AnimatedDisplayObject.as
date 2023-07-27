package animatedDisplayObjects{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class AnimatedDisplayObject extends DisplayObject{
		
		private var _timer:Timer;
		private var _delay:uint;
		private var _repeat:uint;
		private var _parent:Sprite;
		
		public function AnimatedDisplayObject(parent:DisplayObject){
			super();
			_parent = parent;
		}
		
		public function fadeOut(millis:uint):void{
			_repeat = 50;
			_delay = millis / _repeat;
			_timer = new Timer(_delay,_repeat);
			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
		}
		
		private function timerHandler(e:TimerEvent):void {
			this.alpha -= 0.02;

		}
		
		private function completeHandler(e:TimerEvent):void {
			_parent.removeChild(this);
		}
	}
}
