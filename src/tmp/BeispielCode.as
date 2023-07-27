package tmp
{
	public class BeispielCode
	{
		public function BeispielCode()
		{
			var arr:ArrayCollection = new ArrayCollection;
			arr.addItem({Wert1:"Bert",Wert2:1});
			arr.addItem({Wert1:"Ernie",Wert2:2});
			stratusGrid.dataProvider = arr;
			playerNameColumn.dataField = "Wert1";
			stratusIDColumn.dataField = "Wert2";
		}
	}
}