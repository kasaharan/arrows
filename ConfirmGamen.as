package 
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class ConfirmGamen extends Sprite
	{
		private var mc:MovieClip;

		//public var _clickYes:Function = function(e:MouseEvent){trace("#####");};

		public function ConfirmGamen(_mc:MovieClip, clickYes:Function)
		{
			mc = _mc;
			addChild(mc);

			addSpriteBtn(mc.yes_txt, clickYes);
			addSpriteBtn(mc.no_txt, clickNo);
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
			tf.backgroundColor = 0x664477;
			tf.mouseEnabled = false;

			btn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{tf.backgroundColor = 0x9977bb;});
			btn.addEventListener(MouseEvent.MOUSE_OUT,  function(e:MouseEvent):void{tf.backgroundColor = 0x664477;});
			btn.addEventListener(MouseEvent.CLICK, f);
		}

		public function setYesText(str:String):void
		{
			mc.yes_txt.text = str;
		}
		public function setNoText(str:String):void
		{
			mc.no_txt.text = str;
		}
/*
		// ----------------
		// clickNo
		// ----------------
		private function clickYes(e:MouseEvent)
		{
			_clickYes();
		}
*/
		// ----------------
		// clickNo
		// ----------------
		private function clickNo(e:MouseEvent):void
		{
			this.visible = false;
		}

		// ----------------
		// setMessage
		// ----------------
		public function setMessage(msg:String):void
		{
			mc.msg_txt.text = msg;
		}

	}

}