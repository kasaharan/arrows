package
{
	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	public class YumiSettingConnect extends Connect
	{
		public function connect(obj:Object, retFunc:Function):void
		{			
			var i:int;
			var vars:URLVariables = new URLVariables();

			loadedFunc = retFunc;

			vars.name = obj.name;
			vars.yuko = obj.yuko;
			
			vars.sendtime = Global.getLocalTime();

			dummy = Math.random() * 100 | 0;
			vars.dummy = dummy;
			vars.hash = Hash.getHash(vars.dummy + vars.sendtime + escapeMultiByte(vars.name) + vars.yuko);

			send(vars, "ar_yumisetting4.php");
		}

		override protected function loaderCompleteHandler(event:Event):void
		{
			try
			{
				trace(unescapeMultiByte(event.target.data));
				var vars:URLVariables = event.target.data;

				if (vars.response == "OK")
				{
					Global.useryumiTbl = new Table(Global.USERYUMI_TABLE, vars.useryumi, false);

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
				trace("YumiSettingConnect:catch exception:" + e.toString());
			}

			loadedFunc(false);
		}

	}
}
