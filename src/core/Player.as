package core {
	
	import game.units.*;
	import game.world.Region;
		
	public class Player	{	
		private var _playerName : String;
		private var _peerID : String;
		private var _id:uint;
		private var _credits : uint;
		private var _color : uint;
		private var _platoons:Array;
		private var _uniquePlatoonID:uint;
		private var _activePlatoon:Platoon;
		private var _regions:Array;
		private var _userStatus:UserInfo;
	
		public function Player(playerName:String, id:uint, credits:uint, color:uint, peerID:String,userStatus:UserInfo){
			_playerName      = playerName;
			_id			     = id;
			_credits         = credits;
			_color		     = color;
			_peerID			 = peerID;
			_userStatus 	 = userStatus;
			_uniquePlatoonID = 0;
			_platoons        = new Array();
			_regions         = new Array();
		}
		
		public function get userStatus():UserInfo	{
			return _userStatus;
		}

		public function get name() : String	{
			return _playerName;
		}
		
		public function get activePlatoon() : Platoon {
			return _activePlatoon;
		}
		
		public function set activePlatoon(platoon:Platoon) : void {
			_activePlatoon = platoon;
		}
		
		public function get platoonsCount() : uint{
			return _platoons.length;
		}	
		
		public function get allUnitsCount() : uint	{
			var count:uint = 0;
			for(var k:uint=0;k<_platoons.length;k++) {
				count+= this.getPlatoon(k).platoonCount;
			}
			return count;
		}		
				
		public function get credit() : uint	{
			return _credits;
		}		
		
		public function get id() : uint {
			return _id;
		}		

		public function get peerID() : String {
			return _peerID;
		}		
		
		public function get color():uint {
			return _color;
		}	
		
		public function get regions():Array	{
			return _regions;
		}

		public function getUniquePlatoonID():uint {
			return _uniquePlatoonID++;
		}
				
		public function getRegionByID(regionID:uint):Region{
			for(var i:uint=0; i<_regions.length; i++){
				if(_regions[i].id == regionID) return _regions[i];
			}
			return null;
		}	
		
		public function getRegionCount():uint{
			return _regions.length;
		}				
		
		public function getPlatoon(id:uint):Platoon	{
			return _platoons[id] as Platoon;
		}
		
		public function addPlatoon(platoon:Platoon):void {
			_platoons.push(platoon);
		}

		public function mergePlatoons(stayedPlatoon:Platoon, clearedPlatoon:Platoon):void {
			for(var i:uint=0;i<clearedPlatoon.platoonCount;i++){
				stayedPlatoon.addUnit(clearedPlatoon.getUnit(i));
			}
			removePlatoon(clearedPlatoon);
		}
		
		public function removePlatoon(platoon:Platoon):void	{
			_platoons.splice(_platoons.indexOf(platoon),1);
		}					
		
		public function addRegion(region:Region):void{
			regions.push(region);
		}
		
		public function removeRegion(region:Region):void { 
			_regions.splice(_regions.indexOf(region),1);
		}
		
		public function addCredits(credits : uint) : void{
			_credits += credits;
		}
		
		public function removeCredits(credits : uint) : void{
			_credits -= credits;
		}	
	}
}