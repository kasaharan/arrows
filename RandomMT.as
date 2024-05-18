package 
{
	public class RandomMT
	{
	/*	 Copyright (C) 1997 - 2002, Makoto Matsumoto and Takuji Nishimura,	*/
	/*	 All rights reserved.												*/
	
		private var N:int = 624;
		private var M:int = 397; 
		private var MATRIX_A:int = 0x9908b0df;
		private var UPPER_MASK:int = 0x80000000;
		private var LOWER_MASK:int = 0x7fffffff;
	
		private var mt:Vector.<int> = new Vector.<int>;
		private var mti:int = N+1;
	
		function RandomMT(seed:int = 0x12345678)
		{
			/*
			for(var i=0; i < N; i++){
				mt[i] = new int();
			}
			*/
			init_genrand(seed);
		}

		public function init_genrand(seed:int):void
		{
			mt[0]= seed & 0xffffffff;
			for (mti=1; mti<N; mti++) {
				mt[mti] = (1812433253 * (mt[mti-1] ^ (mt[mti-1] >> 30)) + mti); 
				mt[mti] &= 0xffffffff;
			}
		}

		public function genrand_int32():int
		{
			var y:int;
			var mag01:Vector.<int> = new Vector.<int>;
	
			mag01[0] = 0x0;
			mag01[1] = MATRIX_A;
	
			if (mti >= N) {
				var kk:int;
	
				if (mti == N+1)
					init_genrand(5489);
	
				for (kk=0;kk<N-M;kk++) {
					y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
					mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1];
				}
				for (;kk<N-1;kk++) {
					y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
					mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1];
				}
				y = (mt[N-1]&UPPER_MASK)|(mt[0]&LOWER_MASK);
				mt[N-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1];
	
				mti = 0;
			}
		  
			y = mt[mti++];
	
			/* Tempering */
			y ^= (y >> 11);
			y ^= (y << 7) & 0x9d2c5680;
			y ^= (y << 15) & 0xefc60000;
			y ^= (y >> 18);
	
			return y;
		}
		
		public function getRand():Number
		{
			return genrand_int32() / int.MAX_VALUE;
		}

		public function getRandInt(i:int):int
		{
			return genrand_int32() / int.MAX_VALUE * i;
		}

	}
}
