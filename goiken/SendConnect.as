package goiken
{
	import goiken.Goiken;
	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;
	import flash.system.Capabilities;

	public class SendConnect extends Connect
	{
		public function connect(f:Function, name:String, msg:String):void
		{
			loadedFunc = f;

			var vars:URLVariables = new URLVariables();

			vars.name = name;
			vars.msg = msg;
			vars.fver = Capabilities.version;

			vars.sendtime = Goiken.getLocalTime();
			dummy = Math.random() * 100 | 0;
			vars.dummy = dummy;
			vars.hash = Hash.getHash(vars.dummy + vars.sendtime);

			send(vars, "ar_goiken.php");
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
				trace("SendConnect:catch exception:" + e.toString());
			}

			loadedFunc(false);
		}

	}
}
