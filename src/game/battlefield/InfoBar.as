package game.battlefield{	
	import core.Player;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import game.units.Unit;
	
	import util.Tools;
	
	public class InfoBar {
		private var _sprite:Sprite;
		private var myUnitInfoTF  :TextField;
		private var enemyUnitInfoTF :TextField;
		private var healthTF       :TextField;
		private var playerInfoTF   :TextField;		
		private var messageTF	   :TextField;
			
		public function InfoBar(){
			init();
		}
		
		private function init():void {
			_sprite = new Sprite();
			_sprite.graphics.beginFill(0x0000FF,1);
			_sprite.graphics.drawRect(0, 0, 800, 100);
			playerInfoTF = new TextField();
			playerInfoTF.autoSize = TextFieldAutoSize.LEFT;
			playerInfoTF.selectable = false;
//			playerInfoTF.x = -300;
//			playerInfoTF.y = 0;
			playerInfoTF.background = true;
			playerInfoTF.backgroundColor = 0xcccccc;
			playerInfoTF.setTextFormat(Tools.setTextForm("babylon5Credits",16,0xFFFFFF,"left", false));	
			_sprite.addChild(playerInfoTF);
			
			myUnitInfoTF = new TextField();
			myUnitInfoTF.autoSize = TextFieldAutoSize.LEFT;
			myUnitInfoTF.selectable = false;
			myUnitInfoTF.x =  150;
//			myUnitInfoTF.y = 0;
			_sprite.addChild(myUnitInfoTF);	
			
			enemyUnitInfoTF = new TextField();
			enemyUnitInfoTF.autoSize = TextFieldAutoSize.LEFT;
			enemyUnitInfoTF.selectable = false;
			enemyUnitInfoTF.x = 750;
//			enemyUnitInfoTF.y = 0;
			enemyUnitInfoTF.background = true;
			enemyUnitInfoTF.backgroundColor = 0xcccccc;
			_sprite.addChild(enemyUnitInfoTF);			
						
			messageTF = new TextField();
			messageTF.autoSize = TextFieldAutoSize.LEFT;
			messageTF.selectable = false;
//			messageTF.x =  -150;
			messageTF.y = 35;
			_sprite.addChild(messageTF);
		}
				
		public function showMyUnitInfo(myUnit:Unit):void{
			myUnitInfoTF.text =
				"Player:"		  + myUnit.platoon.owner.name + "\n"  +
				"Name:         "  + myUnit.name         + "\n" +
				"Lebenspunkte: "  + myUnit.lebenspunkte  + "\n" +
				"Aktionspunkte: " + myUnit.restAktionspunkte+ "\n" +
				"Reichweite: "    + myUnit.reichweite    + "\n" +
				"Angriff: "       + myUnit.angriff       + "\n" + 
				"Verteidigung: "  + myUnit.verteidigung  + "\n" + 
				"Munition: "      + myUnit.munition;			  
			myUnitInfoTF.setTextFormat(Tools.setTextForm("babylon5Credits",12,0,"left", false));
			myUnitInfoTF.visible = true;
		}
				
		public function showEnemyUnitInfo(enemyUnit:Unit):void{
			enemyUnitInfoTF.text =
				"Player:"		  + enemyUnit.platoon.owner.name + "\n"  +
				"Name:         "  + enemyUnit.name         + "\n" +
				"Lebenspunkte: "  + enemyUnit.lebenspunkte  + "\n" +
				"Aktionspunkte: " + enemyUnit.restAktionspunkte+ "\n" +
				"Reichweite: "    + enemyUnit.reichweite    + "\n" +
				"Angriff: "       + enemyUnit.angriff       + "\n" +
				"Munition: "      + enemyUnit.munition;			  
			enemyUnitInfoTF.setTextFormat(Tools.setTextForm("babylon5Credits",12,0,"left",false));
			enemyUnitInfoTF.visible = true;
		}
		
		public function hideEnemyInfo():void{
			enemyUnitInfoTF.visible = false;
		}
		
		public function hideMyUnitInfo():void{
			myUnitInfoTF.visible = false;
		}							
		
		public function refreshPlayerInfo(player:Player):void{
			playerInfoTF.text = "Name: "+ player.name + "\n" + "Credit: " + player.credit;
			playerInfoTF.setTextFormat(Tools.setTextForm("babylon5Credits",24,0xFFFFFF,"left",false));	
		}
				
		public function showMessage(text:String):void{
			messageTF.text = text;
			messageTF.setTextFormat(Tools.setTextForm("babylon5Credits",14,0xFFFFFF,"left",false));
		}
		
		public function get sprite():Sprite{
			return _sprite;
		}
	}		
}