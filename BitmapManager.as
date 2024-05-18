package 
{
	import starling.utils.deg2rad;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import flash.utils.Dictionary;

	public class BitmapManager
	{
		public static const BMPNO_TREE:int = 16;
		public static const BMPNO_FUNE:int = 17;
		public static const BMPNO_SEA:int  = 18;
		public static const BMPNO_MATO:int = 19;

		public static var normalArrowImage:Vector.<Image> = new Vector.<Image>;
		public static var hamayumiArrowImage:Vector.<Image> = new Vector.<Image>;
		public static var hamayumiArrowImageCoop:Vector.<Image> = new Vector.<Image>;
		public static var hamayumiArrowImageTame:Vector.<Image> = new Vector.<Image>;

		public static function init
		(
			 image:Vector.<Image>
			,arrowImage:Vector.<Image>
			,monsterImage:Vector.<Image>
			,textures:Vector.<Texture>
			,arrowTextures:Vector.<Texture>
			,normalArrowTextures:Vector.<Texture>
			,monsterTextureNo:Vector.<int>
			,monsterImgNo:Dictionary
		):void
		{
			var i:int;
			var idx:int;

			for (i = 0; i < textures.length; i++)
			{
				image[i] = new Image(textures[i]);
				//image[i].smoothing = TextureSmoothing.NONE;
				if (image[i].height <= 16)
				{
					image[i].scaleX = 2;
					image[i].scaleY = 2;
					image[i].smoothing = TextureSmoothing.NONE;
				}
			}
			
			image[12].pivotX = 0;
			image[12].pivotY = 0;

			//海は２倍しない
			image[18].scaleX = 1;
			image[18].scaleY = 1;
			//地面（土、草、板床、土）は２倍しない
			image[9].scaleX = 1;
			image[9].scaleY = 1;
			image[10].scaleX = 1;
			image[10].scaleY = 1;
			image[13].scaleX = 1;
			image[13].scaleY = 1;
			image[20].scaleX = 1;
			image[20].scaleY = 1;
			image[63].scaleX = 1;
			image[63].scaleY = 1;
			image[165].scaleX = 1;
			image[165].scaleY = 1;
			//岩１、２、３
			image[14].scaleX = 1;
			image[14].scaleY = 1;
			image[15].scaleX = 1;
			image[15].scaleY = 1;
			image[22].scaleX = 1;
			image[22].scaleY = 1;
			//山
			image[61].scaleX = 2;
			image[61].scaleY = 2;
			image[61].smoothing = TextureSmoothing.NONE;
			//茂み、草
			image[66].scaleX = 1;
			image[66].scaleY = 1;
			image[66].smoothing = TextureSmoothing.NONE;
			image[67].scaleX = 1;
			image[67].scaleY = 1;
			image[67].smoothing = TextureSmoothing.NONE;
			//墓石
			image[152].scaleX = 1;
			image[152].scaleY = 1;
			//数字は２倍しない
			for (i = 0; i < 10; i++)
			{
				image[71 + i].scaleX = 1;
				image[71 + i].scaleY = 1;
			}
			//矢倉防壁は２倍
			/*
			for (i = 0; i < 5; i++)
			{
				image[98 + i].scaleX = 2;
				image[98 + i].scaleY = 2;
			}
			*/
			for (i = 0; i < 6; i++)
			{
				image[143 + i].scaleX = 2;
				image[143 + i].scaleY = 2;
				image[143 + i].smoothing = TextureSmoothing.NONE;
			}
			//TIME
			image[136].scaleX = 1;
			image[136].scaleY = 1;

			//射者の回転点決定
			image[2].pivotX = 16;
			image[2].pivotY = 16;
			image[3].pivotX = 16;
			image[3].pivotY = 16;
			image[4].pivotX = 16;
			image[4].pivotY = 16;
			image[45].pivotX = 16;
			image[45].pivotY = 16;
			//左向き
			image[52].pivotX = 16;
			image[52].pivotY = 16;
			image[53].pivotX = 16;
			image[53].pivotY = 16;
			image[54].pivotX = 16;
			image[54].pivotY = 16;
			//破魔弓
			image[141].pivotX = 16;
			image[141].pivotY = 16;
			image[142].pivotX = 16;
			image[142].pivotY = 16;

			//炎
			for (i = 215; i <= 216; i++)
			{
				//image[i].scaleX = 2;
				//image[i].scaleY = 2;
				image[i].pivotX = image[i].width * 0.5;
				image[i].pivotY = image[i].height * 0.5;
				image[i].smoothing = TextureSmoothing.NONE;
			}
			
			//氷
			for (i = 223; i <= 223; i++)
			{
				image[i].pivotX = image[i].width * 0.5;
				image[i].pivotY = image[i].height * 0.5;
				image[i].smoothing = TextureSmoothing.NONE;
			}
			
			//--------
			/*
			for (i = 0; i < 360; i++)
			{
				arrowImage[i] = new Image(textures[0]);
				arrowImage[i].pivotX = 16;
				arrowImage[i].rotation = deg2rad(i);//i / 360 * (2 * Math.PI); 
			}
			*/
			for (i = 0; i < 360; i++)
			{
				//normalArrowImage[i] = new Image(textures[0]);
				normalArrowImage[i] = new Image(normalArrowTextures[0]);
				normalArrowImage[i].pivotX = 16;
				normalArrowImage[i].rotation = deg2rad(i);
			}
			for (i = 0; i < 360; i++)
			{
				//hamayumiArrowImage[i] = new Image(textures[140]);
				hamayumiArrowImage[i] = new Image(arrowTextures[0]);
				hamayumiArrowImage[i].pivotX = 16;
				hamayumiArrowImage[i].rotation = deg2rad(i); 
			}
			for (i = 0; i < 360; i++)
			{
				//hamayumiArrowImageCoop[i] = new Image(textures[167]);
				hamayumiArrowImageCoop[i] = new Image(arrowTextures[1]);
				hamayumiArrowImageCoop[i].pivotX = 16;
				hamayumiArrowImageCoop[i].rotation = deg2rad(i); 
			}
			//--------
			for (i = 0; i < 360; i++)
			{
				hamayumiArrowImageTame[i] = new Image(arrowTextures[2]);
				hamayumiArrowImageTame[i].pivotX = 16;
				hamayumiArrowImageTame[i].rotation = deg2rad(i); 
			}
			//--------
			arrowImage = normalArrowImage;

			//--------
			monsterTextureNo = Vector.<int>
			([
				8,					//みかん
				24,25,26,27,28,29,	//鹿
				30,31,32,33,34,35,	//山鳥
				19,					//与一 的
				36,37,38,39,40,41,	//武者
				5, 6,				//石
				42,43,16,			//林檎と人と木
				12,11,14,15,		//的、壁、岩１、岩２
				55,					//通し矢の的
				59,60,				//流鏑馬、的と支え
				64,65,68,118,119,	//大百足
				85,86,				//鬼火
				87,88,				//鬼
				103,104,			//鬼盾持ち
				105,				//盾
				106,107,			//土蜘蛛
				108,109,110,111,	//蜘蛛糸
				112,113,114,115,116,117,	//英胡・軽足・土熊
				120,121,122,123,124,125,	//英胡・軽足・土熊
				126,127,128,129,130,16,		//酒呑童子
				131,132,133,134,135,	//大蛇
				137,138,139,			//大蛇
				149,
				150,151,				//ゾンビ
				153,154,				//スケルトン
				155,156,
				157,158,				//スライム
				159,160,161,162,163,164,//,165,168,169,170,	//鎧のデーモン
				166,						//非表示
				170,171,172,173,			//ツリー
				174,175,176,177,178,179,180,	//ハーピー
				181,182,183,184,185,186,		//ゴーレム
				187,188,189,190,191,			//サモナー
				192,193,194,195,
				196,197,198,				//ウィル・オ・ウィスプ
				199,200,201,202,			//ロングウィットンの魔竜
				203,204,					//戦車
				205,206,207,				//戦闘機
				208,209,210,				//戦艦
				211,212,214,				//ステルス
				213,						//潜水艦
				217, 218, 219, 220,			//UFO
				221, 222,					//TREX
				224, 225, 226, 227, 228,	//プテラノドン
				229, 230, 231, 232,			//隕石
				233, 234, 235,				//報告書(ユーザー投稿)用
				236,						//妖魔弾 霊力x10
				237, 238,					//妖魔弾(ユーザー投稿)用
				239, 240, 241, 242, 243,	//ローズデーモン
				244, 245, 246,				//カメレオン
				247, 248, 249, 250, 251, 252, 253,	//天狗
				254,
				255, 256, 257					//ガル－ダ
			]);
			for (i = 0; i < monsterTextureNo.length; i++)
			{
				monsterImage[i] = new Image(textures[monsterTextureNo[i]]);
				monsterImage[i].pivotX = monsterImage[i].width / 2;// 16;
				monsterImage[i].pivotY = monsterImage[i].height / 2;// 16;
				monsterImage[i].smoothing = TextureSmoothing.NONE;
				if (monsterImage[i].height <= 16)
				{
					monsterImage[i].scaleX = 2;
					monsterImage[i].scaleY = 2;
				}
				monsterImgNo[monsterTextureNo[i]] = i;
			}
			monsterImage[monsterImgNo[55]].pivotX = 0;
			monsterImage[monsterImgNo[55]].pivotY = 0;
			//木
			monsterImage[24].pivotX = 0;
			monsterImage[24].pivotY = 0;
			monsterImage[24].scaleX = 2;
			monsterImage[24].scaleY = 2;
			//的壁
			monsterImage[monsterImgNo[11]].pivotX = 0;
			monsterImage[monsterImgNo[11]].pivotY = 0;
			monsterImage[monsterImgNo[12]].pivotX = 0;
			monsterImage[monsterImgNo[12]].pivotY = 0;
			monsterImage[monsterImgNo[11]].scaleX = 2;
			monsterImage[monsterImgNo[11]].scaleY = 2;
			//大百足
			monsterImage[monsterImgNo[64]].pivotX = 0;
			monsterImage[monsterImgNo[64]].pivotY = 0;
			monsterImage[monsterImgNo[65]].pivotX = 0;
			monsterImage[monsterImgNo[65]].pivotY = 0;
			monsterImage[monsterImgNo[64]].scaleX = 4;
			monsterImage[monsterImgNo[64]].scaleY = 4;
			monsterImage[monsterImgNo[65]].scaleX = 4;
			monsterImage[monsterImgNo[65]].scaleY = 4;
			monsterImage[monsterImgNo[118]].pivotX = 0;
			monsterImage[monsterImgNo[118]].pivotY = 0;
			monsterImage[monsterImgNo[118]].scaleX = 4;
			monsterImage[monsterImgNo[118]].scaleY = 4;
			monsterImage[monsterImgNo[119]].pivotX = 0;
			monsterImage[monsterImgNo[119]].pivotY = 0;
			monsterImage[monsterImgNo[119]].scaleX = 4;
			monsterImage[monsterImgNo[119]].scaleY = 4;
			//盾
			monsterImage[monsterImgNo[105]].pivotX = 0;
			monsterImage[monsterImgNo[105]].pivotY = 0;
			monsterImage[monsterImgNo[105]].scaleX = 2;
			monsterImage[monsterImgNo[105]].scaleY = 2;
			//土蜘蛛
			monsterImage[monsterImgNo[106]].pivotX = 0;
			monsterImage[monsterImgNo[106]].pivotY = 0;
			monsterImage[monsterImgNo[107]].pivotX = 0;
			monsterImage[monsterImgNo[107]].pivotY = 0;
			monsterImage[monsterImgNo[106]].scaleX = 4;
			monsterImage[monsterImgNo[106]].scaleY = 4;
			monsterImage[monsterImgNo[107]].scaleX = 4;
			monsterImage[monsterImgNo[107]].scaleY = 4;
			//酒呑童子
			monsterImage[monsterImgNo[126]].pivotX = 0;
			monsterImage[monsterImgNo[126]].pivotY = 0;
			monsterImage[monsterImgNo[127]].pivotX = 0;
			monsterImage[monsterImgNo[127]].pivotY = 0;
			monsterImage[monsterImgNo[128]].pivotX = 0;
			monsterImage[monsterImgNo[128]].pivotY = 0;
			monsterImage[monsterImgNo[129]].pivotX = 0;
			monsterImage[monsterImgNo[129]].pivotY = 0;
			monsterImage[monsterImgNo[126]].scaleX = 2;
			monsterImage[monsterImgNo[126]].scaleY = 2;
			monsterImage[monsterImgNo[127]].scaleX = 2;
			monsterImage[monsterImgNo[127]].scaleY = 2;
			monsterImage[monsterImgNo[128]].scaleX = 2;
			monsterImage[monsterImgNo[128]].scaleY = 2;
			monsterImage[monsterImgNo[129]].scaleX = 2;
			monsterImage[monsterImgNo[129]].scaleY = 2;
			//矢
			monsterImage[monsterImgNo[130]].pivotX = 0;
			//木
			monsterImage[monsterImgNo[16]].pivotX = 0;
			monsterImage[monsterImgNo[16]].pivotY = 0;
			monsterImage[monsterImgNo[16]].scaleX = 2;
			monsterImage[monsterImgNo[16]].scaleY = 2;
			//大蛇
			monsterImage[monsterImgNo[131]].pivotX = 0;
			monsterImage[monsterImgNo[131]].pivotY = 0;
			monsterImage[monsterImgNo[131]].scaleX = 4;
			monsterImage[monsterImgNo[131]].scaleY = 4;
			monsterImage[monsterImgNo[132]].pivotX = 0;
			monsterImage[monsterImgNo[132]].pivotY = 0;
			monsterImage[monsterImgNo[132]].scaleX = 4;
			monsterImage[monsterImgNo[132]].scaleY = 4;
			monsterImage[monsterImgNo[133]].pivotX = 0;
			monsterImage[monsterImgNo[133]].pivotY = 0;
			monsterImage[monsterImgNo[133]].scaleX = 4;
			monsterImage[monsterImgNo[133]].scaleY = 4;
			//大蛇
			monsterImage[monsterImgNo[137]].pivotX = 0;
			monsterImage[monsterImgNo[137]].pivotY = 0;
			monsterImage[monsterImgNo[137]].scaleX = 4;
			monsterImage[monsterImgNo[137]].scaleY = 4;
			monsterImage[monsterImgNo[138]].pivotX = 0;
			monsterImage[monsterImgNo[138]].pivotY = 0;
			monsterImage[monsterImgNo[138]].scaleX = 4;
			monsterImage[monsterImgNo[138]].scaleY = 4;
			monsterImage[monsterImgNo[139]].pivotX = 0;
			monsterImage[monsterImgNo[139]].pivotY = 0;
			monsterImage[monsterImgNo[139]].scaleX = 4;
			monsterImage[monsterImgNo[139]].scaleY = 4;
			//スケルトンと盾
			monsterImage[monsterImgNo[153]].pivotX = 0;
			monsterImage[monsterImgNo[153]].pivotY = 0;
			monsterImage[monsterImgNo[154]].pivotX = 0;
			monsterImage[monsterImgNo[154]].pivotY = 0;
			monsterImage[monsterImgNo[155]].pivotX = 0;
			monsterImage[monsterImgNo[155]].pivotY = 0;
			monsterImage[monsterImgNo[156]].pivotX = 0;
			monsterImage[monsterImgNo[156]].pivotY = 0;
			//鎧のデーモン
			monsterImage[monsterImgNo[159]].pivotX = 0;
			monsterImage[monsterImgNo[159]].pivotY = 0;
			monsterImage[monsterImgNo[160]].pivotX = 0;
			monsterImage[monsterImgNo[160]].pivotY = 0;
			monsterImage[monsterImgNo[159]].scaleX = 4;
			monsterImage[monsterImgNo[159]].scaleY = 4;
			monsterImage[monsterImgNo[160]].scaleX = 4;
			monsterImage[monsterImgNo[160]].scaleY = 4;
			idx = 161;
			monsterImage[monsterImgNo[idx]].pivotX = 0;
			monsterImage[monsterImgNo[idx]].pivotY = 0;
			monsterImage[monsterImgNo[idx]].scaleX = 4;
			monsterImage[monsterImgNo[idx]].scaleY = 4;
			idx = 162;
			monsterImage[monsterImgNo[idx]].pivotX = 0;
			monsterImage[monsterImgNo[idx]].pivotY = 0;
			monsterImage[monsterImgNo[idx]].scaleX = 4;
			monsterImage[monsterImgNo[idx]].scaleY = 4;
			idx = 163;
			monsterImage[monsterImgNo[idx]].pivotX = 0;
			monsterImage[monsterImgNo[idx]].pivotY = 0;
			monsterImage[monsterImgNo[idx]].scaleX = 4;
			monsterImage[monsterImgNo[idx]].scaleY = 4;
			idx = 164;
			monsterImage[monsterImgNo[idx]].pivotX = 0;
			monsterImage[monsterImgNo[idx]].pivotY = 0;
			monsterImage[monsterImgNo[idx]].scaleX = 4;
			monsterImage[monsterImgNo[idx]].scaleY = 4;
			idx = 170;
			monsterImage[monsterImgNo[idx]].pivotX = 0;
			monsterImage[monsterImgNo[idx]].pivotY = 0;
			monsterImage[monsterImgNo[idx]].scaleX = 3;
			monsterImage[monsterImgNo[idx]].scaleY = 3;
			idx = 173;
			monsterImage[monsterImgNo[idx]].pivotX = 0;
			monsterImage[monsterImgNo[idx]].pivotY = 0;
			monsterImage[monsterImgNo[idx]].scaleX = 3;
			monsterImage[monsterImgNo[idx]].scaleY = 3;

			for (idx = 181; idx <= 186; idx++)
			{
				monsterImage[monsterImgNo[idx]].pivotX = 0;
				monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].scaleX = 2;
				monsterImage[monsterImgNo[idx]].scaleY = 2;
			}

			for (idx = 187; idx <= 191; idx++)
			{
				monsterImage[monsterImgNo[idx]].pivotX = 0;
				monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].scaleX = 2;
				monsterImage[monsterImgNo[idx]].scaleY = 2;
			}

			for (idx = 196; idx <= 198; idx++)
			{
				monsterImage[monsterImgNo[idx]].pivotX = monsterImage[monsterImgNo[idx]].width / 2;
				monsterImage[monsterImgNo[idx]].pivotY = monsterImage[monsterImgNo[idx]].height / 2;
				monsterImage[monsterImgNo[idx]].scaleX = 4;
				monsterImage[monsterImgNo[idx]].scaleY = 4;
			}
			
			idx = 199
			monsterImage[monsterImgNo[idx]].pivotX = 0;
			monsterImage[monsterImgNo[idx]].pivotY = 0;
			monsterImage[monsterImgNo[idx]].scaleX = 4;
			monsterImage[monsterImgNo[idx]].scaleY = 4;
			idx = 202
			monsterImage[monsterImgNo[idx]].pivotX = 0;
			monsterImage[monsterImgNo[idx]].pivotY = 0;
			monsterImage[monsterImgNo[idx]].scaleX = 4;
			monsterImage[monsterImgNo[idx]].scaleY = 4;

			for (idx = 200; idx <= 201; idx++)
			{
				monsterImage[monsterImgNo[idx]].pivotX = 0;
				monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].scaleX = 2;
				monsterImage[monsterImgNo[idx]].scaleY = 2;
			}

			for (idx = 203; idx <= 204; idx++)
			{
				//monsterImage[monsterImgNo[idx]].pivotX = 0;
				//monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].scaleX = 2;
				monsterImage[monsterImgNo[idx]].scaleY = 2;
			}

			/*
			for (idx = 205; idx <= 207; idx++)
			{
				//monsterImage[monsterImgNo[idx]].pivotX = 0;
				//monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].scaleX = 2;
				monsterImage[monsterImgNo[idx]].scaleY = 2;
			}
			*/
			for (idx = 205; idx <= 207; idx++)
			{
				monsterImage[monsterImgNo[idx]].pivotX = 0;
				monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].scaleX = 2;
				monsterImage[monsterImgNo[idx]].scaleY = 2;
			}

			for (idx = 208; idx <= 210; idx++)
			{
				monsterImage[monsterImgNo[idx]].pivotX = 0;
				monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].scaleX = 4;
				monsterImage[monsterImgNo[idx]].scaleY = 4;
			}

			for (idx = 211; idx <= 214; idx++)
			{
				monsterImage[monsterImgNo[idx]].pivotX = 0;
				monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].scaleX = 4;
				monsterImage[monsterImgNo[idx]].scaleY = 4;
			}

			for (idx = 217; idx <= 217; idx++)
			{
				monsterImage[monsterImgNo[idx]].pivotX = 0;
				monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].scaleX = 2;
				monsterImage[monsterImgNo[idx]].scaleY = 2;
			}
			for (idx = 218; idx <= 218; idx++)
			{
				monsterImage[monsterImgNo[idx]].scaleX = 2;
				monsterImage[monsterImgNo[idx]].scaleY = 2;
				monsterImage[monsterImgNo[idx]].pivotX = monsterImage[monsterImgNo[idx]].width / 2;
				monsterImage[monsterImgNo[idx]].pivotY = monsterImage[monsterImgNo[idx]].height / 2;
			}

			for (idx = 221; idx <= 222; idx++)
			{
				monsterImage[monsterImgNo[idx]].pivotX = 0;
				monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].scaleX = 4;
				monsterImage[monsterImgNo[idx]].scaleY = 4;
			}

			for (idx = 224; idx <= 226; idx++)
			{
				monsterImage[monsterImgNo[idx]].pivotX = 0;
				monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].scaleX = 3;
				monsterImage[monsterImgNo[idx]].scaleY = 3;
			}

			for (idx = 227; idx <= 228; idx++)
			{
				//monsterImage[monsterImgNo[idx]].pivotX = 0;
				//monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].pivotY = monsterImage[monsterImgNo[idx]].height / 2 + 2;
				monsterImage[monsterImgNo[idx]].scaleX = 2;
				monsterImage[monsterImgNo[idx]].scaleY = 2;
			}
			
			for (idx = 231; idx <= 232; idx++)
			{
				monsterImage[monsterImgNo[idx]].pivotX = 0;
				monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].scaleX = 3;
				monsterImage[monsterImgNo[idx]].scaleY = 3;
			}
/*
			for (idx = 239; idx <= 247; idx++)
			{
				monsterImage[monsterImgNo[idx]].pivotX = 0;
				monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].scaleX = 3;
				monsterImage[monsterImgNo[idx]].scaleY = 3;
			}
			for (idx = 248; idx <= 248; idx++)
			{
				monsterImage[monsterImgNo[idx]].pivotX = 0;
				monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].scaleX = 3;
				monsterImage[monsterImgNo[idx]].scaleY = 3;
			}
*/
			for (idx = 239; idx <= 239; idx++)
			{
				monsterImage[monsterImgNo[idx]].scaleX = 4;
				monsterImage[monsterImgNo[idx]].scaleY = 4;
			}
			for (idx = 240; idx <= 240; idx++)
			{
				monsterImage[monsterImgNo[idx]].pivotX = 0;
				monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].scaleX = 4;
				monsterImage[monsterImgNo[idx]].scaleY = 4;
			}
			for (idx = 241; idx <= 241; idx++)
			{
				monsterImage[monsterImgNo[idx]].scaleX = 2;
				monsterImage[monsterImgNo[idx]].scaleY = 2;
			}
			for (idx = 243; idx <= 243; idx++)
			{
				monsterImage[monsterImgNo[idx]].pivotX = 0;
				monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].scaleX = 4;
				monsterImage[monsterImgNo[idx]].scaleY = 4;
			}
			
			for (idx = 244; idx <= 245; idx++)
			{
				monsterImage[monsterImgNo[idx]].pivotX = 0;
				monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].scaleX = 2;
				monsterImage[monsterImgNo[idx]].scaleY = 2;
			}

			for (idx = 247; idx <= 252; idx++)
			{
				monsterImage[monsterImgNo[idx]].pivotX = 0;
				monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].scaleX = 4;
				monsterImage[monsterImgNo[idx]].scaleY = 4;
			}
			idx = 253;
			monsterImage[monsterImgNo[idx]].scaleX = 4;
			monsterImage[monsterImgNo[idx]].scaleY = 4;

			for (idx = 254; idx <= 257; idx++)
			{
				monsterImage[monsterImgNo[idx]].pivotX = 0;
				monsterImage[monsterImgNo[idx]].pivotY = 0;
				monsterImage[monsterImgNo[idx]].scaleX = 4;
				monsterImage[monsterImgNo[idx]].scaleY = 4;
			}

			//--------
			_monsterImgNo = monsterImgNo;
			_monsterImage = monsterImage;
		}

		public static var _monsterImgNo:Dictionary;
		public static var _monsterImage:Vector.<Image>;


/*
		public static function setNormalYumi(arrowImage:Vector.<Image>)
		{
			arrowImage = normalArrowImage;
		}
		public static function setHamayumi(arrowImage:Vector.<Image>)
		{
			arrowImage = hamayumiArrowImage;
		}
*/

	}

}