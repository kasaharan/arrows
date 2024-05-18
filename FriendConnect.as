package
{
	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	public class FriendConnect extends Connect
	{
		public function connect(obj:Object, retFunc:Function):void
		{			
			loadedFunc = retFunc;

			var vars:URLVariables = new URLVariables();
			vars.name = obj.name;
			vars.friend = obj.friend;
			vars.msg = obj.msg;
			vars.type = obj.type;
			vars.check = obj.check;
			
			vars.sendtime = Global.getLocalTime();
			dummy = Math.random() * 100 | 0;
			vars.dummy = dummy;
			vars.hash = Hash.getHash(vars.dummy + vars.sendtime + escapeMultiByte(vars.name) + escapeMultiByte(vars.friend) + vars.type);

			send(vars, "ar_friend3.php");
		}

		override protected function loaderCompleteHandler(event:Event):void
		{
			try
			{
				trace(unescapeMultiByte(event.target.data));
				var vars:URLVariables = event.target.data;

				if (vars.response === "OK")
				{
					Global.friendTbl = new Table(Global.FRIEND_TABLE, vars.room , false);
					Global.friendMsgTbl = new Table(Global.FRIEND_MSG_TABLE, vars.msg, false);
					Global.friendNewsTbl = new Table(Global.FRIEND_NEWS_TABLE, vars.news, false);

					loadedFunc(true);
					return;
				}
				else if (vars.response === "NONE")
				{
					message = "入力したユーザは存在しません。";
				}
				else
				{
					message = "通信エラー？";
				}
			}
			catch (e:Error)
			{
				trace("FriendConnect:catch exception:" + e.toString());
			}

			loadedFunc(false);
		}

	}
}
