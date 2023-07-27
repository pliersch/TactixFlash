package game.units 
{	
	import core.Platoon;

	public class Flak extends Unit 
	{
		function Flak() 
		{
			super();
			_cost = 200;
			_typ = 5;
			_lebenspunkte = 10;
			_aktionspunkte = 5;
			_restAktionspunkte = _aktionspunkte;
			_sicht = 4;
			_angriff = 5;
			_verteidigung = 3;		
			_reichweite = 3;
			_munition = 6;
			_tarnung = 4;
			_angriffsKosten = 2;
			_erfahrung = 0;			
			//_einfluss = 0;
			//_geschick = 0;
			//_moral = 0;
		}
	}
}