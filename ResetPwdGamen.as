package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.ui.Keyboard;

	/**
	 * ...
	 * @author kasaharan
	 */
	public class ResetPwdGamen extends Sprite
	{
		public var mc:MovieClip;

		public function ResetPwdGamen(_mc:MovieClip) 
		{
			mc = _mc;
			addChild(mc);

			mc.oldpwd_txt.displayAsPassword = true;
			mc.newpwd_txt.displayAsPassword = true;
			mc.repwd_txt.displayAsPassword = true;
			mc.oldpwd_txt.maxChars = 16;
			mc.newpwd_txt.maxChars = 16;
			mc.repwd_txt.maxChars = 16;
			mc.oldpwd_txt.restrict = "a-zA-Z0-9";
			mc.newpwd_txt.restrict = "a-zA-Z0-9";
			mc.repwd_txt.restrict = "a-zA-Z0-9";
			mc.oldpwd_txt.text = "";
			mc.newpwd_txt.text = "";
			mc.repwd_txt.text = "";

			mc.oldpwd_txt.backgroundColor = 0xffeeff;
			mc.newpwd_txt.backgroundColor = 0xffeeff;
			mc.repwd_txt.backgroundColor = 0xffeeff;
			mc.oldpwd_txt.borderColor = 0xeeccff;
			mc.newpwd_txt.borderColor = 0xeeccff;
			mc.repwd_txt.borderColor = 0xeeccff;

			addSpriteBtn(mc.ok_txt, clickOK);
			addSpriteBtn(mc.cancel_txt, clickCancel);

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

		// ----------------
		// clickCancel
		// ----------------
		private function clickCancel(e:MouseEvent):void 
		{
			this.visible = false;
		}
		
		// ----------------
		// clickOK
		// ----------------
		private var con:ResetPwdConnect = new ResetPwdConnect();
		public var resetOKFunc:Function;
		private var isNowReset:Boolean = false;
		private function clickOK(e:MouseEvent):void
		{
			var obj:Object = new Object();
			obj.name = Global.username;
			obj.oldpwd = mc.oldpwd_txt.text;
			obj.newpwd = mc.newpwd_txt.text;

			//入力チェック
			if (obj.oldpwd.length == 0)
			{
				mc.msg_txt.text = "現在のパスワードを入力してください";
				return;
			}
			if (obj.newpwd.length == 0)
			{
				mc.msg_txt.text = "新パスワードを入力してください";
				return;
			}
			if (mc.newpwd_txt.text != mc.repwd_txt.text)
			{
				mc.msg_txt.text = "新パスワードと新パスワード再入力が一致していません";
				return;
			}
			
			if (isNowReset)
			{
				mc.msg_txt.text = "変更中‥";
				return;
			}
			isNowReset = true;
			
			mc.msg_txt.text = "変更中…";
			Global.pwd = obj.newpwd;
			
			//送信
			con.connect(obj, retFunc);
		}
		private function retFunc(bool:Boolean):void
		{
			if (bool)
			{
				trace("OK");
				mc.msg_txt.text = con.message;
				
				mc.oldpwd_txt.text = "";
				mc.newpwd_txt.text = "";
				mc.repwd_txt.text = "";
			}
			else
			{
				trace("NG");
				mc.msg_txt.text = con.message;
			}
			
			isNowReset = false;
		}
		
		// ----------------
		// CAPSチェックなど
		// ----------------
		private function check_caps(event:Event):void
		{
			mc.msg2_txt.text = "";
			if (Keyboard.capsLock)
			{
				trace("Caps Lock ON");
				mc.msg2_txt.text = "CapsLock ON";
			}
			
			var ret:String = passwordWarning(Global.username, mc.newpwd_txt.text, mc.repwd_txt.text);
			mc.msg2_txt.appendText(ret);
		}
		private function passwordWarning(name:String, pwd:String, repwd:String):String
		{
			if ((pwd.length == 0) || (pwd != repwd))
			{
				return "";
			}
	
			if (pwd.length < 4)
			{
				return "【注意】パスワードは４文字以上にすることを推奨します";
			}
	
			var tmp:Array = pwd.split("");
			for ( var i:int = 1; i < pwd.length; i++ )
			{
				if ( tmp[0] != tmp[i] )
				break;
			}
			if ( i == pwd.length )
			{
				return "【注意】パスワードは推測しにくいものにすることを推奨します";
			}
	
			if ( name == pwd )
			{
				return "【注意】名前とパスワードは違うものにすることを推奨します";
			}
	
			return "";
		}

	}

}