package game.world {
	
	import core.Player;
	import core.Players;
	import core.UserInfo;
	import designPattern.observer.IObservable;
	import designPattern.observer.IObserver;
	import core.onlineStatus.UserLogger;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	import util.GraphicLoader;
	import util.Tools;
	
	public class EnemyWindow implements IObserver{	
		
		private var _sprite:Sprite;
		private var _ownerStatus:TextField;
		private var _ownerName:TextField;
		private var _glow:GlowFilter;
		private var _owner:Player;
				
		public function EnemyWindow(owner:Player) {
			_sprite = new Sprite();
			_ownerName = new TextField();
			_ownerStatus = new TextField();
			_owner = owner;
			init();
		}	
		
		private function init():void{
			UserLogger.instance.addObserver(this);
			if     (_owner.color == 0xFF0000) _sprite.addChild(new GraphicLoader("../media/hq/EnemyWindowRed.png"));
			else if(_owner.color == 0x00FF00) _sprite.addChild(new GraphicLoader("../media/hq/EnemyWindowGreen.png"));
			else if(_owner.color == 0x0000FF) _sprite.addChild(new GraphicLoader("../media/hq/EnemyWindowBlue.png"));
			else   				       _sprite.addChild(new GraphicLoader("../media/hq/EnemyWindowYellow.png"));
			_sprite.addEventListener(MouseEvent.ROLL_OVER, fadeGlow); 
			_ownerName.autoSize = TextFieldAutoSize.LEFT;
			_ownerName.selectable = false;		
			_ownerName.text = _owner.name;
			_ownerName.setTextFormat(Tools.setTextForm("babylon5Credits",20,0,"left",false));
			_ownerName.textColor = 0;
			_ownerName.x = this._sprite.x + 70;
			_ownerName.y = this._sprite.y + 20;
			_ownerStatus.autoSize = TextFieldAutoSize.LEFT;
			_ownerStatus.selectable = false;		
			_ownerStatus.text = _owner.userStatus.getStatusInfo();
			_ownerStatus.setTextFormat(Tools.setTextForm("babylon5Credits",14,0,"left",false));
			_ownerStatus.textColor = 0;
			_ownerStatus.x = this._sprite.x + 70;
			_ownerStatus.y = this._sprite.y + 40;			
			_sprite.addChild(_ownerName);
			_sprite.addChild(_ownerStatus);
		}

		public function update(observerable:IObservable, infoObj:Object):void {
			var userStatus:UserInfo = infoObj as UserInfo;
			if (userStatus.playerName == _ownerName.text){
				if(userStatus.hasTurnReady){
					_ownerStatus.text = userStatus.getStatusInfo() + "  has moved";
				} else {
					_ownerStatus.text = userStatus.getStatusInfo() + "  wait";
				}
				
				_ownerStatus.setTextFormat(Tools.setTextForm("babylon5Credits",14,0,"left",false));
			}
		}
		
		public function get sprite():Sprite	{
        	return _sprite;
        }
        
        public function get width():uint{
        	return _sprite.getChildAt(0).width;
        }			
		
		private function fadeGlow(event:Event):void { 
			var timer:Timer = new Timer(5,50);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, completeHandler);
		}

        private function timerHandler(e:TimerEvent):void {
			_glow = new GlowFilter();
			_glow.color = 0xFFFFFF;
			_glow.alpha += 0.05;
			_glow.blurX = 50;
			_glow.blurY = 30;
			_glow.quality = BitmapFilterQuality.MEDIUM;
			_ownerName.filters = [_glow];
        }

        private function completeHandler(e:TimerEvent):void {
			_glow.alpha = 0;
			_ownerName.filters = [_glow];
		}
	}
}