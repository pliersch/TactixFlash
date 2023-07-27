package game.units {
	
	import core.Platoon;
	
	import game.battlefield.BattlePiece;

	public class Unit {	
		protected var _platoon:Platoon;
		protected var _name:String;
		protected var _typ:uint;
		protected var _id:uint;
		protected var _cost:uint;
		protected var _lebenspunkte:uint;
		protected var _erfahrung:uint;
		protected var _aktionspunkte:uint;
		protected var _restAktionspunkte:uint;
		protected var _angriffsKosten:uint;
		protected var _sicht:uint;
		protected var _angriff:uint;
		protected var _verteidigung:uint;
		protected var _tarnung:uint;
		protected var _munition:uint;
		protected var _reichweite:uint;
		protected var _imFeld:Boolean = false;
		protected var _movable:Boolean = true;
		protected var _isOnRegion:Boolean = true;
		protected var _aktionsRadius:Array;
		protected var _battlePiece:BattlePiece;

		public function Unit(){
			_restAktionspunkte = _aktionspunkte;
			_aktionsRadius = new Array();
		}
		
		public function set platoon(p:Platoon) : void{
			_platoon = p;
		}		
		
		public function get platoon() : Platoon{
			return _platoon;
		}
		
		public function set name(name:String) : void{
			_name = name;
		}
		
		public function get name() : String{
			return _name;
		}
		
		public function get cost() : uint{
			return _cost;
		}
			
		public function get typ() : uint{
			return _typ;
		}
		
		public function set id(id:uint) : void{
			_id = id;
		}		
			
		public function get id() : uint	{
			return _id;
		}		
					
		public function set movable(movable:Boolean) : void{
			_movable = movable;
		}
		
		public function get movable() : Boolean{
			return _movable;
		}		
		
		public function get lebenspunkte() : uint{
			return _lebenspunkte;
		}
		
		public function setLebenspunkte(lebenspunkte:uint) : void{
			_lebenspunkte = lebenspunkte;
		}
	
		public function addLebenspunkte(lebenspunkte:uint) : void{
			_lebenspunkte += lebenspunkte;
		}	
		
		/**
		 * 
		 * @param punkte Angriffskosten der gegnerischen Einheit
		 * @return true wenn noch Lebenspunkte, false wenn keine mehr
		 * 
		 */
		public function decreaseLebenspunkte(punkte:uint) : Boolean{
			if(_lebenspunkte - punkte > 0){
				_lebenspunkte -= punkte;
				return true;
			}
			return false;
		}		
		
		public function get erfahrung() : uint{
			return _erfahrung;
		}
		
		public function set erfahrung(erfahrung:uint) : void{
			_erfahrung = erfahrung;
		}
		
		public function set angriff(angriff:uint) : void{
			_angriff = angriff;
		}
		
		public function get angriff() : uint{
			return _angriff;
		}
		
		public function set reichweite(reichweite:uint) : void{
			_reichweite = reichweite;
		}
		
		public function get reichweite() : uint{
			return _reichweite;
		}
		
		public function set verteidigung(verteidigung:uint) : void{
			_verteidigung = verteidigung;
		}
		
		public function get verteidigung() : uint{
			return _verteidigung;
		}
		
		public function set sicht(sicht:uint) : void{
			_sicht = sicht;
		}
		
		public function get sicht() : uint{
			return _sicht;
		}
		
		public function set angriffskosten(angriffskosten:uint) : void{
			_angriffsKosten = angriffskosten;
		}
		
		public function get angriffskosten() : uint{
			return _angriffsKosten;
		}
		
		public function setTarnung(tarnung:uint) : void{
			_tarnung = tarnung;
		}
		
		public function get tarnung() : uint{
			return _tarnung;
		}		
							
		public function set munition(munition:uint) : void{
			_munition = munition;
		}

		public function addMunition(munition:uint) : void{
			_munition += munition;
		}
		
		public function decreaseMunition() : void{
			if(_munition > 0)
			_munition--;
		}		
		
		public function get munition() : uint{
			return _munition;
		}		
						
		public function get aktionspunkte() : uint{
			return _aktionspunkte;
		}
		
		public function set aktionspunkte(aktionspunkte:uint) : void{
			_aktionspunkte = aktionspunkte;
		}
		
		public function addAktionspunkte(_aktionspunkte:uint) : void{
			_aktionspunkte += _aktionspunkte;
		}
		
		public function get restAktionspunkte() : uint{
			return _restAktionspunkte;
		}
		
		public function decreaseRestAktionspunkte(aktionspunkte:uint) : void{
			_restAktionspunkte -= aktionspunkte;
		}
		
		public function setRestAktionspunkte(aktionspunkte:uint) : void	{
			_restAktionspunkte = aktionspunkte;
		}		
				
		public function resetRestAktionspunkte() : void{
			_restAktionspunkte = _aktionspunkte;
		}						
		
		public function get inField() : Boolean	{
			return _imFeld;
		}
		
		public function set inField(status:Boolean) : void{
			_imFeld = status;
		}
		
		public function get isOnRegion() : Boolean{
			return _isOnRegion;
		}
		
		public function set isOnRegion(onRegion:Boolean) : void{
			_isOnRegion = onRegion;
		}
		
		public function set aktionsRadius(radius:Array) : void	{
			_aktionsRadius = radius;
		}	
		
		public function get aktionsRadius() : Array	{
			return _aktionsRadius;
		}		
		
		public function set battlePiece(_piece:BattlePiece) : void{
			_battlePiece = _piece;
		}	
		
		public function get battlePiece() : BattlePiece	{
			return _battlePiece;
		}
		
		public function get canFire() : Boolean	{
			return _restAktionspunkte >= _angriffsKosten && _munition > 0;
		}

		public function setActive() : void{
			_platoon.activeUnit = this;
		}	
				
		
	}
}