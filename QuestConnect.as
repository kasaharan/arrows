package  
{
	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	/**
	 * ...
	 * @author kasaharan
	 */
	public class QuestConnect extends Connect
	{
		public function connect(obj:Object, retFunc:Function):void
		{			
			var i:int;
			var vars:URLVariables = new URLVariables();

			loadedFunc = retFunc;

			vars.name = obj.name;
			
			vars.sendtime = Global.getLocalTime();

			dummy = Math.random() * 100 | 0;
			vars.dummy = dummy;
			vars.hash = Hash.getHash(vars.dummy + vars.sendtime + escapeMultiByte(vars.name));

			send(vars, "ar_quest2.php");
		}

		override protected function loaderCompleteHandler(event:Event):void
		{
			try
			{
				trace(unescapeMultiByte(event.target.data));
				var vars:URLVariables = event.target.data;

				if (vars.response == "OK")
				{
					Global.questTbl = new Table(Global.QUEST_TABLE, vars.quest, false);

					loadedFunc(true);
					return;
				}
				else
				{
					message = "通信エラー？";
				}
			}
			catch (e:Error)
			{
				trace("QuestConnect:catch exception:" + e.toString());
			}

			loadedFunc(false);
		}

	}
}
