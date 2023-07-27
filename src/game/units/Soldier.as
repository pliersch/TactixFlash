package game.units 
{	
	import core.Platoon;

	public class Soldier extends Unit 
	{
		function Soldier() 
		{
			super();
			_cost = 150;
			_typ = 0;
			_lebenspunkte = 10;
			_aktionspunkte = 5;
			_restAktionspunkte = _aktionspunkte;
			_sicht = 2;
			_angriff = 4;
			_verteidigung = 4;		
			_reichweite = 1;
			_munition = 7;
			_tarnung = 1;
			_angriffsKosten = 1;
			_erfahrung = 0;			
//			_einfluss = 0;
//			_geschick = 0;
//			_moral = 0;
		}
	}
}