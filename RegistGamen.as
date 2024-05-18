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

	public class RegistGamen extends Sprite
	{
		private var mc:MovieClip;

		public function RegistGamen(_mc:MovieClip, clickCancel:Function, _registOKFunc:Function)
		{
			mc = _mc;
			addChild(mc);

			mc.pwd_txt.displayAsPassword = true;
			mc.repwd_txt.displayAsPassword = true;
			mc.name_txt.maxChars = 8;
			mc.pwd_txt.maxChars = 16;
			mc.repwd_txt.maxChars = 16;
			mc.pwd_txt.restrict = "a-zA-Z0-9";
			mc.repwd_txt.restrict = "a-zA-Z0-9";
			mc.name_txt.text = "";
			mc.pwd_txt.text = "";
			mc.repwd_txt.text = "";

			mc.name_txt.backgroundColor = 0xffeeff;
			mc.pwd_txt.backgroundColor = 0xffeeff;
			mc.repwd_txt.backgroundColor = 0xffeeff;
			mc.name_txt.borderColor = 0xeeccff;
			mc.pwd_txt.borderColor = 0xeeccff;
			mc.repwd_txt.borderColor = 0xeeccff;

			addSpriteBtn(mc.ok_txt, clickOK);
			addSpriteBtn(mc.cancel_txt, clickCancel);

			registOKFunc = _registOKFunc;

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
		}
		
		// ----------------
		// clickOK
		// ----------------
		private var con:RegistConnect = new RegistConnect();
		public var registOKFunc:Function;
		private var isNowRegist:Boolean = false;
		private function clickOK(e:MouseEvent):void
		{
			mc.name_txt.text = Global.trim(mc.name_txt.text);
			
			var obj:Object = new Object();
			obj.name = mc.name_txt.text;
			obj.pwd = mc.pwd_txt.text;
			obj.repwd = mc.repwd_txt.text;
			obj.scenario = Global.scenario.lastClearIndex;
			obj.exp = Hamayumi.exp;

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
			if (obj.repwd != obj.pwd)
			{
				mc.msg_txt.text = "パスワードとパスワード再入力が一致していません";
				return;
			}
			if (Global.isUseMojiOK(obj.name) == false)
			{
				mc.msg_txt.text = "名前に使用できない文字があります。";
				return;
			}
			
			//Union PlatformのAttributeには | が設定できない。
			if (0 <= (String)(obj.name).indexOf("|"))
			{
				mc.msg_txt.text = "名前に使用できない文字があります。";
				return;
			}
			
			if (isNowRegist)
			{
				mc.msg_txt.text = "登録中‥";
				return;
			}
			isNowRegist = true;
			
			mc.msg_txt.text = "登録中…";
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
				registOKFunc();
			}
			else
			{
				trace("NG");
				mc.msg_txt.text = con.message;
			}
			
			isNowRegist = false;
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
			
			var ret:String = passwordWarning(mc.name_txt.text, mc.pwd_txt.text, mc.repwd_txt.text);
			mc.msg2_txt.appendText(ret);
		}
		private function passwordWarning(name:String, pwd:String, repwd:String):String
		{
			var i:int;

			if ((pwd.length == 0) || (pwd != repwd))
			{
				return "";
			}
	
			if (pwd.length < 4)
			{
				return "【注意】パスワードは４文字以上にすることを推奨します";
			}
	
			var tmp:Array = pwd.split("");
			for ( i = 1; i < pwd.length; i++ )
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