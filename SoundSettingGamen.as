package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author kasaharan
	 */
	public class SoundSettingGamen extends Sprite
	{
		private var mc:MovieClip = new SoundSettingMC();
		
		public var isBGM:Boolean = false;
		public var isSE:Boolean = false;
		
		public function SoundSettingGamen() 
		{
			addChild(mc);
			
			addSpriteBtn(mc.onoff01_txt, clickBGM);
			addSpriteBtn(mc.onoff02_txt, clickSE);
			addSpriteBtn(mc.close_txt, clickClose);
			
			showOnOff();
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
		
		private function showOnOff():void
		{
			if (isBGM)
			{
				mc.onoff01_txt.text = "○";
			}
			else
			{
				mc.onoff01_txt.text = "";
			}
			
			if (isSE)
			{
				mc.onoff02_txt.text = "○";
			}
			else
			{
				mc.onoff02_txt.text = "";
			}
		}
		
		private function clickBGM(e:MouseEvent):void
		{
			isBGM = !isBGM;
			showOnOff();
			
			if (isBGM)
			{
				Global.volumeBGM = 1.0;
				Global.playBGM();
			}
			else
			{
				Global.volumeBGM = 0.0;
				Global.stopBGM();
			}
		}
		private function clickSE(e:MouseEvent):void
		{
			isSE = !isSE;
			showOnOff();
			
			if (isSE)
			{
				Global.volumeSE = 1.0;
				Global.playShu();
			}
			else
			{
				Global.volumeSE = 0.0;
			}
		}
		private function clickClose(e:MouseEvent):void
		{
			this.visible = false;
		}
	}

}