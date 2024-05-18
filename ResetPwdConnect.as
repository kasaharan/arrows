package  
{
	import flash.utils.*;
	import flash.net.*;
	import flash.events.*;

	/**
	 * ...
	 * @author kasaharan
	 */
	public class ResetPwdConnect extends Connect
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
			vars.oldpwd = Hash.getCryptogram( 131, obj.oldpwd ).substr(0, 16);
			vars.newpwd = Hash.getCryptogram( 131, obj.newpwd ).substr(0, 16);

			vars.sendtime = Global.getLocalTime();
			dummy = Math.random() * 100 | 0;
			vars.dummy = dummy;
			vars.hash = Hash.getHash(vars.dummy + vars.sendtime + escapeMultiByte(vars.name) + vars.oldpwd + vars.newpwd);

			send(vars, "ar_reset.php");
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
					message = "変更しました。";
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
				trace("ResetPwdConnect:catch exception:" + e.toString());
			}

			loadedFunc(false);
		}

	}
}
