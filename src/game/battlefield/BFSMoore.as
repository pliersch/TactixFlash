package game.battlefield {
	import game.battlefield.HexField;
	
	internal class BFSMoore {
		
		public static function getFields(xPos:uint, yPos:uint,points:uint):Array {
			var closedFields:Array = new Array();
			var openFields:Array   = new Array();
			var reachableNeighbours:Array = getReachableNeighbours(xPos, yPos,closedFields,openFields);
			if (reachableNeighbours.length > 0){
				closedFields.push(new Array(xPos, yPos));
				points --;
				for (var i:uint=0;i<reachableNeighbours.length;i++)	{
					openFields.push(reachableNeighbours[i]);
				}
			}
			var counter:uint;
			for (i=0;i<points;i++){
				counter = openFields.length;
				for (var j:uint=0;j<counter;j++){
					reachableNeighbours = getReachableNeighbours(openFields[0][0],openFields[0][1],closedFields,openFields);
					closedFields.push(openFields[0]);
					openFields.splice(0,1);
					for (var n:uint=0;n<reachableNeighbours.length;n++)	{
						openFields.push(reachableNeighbours[n]);
					}
				}
			}
			return closedFields.concat(openFields);
		}
		
		private	static function getReachableNeighbours(xKachel:uint, yKachel:uint, closedFields:Array, openFields:Array):Array {
			var reachableNeighbours:Array = new Array();
			var neighbours:Array = getNeighbours(xKachel,yKachel);
			for (var i:uint=0;i<neighbours.length;i++)	{
				if(0 <= neighbours[i][0] && neighbours[i][0] < Pref.BATTLEFIELD_ROWS && 
				   0 <= neighbours[i][1] && neighbours[i][1]< Pref.BATTLEFIELD_COL ){
					if(!isClosedField(neighbours[i][0],neighbours[i][1],closedFields) && !isOpenField(neighbours[i][0],neighbours[i][1],openFields)){
						reachableNeighbours.push(neighbours[i]);
					}
				}
			}
			return reachableNeighbours;
		}		

		private static function isClosedField(xPos:uint, yPos:uint, closedFields:Array):Boolean{
			for(var i:uint=0;i<closedFields.length;i++)	{
				if(xPos == closedFields[i][0] && yPos == closedFields[i][1]){
					return true;
				}
			}
			return false;
		}
		
		private static function isOpenField(xPos:uint, yPos:uint, openFields:Array):Boolean	{
			for(var i:uint=0;i<openFields.length;i++){
				if(xPos == openFields[i][0] && yPos == openFields[i][1]){
					return true;
				}
			}
			return false;
		}		
		
		private static function getNeighbours(xKachel:uint, yKachel:uint):Array {
			var neighbours:Array = new Array(6);
			neighbours[0] = new Array((xKachel - 2),yKachel);
			neighbours[1] = new Array((xKachel - 1),yKachel + (xKachel%2));
			neighbours[2] = new Array((xKachel+ 1),(yKachel  + (xKachel%2)));
			neighbours[3] = new Array((xKachel + 2),yKachel);
			neighbours[4] = new Array((xKachel + 1),(yKachel -1 + (xKachel%2)));
			neighbours[5] = new Array((xKachel - 1),(yKachel  -1 + (xKachel%2)));
			return neighbours;
		}
		
					
	}
}