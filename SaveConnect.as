package
{
	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	public class SaveConnect extends Connect
	{
		public function connect(obj:Object, retFunc:Function):void
		{			
			loadedFunc = retFunc;

			var vars:URLVariables = new URLVariables();
			vars.name = obj.name;
			//vars.pwd = Hash.getCryptogram( 131, obj.pwd ).substr(0, 8);
			vars.pwd = Hash.getCryptogram( 131, obj.pwd ).substr(0, 16);
			vars.scenarioIdx = obj.scenarioIdx;
			vars.scenarioNo = obj.scenarioNo;
			vars.exp = obj.exp;
			vars.magatama = obj.magatama;
			vars.noroi = obj.noroi;
			vars.clearframecnt = obj.clearframecnt;
			vars.cleartime = obj.cleartime;
			vars.personcnt = obj.personcnt;
			vars.win = obj.win;
			vars.dmgrate = obj.dmgrate;
			vars.addexp = obj.addexp;
			vars.ch = obj.ch;
			vars.sac = obj.shootArrowCnt;
			vars.linfo = Global.loginInfo;
			vars.pageno = obj.pageno;
			vars.daily = obj.daily;
			vars.thisIdx = obj.thisIdx
			
			vars.sendtime = Global.getLocalTime();
			//vars.fpver = Global.flashPlayerVersion;
			dummy = Math.random() * 100 | 0;
			vars.dummy = dummy;
			vars.hash = Hash.getHash(vars.dummy + vars.sendtime + escapeMultiByte(vars.name) + vars.pwd + vars.scenarioIdx + vars.exp + vars.magatama + vars.noroi + vars.clearframecnt + vars.win + vars.personcnt + vars.dmgrate + vars.addexp + vars.ch + vars.daily + vars.thisIdx);

			send(vars, "ar_save26.php");
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
					Global.itemTbl = new Table(Global.ITEM_TABLE, vars.idata, true);
					Global.silhouetteTbl = new Table(Global.SILHOUETTE_TABLE, vars.silhouette, false);
					Global.tobatsuTbl = new Table(Global.TOBATSU_TABLE, vars.tobatsu, false);
					Global.friendNewsTbl = new Table(Global.FRIEND_NEWS_TABLE, vars.news, false);
					Global.noroi2ClearTbl = new Table(Global.NOROI2CLEAR_TABLE, vars.n2clr, false);

					Global.scenario.lastClearIndex = int(Global.userTbl.getData(0, "SCENARIO"));
					Global.magatamaID = vars.giid;
					Hamayumi.exp = int(Global.userTbl.getData(0, "EXP"));
					Global.loginInfo = vars.linfo;
					Global.expup = vars.expup;
					Global.dochoFlag = vars.docho;
					Global.dailyReward = vars.reward;

					//クリアして再読み込みさせる
					Global.questTbl = new Table(Global.QUEST_TABLE, "", false);

					Global.initEquipIdx();

					loadedFunc(true);
					return;
				}
				else if (vars.response == 'OLD')
				{
					message = "ログイン情報が無効です。";
				}
				else
				{
					message = "通信エラー？";
				}
			}
			catch (e:Error)
			{
				trace("Save:catch exception:" + e.toString());
			}

			loadedFunc(false);
		}

	}
}
