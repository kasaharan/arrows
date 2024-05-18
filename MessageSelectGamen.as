package 
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.ui.Keyboard;

	public class MessageSelectGamen extends Sprite
	{
		public var mc:MovieClip;

		public function MessageSelectGamen(_mc:MovieClip, clickYes:Function, clickNo:Function)
		{
			mc = _mc;
			addChild(mc);

			addSpriteBtn(mc.yes_txt, clickYes);
			addSpriteBtn(mc.no_txt, clickNo);

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

	}

}