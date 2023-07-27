package game.world{
	import core.Platoon;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import game.ArrayFigure;
	
	import util.PictureButton;
	import util.Tools;
	
	public class TransferAndAttackWindow {
		private var _sprite:Sprite;
		private var _container:Sprite;
		private var _offenerSprite:Sprite;
		private var _defenderSprite:Sprite;
		private var okBtn:PictureButton;
		private var cancelBtn:PictureButton;
		private var _offenerPlatoon:Platoon;
		private var _defenderPlatoon:Platoon;
		private var container :Array;
		private var transfers :Array;
		private var activeArrayFigure:ArrayFigure;
		private var infoTF:TextField;	
		private var transferPieces:uint;	
		//private var transferMessage:String;
		private var _regions:Regions;
				
		public function TransferAndAttackWindow(regions:Regions){
			_regions = regions;
			_sprite = new Sprite();
			_container = new Sprite();
			_container.graphics.beginFill(0,0.7);
            _container.graphics.lineStyle(1, 0x777777);
            _container.graphics.drawRect(0,0,600,300);
            _container.graphics.endFill();
            _sprite.visible = false;
            _sprite.addChild(getBG());
            _sprite.addChild(_container);
            _container.x = (_sprite.width - _container.width)/2;
            _container.y = (_sprite.height - _container.height)/2;
            okBtn = new PictureButton("../media/buttons/ButtonV1Black.png",
										 "../media/buttons/ButtonV1Green.png",
										 "../media/buttons/ButtonV1Red.png");
			okBtn.x = 304;
			okBtn.y = 274;
			okBtn.addEventListener(MouseEvent.CLICK, onClickOk);
			_container.addChild(okBtn);	
            cancelBtn = new PictureButton("../media/buttons/ButtonV1Black.png",
										 "../media/buttons/ButtonV1Green.png",
										 "../media/buttons/ButtonV1Red.png");
			cancelBtn.x = 196;
			cancelBtn.y = 274;
			cancelBtn.addEventListener(MouseEvent.CLICK, onClickCancel);
			_container.addChild(cancelBtn);				
			container = new Array();
			transfers = new Array(0,0,0,0,0,0);
			infoTF = new TextField();
			infoTF.autoSize = TextFieldAutoSize.LEFT;
			infoTF.selectable = false;
			infoTF.x = (_container.width - infoTF.width) / 2;
			infoTF.y = _container.height / 2;
			_container.addChild(infoTF);  			
		}
		
		public function get sprite():Sprite{
			return _sprite;
		}
		
		private function getBG():Shape {
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0,0.4);
            bg.graphics.lineStyle(2, 0);
            bg.graphics.drawRect(0,0,1024,500);
            bg.graphics.endFill();	
			return bg;
		}		
		
		public function show(offener:Platoon, defender:Platoon):void {
			transfers = new Array(0,0,0,0,0,0);
			container = new Array();
			if(_offenerSprite != null)  _container.removeChild(_offenerSprite);
			if(_defenderSprite != null) _container.removeChild(_defenderSprite);
			_offenerPlatoon  = offener;
			_defenderPlatoon = defender;
			_defenderSprite  = createArray(_defenderPlatoon,false);
			_offenerSprite   = createArray(_offenerPlatoon,true);
			_offenerSprite.x = (_container.width - _offenerSprite.width) / 2;
			_offenerSprite.y = _container.height  - 100;
			_defenderSprite.x = (_container.width - _defenderSprite.width) / 2;
			_defenderSprite.y = 50;
			_container.addChild(_offenerSprite);
			_container.addChild(_defenderSprite);		
			infoTF.x = (_container.width - infoTF.width) / 2;	
			_sprite.visible = true;				
		}
		
		private function onClickOk(event:MouseEvent):void {
			_sprite.visible = false;
			var typ:uint = 0;
			for(var i:uint=0;i<container.length;i++){
				activeArrayFigure = container[i] as ArrayFigure;
				if (activeArrayFigure.isActivated){
					transfers[activeArrayFigure.unit.typ] += 1;
				}
			}
			_regions.addMyMoves(transfers[0],transfers[1],transfers[2],transfers[3],transfers[4],transfers[5]);
		}

		private function onClickCancel(event:MouseEvent):void {
			_sprite.visible = false;
			for(var i:uint=0;i<container.length;i++){
				container[i].unit.isOnRegion = true;
			}
		}		
				
		private function onPress(event:MouseEvent):void {
			activeArrayFigure = event.target.parent as ArrayFigure;
			if (activeArrayFigure.isActivated){
				activeArrayFigure.unhighlight();
				transferPieces--;
				activeArrayFigure.unit.isOnRegion = true;
			} else 	{
				activeArrayFigure.highlight();
				transferPieces++;
				activeArrayFigure.unit.isOnRegion = false;
			}
			infoTF.text = transferPieces + " : " + _defenderPlatoon.platoonCount;
			infoTF.setTextFormat(Tools.setTextForm("babylon5Credits",24,0xFFFFFF,"left", false));	
			infoTF.x = (_container.width - infoTF.width) / 2;
		}			
		
		private function createArray(platoon:Platoon, isOffener:Boolean):Sprite	{
			var sprite:Sprite = new Sprite();
			var counter:uint = 0; 
			for(var i:uint=0;i<platoon.platoonCount;i++){
					if(platoon.getUnit(i).isOnRegion == true)	{
						container[counter] = new ArrayFigure(platoon.getUnit(i));
						if (isOffener)	{
							platoon.getUnit(i).isOnRegion = false; 
							container[counter].addEventListener(MouseEvent.MOUSE_DOWN, onPress);
							container[counter].highlight();
						}
						container[counter].setArrayElem(counter);
						container[counter].x = counter * 57 - 4;
						sprite.addChild(container[counter]);
						counter++;
					}	
			}
			transferPieces = counter;
			infoTF.text = transferPieces + " : " + _defenderPlatoon.platoonCount;
			infoTF.setTextFormat(Tools.setTextForm("babylon5Credits",24,0xFFFFFF,"left", false));
			return sprite;
		}				
	}
}