package game.units 
{
	import core.Platoon;

	public class Mech extends Unit 
	{
		function Mech() 
		{
			super();
			_cost = 200;
			_typ = 4;
			_lebenspunkte = 15;
			_aktionspunkte = 5;
			_restAktionspunkte = _aktionspunkte;
			_sicht = 3;
			_angriff = 7;
			_verteidigung = 5;		
			_reichweite = 4;
			_munition = 6;
			_tarnung = 5;
			_angriffsKosten = 2;
			_erfahrung = 0;
		}
	}
}