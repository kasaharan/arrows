package
{
	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	public class BuyConnect extends Connect
	{
		public function connect(obj:Object, retFunc:Function):void
		{			
			var i:int;
			var vars:URLVariables = new URLVariables();

			loadedFunc = retFunc;

			vars.name = obj.name;
			vars.pwd = Hash.getCryptogram( 131, obj.pwd ).substr(0, 16);
			vars.itemno = obj.itemno;
			
			vars.sendtime = Global.getLocalTime();
			dummy = Math.random() * 100 | 0;
			vars.dummy = dummy;
			vars.hash = Hash.getHash(vars.dummy + vars.sendtime + escapeMultiByte(vars.name) + vars.pwd + vars.itemno);

			send(vars, "ar_buy5.php");
		}

		override protected function loaderCompleteHandler(event:Event):void
		{
			try
			{
				trace(unescapeMultiByte(event.target.data));
				var vars:URLVariables = event.target.data;

				if (vars.response === "OK")
				{
					Global.userTbl = new Table(Global.USER_TABLE, vars.udata, false);
					
					Item.MAX_COUNT = int(Global.userTbl.getData(0, "ITEMCNT"));
					
					message = "購入しました";

					loadedFunc(true);
					return;
				}
				else if (vars.response === "NOMONEY")
				{
					message = "霊銭が足りません";
				}
				else
				{
					message = "通信エラー？";
				}
			}
			catch (e:Error)
			{
				trace("BuyConnect:catch exception:" + e.toString());
			}

			loadedFunc(false);
		}

	}
}
