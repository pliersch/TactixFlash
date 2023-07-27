package core
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	public class MusicLoader
	{		
		public static function loadSound (mp3URL_1 : String):void
		{
			try 
			{
				var sound:Sound = new Sound();
				var request:URLRequest = new URLRequest(mp3URL_1);
				sound.load(request);
				var channel:SoundChannel = sound.play();
				channel.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);	
			} 
			catch (e:Error)
			{
				trace ("something is wrong");
			}
		}

		public static function onPlaybackComplete(event:Event):void
		{
			trace("The sound has finished playing.");
		}
		
		public static function fire(soundID:uint):void
		{
			switch(soundID)
			{
				case 0: 
			        MusicLoader.loadSound("../media/fireSoldier.mp3");
			        break; 
			    case 1: 
			        MusicLoader.loadSound("../media/fireTank.mp3");
			        break; 
			}			
		}
		
		public static function fire2(soundID_1:uint, soundID_2:uint):void
		{	
			fire(soundID_1);
		}
		
		
		
		
//		public static function loadSound (mp3URL_1 : String):void
//		{
//			if (mp3URL_1 != null)
//			{
//	            var request:URLRequest = new URLRequest(mp3URL_1);
//				try {     
//	                var snd : Sound = new Sound();
//	                var soundLoaded : Function = function (e:Event) : void
//	                {
//	                	var soundChannel : SoundChannel = snd.play(0, 1);
//	                	//fadeInSndChannel(soundChannel, 0, 1);
//	                }
//	                snd.addEventListener(Event.COMPLETE, soundLoaded);
//	                snd.load(request);
//	            }
//	            catch (e:Error) {
//	                trace ("something is wrong");
//	            }
//			}
//			else
//				throw new Error("Invalid url address"); 
//		}			 
		
//		public static function fadeInSndChannel (sndChannel : SoundChannel,startVolume : Number = 0,endVolume : Number = 1 ):void
//		{
//			var timer : Timer = new Timer ( 100, 100 );
//        	var fadeIn : Function = function ( tEvent : TimerEvent ) : void
//        	{
//            	var transform : SoundTransform = sndChannel.soundTransform;
//            	transform.volume = startVolume;
//            	sndChannel.soundTransform = transform;
//            	startVolume += 0.01;
//            	if ( startVolume >= endVolume )
//            		timer.stop();
//        	};
//        	timer.addEventListener(TimerEvent.TIMER, fadeIn);
//        	fadeIn ( new TimerEvent ( TimerEvent.TIMER ) );
//        	timer.start();
//		} 
	}
}