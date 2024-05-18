package
{
	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	public class YumishiConnect extends Connect
	{
		public function connect(obj:Object, retFunc:Function):void
		{			
			var i:int;
			var vars:URLVariables = new URLVariables();

			loadedFunc = retFunc;

			vars.type = obj.type;
			vars.name = obj.name;
			vars.id = obj.id;
			vars.magatamaid = obj.magatamaid;
			
			vars.sendtime = Global.getLocalTime();

			dummy = Math.random() * 100 | 0;
			vars.dummy = dummy;
			vars.hash = Hash.getHash(vars.dummy + vars.sendtime + escapeMultiByte(vars.name) + vars.type + vars.id);

			send(vars, "ar_yumishi14.php");
		}

		override protected function loaderCompleteHandler(event:Event):void
		{
			try
			{
				trace(unescapeMultiByte(event.target.data));
				var vars:URLVariables = event.target.data;

				if (vars.response == "OK")
				{
					Global.userTbl = new Table(Global.USER_TABLE, vars.udata, false);
					Global.useryumiTbl = new Table(Global.USERYUMI_TABLE, vars.useryumi, false);
					if (vars.yumishi != null)
					{
						Global.yumishiTbl = new Table(Global.YUMISHI_TABLE, vars.yumishi, false);
					}
					Global.itemTbl = new Table(Global.ITEM_TABLE, vars.idata, true);
					Global.equipTbl = new Table(Global.EQUIP_TABLE, vars.edata, false);
					Global.initEquipIdx();

					loadedFunc(true);
					return;
				}
				else if (vars.response == "NG")
				{
					message = "強化に失敗しました。";
				}
				else
				{
					message = "通信エラー？";
				}
			}
			catch (e:Error)
			{
				trace("YumishiConnect:catch exception:" + e.toString());
			}

			loadedFunc(false);
		}

	}
}
