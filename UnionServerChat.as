package 
{
	import net.user1.reactor.Reactor;
	import net.user1.reactor.ReactorEvent;
	import net.user1.reactor.IClient;
	import net.user1.reactor.Room;
	import net.user1.reactor.RoomSettings;
	import net.user1.reactor.RoomEvent;
	import net.user1.reactor.Status;
	import net.user1.reactor.RoomManagerEvent;
	import net.user1.reactor.RoomManager;
	import net.user1.reactor.Client;

	public class UnionServerChat
	{
		public var reactor:Reactor;
		public var room:Room;
		
		private const QUALIFIER:String = "arrows_chat";
		private const TOP_ROOM_ID:String = "TOP_ROOM";
		
		public var isSuccess:Boolean = false;

		// ----------------
		// http://www.macromedia.com/support/documentation/jp/flashplayer/help/settings_manager04.html
		// UnionServer.swfUrl = loaderInfo.url;
		// ----------------
		public static var swfUrl:String = "";
		public static function isLocalSite():Boolean
		{
			if (swfUrl.length == 0)
			{
				trace("swfUrlに代入してないよ！！");
				return true;
			}
			return (swfUrl.substr(0, 4) == "file");
		}
		// ----------------

		public function UnionServerChat()
		{
			reactor = new Reactor();
		}
		public function init()
		{
			reactor.addEventListener(ReactorEvent.READY, _readyListener);

			if (isLocalSite())
			{
				reactor.connect("localhost", 9100);
			}
			else
			{
				reactor.connect("kasaharan.com", 9100);
				//reactor.connect("153.122.35.249", 9100);
			}
			
			function _readyListener(e:ReactorEvent):void
			{
				reactor.removeEventListener(ReactorEvent.READY, _readyListener);
/*
				//監視設定（部屋情報が取れないため）
				reactor.getRoomManager().watchForRooms(QUALIFIER);
				//監視だけでは詳細が取れないので(observeしないとroomIDしかとれないっぽい)
				reactor.getRoomManager().addEventListener(RoomManagerEvent.ROOM_ADDED, _roomAddedListener);
				reactor.getRoomManager().addEventListener(RoomManagerEvent.ROOM_REMOVED, _roomRemovedListener);
*/
			}
/*
			function _roomAddedListener(e:RoomManagerEvent)
			{
				e.getRoom().observe();
			}
			function _roomRemovedListener(e:RoomManagerEvent)
			{
				e.getRoom().stopObserving();
			}
*/
		}

		//****************
		public function joinChat()
		{
			var roomSettings:RoomSettings = new RoomSettings();
			roomSettings.maxClients = 100;
			var roomID:String = QUALIFIER + "." + TOP_ROOM_ID;
			room = reactor.getRoomManager().createRoom(roomID, roomSettings);
			room.addMessageListener("CHAT", topMessageListener);
			room.addEventListener(RoomEvent.ADD_OCCUPANT, addOccupantTopListener);
			room.addEventListener(RoomEvent.REMOVE_OCCUPANT, removeOccupantTopListener);
			room.addEventListener(RoomEvent.JOIN_RESULT, joinResultTopListener);
		
			room.join();
		}
		
		private function topMessageListener(fromClient:IClient, messageText:String):void
		{
			trace(fromClient.getClientID() + ":" + messageText);
		}
		
		private function addOccupantTopListener(e:RoomEvent):void
		{
			var i:int;
		
			trace("####Clientが入室" + e.getClientID());
		}
		
		private function removeOccupantTopListener(e:RoomEvent):void
		{
			var i:int;
		
			trace("####Clientが退室" + e.getClientID());
		}
		
		private function joinResultTopListener(e:RoomEvent):void
		{
			trace("##" + e.getStatus());
		
			if (e.getStatus() == Status.ROOM_FULL)
			{
				trace("ROOM_FULL");
			}
			else if (e.getStatus() == Status.SUCCESS)
			{
		
			}
		}
		//****************

		public function finalize()
		{
			reactor.addEventListener(ReactorEvent.CLOSE, _closeReactor);
			reactor.disconnect();
			function _closeReactor(e:ReactorEvent)
			{
				reactor.removeEventListener(ReactorEvent.CLOSE, _closeReactor);
				init();
			}
		}

	}
}