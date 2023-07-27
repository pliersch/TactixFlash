package game.world{
	import core.Player;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import game.units.*;
	
	import util.GraphicLoader;
	import util.PictureButton;
	import util.PictureIDButton;
	import util.Tools;

	public class SupplyMenu{
		private var _player:Player;
		private var infoTF:TextField;
		private var costTF:TextField;
		private var moneyTF:TextField;
		private var unitCountTF:TextField;
		private var _window:Sprite
		private var typbuttonContainer:Sprite;
		private var largeInfoContainer:Sprite;
		private var selectedTyp:uint;		
		private var actCost:uint;
		private var high:uint;
		private var largeFontSize:uint = 20;
		private var smallFontSize:uint = 14;
		private var typBtns:Array;
		private var _newUnits:Array;
		private var _platoonCountChanged:Boolean;
		private var soldierButton:PictureIDButton;	
		private var tankButton:PictureIDButton;
		private var artillerieButton:PictureIDButton;
		private var mechButton:PictureIDButton;
		private var aircraftButton:PictureIDButton;
		private var flagButton:PictureIDButton;
		private var closeBtn:PictureButton;
		private var buyBtn:PictureButton;
				
		public function SupplyMenu(player:Player){
			super();
			_player     = player;
			selectedTyp = 0;
			typBtns  = new Array();
			_platoonCountChanged = false;
			actCost     = 0;
			high		= 78;
			init();
			selectUnit(0);
		}
		
		private function init():void{
			_window = new Sprite();
			largeInfoContainer = new Sprite();
			_newUnits = new Array(0,0,0,0,0,0);			
			largeInfoContainer.addChild(new GraphicLoader("../media/supply/HummerLarge.png"));
			largeInfoContainer.addChild(new GraphicLoader("../media/supply/TankLarge.png"));
			largeInfoContainer.addChild(new GraphicLoader("../media/supply/ArtillerieLarge.png"));			
			largeInfoContainer.addChild(new GraphicLoader("../media/supply/FlagLarge.png"));			
			largeInfoContainer.addChild(new GraphicLoader("../media/supply/HeliLarge.png"));
			largeInfoContainer.addChild(new GraphicLoader("../media/supply/AircraftLarge.png"));			
			largeInfoContainer.x = 140;
			largeInfoContainer.y = 6;
			_window.addChild(new GraphicLoader("../media/supply/supplyBorderBlack.png"));
			_window.addChild(largeInfoContainer);
			buyBtn = new PictureButton("../media/supply/buttons/okOverDown.png",
										 "../media/supply/buttons/okOut.png",
										 "../media/supply/buttons/okOverDown.png");
			buyBtn.x = 560;
			buyBtn.y = 242;
			buyBtn.addEventListener(MouseEvent.CLICK, onClickBuy);
			_window.addChild(buyBtn);			
			closeBtn = new PictureButton("../media/supply/buttons/okOverDown.png",
										 "../media/supply/buttons/okOut.png",
										 "../media/supply/buttons/okOverDown.png");
			closeBtn.x = 752;
			closeBtn.y = 448;
			closeBtn.addEventListener(MouseEvent.CLICK, onClickClose);
			_window.addChild(closeBtn);										 
			soldierButton = new PictureIDButton(0,"../media/supply/buttons/hummerOver.png",
											  "../media/supply/buttons/hummerOut.png",
											  "../media/supply/buttons/hummerOver.png");
			tankButton = new PictureIDButton(1,"../media/supply/buttons/tankOver.png",
										   "../media/supply/buttons/tankOut.png",
										   "../media/supply/buttons/tankOver.png");
			artillerieButton = new PictureIDButton(2,"../media/supply/buttons/artillerieOver.png",
											     "../media/supply/buttons/artillerieOut.png",
											     "../media/supply/buttons/artillerieOver.png");
			aircraftButton = new PictureIDButton(3,"../media/supply/buttons/flagOver.png",
											   "../media/supply/buttons/flagOut.png",
											   "../media/supply/buttons/flagOver.png");
			mechButton = new PictureIDButton(4,"../media/supply/buttons/heliOver.png",
										   "../media/supply/buttons/heliOut.png",
										   "../media/supply/buttons/heliOver.png");
			flagButton = new PictureIDButton(5,"../media/supply/buttons/aircraftOver.png",
										   "../media/supply/buttons/aircraftOut.png",
										   "../media/supply/buttons/aircraftOver.png");
			typBtns.push(soldierButton);
			typBtns.push(tankButton);
			typBtns.push(artillerieButton);
			typBtns.push(aircraftButton);
			typBtns.push(mechButton);
			typBtns.push(flagButton);

			typbuttonContainer = new Sprite();
			typbuttonContainer.x = 7;
			typbuttonContainer.y = 10;	
						
			for(var i:uint=0;i<typBtns.length;i++){
				typBtns[i].y = high * i;
				typBtns[i].addEventListener(MouseEvent.CLICK, onClickTypBtn);
				typBtns[i].addEventListener(MouseEvent.MOUSE_OUT, onOutTypBtn);
				typBtns[i].addEventListener(MouseEvent.MOUSE_OVER, onOverTypBtn);
				typbuttonContainer.addChild(typBtns[i]);
			}

			_window.addChild(typbuttonContainer);							
			infoTF = new TextField();
			infoTF.autoSize = TextFieldAutoSize.LEFT;
			infoTF.selectable = false;
			infoTF.x = 154;
			infoTF.y = 340;
			infoTF.setTextFormat(Tools.setTextForm("babylon5Credits",largeFontSize,0xFFFFFF,"left", false));
			_window.addChild(infoTF); 
			unitCountTF = new TextField();
			unitCountTF.autoSize = TextFieldAutoSize.LEFT;
			unitCountTF.selectable = false;
			unitCountTF.x = 762;
			unitCountTF.y = 171;
			unitCountTF.setTextFormat(Tools.setTextForm("babylon5Credits",largeFontSize,0xFFFFFF,"left", false));
			_window.addChild(unitCountTF); 			
			costTF = new TextField();
			costTF.autoSize = TextFieldAutoSize.LEFT;
			costTF.selectable = false;
			costTF.x = 560;
			costTF.y = 220;
			costTF.setTextFormat(Tools.setTextForm("babylon5Credits",largeFontSize,0xFFFFFF,"left", false));
			_window.addChild(costTF); 			
			moneyTF = new TextField();
			moneyTF.autoSize = TextFieldAutoSize.CENTER;
			moneyTF.selectable = false;
			moneyTF.x = 814;
			moneyTF.y = 20;
			moneyTF.text = "Guthaben: \n" + _player.credit + "$";
			moneyTF.setTextFormat(Tools.setTextForm("babylon5Credits",largeFontSize,0xFFFFFF,"left", false));
			_window.addChild(moneyTF); 
		}
		
		private function getBG():Shape{
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0,0.4);
            bg.graphics.lineStyle(2, 0);
            bg.graphics.drawRect(0,0,1024,768);
            bg.graphics.endFill();	
			return bg;
		}
		
		public function openMenu():void{
			selectedTyp = 0;
			showLargeInfo(0);
			showUnitCount();
			_newUnits = new Array(0,0,0,0,0,0);
			_platoonCountChanged = false;
			buyBtn.visible = _player.credit >= actCost;
			_window.visible = true;
			selectUnit(0);
		}				

		public function closeMenu():void{
			_window.visible = false;
		}
		
		public function get window():Sprite{
			return _window;
		}		
		
		private function onClickTypBtn(event:MouseEvent):void{
			for(var k:uint=0;k<typBtns.length;k++){
				typBtns[k].onOut(event);
			}
			typBtns[event.currentTarget.id].onDown(event);
			selectedTyp = event.currentTarget.id; 
			selectUnit(selectedTyp);
			if(_player.credit >= actCost) moneyTF.setTextFormat(Tools.setTextForm("babylon5Credits",largeFontSize,0xFFFFFF,"left", false));
			else moneyTF.setTextFormat(Tools.setTextForm("babylon5Credits",largeFontSize,0xFF0000,"left", false));
			buyBtn.visible = _player.credit >= actCost;
		}

		private function selectUnit(typ:uint):void{
			switch(typ){ 
			    case 0:	showInfo(new Soldier()); break; 
			    case 1: showInfo(new Panzer()); break; 
			    case 2: showInfo(new Artillerie()); break; 
			    case 3: showInfo(new Flieger()); break; 
			    case 4: showInfo(new Mech()); break; 
			    case 5: showInfo(new Flak());  
			}
			showLargeInfo(typ);
		}		
		private function showLargeInfo(typ:uint):void{
			for (var i:uint=0;i<largeInfoContainer.numChildren;i++){
				largeInfoContainer.getChildAt(i).visible = false;
			}
			largeInfoContainer.getChildAt(typ).visible = true;
		}			
		
		private function showUnitCount():void{
			unitCountTF.text = _player.activePlatoon.getNumbersOfUnit(0) + "\n \n" + _player.activePlatoon.getNumbersOfUnit(1) + "\n \n" +
							   _player.activePlatoon.getNumbersOfUnit(2) + "\n \n" + _player.activePlatoon.getNumbersOfUnit(3) + "\n \n" +
							   _player.activePlatoon.getNumbersOfUnit(4) + "\n \n" + _player.activePlatoon.getNumbersOfUnit(5);
			unitCountTF.setTextFormat(Tools.setTextForm("babylon5Credits",largeFontSize,0xFFFFFF,"left", false));
		}		
		
		private function onOutTypBtn(event:MouseEvent):void{
			typBtns[selectedTyp].onDown(event);
		}

		private function onOverTypBtn(event:MouseEvent):void{
			typBtns[selectedTyp].onOut(event);
			typBtns[selectedTyp].onOver(event);
		}
		
		private function onClickClose(event:MouseEvent):void{
			_window.dispatchEvent(new Event("closeSupply",true));
		}										
		
		private function onClickBuy(event:MouseEvent):void{
			_platoonCountChanged = true;
			_player.activePlatoon.addUnitByTyp(selectedTyp);
			_player.activePlatoon.region.addUnitsOnRegion(1);
			_player.removeCredits(actCost);
			moneyTF.text = "Guthaben:\n" + _player.credit + "$";
			if(_player.credit >= actCost) moneyTF.setTextFormat(Tools.setTextForm("babylon5Credits",largeFontSize,0xFFFFFF,"left", false));
			else moneyTF.setTextFormat(Tools.setTextForm("babylon5Credits",largeFontSize,0xFF0000,"left", false));
			showUnitCount();
			buyBtn.visible = _player.credit >= actCost;
			_newUnits[selectedTyp] += 1;
		}
		
		public function setActTyp(typ:uint):void{
			selectedTyp = typ;
		}
		
		public function setActCost(_cost:uint):void{
			actCost = _cost;
		}				

		public function get newUnits():Array{
			return _newUnits;
		}
				
		public function get platoonCountChanged():Boolean{
			return _platoonCountChanged;
		}

		public function showCost(type:Unit):void{
			actCost = type.cost;				
			costTF.text ="Kosten: " + type.cost + "$";			  
			costTF.setTextFormat(Tools.setTextForm("babylon5Credits",largeFontSize,0xFFFFFF,"left", false));
		}

		public function showInfo(type:Unit):void{
			actCost = type.cost;				
			infoTF.text =
			"Lebenspunkte: "  + type.lebenspunkte  + "\n" +
			"Aktionspunkte: " + type.aktionspunkte + "\n" +
			"Sicht: "         + type.sicht         + "\n" +
			"Angriff: "       + type.angriff       + "\n" + 
			"Verteidigung: "  + type.verteidigung  + "\n" + 
			"Tarnung: "       + type.tarnung       + "\n" +
			"Munition: "      + type.munition;			  
			infoTF.setTextFormat(Tools.setTextForm("babylon5Credits",smallFontSize,0xFFFFFF,"left", false));
			showCost(type);
		}
	}
}