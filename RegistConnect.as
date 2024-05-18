package
{
	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	public class RegistConnect extends Connect
	{
		public function connect(obj:Object, retFunc:Function):void
		{
			/*
			if (checkInput(obj) === false)
			{
				loadedFunc(false);
				return;
			}
			*/
			
			loadedFunc = retFunc;

			var vars:URLVariables = new URLVariables();

			vars.name = obj.name;
			vars.pwd = Hash.getCryptogram( 131, obj.pwd ).substr(0, 16);
			vars.scenario = obj.scenario;
			vars.exp = obj.exp;
			vars.sendtime = Global.getLocalTime();
			//vars.fpver = Global.flashPlayerVersion;
			dummy = Math.random() * 100 | 0;
			vars.dummy = dummy;
			vars.hash = Hash.getHash(vars.dummy + vars.sendtime + escapeMultiByte(vars.name) + vars.pwd + vars.scenario + vars.exp);

vars.ls = LocalStorage.getItem(LocalStorage.key);

			send(vars, "ar_regist3.php");
		}
/*
		override protected function checkInput(obj:Object):Boolean
		{
			//未入力チェック
			if (obj.name.length == 0)
			{
				message = "名前が入力されていません";
				return false;
			}
			if (obj.pwd.length == 0)
			{
				message = "パスワードが入力されていません";
				return false;
			}
			if (obj.repwd != obj.pwd)
			{
				message = "パスワードとパスワード再入力が一致していません";
				return false;
			}

			return true;
		}
*/
		override protected function loaderCompleteHandler(event:Event):void
		{
			try
			{
				trace(unescapeMultiByte(event.target.data));
				var vars:URLVariables = event.target.data;

				if (vars.response === "OK")
				{
					Global.userTbl = new Table(Global.USER_TABLE, vars.udata, false);

					Global.scenario.lastClearIndex = int(Global.userTbl.getData(0, "SCENARIO"));
					Hamayumi.exp = int(Global.userTbl.getData(0, "EXP"));
					Global.username = Global.userTbl.getData(0, "NAME");

					Global.selectGamen.initSettingNearLevel();
					
					message = "登録しました。";
					loadedFunc(true);
					return;
				}
				else if (vars.response === "USED")
				{
					message = "その名前はすでに使われています。";
				}
				else if (vars.response === "REGISTNG")
				{
					message = "短時間での複数ユーザ登録はできません。";
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
				trace("Regist:catch exception:" + e.toString());
			}

			loadedFunc(false);
		}

	}
}
