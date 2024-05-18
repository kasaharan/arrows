package 
{
	import net.user1.reactor.Reactor;
	import net.user1.reactor.ReactorEvent;
	import net.user1.reactor.IClient;
	import net.user1.reactor.Room;
	import net.user1.reactor.RoomSettings;
	import net.user1.reactor.RoomEvent;
	import net.user1.reactor.snapshot.RoomSnapshot;
	import net.user1.reactor.snapshot.SnapshotEvent;
	import net.user1.reactor.Status;
	import net.user1.reactor.RoomManagerEvent;
	import net.user1.reactor.RoomManager;
	import net.user1.reactor.Client;
	import flash.utils.Dictionary;
	import net.user1.reactor.UpdateLevels;

	public class UnionServer2
	{
		public var reactor:Reactor;
		public var topRoom:Room;
		public var room:Room;
		
		//private const QUALIFIER:String = "arrows14";
		//private const QUALIFIER:String = "arrows" + TitleGamen.version;
		//20140723人多すぎ対策(32人ずつ部屋分ける)
		public static const MAX_ROOM_CNT:int = 50;	// 40;	//32
		public static function get QUALIFIER():String { return "arrows" + TitleGamen.version + Global.rootRoomName; }
		private const TOP_ROOM_ID:String = "TOP_TOP_TOP";

		public var isJoinSuccess:Boolean = false;
		public static const PHASE_JOIN_NONE:int = 0;
		public static const PHASE_JOIN_START:int = 1;
		public static const PHASE_JOIN_END:int = 2;
		public var joinPhase:int = 0;
		
		public var isReady:Boolean = false;
		public var isRoomMakeHost:Boolean = false;	//部屋作成主

		public var isChatReady:Boolean = false;

		private const RETRY_COUNT:int = 5;
		
		//public var topRoomAddCount:int = 0;

		// ----------------
		// http://www.macromedia.com/support/documentation/jp/flashplayer/help/settings_manager04.html
		// UnionServer.swfUrl = loaderInfo.url;
		// ----------------
		public static var swfUrl:String = "";
		public static function isLocalSite():Boolean
		{
			//++++++++
			//Game.setLogInfo("isLocalSite");
			//++++++++

			if (swfUrl.length == 0)
			{
				trace("swfUrlに代入してないよ！！");
				return true;
			}
			return (swfUrl.substr(0, 4) == "file");
		}
		// ----------------

		public function UnionServer2()
		{
			reactor = new Reactor();
			//init();
		}
		public function init():void
		{
			//++++++++
			//Game.setLogInfo("init");
			//++++++++

			isReady = false;

			//reactor = new Reactor();
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

				//roomMan = reactor.getRoomManager();
				//監視設定（部屋情報が取れないため）
				reactor.getRoomManager().watchForRooms(QUALIFIER);
				//監視だけでは詳細が取れないので(observeしないとroomIDしかとれないっぽい)
				reactor.getRoomManager().addEventListener(RoomManagerEvent.ROOM_ADDED, _roomAddedListener);
				reactor.getRoomManager().addEventListener(RoomManagerEvent.ROOM_REMOVED, _roomRemovedListener);
	
				isReady = true;
			}

		}
		private function _roomAddedListener(e:RoomManagerEvent):void
		{
			//++++++++
			//Game.setLogInfo("_roomAddedListener");
			//++++++++
			
			e.getRoom().observe();		
		}
		private function _roomRemovedListener(e:RoomManagerEvent):void
		{
			//++++++++
			//Game.setLogInfo("_roomRemovedListener");
			//++++++++

			e.getRoom().stopObserving();
		}

		//****************
		public function joinTop():void
		{
			//++++++++
			//Game.setLogInfo("joinTop");
			//++++++++

			var roomSettings:RoomSettings = new RoomSettings();
			roomSettings.maxClients = 32;// 100;
			//var roomID:String = QUALIFIER + "_TOP" + ".ROOM";
			var roomID:String = QUALIFIER + "." + TOP_ROOM_ID;
			topRoom = null;
			topRoom = reactor.getRoomManager().createRoom(roomID, roomSettings);
			topRoom.addMessageListener("CHAT", topMessageListener);
			topRoom.addMessageListener("DC", topDCMessageListener);	//多重ログイン切断用
			topRoom.addEventListener(RoomEvent.ADD_OCCUPANT, addOccupantTopListener);
			topRoom.addEventListener(RoomEvent.REMOVE_OCCUPANT, removeOccupantTopListener);
			topRoom.addEventListener(RoomEvent.JOIN_RESULT, joinResultTopListener);
		
			reactor.self().setAttribute("username", Global.username);

			//topRoom.join();
			var updateLevels:UpdateLevels = new UpdateLevels();
			updateLevels.restoreDefaults();
			//updateLevels.clearAll();
			updateLevels.observerCount = true;
			topRoom.join(null, updateLevels);
		}
		
		public function leaveTop():void
		{
			//++++++++
			//Game.setLogInfo("leaveTop");
			//++++++++

			if (isChatReady)
			{
				isChatReady = false;
				
				topRoom.removeMessageListener("CHAT", topMessageListener);
				topRoom.removeMessageListener("DC", topDCMessageListener);	//多重ログイン切断用
				Global.chatGamen.removeMsgListener();
				topRoom.removeEventListener(RoomEvent.ADD_OCCUPANT, addOccupantTopListener);
				topRoom.removeEventListener(RoomEvent.REMOVE_OCCUPANT, removeOccupantTopListener);
				topRoom.removeEventListener(RoomEvent.JOIN_RESULT, joinResultTopListener);
		
				topRoom.leave();
			}
		}
		
		private function topMessageListener(fromClient:IClient, messageText:String):void
		{
			//++++++++
			//Game.setLogInfo("topMessageListener");
			//++++++++

			trace(fromClient.getClientID() + ":" + messageText);
		}

		private function topDCMessageListener(fromClient:IClient, messageText:String):void
		{
			//++++++++
			//Game.setLogInfo("topDCMessageListener");
			//++++++++

			//切断メッセージ受信
			trace(fromClient.getClientID() + ":" + messageText);
			//finalize();
			reactor.dispose();
		}
		
		private function addOccupantTopListener(e:RoomEvent):void
		{
			//++++++++
			//Game.setLogInfo("addOccupantTopListener");
			//++++++++

			var i:int;

			//topRoomAddCount++;

			trace("####Clientが入室" + e.getClientID());
		}
		
		private function removeOccupantTopListener(e:RoomEvent):void
		{
			//++++++++
			//Game.setLogInfo("removeOccupantTopListener");
			//++++++++

			var i:int;
		
			trace("####Clientが退室" + e.getClientID());
		}
		
		private function joinResultTopListener(e:RoomEvent):void
		{
			//++++++++
			//Game.setLogInfo("joinResultTopListener");
			//++++++++

			trace("##" + e.getStatus());
		
			if (e.getStatus() == Status.ROOM_FULL)
			{
				trace("ROOM_FULL");
			}
			else if (e.getStatus() == Status.SUCCESS)
			{
				isChatReady = true;
			}

//すでに同じ名前がいるならぬける
if (Global.checkLogined(Global.usvr.topRoom, Global.username))
{
	leaveTop();
}
		}
		
		private var kyoCount:int = 0;
		public function kyoMusubi():void
		{
			//++++++++
			//Game.setLogInfo("kyoMusubi");
			//++++++++

			//今日の日付
			var dd:String = (String)("00" + (new Date()).date).substr(-2);
			
			//今日の日付のもののみ残す
			var i:int;
			var dic:Dictionary = new Dictionary();
			//var kyo:String = "";
			var tmp:Array = (String)(topRoom.getAttribute("kyo")).split(",");
			kyoCount = 1;
			for (i = 0; i < tmp.length; i++)
			{
				var tmpDD:String = (String)(tmp[i]).substr(0, 2);
				var tmpName:String = (String)(tmp[i]).substr(2);
				if (dd == tmpDD)
				{
					//kyo += dd + tmpName + ",";
					dic[dd + tmpName] = "";
					kyoCount++;
				}
			}

			//新データ作成、設定
			//kyo += dd + Global.username + ",";
			dic[dd + Global.username] = "";
			
			var kyo:String = "";
			for (var key:String in dic)
			{
				kyo += key + ",";
			}
			
			topRoom.setAttribute("kyo", kyo);
		}
		public function getKyoCount():int
		{
			//++++++++
			////Game.setLogInfo("getKyoCount");
			//++++++++

			var tmp:Array = (String)(topRoom.getAttribute("kyo")).split(",");
			return tmp.length - 1;	//最後はカンマのみなので-1
		}
		//****************

		// ----------------
		// start
		// ----------------
		//public function start()
		//public function start(aikotoba:String = ""):void
		public function start(aikotoba:String = "", minLv:int = 0, maxLv:int = 999):void
		{
			//++++++++
			//Game.setLogInfo("start");
			//++++++++

			isJoinSuccess = false;
			isRoomMakeHost = true;

			var roomSettings:RoomSettings = new RoomSettings();
			roomSettings.maxClients = 4;
			var roomID:String = QUALIFIER + ".ROOM" + reactor.self().getClientID() + "_" + Global.getHHMISS();
			room = reactor.getRoomManager().createRoom(roomID, roomSettings);
			room.addMessageListener("PLAYER", messageListener);
			room.addEventListener(RoomEvent.ADD_OCCUPANT, addOccupantListener);
			room.addEventListener(RoomEvent.REMOVE_OCCUPANT, removeOccupantListener);
			room.addEventListener(RoomEvent.JOIN_RESULT, joinResultListener);

			room.setAttribute("host", reactor.self().getClientID());
			room.setAttribute("scenarioNo", "" + Global.scenario.no);
			//room.setAttribute("minLevel", "" + Global.scenario.getMinLevel());
			room.setAttribute("aikotoba", "" + aikotoba);
			room.setAttribute("join", "ready");
			room.setAttribute("close", "false");
			
			room.setAttribute("username", Global.username);
			room.setAttribute("level", "" + Hamayumi.level);
			
			room.setAttribute("minlv", "" + minLv);
			room.setAttribute("maxlv", "" + maxLv);
			
			//--------
			//報告書
			//if (Global.scenario.no == Scenario.REPORT_LV1)
			if (Global.scenario.isReportStage())
			{
				room.setAttribute("reportNo", "" + Global.reportGamen.pageNo);
				//討伐数に応じたHP補正のための値セット
				var tobatsu:Number = Global.reportGamen.getTobatsuHosei(Global.scenario.no);
				room.setAttribute("tobatsu", tobatsu.toString());
			}
			else
			{
				//room.setAttribute("reportIdx", "");	まちがい？
				room.setAttribute("reportNo", "");
				room.setAttribute("tobatsu", "1.0");
			}
			//--------

			//--------
			//if (Global.isEquipNoroi())
			//呪い　OR 日刊稲荷依頼
			if ((Global.isEquipNoroi()) || (0 < Global.dailyQuestNo))
			{
				//呪い設定(ONLINE)
				Global.stageNoroiValue = "1";
				room.setAttribute("noroi", "1");
				room.setAttribute("minLevel", "" + Global.scenario.getMinLevel());
			}
			else if (Global.yumiSettingGamen.isNoroi2())
			{
				//呪い設定(ONLINE)
				Global.stageNoroiValue = "2";
				room.setAttribute("noroi", "2");
				room.setAttribute("minLevel", "" + Global.scenario.getMinLevel());
			}
			else
			{
				room.setAttribute("noroi", "0");
				room.setAttribute("minLevel", "" + Global.scenario.getMinLevel());
			}
			//--------

			joinPhase = PHASE_JOIN_START;
			//UpdateLevelsを指定してjoinしたら部屋のattributeがnullになることがなくなった
			//room.join();
			var updateLevels:UpdateLevels = new UpdateLevels();
			updateLevels.restoreDefaults();
			room.join(null, updateLevels);
		}

		private function addOccupantListener(e:RoomEvent):void
		{
			//++++++++
			//Game.setLogInfo("addOccupantListener");
			//++++++++

			var i:int;

			trace("####Clientが入室" + e.getClientID());
			Global.playEntry();

			for (i = 0; i < RETRY_COUNT; i++)
			{
				if (makeMenmberNo())
				{
					break;
				}
			}
			
			//霊力同調用
			/*
			if (Global.yumiSettingGamen.isDocho)
			{
				e.getClient().getAttribute("");
			}
			*/
			var msg:String = "DOCHO," + reactor.self().getClientID() + ",";
			msg += Hamayumi.level + ",";
			msg += Hamayumi.yakazu + ",";
			msg += Hamayumi.maxPower + ",";
			msg += Hamayumi.addPowerValue + ",";
			msg += Hamayumi.penetrateMaxCnt + ",";
			msg += Hamayumi.shuchu + ",";
			msg += Hamayumi.sanran + ",";
			msg += Global.getWazaKind() + ",";
			msg += Global.getWazaKyokaKind() + ",";

			room.sendMessage("PLAYER", true, null, msg);
		}

		private function removeOccupantListener(e:RoomEvent):void
		{
			//++++++++
			//Game.setLogInfo("removeOccupantListener");
			//++++++++

			var i:int;

			trace("####Clientが退室" + e.getClientID());

			if (isJoinSuccess == false)
			{
				return;
			}
			
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
			//++++++++
			//Game.setLogInfo("joinResultListener");
			//++++++++

			trace("##" + e.getStatus() + ":" + Status.PERMISSION_DENIED);

			joinPhase = PHASE_JOIN_END;
			
			if (e.getStatus() == Status.ROOM_FULL)
			{
				trace("ROOM_FULL");
				(new TextLogConnect()).connect(Global.username + " ROOM_FULL");
				
				//--------
				room.removeMessageListener("PLAYER", messageListener);
				room.removeEventListener(RoomEvent.ADD_OCCUPANT, addOccupantListener);
				room.removeEventListener(RoomEvent.REMOVE_OCCUPANT, removeOccupantListener);
				room.removeEventListener(RoomEvent.JOIN_RESULT, joinResultListener);
				//--------
			}
			else if (e.getStatus() == Status.SUCCESS)
			{
				reactor.self().setAttribute("username", Global.username);
				reactor.self().setAttribute("level", "" + Hamayumi.level);

				if (isHost())
				{
					//ホスト入室OK
					room.setAttribute("join", "ok");
				}
				
				isJoinSuccess = true;
			}
		}

		// ----------------
		// join
		// ----------------
		/*
		//public function join():Boolean
		public function join(aikotoba:String = ""):Boolean
		{
			var i:int;
			
			isJoinSuccess = false;
			isRoomMakeHost = false;
			
			//for (i = 0; i < RETRY_COUNT; i++)
			{
				if (_join(aikotoba))
				{
					return true;
				}
			}
			return false;
		}
		*/
		//private function _join(aikotoba:String = ""):Boolean
		public function join(aikotoba:String = "", isRoomUpdate:Boolean = false):Boolean
		{
			//++++++++
			//Game.setLogInfo("join");
			//++++++++

			var ret:Boolean = false;

			isJoinSuccess = false;
			isRoomMakeHost = false;
			
			try
			{			
				var i:int;
				var tmpRoom:Room;
				var rooms:Array = reactor.getRoomManager().getRoomsWithQualifier(QUALIFIER);

				//roomシャッフル
				rooms = shuffleRoom(rooms);
				
				trace("##" + rooms.length);
				for (i = 0; i < rooms.length; i++)
				{
					tmpRoom = rooms[i];
					trace("#room#" + tmpRoom.getRoomID());
					var roomSetting:RoomSettings = tmpRoom.getRoomSettings();
					trace("join!!!" + tmpRoom.getNumOccupants() + ":" + roomSetting.maxClients);
					if (roomSetting.maxClients <= tmpRoom.getNumOccupants())
					{
						continue;
					}
					
					if (tmpRoom.getSimpleRoomID() == TOP_ROOM_ID)
					{
						continue;
					}

					if (isRoomUpdate)
					{
						//部屋情報更新指示
						updateRoomAttributes(tmpRoom.getRoomID());
					}
	
					if (tmpRoom.getAttribute("join") != "ok")
					{
						//ホストがまだ入室していない
						continue;
					}

					if (aikotoba != tmpRoom.getAttribute("aikotoba"))
					{
						continue;
					}

					var minLevel:int = int(tmpRoom.getAttribute("minLevel"));
					if (Hamayumi.level < minLevel)
					{
						continue;
					}

					//すでに同じ名前がいるなら入れない
					if (Global.checkLogined(tmpRoom, Global.username))
					{
						continue;
					}
					
					//協力戦選択なら選択したものにjoin
					if (0 < Global.selectedCoopName.length)
					{
						if (Global.selectedCoopName != tmpRoom.getAttribute("username"))
						{
							continue;
						}
					}

					//募集設定によるレベル制限
					var boshuMinLv:int = int(tmpRoom.getAttribute("minlv"));
					var boshuMaxLv:int = int(tmpRoom.getAttribute("maxlv"));
					if ((Hamayumi.level < boshuMinLv) || (boshuMaxLv < Hamayumi.level))
					{
						continue;
					}

					var isClose:Boolean = ("true" == tmpRoom.getAttribute("close"));
					if (isClose == false)
					{
						room = rooms[i];
						room.addMessageListener("PLAYER", messageListener);
						room.addEventListener(RoomEvent.ADD_OCCUPANT, addOccupantListener);
						room.addEventListener(RoomEvent.REMOVE_OCCUPANT, removeOccupantListener);
						room.addEventListener(RoomEvent.JOIN_RESULT, joinResultListener);
						joinPhase = PHASE_JOIN_START;
						
						//UpdateLevelsを指定してjoinしたら部屋のattributeがnullになることがなくなった
						//room.join();
						var updateLevels:UpdateLevels = new UpdateLevels();
						updateLevels.restoreDefaults();
						room.join(null, updateLevels);
						
						ret = true;
						break;
					}
				}
			}
			catch(e:Error)
			{
				//++++++++
				//Game.setLogInfo("join:" + e.errorID);
				//++++++++

				trace("###" + e);
				ret = false;
			}
		
			return ret;
		}
		// ----------------
		// updateRoomAttributes
		// ----------------
		public function updateRoomAttributes(roomID:String):void 
		{
			//++++++++
			//Game.setLogInfo("updateRoomAttributes");
			//++++++++

			//※マニュアルにはRoomのAttribute情報は同期されるとあるが、同期されないことがあるので手動で同期する
			
			var updateLevels:UpdateLevels = new UpdateLevels();
			updateLevels.restoreDefaults();
			var roomSnapShot:RoomSnapshot = new RoomSnapshot(roomID, null, updateLevels);
			roomSnapShot.addEventListener(SnapshotEvent.LOAD, loadListener);
			function loadListener (e:SnapshotEvent):void
			{
				try
				{
					var i:int;
					var roomAttrs:Object = roomSnapShot.getAttributes();
					var tmpRoom:Room = reactor.getRoomManager().getRoom(roomSnapShot.getRoomID());
					for (var attrName:String in roomAttrs)
					{
						//new TextLogConnect().connect(attrName, "" + tmpRoom.getAttribute(attrName) + "->" + roomAttrs[attrName]);
						tmpRoom.setAttribute(attrName, roomAttrs[attrName]);
					}
				}
				catch (e:Error)
				{
					//++++++++
					//Game.setLogInfo("updateRoomAttributes:" + e.errorID);
					//++++++++
				}
			}
			reactor.updateSnapshot(roomSnapShot);
		}
		// ----------------
		// shuffleRoom
		// ----------------
		private function shuffleRoom(_rooms:Array):Array
		{
			//++++++++
			//Game.setLogInfo("shuffleRoom");
			//++++++++

			var i:int, r:int;
			var len:int = _rooms.length;
			var tmp:Array = new Array();
			for (i = 0; i < len; i++)
			{
				r = int(Math.random() * _rooms.length);
				tmp.push(_rooms[r]);
				trace((Room)(_rooms[r]).getAttribute("scenarioNo"));
				_rooms.splice(r, 1);
			}
			return tmp;
		}

		// ----------------
		// getPublicRooms
		// ----------------
		//public var publicAikotoba:Vector.<String> = new Vector.<String>(8);
		public var coopName:Vector.<String> = new Vector.<String>;
		public function getBoshuRooms(aikotoba:String = ""):Vector.<String> 
		{
			var i:int;
			var idx:int = 0;
			var _sc:Scenario = new Scenario();
			var ret:Vector.<String> = new Vector.<String>;
			coopName = new Vector.<String>;
			var rooms:Array = reactor.getRoomManager().getRoomsWithQualifier(QUALIFIER);
			if (rooms != null)
			{
				for (i = 0; i < rooms.length; i++ )
				{
					try
					{
						var _room:Room = rooms[i];
						
						if (_room.getSimpleRoomID() == TOP_ROOM_ID)
						{
							continue;
						}

						if (_room.getAttribute("join") != "ok")
						{
							//ホストがまだ入室していない
							continue;
						}
						var minLevel:int = int(_room.getAttribute("minLevel"));
						if (Hamayumi.level < minLevel)
						{
							continue;
						}
						if (aikotoba != _room.getAttribute("aikotoba"))
						{
							continue;
						}
						if (_room.getAttribute("close") == "true")
						{
							continue;
						}
						
						//募集設定によるレベル制限
						var boshuMinLv:int = int(_room.getAttribute("minlv"));
						var boshuMaxLv:int = int(_room.getAttribute("maxlv"));
						if ((Hamayumi.level < boshuMinLv) || (boshuMaxLv < Hamayumi.level))
						{
							continue;
						}

						var _name:String = _room.getAttribute("username");
						var _level:String = _room.getAttribute("level");
						//var _noroi:String = (_room.getAttribute("noroi") == "1" ? "[呪]" : "    ");
						var _noroi:String = "    ";
						var _noroiVal:String = _room.getAttribute("noroi");
						if (_noroiVal == "1")
						{
							_noroi = "[呪]";
						}
						else if (_noroiVal == "2")
						{
							_noroi = "[呪×呪]";
						}
						
						_sc.no = int(_room.getAttribute("scenarioNo"));
						var sname:String = _sc.getName(_sc.getStageIdx(_sc.no));
						
						if (_sc.isReportStage())
						{
							var _pageNo:int = int(_room.getAttribute("reportNo"));
							if (_pageNo <= Global.reportTbl.getCount())
							{
								sname = Global.reportTbl.getData(_pageNo, "TITLE");
							}
							else
							{
								sname = "？？？";
							}
						}
						
						ret.push(Global.leftStr(_name, 16) + " Lv." + Global.leftStr(_level, 2) + _noroi + sname);
						coopName[idx] = _name;
						idx++;
					}
					catch (e:Error)
					{
						(new TextLogConnect()).connect("getBoshuRooms error " + e.errorID + "[" + i + "]");
					}
				}
			}

			return ret;
		}
/*
		private function observePasswordRoom(_password:String)
		{
			try
			{
				var i:int;
				var tmpRoom:Room;
				var rooms:Array = reactor.getRoomManager().getRoomsWithQualifier(QUALIFIER);

				for (i = 0; i < rooms.length; i++)
				{
					tmpRoom = rooms[i];
					if (reactor.self().isObservingRoom(tmpRoom.getRoomID()) == false)
					{
						tmpRoom.observe(_password);
					}
				}
			}
			catch(e:Error){}
		}
*/
		/*
		public function get isRoomFull():Boolean
		{
			var ret:Boolean = false;

			try
			{
				var roomSetting:RoomSettings = room.getRoomSettings();
				//trace("!!!" + room.getNumOccupants() + ":" + roomSetting.maxClients);
				if (room.getNumOccupants() < roomSetting.maxClients)
				{
					ret = false;
				}
				else
				{
					ret = true;
				}
			}
			catch(e:Error)
			{
				trace(e);
				ret = false;
			}

			return ret;
		}
		*/
		public function isRoomFull():Boolean
		{
			//++++++++
			//Game.setLogInfo("isRoomFull");
			//++++++++

			if (room == null)
			{
				return false;
			}
			
			var roomSetting:RoomSettings = room.getRoomSettings();
			if (roomSetting == null)
			{
				return false;
			}
			
			if (room.getNumOccupants() < roomSetting.maxClients)
			{
				return false;
			}
			return true;
		}
		
		public function shimekiriRoom():void
		{
			//++++++++
			//Game.setLogInfo("shimekiriRoom");
			//++++++++

			room.setAttribute("close", "true");
		}
		
		public function isClose():Boolean
		{
			//++++++++
			//Game.setLogInfo("isClose");
			//++++++++

			if (room == null)
			{
				return false;
			}
			
			return ("true" == room.getAttribute("close"));
		}
/*
		public function removeRoom()
		{
			room.remove();
		}
*/
		// ----------------
		// setGameLevel
		// ----------------
		public function setGameLevel(m:Vector.<Monster>):void
		{
			//++++++++
			//Game.setLogInfo("setGameLevel");
			//++++++++

			var i:int;
			var cnt:int = 2;

			//メンバーの数カウント
			try
			{
				cnt = room.getNumOccupants();
			}
			catch(e:Error)
			{
				//++++++++
				//Game.setLogInfo("setGameLevel:" + e.errorID);
				//++++++++

				trace("###getMemberCnt:" + e);
				cnt = 2;
			}
			
			var zoomRate:Number = 1.0;
			//呪い装備
			//ONLINE の呪判定は waitGamen の setMemberText で取得している
			if (Global.stageNoroiValue == "0")
			{
				//HPの倍率決定
				if (cnt == 2)
				{
					zoomRate = 1.5;
				}
				else if (cnt == 3)
				{
					zoomRate = 2.25;//2.0;	//75% * 人数
				}
				else if (cnt == 4)
				{
					zoomRate = 3.0;
				}
	
				//HP変更
				for (i = 0; i < m.length; i++)
				{
					//m[i].hp *= zoomRate;
					if (m[i].isMissile == false)
					{
						m[i].hp *= zoomRate;
						trace("m[i].hp:" + m[i].hp);
					}
				}
			}
			else if (Global.stageNoroiValue == "1")
			{
				//setNoroiLevel(m);
				setNoroiLevel(m);
			}
			//--------
			else if (Global.stageNoroiValue == "2")
			{
				setNoroi2Level(m);
			}
			//--------
		}
		
		// ----------------
		// setNoroiLevel
		// ----------------
		public function setNoroiLevel(m:Vector.<Monster>):void
		{
			//++++++++
			//Game.setLogInfo("setNoroiLevel");
			//++++++++

			var i:int;
			//HPの倍率決定
			var zoomRate:Number = 5.0;
			var zoomRateMissile:Number = 3.0;

			//HP変更
			for (i = 0; i < m.length; i++)
			{
				if (m[i].isMissile)
				{
					m[i].hp *= zoomRateMissile;
					m[i].missileHP *= zoomRateMissile;
				}
				else
				{
					m[i].hp *= zoomRate;
				}
				trace("呪m[i].hp:" + m[i].hp);
			}
		}
		// ----------------
		// setNoroi2Level
		// ----------------
		public function setNoroi2Level(m:Vector.<Monster>):void
		{
			var i:int;
			//HPの倍率決定
			var zoomRate:Number = 50;// 5.0;
			var zoomRateMissile:Number = 15;// 3.0;

			//
			if ((11 <= Global.scenario.no) && (Global.scenario.no <= 18))
			{
				//日本
				zoomRate = 100;
				zoomRateMissile = 40;
			}
			if ((19 <= Global.scenario.no) && (Global.scenario.no <= 26))
			{
				//イギリス
				zoomRate = 50;
				zoomRateMissile = 20;
			}
			if ((27 <= Global.scenario.no) && (Global.scenario.no <= 34))
			{
				//アメリカ
				zoomRate = 30;
				zoomRateMissile = 15;
			}
			if ((35 <= Global.scenario.no) && (Global.scenario.no <= 39))
			{
				//妖魔界1前半(1~5)
				zoomRate = 25;
				zoomRateMissile = 12;
			}
			if ((40 <= Global.scenario.no) && (Global.scenario.no <= 41))
			{
				//妖魔界1後半(6~7)
				zoomRate = 20;
				zoomRateMissile = 10;
			}
			if (Global.scenario.no == 42)
			{
				//妖魔界1 END(8)
				zoomRate = 13;
				zoomRateMissile = 6;
			}
			if (Global.scenario.no == Scenario.ROSE)
			{
				//ローズ
				zoomRate = 11;
				zoomRateMissile = 5;
			}
			if (Global.scenario.no == Scenario.REPORT_LV9)
			{
				zoomRate = 13;
				zoomRateMissile = 6;
			}
			if (Global.scenario.no == Scenario.CHAMAELEON)
			{
				zoomRate = 10;
				zoomRateMissile = 5;
			}
			if (Global.scenario.no == Scenario.REPORT_LV10)
			{
				zoomRate = 12;
				zoomRateMissile = 6;
			}
			if (Scenario.TENGU <= Global.scenario.no)
			{
				zoomRate = 10;
				zoomRateMissile = 5;
			}
			
			//HP変更
			for (i = 0; i < m.length; i++)
			{
				if (m[i].isMissile)
				{
					m[i].hp *= zoomRateMissile;
					m[i].missileHP *= zoomRateMissile;
				}
				else
				{
					m[i].hp *= zoomRate;
				}
				trace("呪2m[i].hp:" + m[i].hp);
			}
		}

		// ----------------
		// finalize
		// ----------------
		public function finalize(isDisconnect:Boolean = true):void
		{
			//++++++++
			//Game.setLogInfo("finalize:" + isDisconnect);
			//++++++++

			memberNo = new Array();

			isJoinSuccess = false;
			isReady = false;
			isRoomMakeHost = false;
			isChatReady = false;

			reactor.getRoomManager().stopWatchingForRooms(QUALIFIER);
			reactor.getRoomManager().removeEventListener(RoomManagerEvent.ROOM_ADDED, _roomAddedListener);
			reactor.getRoomManager().removeEventListener(RoomManagerEvent.ROOM_REMOVED, _roomRemovedListener);
			
			//--------
			if (topRoom != null)
			{
				topRoom.removeMessageListener("CHAT", topMessageListener);
				topRoom.removeMessageListener("DC", topDCMessageListener);	//多重ログイン切断用
				Global.chatGamen.removeMsgListener();
				topRoom.removeEventListener(RoomEvent.ADD_OCCUPANT, addOccupantTopListener);
				topRoom.removeEventListener(RoomEvent.REMOVE_OCCUPANT, removeOccupantTopListener);
				topRoom.removeEventListener(RoomEvent.JOIN_RESULT, joinResultTopListener);
			}
			if (room != null)
			{
				room.removeMessageListener("PLAYER", messageListener);
				room.removeEventListener(RoomEvent.ADD_OCCUPANT, addOccupantListener);
				room.removeEventListener(RoomEvent.REMOVE_OCCUPANT, removeOccupantListener);
				room.removeEventListener(RoomEvent.JOIN_RESULT, joinResultListener);
			}
			//--------
			
			if (isDisconnect)
			{
				reactor.disconnect();
			}
		}
		
		// ----------------
		// reconnect
		// ----------------
		public function reconnect():void
		{
			//++++++++
			//Game.setLogInfo("reconnect");
			//++++++++

			/*
			memberNo = new Array();

			isJoinSuccess = false;
			isReady = false;
			isRoomMakeHost = false;
			isChatReady = false;

			reactor.getRoomManager().stopWatchingForRooms(QUALIFIER);
			reactor.getRoomManager().removeEventListener(RoomManagerEvent.ROOM_ADDED, _roomAddedListener);
			reactor.getRoomManager().removeEventListener(RoomManagerEvent.ROOM_REMOVED, _roomRemovedListener);

			reactor.addEventListener(ReactorEvent.CLOSE, _closeReactor);
			reactor.disconnect();
			*/
			
			finalize(false);
			
			reactor.addEventListener(ReactorEvent.CLOSE, _closeReactor);
			reactor.disconnect();
			function _closeReactor(e:ReactorEvent):void
			{
				//--------20141108
				reactor.dispose();
				reactor = new Reactor();
				//--------
				reactor.removeEventListener(ReactorEvent.CLOSE, _closeReactor);
				init();
			}
		}
		
		//********************************
		//********************************
		//public function sendMessage(sendID:String, sendData:String):void
		public function sendMessage(sendID:String, sendData:String, includeSelf:Boolean = false):void
		{
			//++++++++
			//Game.setLogInfo("sendMessage");
			//++++++++

			if (isJoinSuccess == false)
			{
				return;
			}

			/*
			room.sendMessage
			(
				"PLAYER",
				false,
				null,
				sendID + "," + reactor.self().getClientID() + "," + sendData
			);
			*/
			room.sendMessage
			(
				"PLAYER",
				includeSelf,
				null,
				sendID + "," + reactor.self().getClientID() + "," + sendData
			);
		}

		public var recieveCoopMsg:Function;
		public var memberShoot:Function;// = function(yumiX:int, yumiY:int, baseR:Number, power:Number, seed:int, baratsuki:Number){};
		public var recieveHostCancel:Function;
		public var docho:Docho = new Docho();
		private function messageListener(fromClient:IClient, messageText:String):void
		{
			//++++++++
			//Game.setLogInfo("messageListener");
			//++++++++

			try
			{
				trace(messageText);
				var i:int;
				var tmp:Array = messageText.split(",");
				var id:String = tmp.shift();
				var clientID:String = tmp.shift();

				if (id == "SHOOT")
				{
					memberShoot(clientID, tmp.shift(), tmp.shift(), tmp.shift(), tmp.shift(), tmp.shift(), tmp.shift(), tmp.shift(), tmp.shift(), tmp.shift(), tmp.shift(), tmp.shift(), tmp.shift());
				}
				else if (id == "COOP")
				{
					recieveCoopMsg(clientID, tmp);
				}
				else if (id == "HOST_CANCEL")
				{
					//recieveHostCancel(true);
					recieveHostCancel();
				}
				else if (id == "DOCHO")
				{
					var level:int = int(tmp.shift());
					var yakazu:int = int(tmp.shift());
					var maxPower:Number = (Number)(tmp.shift());
					var addPowerValue:Number = (Number)(tmp.shift());
					var penetrateMaxCnt:int = int(tmp.shift());
					var shuchu:Number = (Number)(tmp.shift());
					var sanran:Number = (Number)(tmp.shift());
					var waza:int = int(tmp.shift());
					var wazaKyoka:int = int(tmp.shift());

					if (level < docho.level)
					{
						docho.setData(level, yakazu, maxPower, addPowerValue, penetrateMaxCnt, shuchu, sanran, waza, wazaKyoka);
					}
					//new TextLogConnect().connect("#" + Global.username + "(" + fromClient.getClientID() + "->" + reactor.self().getClientID() +"[RCV]:" + messageText + "[MIN" + docho.level + "]");
				}
				
			}
			catch (e:Error)
			{
				//++++++++
				//Game.setLogInfo("messageListener:" + e.errorID);
				//++++++++

				trace("###" + e)
			}
		}

		// ----------------
		// 部屋内のメンバーをソートした配列を作成
		// ホストは先頭にする
		// ----------------
		public var memberNo:Array = new Array(); 
		//private function makeMenmberNo():Boolean
		public function makeMenmberNo():Boolean
		{
			//++++++++
			//Game.setLogInfo("makeMenmberNo");
			//++++++++

			var i:int;
			var ret:Boolean = true;

			try
			{
				memberNo = new Array();	//init
				var occupantIDs:Array = room.getOccupantIDs();
				var hostIDStr:String = room.getAttribute("host");
				if (hostIDStr.length == 0)
				{
					ret = false;
				}
				else
				{
					//host以外をソート
					var hostID:int = int(hostIDStr);
					for (i = 0; i < occupantIDs.length; i++)
					{
						if (hostID == int(occupantIDs[i]))
						{
							continue;
						}
						memberNo.push(occupantIDs[i]);
					}
					memberNo.sort();
					//memberNo.unshift(hostID);
					
					//hostを先頭に入れる。
					for (i = 0; i < occupantIDs.length; i++)
					{
						if (hostID == int(occupantIDs[i]))
						{
							memberNo.unshift(hostID);
							break;
						}
					}
				}
			}
			catch(e:Error)
			{
				//++++++++
				//Game.setLogInfo("makeMenmberNo:" + e.errorID);
				//++++++++

				ret = false;
			}

			trace("memberNo[" + ret + "]:" + memberNo);

			return ret;
		}

		// ----------------
		// isHost
		// ----------------
		public function isHost():Boolean
		{
			//++++++++
			//Game.setLogInfo("isHost");
			//++++++++

			//var hostID:String = room.getAttribute("host");
			var hostID:String = "";
			if (0 < memberNo.length)
			{
				hostID = memberNo[0];
			}
			var clientID:String = reactor.self().getClientID();
			return (hostID == clientID);
		}
/*
		// ----------------
		// setUsername
		// ----------------
		public function setUsername(str:String)
		{
			reactor.self().setAttribute("username", str);
		}
*/
		// ----------------
		// getRoomMemberStr
		// ----------------
		public function getRoomMemberStr():String
		{
			//++++++++
			//Game.setLogInfo("getRoomMemberStr");
			//++++++++

			var i:int;
			var m:int;
			var ret:String = "";
			var tmp:Vector.<String> = new Vector.<String>;
			var client:Client;
			var username:String = "?";
			var userLevel:String = "?";

			try
			{
				if (room == null)
				{
					return "";
				}
				var occupants:Array = room.getOccupants();
				/*
				for (i = 0; i < occupants.length; i++)
				{
					client = occupants[i];
					//tmp.push(client.getAttribute("username"));
					if (client.getAttribute("username") != null)
					{
						username = client.getAttribute("username");
					}
					if (client.getAttribute("level") != null)
					{
						userLevel = client.getAttribute("level");
					}
					tmp.push(username + "(Lv." + userLevel + ")");
				}
				*/
				//メンバーの順番に表示（ホスト先頭）
				for (m = 0; m < memberNo.length; m++ )
				{
					for (i = 0; i < occupants.length; i++)
					{
						client = occupants[i];
						if (memberNo[m] == client.getClientID())
						{
							if (client.getAttribute("username") != null)
							{
								username = client.getAttribute("username");
							}
							if (client.getAttribute("level") != null)
							{
								userLevel = client.getAttribute("level");
							}
							tmp.push(username + "(Lv." + userLevel + ")");
						}
					}
				}
			}
			catch(e:Error)
			{
				//++++++++
				//Game.setLogInfo("getRoomMemberStr:" + e.errorID);
				//++++++++

				trace("@ERROR@" + e);
				return "";
			}

			for (i = 0; i < tmp.length; i++)
			{
				if (0 < i)
				{
					ret += "\n";
				}
				ret += tmp[i];
			}
			
			return ret;
		}

		// ----------------
		// getMemberMinLv
		// ----------------
		public function getMemberMinLv():int
		{
			var i:int, m:int;
			var tmpLv:Vector.<int> = new Vector.<int>;
			var client:Client;
			var occupants:Array = room.getOccupants();

			for (m = 0; m < memberNo.length; m++ )
			{
				for (i = 0; i < occupants.length; i++)
				{
					client = occupants[i];
					if (memberNo[m] == client.getClientID())
					{
						tmpLv.push(int(client.getAttribute("level")));
					}
				}
			}
			
			if (0 < tmpLv.length)
			{
				tmpLv.sort(Array.NUMERIC);
				return tmpLv[0];
			}

			return -1;
		}
		
		// ----------------
		// getPlayerCnt
		// ----------------
		public function getPlayerCnt():int
		{
			//++++++++
			//Game.setLogInfo("getPlayerCnt");
			//++++++++

			var i:int;
			var cnt:int = 0;

			try
			{
				var tmpRoom:Room;
				//--------
				var rooms:Array = reactor.getRoomManager().getRoomsWithQualifier(QUALIFIER);
				for (i = 0; i < rooms.length; i++)
				{
					tmpRoom = rooms[i];
					if (tmpRoom.getSimpleRoomID() == TOP_ROOM_ID)
					{
						cnt += tmpRoom.getNumObservers();
					}
					else
					{
						//cnt += tmpRoom.getNumOccupants();
					}
				}
			}
			catch(e:Error)
			{
				//++++++++
				//Game.setLogInfo("getPlayerCnt:" + e.errorID);
				//++++++++

				cnt = -1;
			}
			
			return cnt;
		}
		
		// ----------------
		// getOnlinePlayerName
		// ----------------
		public function getOnlinePlayerName():Vector.<String>
		{
			var i:int, m:int
			var retNames:Vector.<String> = new Vector.<String>();
			
			try
			{
				var tmpRoom:Room;
				var observers:Array;
				//--------
				var rooms:Array = reactor.getRoomManager().getRoomsWithQualifier(QUALIFIER);
				for (i = 0; i < rooms.length; i++)
				{
					tmpRoom = rooms[i];
					//observers = tmpRoom.getObservers();
					observers = tmpRoom.getOccupants();
					for (m = 0; m < observers.length; m++ )
					{
						retNames.push(Client(observers[m]).getAttribute("username"))
					}
				}
			}
			catch(e:Error)
			{
				//
			}
			
			return retNames;
		}

	}
}