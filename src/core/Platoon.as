package core{
	import game.units.Artillerie;
	import game.units.Flak;
	import game.units.Flieger;
	import game.units.Mech;
	import game.units.Panzer;
	import game.units.Soldier;
	import game.units.Unit;
	import game.world.Region;
	
	public class Platoon{
		private var _owner:Player;
		private var _region:Region;
		private var _activeUnit : Unit;
		private var _platoon :Array; 
		private var _movablePieces:uint;
		private var _id:uint;
		private var _isActivePlatoon:Boolean;		
		private var _uniqueUnitID:uint = 0;
		private var _battleID:uint = 0;
		
		public static var SOLDIER_ID:uint = 0;
		public static var TANK_ID:uint = 1;
		public static var ARTILLERIE_ID:uint = 2;
		public static var AIRCRAFT_ID:uint = 3;
		public static var MECH_ID:uint = 4;
		public static var FLAK_ID:uint = 5;
		
		public function Platoon(owner:Player,id:uint, _soldiers:uint, _tanks:uint, _artilleries:uint, _aircrafts:uint, _mechs:uint, _flaks:uint){	
			_owner = owner;
			_platoon = new Array();
			_id = id;
			var unit:Unit;					
			for(var i : uint =0;i<_soldiers;i++){
				unit = new Soldier();
				_platoon.push(unit);
				unit.platoon = this;
				unit.name = "Unit " + _uniqueUnitID;
				unit.id = _uniqueUnitID;
				_uniqueUnitID++;
			}
			
			for(i = 0;i<_tanks;i++)	{
				unit = new Panzer();
				_platoon.push(unit);
				unit.platoon = this;
				unit.name = "Unit " + _uniqueUnitID;
				unit.id = _uniqueUnitID;
				_uniqueUnitID++;
			}
			
			for(i = 0;i<_artilleries;i++){
				unit = new Artillerie();
				_platoon.push(unit);
				unit.platoon = this;
				unit.name = "Unit " + _uniqueUnitID;
				unit.id = _uniqueUnitID;
				_uniqueUnitID++;
			}
			
			for(i = 0;i<_aircrafts;i++){
				unit = new Flieger();
				_platoon.push(unit);
				unit.platoon = this;
				unit.name = "Unit " + _uniqueUnitID;
				unit.id = _uniqueUnitID;
				_uniqueUnitID++;
			}
			
			for(i = 0;i<_mechs;i++)	{
				unit = new Mech();
				_platoon.push(unit);
				unit.platoon = this;
				unit.name = "Unit " + _uniqueUnitID;
				unit.id = _uniqueUnitID;
				_uniqueUnitID++;
			}
			
			for(i = 0;i<_flaks;i++)	{
				unit = new Flak();
				_platoon.push(unit);
				unit.platoon = this;
				unit.name = "Unit " + _uniqueUnitID;
				unit.id = _uniqueUnitID;
				_uniqueUnitID++;
			}
			//TODO: prüfen, ob weg kann!!
			setNextActive();	
		}
		
		public function get owner():Player {
			return _owner;
		}
				
		public function get region():Region {
			return _region;
		}
		
		public function set region(region:Region):void{
			_region = region;
		}				

		public function get id():uint{
			return _id;
		}		
		
		public function get battleID():uint{
			return _battleID;
		}	
		
		public function set battleID(value:uint):void{
			_battleID = value;
		}	
				
		public function getUnit(_nr :uint):Unit {
			for(var j:uint = 0; j < _platoon.length; j++){
				if(_platoon[j].id == _nr){
					break;
				}
			}
			return _platoon[j];
		}
				
		public function get activeUnit():Unit{
			return _activeUnit;
		}
		
		public function set activeUnit(unit:Unit):void {
			_activeUnit = unit;
		}
			
		public function resetRestAktionspunkte():void {
			for(var j:uint=0;j<_platoon.length;j++){
				_platoon[j].resetRestAktionspunkte();
				_platoon[j].movable = true;
			}			
		}
	
		public function anyUnitCanFire():Boolean{
			for (var i:uint=0;i<_platoon.length;i++)	{
				if (_platoon[i].canFire) return true;			
			}
			return false;			
		}	
		
		public function setCircleColor(color:uint):void	{
			for(var j:uint=0;j<_platoon.length;j++){
				_platoon[j].battlePiece.setCircleColor(color);					
			}		
		}	
		
		// lieber void als boolean ???		
		public function setNextActive():Boolean {
			var activeUnitPos:uint = 0;
			for(var j:uint = 0;j < _platoon.length; j++){
				if(_platoon[j] == _activeUnit){
					activeUnitPos = j;
					break;
				}
			}
			for(j = activeUnitPos;j < _platoon.length; j++){
				if (!_platoon[j].inField){
					_activeUnit = _platoon[j];
				  	return true;
				}
			}				
			return false;
		}
				
		public function setActiveUnit(id:uint):void{
			_activeUnit = getUnit(id);
		}	
		
		public function addUnit(unit:Unit):void	{
	    	_platoon.push(unit);
	    	unit.platoon = this;
	    	unit.name = unit.typ + "|" + _uniqueUnitID;
	    	unit.id = _uniqueUnitID++;
		}

		public function addUnitByTyp(typ:uint):void	{
			var unit:Unit;
			switch(typ){ 
			    case 0:	unit = new Soldier(); break; 
			    case 1: unit = new Panzer(); break; 
			    case 2: unit = new Artillerie(); break; 
			    case 3: unit = new Flieger(); break; 
			    case 4: unit = new Mech(); break; 
			    case 5: unit = new Flak();  
			}
	    	_platoon.push(unit);
	    	unit.platoon = this;
	    	unit.name = unit.typ + "|" + _uniqueUnitID;
	    	unit.id = _uniqueUnitID++;
		}
				
		public function removeUnit(unit:Unit):void{
			decreaseMovablePieces();
			unit.battlePiece.hexField.removeUnit();
			var index:uint = _platoon.indexOf(unit);	
			_platoon.splice(index,1);			
		}
		
		public function get active():Boolean{
			return _isActivePlatoon;
		}
		
		public function set active(_active:Boolean):void{
			_isActivePlatoon = _active;
		}
				
		public function get platoonCount() : uint{
			return _platoon.length;
		}		
				
		public function getNumbersOfUnit(typ:uint):uint	{
			var unitCount:uint = 0;
			for(var j:uint=0;j<_platoon.length;j++){
				if(_platoon[j].typ == typ) unitCount++;					
			}	
			return unitCount;
		}		
				
		public function decreaseMovablePieces():void{
			_movablePieces--;
		}
		
		public function resetMovablePieces():void{
			_movablePieces = platoonCount;
		}		
			
		public function get movablePieces():uint{
			return _movablePieces;
		}
	}
}