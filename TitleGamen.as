package 
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class TitleGamen extends Sprite
	{
		public static const version:String = "20141207";

		private var mc:MovieClip;

		//public var clickNewGame:Function;
		//public var clickContinue:Function;

		public function TitleGamen(_mc:MovieClip, clickNewGame:Function, clickContinue:Function, clickDemo:Function)
		{
			mc = _mc;
			addChild(mc);

			mc.version_txt.text = "ver." + version + "-11";
			mc.version_txt.mouseEnabled = false;
			mc.title_txt.mouseEnabled = false;
			mc.newgame_txt.mouseEnabled = false;
			mc.continue_txt.mouseEnabled = false;
			mc.copyright_txt.mouseEnabled = false;

			addSpriteBtn(mc.newgame_txt, clickNewGame);
			addSpriteBtn(mc.continue_txt, clickContinue);
			addSpriteBtn(mc.demo_txt, clickContinue);

			mc.demo_txt.visible = false;
		}

		private function addSpriteBtn(tf:TextField, f:Function):void
		{
			tf.mouseEnabled = false;

			var btn:Sprite = new Sprite();
			btn.buttonMode = true;
			btn.addChild(tf);
			mc.addChild(btn);

			btn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{tf.textColor = 0xccaaee;});
			btn.addEventListener(MouseEvent.MOUSE_OUT,  function(e:MouseEvent):void{tf.textColor = 0xffffff;});

			btn.addEventListener(MouseEvent.CLICK, f);
		}

	}

}