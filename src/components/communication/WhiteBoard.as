package components.communication {
	
	import core.onlineStatus.P2P_Manager;
	
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import valueObjects.VO_Manager;
	import valueObjects.communicator.WhiteboardLineToVO;
	import valueObjects.communicator.WhiteboardMoveToVO;

	public class WhiteBoard extends Sprite {
		private var _oldX:uint;
		private var _oldY:uint;
		private var _drawModus:Boolean=false;
		private var _drawableArea:Sprite;
		private var _p2pManager:P2P_Manager;
		private var _lineToVO:WhiteboardLineToVO;
		private var _moveToVO:WhiteboardMoveToVO;

		public function WhiteBoard() {
			super();
			_p2pManager = P2P_Manager.instance;
			_drawableArea = new Sprite();
			_lineToVO = new WhiteboardLineToVO();
			_moveToVO = new WhiteboardMoveToVO();
			addChild(_drawableArea);
			initWhiteBoard();
		}

		private function setStartPoint(e:MouseEvent):void {
			_drawModus=true;
			_drawableArea.graphics.moveTo(mouseX, mouseY);
			_oldX=mouseX;
			_oldY=mouseY;
			_drawableArea.removeEventListener(MouseEvent.MOUSE_DOWN, setStartPoint);
			_moveToVO.xCoord = _oldX;
			_moveToVO.yCoord = _oldY;
			_p2pManager.sendObject(_moveToVO);
		}

		private function setNextPoint(e:MouseEvent):void {
			if (_drawModus) {
				if ((mouseX - _oldX) * (mouseX - _oldX) + (mouseY - _oldY) * (mouseY - _oldY) > 20) {
					_drawableArea.graphics.lineTo(mouseX, mouseY);
					_oldX=mouseX;
					_oldY=mouseY;
					_lineToVO.xCoord = _oldX;
					_lineToVO.yCoord = _oldY;
					_p2pManager.sendObject(_lineToVO);
				}
			}
		}
		
		public function beginDraw(moveToVO:WhiteboardMoveToVO):void{
			_drawableArea.graphics.moveTo(moveToVO.xCoord, moveToVO.yCoord);
		}
		
		public function draw(lineToVO:WhiteboardLineToVO):void{
			_drawableArea.graphics.lineTo(lineToVO.xCoord, lineToVO.yCoord);
		}

		private function stopDraw(e:MouseEvent):void {
			_drawModus=false;
			_drawableArea.addEventListener(MouseEvent.MOUSE_DOWN, setStartPoint);
		}
		
		public function initWhiteBoard():void {
			_drawableArea.graphics.clear();
			_drawableArea.graphics.beginFill(0xFFFFFF);
			_drawableArea.graphics.drawRect(0,0,620,306);
			_drawableArea.graphics.endFill();
			_drawableArea.addEventListener(MouseEvent.MOUSE_DOWN, setStartPoint);
			_drawableArea.addEventListener(MouseEvent.MOUSE_MOVE, setNextPoint);
			_drawableArea.addEventListener(MouseEvent.MOUSE_UP, stopDraw);
			_drawableArea.graphics.lineStyle(5,0,0.9,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,1);
		}
	}
}