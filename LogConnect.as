package
{
	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	public class LogConnect extends Connect
	{
		public function connect(f:Function, name:String, log:String):void
		{
			loadedFunc = f;

			var vars:URLVariables = new URLVariables();

			vars.name = name;
			vars.log = log;

			vars.sendtime = Global.getLocalTime();
			dummy = Math.random() * 100 | 0;
			vars.dummy = dummy;
			vars.hash = Hash.getHash(vars.dummy + vars.sendtime + escapeMultiByte(vars.name));

			send(vars, "ar_log.php");
		}

		override protected function loaderCompleteHandler(event:Event):void
		{
			try
			{
				trace(unescapeMultiByte(event.target.data));
				var vars:URLVariables = event.target.data;

				if (vars.response === "OK")
				{
					loadedFunc(true);
					return;
				}
				else if (vars.response === "NG")
				{
					message = "失敗";
				}
				else
				{
					message = "通信エラー？";
				}
			}
			catch (e:Error)
			{
				trace("LogConnect:catch exception:" + e.toString());
			}

			loadedFunc(false);
		}

	}
}
