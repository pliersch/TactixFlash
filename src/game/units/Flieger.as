package game.units 
{
	import core.Platoon;

	public class Flieger extends Unit 
	{
		function Flieger() 
		{
			super();
			_cost = 400;
			_typ = 3;
			_lebenspunkte = 12;
			_aktionspunkte = 8;
			_restAktionspunkte = _aktionspunkte;
			_sicht = 4;
			_angriff = 5;
			_verteidigung = 5;		
			_reichweite = 2;
			_munition = 6;
			_tarnung = 7;
			_angriffsKosten = 1;
			_erfahrung = 0;			
			//_einfluss = 0;
			//_geschick = 0;
			//_moral = 0;
		}
	}
}