package 
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.ui.Keyboard;

	public class LoginGamen extends Sprite
	{
		private var mc:MovieClip;

		public function LoginGamen(_mc:MovieClip, clickCancel:Function, _loginOKFunc:Function)
		{
			mc = _mc;
			addChild(mc);

			mc.pwd_txt.displayAsPassword = true;
			//mc.repwd_txt.displayAsPassword = true;
			mc.name_txt.maxChars = 8;
			mc.pwd_txt.maxChars = 16;
			//mc.repwd_txt.maxChars = 16;
			//mc.name_txt.maxChars = 8;
			mc.pwd_txt.restrict = "a-zA-Z0-9";
			//mc.repwd_txt.restrict = "a-zA-Z0-9";
			mc.name_txt.text = "";
			mc.pwd_txt.text = "";
			//mc.repwd_txt.text = "";

			//mc.ok_txt.borderColor = 0xff7f00;
			//mc.ok_txt.backgroundColor = 0xffdd88;
			mc.ok_txt.mouseEnabled = false;
			//mc.cancel_txt.borderColor = 0xff7f00;
			//mc.cancel_txt.backgroundColor = 0xffdd88;
			mc.cancel_txt.mouseEnabled = false;

			mc.name_txt.backgroundColor = 0xffeeff;
			mc.pwd_txt.backgroundColor = 0xffeeff;
			mc.name_txt.borderColor = 0xeeccff;
			mc.pwd_txt.borderColor = 0xeeccff;

			addSpriteBtn(mc.ok_txt, clickOK);
			addSpriteBtn(mc.cancel_txt, clickCancel);

			loginOKFunc = _loginOKFunc;

			this.addEventListener(Event.ENTER_FRAME, check_caps);

			this.focusRect = false;
		}

		private function addSpriteBtn(tf:TextField, f:Function):void
		{
			tf.mouseEnabled = false;

			var btn:Sprite = new Sprite();
			btn.buttonMode = true;
			btn.addChild(tf);
			mc.addChild(btn);

			tf.borderColor = 0x9977bb;
			tf.textColor = 0xffffff;
			tf.backgroundColor = Global.BUTTON_NORMAL_COLOR;//0x664477;
			tf.mouseEnabled = false;

			btn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{tf.backgroundColor = Global.BUTTON_SELECT_COLOR;});
			btn.addEventListener(MouseEvent.MOUSE_OUT,  function(e:MouseEvent):void{tf.backgroundColor = Global.BUTTON_NORMAL_COLOR;});
			btn.addEventListener(MouseEvent.CLICK, f);
		}

		public function setInitFocus(_stage:Stage):void
		{
			_stage.focus = mc.name_txt;

			try
			{
				mc.name_txt.text = Global.my_so.data.username;
			}
			catch(e:Error){}
		}

		// ----------------
		// clickOK
		// ----------------
		private var con:LoginConnect = new LoginConnect();
		public var loginOKFunc:Function;
		private var isNowLogin:Boolean = false;
		private function clickOK(e:MouseEvent):void
		{			
			var obj:Object = new Object();

			var _username:String = Global.trim(mc.name_txt.text);
			mc.name_txt.text = _username;

			obj.name = mc.name_txt.text;
			obj.pwd = mc.pwd_txt.text;

			//入力チェック
			if (obj.name.length == 0)
			{
				mc.msg_txt.text = "名前を入力してください";
				return;
			}
			if (obj.pwd.length == 0)
			{
				mc.msg_txt.text = "パスワードを入力してください";
				return;
			}

			if (isNowLogin)
			{
				mc.msg_txt.text = "ログイン中‥";
				return;
			}
			isNowLogin = true;

			mc.msg_txt.text = "ログイン中…";
			Global.pwd = obj.pwd;
			
			//送信
			con.connect(obj, retFunc);
		}
		private function retFunc(bool:Boolean):void
		{
			if (bool)
			{
				trace("OK");
				mc.msg_txt.text = con.message;
				loginOKFunc();
			}
			else
			{
				trace("NG");
				mc.msg_txt.text = con.message;
			}
			
			isNowLogin = false;
		}

		// ----------------
		// CAPSチェックなど
		// ----------------
		private function check_caps(e:Event):void
		{
			mc.msg2_txt.text = "";
			if (Keyboard.capsLock)
			{
				trace("Caps Lock ON");
				mc.msg2_txt.text = "CapsLock ON";
			}
		}

	}

}