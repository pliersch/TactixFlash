package base {
	
	import core.MyUser;
	import core.Player;
	import core.Players;
	import core.UserInfo;
	import designPattern.observer.IObservable;
	import designPattern.observer.IObserver;
	import core.onlineStatus.OnlineStatus;
	import core.onlineStatus.P2P_Manager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TextEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.DataGridEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	import valueObjects.player.PlayerVO;
	
	public class Overview extends Canvas implements IObserver {
		public var playerNameLabel:Label;
		[Bindable]
		public var gamesDB:DataGrid;
		public var gname:DataGridColumn;
		public var spnameP2P:DataGridColumn;
		public var gspieler:DataGridColumn;
		public var gspieler2:DataGridColumn;
		public var gspieler3:DataGridColumn;
		public var gspieler4:DataGridColumn;		
		public var levelEditorBtn:Button;
		public var joingame:Button;
		public var leavegame:Button;
		public var openGame:Button;
		public var newGame:Button;
		public var fullScreenBtn:Button;
		public var addPlayerBtn:Button;
		public var newGameName:TextInput;
		[Bindable]
		public var _players:Players;		
		public var userRO:RemoteObject;
		public var gameRO:RemoteObject;
		public var addgameRO:RemoteObject;
		public var removeGameRO:RemoteObject;
		public var newState:Event;
		private var selectedgame_name:String;
		private var selectedgame_p1:String;
		private var selectedgame_p2:String;
		private var selectedgame_p3:String;
		private var selectedgame_p4:String;
		private var _userList:UserList;
		private var _p2pManager:P2P_Manager;

		private static var _link1:Array = [valueObjects.player.PlayerVO];
		
		public function Overview(){
			super();
			userRO = new RemoteObject("toLogin");
			gameRO = new RemoteObject("toGame");
			addgameRO = new RemoteObject("toGame");
			removeGameRO = new RemoteObject("toGame");
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function init(e:FlexEvent):void{
			_userList = UserList.instance;
			gameRO.getList();
			joingame.enabled = false;
			leavegame.enabled = false;
			openGame.enabled = false;
			gameRO.addEventListener(ResultEvent.RESULT, gotGameList);
			addPlayerBtn.addEventListener(MouseEvent.CLICK, addNewPlayer);
			fullScreenBtn.addEventListener(MouseEvent.CLICK, handleFullScreen);
			gamesDB.addEventListener(ListEvent.ITEM_CLICK, gameSelected);
			joingame.addEventListener(MouseEvent.CLICK, addToGame);
			leavegame.addEventListener(MouseEvent.CLICK, leaveGame);
			openGame.addEventListener(MouseEvent.CLICK, goToGame);
			newGame.addEventListener(MouseEvent.CLICK, createGame);
			levelEditorBtn.addEventListener(MouseEvent.CLICK, openLevelEditor);
			addgameRO.addEventListener(ResultEvent.RESULT, gameadded);
			removeGameRO.addEventListener(ResultEvent.RESULT, gameleft);
			_p2pManager = P2P_Manager.instance;
			_p2pManager.addObserver(this);
			OnlineStatus.instance.addObserver(this);
			OnlineStatus.instance.getList();
			
			// notwendig, da p2p noch nicht einsatzbereit, gegenseite kennt eigene peerID noch nicht
			// und muss erst die db abrufen
			// obwohl es vielleicht auch schlauer geht...
			var newUserOnlineEvent: TextEvent = new TextEvent("userOnlineEvent", true);
			newUserOnlineEvent.text = "userOnlineEvent";
			dispatchEvent(newUserOnlineEvent);	
		}
		
		public function update(observerable:IObservable, infoObj:Object):void {
			// fehler, observerable ist ObservableSubject
			//if(observerable is PeerManager){
			if(infoObj is ArrayCollection){
				_userList.list = infoObj as ArrayCollection;
				if(OnlineStatus.instance.isNewUserOnline()){
					_p2pManager.initSendStream();
					_p2pManager.initReceiveStreamByArray(_userList.list);
				}
			}
			if(infoObj is PlayerVO){
				addPlayer(infoObj as PlayerVO);
			}
		}

		private function openLevelEditor(e:MouseEvent):void{
			dispatchEvent(new Event("levelEditorEvent", true));
		}
		
		public function handleFullScreen(e:MouseEvent):void{
			stage.displayState = "fullScreen";
		}
						
		private function gotGameList(e:ResultEvent):void{
			gamesDB.dataProvider = e.result;
			gname.dataField = "name";
			gspieler.dataField = "player1";
			gspieler2.dataField = "player2";
			gspieler3.dataField = "player3";
			gspieler4.dataField = "player4";
		}
				
		private function gameSelected(e:ListEvent):void{
			joingame.enabled = true;
			leavegame.enabled = true;
			openGame.enabled = true;
			selectedgame_name = e.itemRenderer.data.name;
			selectedgame_p1 = e.itemRenderer.data.player1;
			selectedgame_p2 = e.itemRenderer.data.player2;
			selectedgame_p3 = e.itemRenderer.data.player3;
			selectedgame_p4 = e.itemRenderer.data.player4;
		}
		
		private function addToGame(e:MouseEvent):void{
			if(MyUser.instance.name == (selectedgame_p1 || selectedgame_p2 || selectedgame_p3 || selectedgame_p4)){
				mx.controls.Alert.show("Du bist schon in dem Spiel!");
				return;
			}else if(selectedgame_p1 != null && selectedgame_p2 != null && selectedgame_p3 != null && selectedgame_p4 != null){
				mx.controls.Alert.show("Das Spiel ist schon voll");
				return;
			}else{
				addgameRO.joinGame(selectedgame_name, MyUser.instance.name);
			}
			userRO.getOnline();
			gameRO.getList();
		}
		
		private function leaveGame(e:MouseEvent):void{
			if( MyUser.instance.name != (selectedgame_p1 || selectedgame_p2 || selectedgame_p3 || selectedgame_p4)){
				mx.controls.Alert.show("Du bist nicht in diesem Spiel");
				return
			}else{
				removeGameRO.leaveGame(selectedgame_name, MyUser.instance.name);
			}
			userRO.getOnline();
			gameRO.getList();
		}
		
		private function goToGame(e:MouseEvent):void{
			var userStatusEvent: TextEvent = new TextEvent("userStatusEvent", true);
			userStatusEvent.text = "userStatusEvent." + Players.instance.myPlayer.name + "." + UserInfo.USER_IN_GAME;
			dispatchEvent(userStatusEvent);
			newState = new Event("toGame",true);
			dispatchEvent(newState);
		}
				
		private function createGame(e:MouseEvent):void{
			if(newGameName.text != null){
				addgameRO.addGame(newGameName.text, MyUser.instance.name);
			}else{
				mx.controls.Alert.show("Bitte geben Sie einen Namen für das Spiel ein!");
			}
		}
		
		private function gameadded(e:ResultEvent):void{
			if(e.result == 0){
				userRO.getOnline();
				gameRO.getList();
			}else if(e.result == 1){
				mx.controls.Alert.show("Spiel schon vorhanden, bitte wählen Sie einen anderen Namen");
			}
		}
		
		private function gameleft(e:ResultEvent):void{
				addgameRO.deleteGame(selectedgame_name);
				userRO.getOnline();
				gameRO.getList();
		}
				
		private function addPlayer(playerVO:PlayerVO):void {
			_players = Players.instance;
			var player:Player = new Player(playerVO.name,playerVO.id,2000,playerVO.color,playerVO.peerID, new UserInfo(playerVO.name));
			_players.addPlayer(player);
			if(player.name == MyUser.instance.name){
				playerNameLabel.text = MyUser.instance.name;
				_players.myPlayer = player;
			} 
			if(_players.length > 1) openGame.enabled = true;
		}
				
		private function addNewPlayer(e:MouseEvent):void{
			var players:Players = Players.instance;
			var color:uint;
			if(MyUser.instance.name      == "Alpha") color = 0xFF0000;
			else if(MyUser.instance.name == "Beta")	 color = 0x0000FF;
			else if(MyUser.instance.name == "Gamma") color = 0x00FF00;
			else									 color = 0xFFFF00;
			
			var playerVO:PlayerVO = new PlayerVO(players.length,MyUser.instance.name,color,MyUser.instance.myPeerID);
			_p2pManager.sendObject(playerVO);
			addPlayer(playerVO);
			// woanders hin
			if(_players.length > 1) openGame.enabled = true;
		}
	}
}
