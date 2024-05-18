package
{
	public class Hash
	{
		static private  var code:String  = "yumiyade";
		static private  var code2:String = "20140423";

		/* ******************************** */
		/* ハッシュコードを生成する			*/
		/* ******************************** */
		static public function getHash(str:String):String
		{
			//var e_str = escape(str + code);
			var e_str:String = str + code;

			var sum:int = 0;
			var hash:String = "";

			sum = e_str.charCodeAt(0) + e_str.charCodeAt(1);

			for (var i:int = 2; i < e_str.length; i = i + 2)
			{
				//sum += (e_str.charCodeAt(i) + e_str.charCodeAt(i - 1) + e_str.charCodeAt(i - 2)) * 7 % i;
				sum += (e_str.charCodeAt(i) * 3 + e_str.charCodeAt(i - 1) + e_str.charCodeAt(i - 2) * 7) % i;
				hash += String.fromCharCode(sum % (90 - 65) + 65);
			}
			trace(hash);
			return hash;
		}

		static public function getCryptogram(key:Number, moji:String):String
		{
			var str:String = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

			moji += code2 + code2;

			var code:String = "";
			var sum:int = 0;
			for (var i:int = 0; i < moji.length; i++)
			{
				if (moji.charCodeAt(i) < 128)
				{
					sum = sum + moji.charCodeAt(i);
				}
				var num:int = (sum + key * (i + 1)) % str.length;
				code = code + str.substr(num, 1);
				sum = 0;
			}
			return code;
		}


		static public function getIPHash(ip:String):String
		{
			var tmp:Array = ip.split(".");
			var sum:int = 0 + int(tmp[0]) + int(tmp[1]) + int(tmp[2]) + int(tmp[3]);
			var str:String = "" + tmp[0] + tmp[1] + tmp[2] + tmp[3] + "getIPHash";
trace("sum" + sum + " str" + str)
trace(getCryptogram2(sum, str));
			return getCryptogram2(sum, str).substr(0, 8);
		}
		static public function getCryptogram2(key:Number, moji:String):String
		{
			var str:String = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

			moji += code2;

			var code:String = "";
			var sum:int = 0;
			for (var i:int = 0; i < moji.length; i++)
			{
				if (moji.charCodeAt(i) < 128)
				{
					sum = sum + moji.charCodeAt(i);
				}
				if (i % 2 == 0)
				{
					continue;
				}
				var num:int = (sum + key * (i + 1)) % str.length;
				code = code + str.substr(num, 1);
				sum = 0;
			}
			return code;

		}

	}
}