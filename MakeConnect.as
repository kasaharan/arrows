package  
{
	import flash.events.Event;
	import flash.net.URLVariables;
	import flash.utils.escapeMultiByte;
	import flash.utils.unescapeMultiByte;

	/**
	 * ...
	 * @author kasaharan
	 */
	public class MakeConnect extends Connect
	{
		
		public function MakeConnect() 
		{
			
		}
		
		public function connect(obj:Object, retFunc:Function):void
		{			
			var i:int;
			var vars:URLVariables = new URLVariables();

			loadedFunc = retFunc;

			vars.name = obj.name;
			vars.pwd = Hash.getCryptogram( 131, obj.pwd ).substr(0, 16);
			vars.type = obj.type;
			vars.attack = obj.attack;
			vars.title = obj.title;
			vars.mngdata = obj.mngdata;
			vars.img1 = obj.img1;
			vars.img2 = obj.img2;
			vars.img3 = obj.img3;
			vars.img4 = obj.img4;
			vars.img5 = obj.img5;
			
			vars.sendtime = Global.getLocalTime();
			dummy = Math.random() * 100 | 0;
			vars.dummy = dummy;
			vars.hash = Hash.getHash(vars.dummy + vars.sendtime + escapeMultiByte(vars.name) + vars.pwd + vars.mngdata);

			send(vars, "ar_make3.php");
		}

		override protected function loaderCompleteHandler(event:Event):void
		{
			try
			{
				trace(unescapeMultiByte(event.target.data));
				var vars:URLVariables = event.target.data;

				if (vars.response == "OK")
				{
					Global.myReportTbl = new Table(Global.MYREPORT_TABLE, vars.rdata, false);
					
					//message = "提出しました。";
					message = "提出しました。審査結果をお待ちください。";

					loadedFunc(true);
					return;
				}
				else if (vars.response == "")
				{
					message = "";
				}
				else
				{
					message = "通信エラー？";
				}
			}
			catch (e:Error)
			{
				trace("MakeConnect:catch exception:" + e.toString());
			}

			loadedFunc(false);
		}
		
	}

}