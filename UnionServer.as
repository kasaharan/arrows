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

	public class UnionServer
	{
		public var reactor:Reactor;
		public var room:Room;
		
		private const QUALIFIER:String = "archer";
		
		private var roomNo:int = 0;
		private var retry:int = 0;
		private var isSuccess:Boolean = false;
public var isAdd:Boolean = false;
		public var isHost:Boolean = false;

		//private var messageListener:Function;
		
		/*
		public const STATUS_NONE:int = 0;
		public const STATUS_CONNECT_START:int = 1;
		public const STATUS_CONNECT_OK:int = 2;
		public var nowStatus:int = STATUS_NONE;
		*/

		private const RETRY_COUNT:int = 32;

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

		public function UnionServer()
		{
			
		}
		public function start()
		{
			//this.messageListener = messageListener;
			
			isHost = false;
			
			reactor = new Reactor();
			reactor.addEventListener(ReactorEvent.READY, readyListener);

			if (isLocalSite())
			{
				reactor.connect("localhost", 9100);
			}
			else
			{
				reactor.connect("kasaharan.com", 9100);
			}

			//nowStatus = STATUS_CONNECT_START;
		}

public function test()
{
	var i:int;

	var rooms:Array = reactor.getRoomManager().getRooms();
	var room:Room = null;
	for (i = 0; i < rooms.length; i++)
	{
		room = rooms[i];
		var roomSetting:RoomSettings = room.getRoomSettings();
		if (room.getNumOccupants() < roomSetting.maxClients)
		{
			room.addMessageListener("PLAYER", messageListener);
			room.addEventListener(RoomEvent.ADD_OCCUPANT, addOccupantListener);
			room.addEventListener(RoomEvent.REMOVE_OCCUPANT, removeOccupantListener);
			room.addEventListener(RoomEvent.JOIN_RESULT, joinResultListener);
			room.join();
		}
	}
}

		protected function readyListener(e:ReactorEvent):void
		{
			var roomMan:RoomManager = reactor.getRoomManager();
			//roomMan.addEventListener(RoomManagerEvent.ROOM_ADDED, roomAddedListener);
			roomMan.addEventListener(RoomManagerEvent.CREATE_ROOM_RESULT, createResultListener);

			/*
			var roomSettings:RoomSettings = new RoomSettings();
			roomSettings.maxClients = 4;
			var roomName:String = QUALIFIER + ".ROOM" + roomNo;
			room = reactor.getRoomManager().createRoom(roomName, roomSettings);
			*/
			craeteRoom();

			/*
			room.addMessageListener("PLAYER", messageListener);

			room.addEventListener(RoomEvent.ADD_OCCUPANT, addOccupantListener);
			//Clientが退室
			room.addEventListener(RoomEvent.REMOVE_OCCUPANT, removeOccupantListener);

			//入室完了
			room.addEventListener(RoomEvent.JOIN_RESULT, joinResultListener);
			*/
		}
		
		private function craeteRoom()
		{
			if (0 < roomNo)
			{
				room.removeMessageListener("PLAYER", messageListener);
				room.removeEventListener(RoomEvent.ADD_OCCUPANT, addOccupantListener);
				room.removeEventListener(RoomEvent.REMOVE_OCCUPANT, removeOccupantListener);
				room.removeEventListener(RoomEvent.JOIN_RESULT, joinResultListener);
			}
			
			var roomSettings:RoomSettings = new RoomSettings();
			roomSettings.maxClients = 4;
			var roomName:String = QUALIFIER + ".ROOM" + roomNo;
			room = reactor.getRoomManager().createRoom(roomName, roomSettings);
			
			room.addMessageListener("PLAYER", messageListener);
			room.addEventListener(RoomEvent.ADD_OCCUPANT, addOccupantListener);
			room.addEventListener(RoomEvent.REMOVE_OCCUPANT, removeOccupantListener);
			room.addEventListener(RoomEvent.JOIN_RESULT, joinResultListener);
		}
		
		private function createResultListener(e:RoomManagerEvent)
		{
			if (e.getStatus() == Status.SUCCESS)
			{
				isHost = true;
				room.setAttribute("host", reactor.self().getClientID());
				trace("@@@SUCCESS");
			}
			else if (e.getStatus() == Status.ROOM_EXISTS)
			{
				isHost = false;
				trace("@@@ROOM_EXISTS");
			}
			else
			{
				//ERROR
				trace("@@@ERROR");
				return;
			}
			
			room.join();
		}
		/*
		private function joinRoom()
		{
			var roomSettings:RoomSettings = new RoomSettings();
			roomSettings.maxClients = 4;

			var roomName:String = QUALIFIER + ".ROOM" + roomNo;
			room = reactor.getRoomManager().createRoom(roomName, roomSettings);

			room.addMessageListener("PLAYER", messageListener);

			room.addEventListener(RoomEvent.ADD_OCCUPANT, addOccupantListener);
			//Clientが退室
			room.addEventListener(RoomEvent.REMOVE_OCCUPANT, removeOccupantListener);

			//入室完了
			room.addEventListener(RoomEvent.JOIN_RESULT, joinResultListener);
			
			room.join(); 
		}
		*/

		private function addOccupantListener(e:RoomEvent):void
		{
			var i:int;

			trace("####Clientが入室" + e.getClientID());
			isAdd = true;


			for (i = 0; i < RETRY_COUNT; i++)
			{
				if (makeMenmberNo())
				{
					break;
				}
			}

		}

		private function removeOccupantListener(e:RoomEvent):void
		{
			var i:int;

			trace("####Clientが退室" + e.getClientID());

			if (isSuccess == false)
			{
				return;
			}

			/*
			//時間がないので自分も含めて送ってしまうｓ
			room.sendMessage
			(
				"PLAYER",
				true,
				null,
				"LEAVE," + e.getClientID()
			);
			*/

			for (i = 0; i < RETRY_COUNT; i++)
			{
				if (makeMenmberNo())
				{
					break;
				}
			}
		}
		
		private function joinResultListener(e:RoomEvent):void
		{
			trace("##" + e.getStatus());

			if (e.getStatus() == Status.ROOM_FULL)
			{
				//時間がないのでこの方法でやる。負荷がちょっと気になる。
				//ほんとは存在している部屋をみたいがやりかたわからん
				roomNo++;
				retry++;
				if (retry < 32)	//このくらいでやめとく
				{
					//joinRoom();
					craeteRoom();
				}
			}
			else if (e.getStatus() == Status.SUCCESS)
			{
				isSuccess = true;
			}
		}

		public function finalize()
		{
			reactor.removeEventListener(ReactorEvent.READY, readyListener);
			room.removeEventListener(RoomEvent.ADD_OCCUPANT, addOccupantListener);
			room.removeEventListener(RoomEvent.REMOVE_OCCUPANT, removeOccupantListener);
			room.removeEventListener(RoomEvent.JOIN_RESULT, joinResultListener);
			room.removeMessageListener("PLAYER", messageListener);
			room.leave();

			//init
			memberNo = new Array();
			reactor.disconnect();
			reactor = null;
		}

		public function sendMessage(px:int, py:int, action:int, charNo:int)
		{
			if (isSuccess == false)
			{
				return;
			}

			room.sendMessage
			(
				"PLAYER",
				false,
				null,
				"MOV," + reactor.self().getClientID() + "," + px + "," + py + "," + action + "," + charNo
			);
		}
		
		public function sendShootMessage(x:int, y:int, r:Number, v:Number, cnt:int, seed:int)
		{
			if (isSuccess == false)
			{
				return;
			}

			room.sendMessage
			(
				"PLAYER",
				false,
				null,
				"SHOOT," + reactor.self().getClientID() + "," + x + "," + y + "," + r + "," + v + "," + cnt + "," + seed
			);
		}

		public var memberShoot:Function = function(yumiX:int, yumiY:int, baseR:Number, power:Number, seed:int){};
		private function messageListener(fromClient:IClient, messageText:String):void
		{
			try
			{
				trace(messageText);
				var i:int;
				var tmp:Array = messageText.split(",");
				var command:String = tmp.shift();
				var clientID:String = tmp.shift();
				/*
				var rx:int = tmp[2];
				var ry:int = tmp[3];
				var action:int = tmp[4];
				var charNo:int = tmp[5];
				*/

				if (command == "SHOOT")
				{
					memberShoot(tmp.shift(), tmp.shift(), tmp.shift(), tmp.shift(), tmp.shift(), tmp.shift());
				}

				/*
				if (command == "DEL")
				{
					for (i = 0; i < Game.player.length; i++)
					{
						if (Game.player[i].clientID == clientID)
						{
							Game.player[i].clientID = "";
							break;
						}
					}
				}
				else if (command == "MOV")
				{
					for (i = 0; i < Game.player.length; i++)
					{
						if (Game.player[i].clientID == clientID)
						{
							Game.player[i].x = rx;
							Game.player[i].y = ry;
							Game.player[i].msgNo = action;
							break;
						}
					}
					if (i == Game.player.length)
					{
						//新規
						for (i = 0; i < Game.player.length; i++)
						{
							if (Game.player[i].clientID.length == 0)
							{
								Game.player[i].clientID = clientID;
								Game.player[i].x = rx;
								Game.player[i].y = ry;
								Game.player[i].msgNo = action;
								break;
							}
						}
					}
				}
				else if (command == "OPI")
				{
					
				}
				*/
			}
			catch(e:Error){trace(e)}
		}

		// ----------------
		// 部屋内のメンバーをソートした配列を作成
		// ホストは先頭にする
		// ----------------
		public var memberNo:Array = new Array(); 
		private function makeMenmberNo():Boolean
		{
			var i:int;
			var ret:Boolean = true;

			try
			{
				memberNo = new Array();	//init
				var occupantIDs:Array = room.getOccupantIDs();
				var hostNo:int = (int)(room.getAttribute("host"));
				for (i = 0; i < occupantIDs.length; i++)
				{
					if (hostNo == (int)(occupantIDs[i]))
					{
						continue;
					}
					memberNo.push(occupantIDs[i]);
				}
				memberNo.sort();
				memberNo.unshift(hostNo);
			}
			catch(e:Error)
			{
				ret = false;
			}

			trace(memberNo);

			return ret;
		}
		/*
		private function makeMenmberNo():Boolean
		{
			var i:int;
			var ret:Boolean = true;

			try
			{
				memberNo = new Array();	//init
				var occupantIDs:Array = room.getOccupantIDs();
				for (i = 0; i < occupantIDs.length; i++)
				{
					memberNo.push(occupantIDs[i]);
				}
				memberNo.sort();
			}
			catch(e:Error)
			{
				ret = false;
			}

			trace(memberNo);

			return ret;
		}
		*/


	}
}