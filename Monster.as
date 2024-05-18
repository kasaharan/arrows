package 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import starling.display.Image;

	public class Monster
	{
		public static const COUNT:int = 64;
		
		public static const DIR_LEFT:int = 0;
		public static const DIR_RIGHT:int = 1;
		public static const VDIR_TOP:int = 0;
		public static const VDIR_DOWN:int = 1;

		public var x:Number;
		public var y:Number;
		public var dir:int;
		public var vdir:int;
		public var isNowMove:Boolean;
		public var imgNo:int;
		public var hp:int;
		public var moveValX:Number;
		public var moveValY:Number;
		public var turnRate:int;
		public var vanishCnt:int;
		public var hitRange:int;
		public var hitRect:Rectangle = new Rectangle();
		
		//中心指定の円当たり判定
		public var hitRange2:int;
		public var hitRange2X:int;
		public var hitRange2Y:int;
		public var isNoDamage:Boolean = false;
		
		public var isEnemy:Boolean;
		public var enableBreak:Boolean;
		
		public var isNGHit:Boolean;
		public var isBmpHit:Boolean;	
		public var isReflect:Boolean;
		public var isDieFall:Boolean;
		public var isVanish:Boolean;

		public var hontaiIdx:int;
		
		public var v:Number = 0.0;
		public var maxV:Number = 0.0;
		
		public var phase:int = 0;
		
		//報告書用
		//public var dotWidth:int = 0;
		//public var dotHeight:int = 0;
		
		//動きのパターン
		public static const MOVE_NONE:int = 0;
		public static const MOVE_NORMAL:int = 1;	//設定値による移動
		public static const MOVE_RU2LD:int = 3;		//右上から来て左下STOP
		public static const MOVE_FALL:int = 4;		//落下あり
		public static const MOVE_LEFT_STOP:int = 5;	//右から左に来て停止
		public static const MOVE_DOWN_STOP:int = 6;	//上から降ってきて停止
		public static const MOVE_LEFT_VANISH:int = 7;//右から左に来て消滅
		public static const MOVE_DOWN_VANISH:int = 8;//上から降ってきて消滅
		public static const MOVE_LEFT_STOP_CHANGE:int = 9;	//右から左に来て停止、画像切替
		public static const MOVE_JUMPPING:int = 10;	//ジャンピング
		public static const MOVE_FALL2:int = 11;	//落下あり2
		public static const MOVE_ARMOR:int = 12;	//
		public static const MOVE_TAN2:int = 13;		//
		public static const MOVE_NORMAL_FROM_RANGE:int = 14;	//画面内に入るまで止まらず移動。入ったらNORMALに切り替える
		public static const MOVE_FALL3:int = 15;
		public static const MOVE_ROTATION:int = 16;
		public static const MOVE_LEFT_STOP_CHANGE2:int = 17;	//右から左に来て停止。指定時間内は画像を変える
		public static const MOVE_TANK:int = 18;					//右から左に来て停止。重力あり
		public static const MOVE_LEFT_STOP_TURN:int = 19;		//端まで行ったら方向転換
		public static const MOVE_STEALTH:int = 20;
		public static const MOVE_SUBMARINE:int = 21;
		public static const MOVE_FALL_AUTO:int = 22;
		public static const MOVE_FALL2B:int = 23;
		public static const MOVE_TAN2WAVE:int = 24;
		//public static const MOVE_TSUMIKI:int = 24;					//右から左に来て停止。重力あり
		//public static const MOVE_KOUSHIN:int = 26;					//右から左に来て停止。左に詰める
		public static const MOVE_CHAMAELEON:int = 25;
		public static const MOVE_TENGU:int = 26;
		public static const MOVE_UCHIWA:int = 27;
		//public static const MOVE_TAN2XY:int = 28;
		public static const MOVE_GARUDA:int = 28;
		
		public var movePattern:int = MOVE_NONE;
		public var moveInterval:int = -1;			//秒間 24/moveCnt 回動く
		

		//移動範囲
		public var minX:int;
		public var maxX:int;
		public var minY:int;
		public var maxY:int;
		
		//設定画像番号
		public var imgNoWalkLeft1:int;
		public var imgNoWalkRight1:int;
		public var imgNoWalkLeft2:int;
		public var imgNoWalkRight2:int;
		public var imgNoDeadLeft:int;
		public var imgNoDeadRight:int;
		public var imgChangeInterval:int;
		//設定画像番号phase2
		//public var isPhase2Image:Boolean;
		public var imgNoWalkLeft3:int;
		public var imgNoWalkRight3:int;
		public var imgNoWalkLeft4:int;
		public var imgNoWalkRight4:int;
		public var imgChangeInterval2:int;
		
		//
		public var imgPatternCnt:int = 2;
		public var imgNoWalkLeft5:int;
		public var imgNoWalkRight5:int;
		
		//攻撃用
		public var isMissile:Boolean;
		public var missileX:int;
		public var missileY:int;
		public var missilePlusX:int;
		public var missilePlusY:int;
		public var missileHP:int;
		public var power:Number;
		public var fallValue:Number;
		public var missilePower:Number;
		public var isHitEachOther:Boolean;		//お互いの当たり判定があるか
		public var isShootSound:Boolean;		//射出音はあるか

		public var startShootFrameCnt:int;	//発射時間
		public var shootInterval:int;		//発射間隔
		
		public var shooterIdx:int;			//発射モンスターindex
		public var bodyIdx:int;				//本体モンスターindex
		
		//public var shootStart:Boolean;	//発射指示
		//public var dieKanseiX:Number;		//矢が当たって後ろに飛ぶ制御用

		//狙い攻撃
		public var moveVal:Number;
		public var r:Number;
		public var atan2X:Number;
		public var atan2Y:Number;
		
		public var isUnbreakableMissile:Boolean;
		
		//
		public var isNoCount:Boolean = false;
		
		public var maxHP:int = 0;
		public var showHPx:int = 0;
		public var showHPy:int = 0;
		

		public function Monster()
		{
			// constructor code
			
			initMoveFunc();
		}

		public function resetMissile(m:Vector.<Monster>):void
		{
			/*
			this.x = missileX;
			this.y = missileY;
			this.hp = missileHP;
			this.power = missilePower;
			*/
			if (m == null)
			{
				
			}
			else if (0 <= this.shooterIdx)
			{
				//if (this.hp <= 0)
				{
					this.x = m[this.shooterIdx].x + missilePlusX;
					this.y = m[this.shooterIdx].y + missilePlusY;
					this.hp = missileHP;
					this.power = missilePower;
this.phase = 0;
				}
			}
		}

		// ----------------
		// move
		// ----------------
		private var moveFunc:Dictionary = new Dictionary();
		public function initMoveFunc():void
		{
			moveFunc[MOVE_LEFT_STOP] = moveLeftStop;
			moveFunc[MOVE_DOWN_STOP] = moveDownStop;
			moveFunc[MOVE_LEFT_VANISH] = moveLeftVanish;
			moveFunc[MOVE_DOWN_VANISH] = moveDownVanish;
			moveFunc[MOVE_LEFT_STOP_CHANGE] = moveLeftStopChange;
			moveFunc[MOVE_JUMPPING] = moveJumpping;
			moveFunc[MOVE_ARMOR] = moveArmor;
			moveFunc[MOVE_TAN2] = moveAtan2;
			moveFunc[MOVE_NORMAL_FROM_RANGE] = moveNormalFromRange;
			moveFunc[MOVE_FALL3] = moveFall3;
			moveFunc[MOVE_ROTATION] = moveRotation;
			moveFunc[MOVE_LEFT_STOP_CHANGE2] = moveLeftStopChange2;
			moveFunc[MOVE_TANK] = moveTank;
			moveFunc[MOVE_LEFT_STOP_TURN] = moveLeftStopTurn;
			moveFunc[MOVE_STEALTH] = moveStealth;
			moveFunc[MOVE_SUBMARINE] = moveSubMarine;
			moveFunc[MOVE_FALL_AUTO] = moveFallAuto;
			moveFunc[MOVE_FALL2B] = moveFall2B;
			moveFunc[MOVE_TAN2WAVE] = moveAtan2Wave;
			//moveFunc[MOVE_TSUMIKI] = moveTsumiki;
			moveFunc[MOVE_RU2LD] = moveRU2LD;
			moveFunc[MOVE_CHAMAELEON] = moveChamaeleon;
			moveFunc[MOVE_TENGU] = moveTengu;
			moveFunc[MOVE_UCHIWA] = moveUchiwa;
			//moveFunc[MOVE_TAN2XY] = moveAtan2XY;
			moveFunc[MOVE_GARUDA] = moveGaruda;
		}

		// ----------------
		// move
		// ----------------
		public function move():void
		{
			moveFunc[movePattern]();
		}
		
		// ----------------
		// moveLeftStop
		// ----------------
		public function moveLeftStop():void
		{
			if (this.minX < this.x)
			{
				this.x += this.moveValX;
			}
		}

		// ----------------
		// moveDownStop
		// ----------------
		public function moveDownStop():void
		{
			if (this.y < this.maxY)
			{
				this.y += this.moveValY;
			}
		}

		// ----------------
		// moveRU2LD
		//右上から来て左下STOP
		// ----------------
		public function moveRU2LD():void
		{
			if (this.minX < this.x)
			{
				this.x += this.moveValX;
			}
			
			if (this.y < this.minY)
			{
				this.y += this.moveValY;
			}
		}
		
		// ----------------
		// moveLeftVanish
		// ----------------
		public function moveLeftVanish():void
		{
			if (this.minX < this.x)
			{
				this.x += this.moveValX;
			}
			else
			{
				this.hp = 0;
			}
		}

		// ----------------
		// moveDownVanish
		// ----------------
		public function moveDownVanish():void
		{
			if (this.y < this.maxY)
			{
				this.y += this.moveValY;
			}
			else
			{
				this.hp = 0;
			}
		}
		
		// ----------------
		// moveLeftStopChange
		// ----------------
		public function moveLeftStopChange():void
		{
			if (this.minX < this.x)
			{
				this.x += this.moveValX;
			}
			else
			{
				imgNoWalkLeft1 = imgNoWalkLeft3;
				imgNoWalkRight1 = imgNoWalkRight3;
				imgNoWalkLeft2 = imgNoWalkLeft4;
				imgNoWalkRight2 = imgNoWalkRight4;
				imgChangeInterval = imgChangeInterval2;
			}
		}
		// ----------------
		// moveLeftStopChange2
		// ----------------
		public function moveLeftStopChange2():void
		{
			monsterImgNo = BitmapManager._monsterImgNo;

			if (this.minX < this.x)
			{
				this.x += this.moveValX;
			}
			
			var sec:int = moveCnt / Global.FPS;
			var sec1:int = (sec - 10) % 30;
			var sec2:int = (sec - 15) % 30;
			
			if ((2 <= sec1) && (sec1 <= 5))
			{
				imgNoWalkLeft1 = monsterImgNo[198];
				imgNoWalkLeft2 = monsterImgNo[198];
			}
			else if ((2 <= sec2) && (sec2 <= 5))
			{
				imgNoWalkLeft1 = monsterImgNo[198];
				imgNoWalkLeft2 = monsterImgNo[198];
			}
			else
			{
				imgNoWalkLeft1 = monsterImgNo[196];
				imgNoWalkLeft2 = monsterImgNo[197];
			}
			
			moveCnt++;
		}

		// ----------------
		// moveJumpping
		// ----------------
		public function moveJumpping():void
		{
			y += v;
			if (maxY <= y)
			{
				if (phase == 1)
				{
					y = maxY;
					v = maxV;
				}
				else
				{
					y += moveValY;
				}
			}
			else
			{
				phase = 1;
				v += 0.1;
			}
			x -= moveValX;
		}

		// ----------------
		// moveArmor
		// ----------------
public var moveCnt:int = 0;
private static var monsterImgNo:Dictionary;
private static var monsterImage:Vector.<Image>;
		public function moveArmor():void
		{
			var interval:int = Global.FPS * 5;

			monsterImgNo = BitmapManager._monsterImgNo;

			if (this.minX < this.x)
			{
				this.x += this.moveValX;

				imgNoWalkLeft1 = monsterImgNo[159];
				imgNoWalkLeft2 = monsterImgNo[160];
				imgNoDeadLeft = monsterImgNo[159];
			}
			else
			{
				var idx:int = 161;
				var animationNo:int = (moveCnt % (3 * interval)) / interval;

				if (animationNo == 1)
				{
					idx = 161;
				}
				else if (animationNo == 2)
				{
					idx = 162;
				}
				else if (animationNo == 0)
				{
					idx = 163;
				}
				imgNoWalkLeft1 = monsterImgNo[idx];
				imgNoWalkLeft2 = monsterImgNo[idx];
				imgNoDeadLeft = monsterImgNo[idx];
			}
			
			moveCnt++;
		}

		// ----------------
		// moveAtan2
		// ----------------
		public function moveAtan2():void
		{
			if (phase == 0)
			{
				this.x = Global.monster[this.shooterIdx].x + this.missilePlusX;
				this.y = Global.monster[this.shooterIdx].y + this.missilePlusY;
				this.r = Math.atan2(448 - 32 - this.y, this.x - 32) + Math.PI;
			}
			phase = 1;
			this.x += moveVal * Math.cos(this.r);
			this.y += -1.0 * moveVal * Math.sin(this.r);
		}

		// ----------------
		// moveAtan2Wave
		// ----------------
		private var waveCnt:int = 0;
		//private var waveValue:Vector.<int> = Vector.<int>([-4,-3,-2,-1,0,1,2,3,4,5,4,3,2,1,0,-1,-2,-3,-4,-5]);
		public function moveAtan2Wave():void
		{
			if (phase == 0)
			{
				this.x = Global.monster[this.shooterIdx].x + this.missilePlusX;
				this.y = Global.monster[this.shooterIdx].y + this.missilePlusY;
				this.r = Math.atan2(448 - 32 - this.y, this.x - 32) + Math.PI;
				waveCnt = 0;// 24;
			}
			phase = 1;
			this.x += moveVal * Math.cos(this.r);
			this.y += -1.0 * moveVal * Math.sin(this.r)
			
			if (waveCnt < 24)
			{
				//this.y += (24 - waveCnt) / 6;
				this.y += -4 + waveCnt / 3;
			}
			else
			{
				//this.y -= (48 - waveCnt) / 6;
				this.y += 4 + (24 - waveCnt) / 3;
			}
			
			
			//this.y += waveValue[waveCnt];
			//waveCnt = (waveCnt + 1) % waveValue.length;
			waveCnt = (waveCnt + 1) % 48;
		}

		// ----------------
		// moveFall2B
		// ----------------
		public function moveFall2B():void
		{
			if (this.phase == 0)
			{
				calcAutoDistance();
				
				//半分の位置で地面に着くよう計算
				this.moveValX = this.moveValX * 0.5;
				
				this.phase = 1;
			}
			else
			{
				if (this.isNowMove)
				{
					if (this.minX < this.x)
					{
						this.x -= this.moveValX;
					}
					if (this.y < this.maxY)
					{
						this.y += this.power;
						this.power += this.fallValue;
					}
				}
			}
		}
		private function calcAutoDistance():void
		{
			this.x = Global.monster[this.shooterIdx].x + this.missilePlusX;
			this.y = Global.monster[this.shooterIdx].y + this.missilePlusY;
			
			//地面に落下するまでのフレーム数を取得
			var i:int;
			var cnt:int = 0;
			//var tmpX:int = this.x;
			var tmpY:int = this.y;
			var tmpPower:Number = this.power;
			for (i = 0; i < Global.FPS * 10; i++ )
			{
				cnt++;
				//tmpX -= this.moveValX;
				tmpY += tmpPower;
				tmpPower += this.fallValue;
				if (480 - 32 <= tmpY)
				{
					break;
				}
			}
			//矢倉に当たるようX調整
			this.moveValX = (this.x - 32) / cnt;
		}
		
		// ----------------
		// moveFall3
		// ----------------
		public function moveFall3():void
		{
			/*
			if (0 <= this.power)
			{
				if (phase == 0)
				{
					//this.x = Global.monster[this.shooterIdx].x;
					//this.y = Global.monster[this.shooterIdx].y;
					this.r = Math.atan2(448-32 - this.y, this.x - 32) + Math.PI;
				}
				phase = 1;
				this.x += moveVal * Math.cos(this.r);
				this.y += -1.0 * moveVal * Math.sin(this.r);
			}
			else
			{
				if (this.minX < this.x)
				{
					this.x -= this.moveValX;
				}
			
				this.y += this.power;
				this.power += this.fallValue;
			}
			*/
			
			if (this.power < 0)
			{
				if ((this.minX < this.x) && (this.y < this.maxY))
				{
					this.x -= this.moveValX;
					this.y += this.power;
					this.power += this.fallValue;
				}
			}
			else
			{
				if (phase == 0)
				{
					//this.x = Global.monster[this.shooterIdx].x + this.missilePlusX;
					//this.y = Global.monster[this.shooterIdx].y + this.missilePlusY;
					this.r = Math.atan2(448-32 - this.y, this.x - 32) + Math.PI;
				}
				phase = 1;
				this.x += moveVal * Math.cos(this.r);
				this.y += -1.0 * moveVal * Math.sin(this.r);
			}
		}

		// ----------------
		// moveRotation
		// ----------------
		public function moveRotation():void
		{
			if (this.phase == 0)
			{
				this.x = Global.monster[this.shooterIdx].x;
				this.y = Global.monster[this.shooterIdx].y;
				this.r = Math.PI;
				this.hp = missileHP;
				//this.power = missilePower;
				this.phase = 1;
			}
			this.x = Global.monster[this.shooterIdx].x + this.missilePlusX + Math.cos(this.r) * this.moveVal;
			this.y = Global.monster[this.shooterIdx].y + this.missilePlusY - Math.sin(this.r) * this.moveVal;
			this.r += Math.PI * 0.05;
		}

		// ----------------
		// moveNormalInRange
		// ----------------
		public function moveNormalFromRange():void
		{
			if (this.dir == Monster.DIR_LEFT)
			{
				if (this.minX < this.x)
				{
					this.x -= this.moveValX;
				}
			}
			else if (this.dir == Monster.DIR_RIGHT)
			{
				if (this.x < this.maxX)
				{
					this.x += this.moveValX;
				}
			}

			if (this.vdir == Monster.VDIR_TOP)
			{
				if (this.minY < this.y)
				{
					this.y -= this.moveValY;
				}
			}
			else if (this.dir == Monster.VDIR_DOWN)
			{
				if (this.y < this.maxY)
				{
					this.y += this.moveValY;
				}
			}

			//範囲内に入ったら通常移動に変更
			if ((minX <= this.x) && (this.x <= maxX))
			{
				if ((minY <= this.y) && (this.y <= maxY))
				{
					this.movePattern = MOVE_NORMAL;
				}
			}			
		}

		// ----------------
		// moveTank
		// ----------------
		public function moveTank():void
		{
			var i:int;
			var d:int;
			var isFall:Boolean = true;
			var m:Vector.<Monster> = Global.monster;

			if (this.minX < this.x)
			{
				this.x += this.moveValX;
			}

			for (i = 0; i < m.length; i++)
			{
				if (this == m[i])
				{
					continue;
				}
				if (m[i].hp <= 0)
				{
					continue;
				}
				if (this.y < m[i].y)
				{
					d = (this.x - m[i].x) * (this.x - m[i].x) + (this.y - m[i].y) * (this.y - m[i].y);
					if (d <= 54 * 54)
					{
						isFall = false;
						break;
					}
				}
			}
			if (this.y < this.maxY)
			{
				if (isFall)
				{
					this.y++;
				}
			}

		}
/*
		// ----------------
		// moveTsumiki(moveTank2)
		// ----------------
		public function moveTsumiki():void
		{
			var i:int;
			var d:int;
			var isFall:Boolean = true;
			var m:Vector.<Monster> = Global.monster;

			if (this.minX < this.x)
			{
				this.x += this.moveValX;
			}

			for (i = 0; i < m.length; i++)
			{
				if (this == m[i])
				{
					continue;
				}
				if (m[i].hp <= 0)
				{
					continue;
				}
				if (this.y < m[i].y)
				{
					d = (this.x - m[i].x) * (this.x - m[i].x) + (this.y - m[i].y) * (this.y - m[i].y);
					if (d <= m[i].dotHeight * m[i].dotHeight)
					{
						isFall = false;
						break;
					}
				}
			}
			if (this.y < this.maxY)
			{
				if (isFall)
				{
					this.y++;
				}
			}
		}
*/
		// ----------------
		// moveLeftStopTurn
		// ----------------
		public function moveLeftStopTurn():void
		{
			if (this.dir == Monster.DIR_LEFT)
			{
				if (this.minX < this.x)
				{
					this.x -= this.moveValX;
				}
				else
				{
					this.dir = Monster.DIR_RIGHT
				}
			}
			else if (this.dir == Monster.DIR_RIGHT)
			{
				if (this.x < this.maxX)
				{
					this.x += this.moveValX;
				}
				else
				{
					this.dir = Monster.DIR_LEFT
				}
			}
			/*
			if (this.vdir == Monster.VDIR_TOP)
			{
				if (this.minY < this.y)
				{
					this.y -= this.moveValY;
				}
			}
			else if (this.dir == Monster.VDIR_DOWN)
			{
				if (this.y < this.maxY)
				{
					this.y += this.moveValY;
				}
			}
			*/
		}

		// ----------------
		// moveStealth
		// ----------------
		public function moveStealth():void
		{
			if (moveCnt % (Global.FPS * 10) == 0)
			{
				monsterImgNo = BitmapManager._monsterImgNo;

				imgNoWalkLeft1 = monsterImgNo[211];
				imgNoWalkLeft2 = monsterImgNo[211];
				imgNoWalkRight1 = monsterImgNo[214];
				imgNoWalkRight2 = monsterImgNo[214];
			}
			else if (moveCnt % (Global.FPS * 5) == 0)
			{
				//姿消す
				monsterImgNo = BitmapManager._monsterImgNo;

				imgNoWalkLeft1 = monsterImgNo[212];
				imgNoWalkLeft2 = monsterImgNo[212];
				imgNoWalkRight1 = monsterImgNo[212];
				imgNoWalkRight2 = monsterImgNo[212];
			}
			
			if (this.dir == Monster.DIR_LEFT)
			{
				if (this.minX < this.x)
				{
					this.x -= this.moveValX;
				}
				else
				{
					this.dir = Monster.DIR_RIGHT
				}
			}
			else if (this.dir == Monster.DIR_RIGHT)
			{
				if (this.x < this.maxX)
				{
					this.x += this.moveValX;
				}
				else
				{
					this.dir = Monster.DIR_LEFT
				}
			}
			
			moveCnt++;
		}
		
		// ----------------
		// moveSubMarine
		// ----------------
		public function moveSubMarine():void
		{
			moveCnt--;
			if (0 < moveCnt)
			{
				return;
			}
			
			if (this.vdir == Monster.VDIR_TOP)
			{
				if (this.minY < this.y)
				{
					this.y -= this.moveValY;
				}
				else
				{
					this.vdir = Monster.VDIR_DOWN;
					moveCnt = Global.FPS * 5;
				}
			}
			else if (this.vdir == Monster.VDIR_DOWN)
			{
				if (this.y < this.maxY)
				{
					this.y += this.moveValY;
				}
				else
				{
					this.vdir = Monster.VDIR_TOP;
					moveCnt = Global.FPS * 5;
				}
			}
		}

		// ----------------
		// fallAuto
		// ----------------
		private function moveFallAuto():void
		{
			if (this.phase == 0)
			{
				this.x = Global.monster[this.shooterIdx].x + this.missilePlusX;
				this.y = Global.monster[this.shooterIdx].y + this.missilePlusY;
				
				//地面に落下するまでのフレーム数を取得
				var i:int;
				var cnt:int = 0;
				//var tmpX:int = this.x;
				var tmpY:int = this.y;
				var tmpPower:Number = this.power;
				for (i = 0; i < Global.FPS * 10; i++ )
				{
					cnt++;
					//tmpX -= this.moveValX;
					tmpY += tmpPower;
					tmpPower += this.fallValue;
					if (480 - 32 <= tmpY)
					{
						break;
					}
				}
				//矢倉に当たるようX調整
				this.moveValX = (this.x - 32) / cnt;
				
				this.phase = 1;
			}
			else
			{
				this.x -= this.moveValX;
				this.y += this.power;
				this.power += this.fallValue;
			}
	
		}
		
		// ----------------
		// moveChamaeleon
		// ----------------
		public var frameCnt:int = 0;
		public var isShow:Boolean = false;
		public var commandArrowHide:Boolean = false;
		private function moveChamaeleon():void
		{
			if (phase == 0)
			{
				frameCnt = 0;
				phase = 1;
				
				var seed:int = Math.random() * 10000;
				try
				{
					if (Global.usvr.room)
					{
						seed = int(Global.usvr.room.getAttribute("host"));
					}
				}
				catch (e:Error) { }

				Global.rnd.init_genrand(seed);
			}
			
			//10秒ごとに移動
			var m:int = frameCnt - Global.FPSx10 * ((frameCnt / Global.FPSx10) >> 0);
			if (m == 0)
			{
				//消える
				this.x = 640;
				this.y = 480;
				isShow = false;
				commandArrowHide = true;	//刺さっている矢を消す命令
			}
			else if (m == Global.FPS)
			{
				//移動
				commandArrowHide = false;
				this.x = 300 + Global.rnd.getRandInt(200);
				this.y = Global.rnd.getRandInt(354);// * ((480 - 32) - (47 * 2));
			}
			else if (m == Global.FPSx7)
			{
				//姿チラ見せ
				isShow = true;
			}
			
			frameCnt++;
		}

		// ----------------
		// moveTengu
		// ----------------
		private function moveTengu():void
		{
			if (this.y < this.maxY)
			{
				this.y += 2;
			}
		}
		// ----------------
		// moveUchiwa
		// ----------------
		private function moveUchiwa():void
		{
			if (this.y < this.maxY)
			{
				this.y += 2;
			}
			
			if (phase == 0)
			{
				phase = 1;
				frameCnt = 0;
				monsterImgNo = BitmapManager._monsterImgNo;
			}

			//var i:int = (frameCnt / 24) % 6;
			var i:int = frameCnt % (5 * 24);
			commandArrowHide = false;
			if (i == 0)
			{
				imgNoWalkLeft1 = monsterImgNo[249];
				imgNoWalkLeft2 = monsterImgNo[249];
				imgNoDeadLeft = monsterImgNo[251];
				
				//当たり判定中心座標を変える
				this.hitRange2X = 16 * 4;
				this.hitRange2Y = 8 * 4;
				
				//移動するので刺さっている矢を消す
				commandArrowHide = true;	//刺さっている矢を消す命令
			}
			//else if (i == 4 * 24 - 4)
			else if (i == 92)
			{
				imgNoWalkLeft1 = monsterImgNo[250];
				imgNoWalkLeft2 = monsterImgNo[250];
				imgNoDeadLeft = monsterImgNo[252];

				//当たり判定中心座標を変える
				this.hitRange2X = 8 * 4;
				this.hitRange2Y = 40 * 4;
				
				//移動するので刺さっている矢を消す
				commandArrowHide = true;	//刺さっている矢を消す命令
			}

			frameCnt++;
		}

		// ----------------
		// moveGaruda
		// ----------------
		private function moveGaruda():void
		{
			if (phase == 0)
			{
				frameCnt = 0;
				phase = 1;
				
				var seed:int = Math.random() * 10000;
				try
				{
					if (Global.usvr.room)
					{
						seed = int(Global.usvr.room.getAttribute("host"));
					}
				}
				catch (e:Error) { }

				Global.rnd.init_genrand(seed);
			}
/*
			moveVal = 4;
			if (Global.FPS * 15 <= frameCnt)
			{
				this.y += moveVal;
			}
			else if (Global.FPS * 10 <= frameCnt)
			{
				this.y -= moveVal;
			}
			else
			{
				this.y += moveVal;
			}
*/
			/*
			if (frameCnt % Global.FPSx5 == 0)
			{
				phase++;
				if (5 <= phase)
				{
					phase = 1;
					//phase = Global.rnd.getRandInt(2) + 1;
				}
			}
			*/
			
			var _isMove:Boolean = false;
			moveVal = 4;
			
			if (phase == 1)
			{
				//中心へ↓
				if (this.y <= 120)
				{
					this.y += moveVal;
					_isMove = true;
					if (120 < this.y)
					{
						this.y = 120;
						_isMove = false;
					}
				}
			}
			else if (phase == 2)
			{
				//中心↑
				if ((0 <= this.y) && (this.y <= 120))
				{
					this.y -= moveVal;
					_isMove = true;
					if (this.y < 0)
					{
						this.y = 0;
						_isMove = false;
					}
				}
			}
			else if (phase == 3)
			{
				//中心↓
				if ((0 <= this.y) && (this.y <= 120))
				{
					this.y += moveVal;
					_isMove = true;
					if (120 < this.y)
					{
						this.y = 120;
						_isMove = false;
					}
				}
			}
			else if (phase == 4)
			{
				//↓中心
				if ((120 <= this.y) && (this.y <= 230))
				{
					this.y += moveVal;
					_isMove = true;
					if (230 < this.y)
					{
						this.y = 230;
						_isMove = false;
					}
				}
			}
			else if (phase == 5)
			{
				//↓中心
				if ((120 <= this.y) && (this.y <= 230))
				{
					this.y -= moveVal;
					_isMove = true;
					if (this.y < 120)
					{
						this.y = 120;
						_isMove = false;
					}
				}
			}
			
			if (_isMove == false)
			{
				if (frameCnt % Global.FPSx5 == 0)
				{
					phase = (phase + 1) % 6;
					if (phase == 0)
					{
						phase = 1;
					}
				}
			}
			
			
			frameCnt++;
		}

		/*
		// ----------------
		// moveAtan2XY
		// ----------------
		public function moveAtan2XY():void
		{
			if (phase == 0)
			{
				this.x = Global.monster[this.shooterIdx].x + this.missilePlusX;
				this.y = Global.monster[this.shooterIdx].y + this.missilePlusY;
				//this.r = Math.atan2(448 - 32 - this.y, this.x - 32) + Math.PI;
				var targetX:Number = (32) + atan2X;
				var targetY:Number = (448 - 32) + atan2Y;
				this.r = Math.atan2(targetY - this.y, this.x - targetX) + Math.PI;
			}
			phase = 1;
			this.x += moveVal * Math.cos(this.r);
			this.y += -1.0 * moveVal * Math.sin(this.r);
		}
		*/
	}

}