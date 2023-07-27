package game.units 
{
	import core.Platoon;

	public class Panzer extends Unit 
	{
		function Panzer() 
		{
			super();
			_cost = 300;
			_typ = 1;
			_lebenspunkte = 20;
			_aktionspunkte = 5;
			_restAktionspunkte = _aktionspunkte;
			_sicht = 3;
			_angriff = 15;
			_verteidigung = 12;		
			_reichweite = 2;
			_munition = 7;
			_tarnung = 7;
			_angriffsKosten = 1;
			_erfahrung = 0;			
//			_einfluss = 0;
//			_geschick = 0;
//			_moral = 0;
		}
	}
}