package 
{
	public class Item
	{
		public static const EQUIP_MAX_CNT:int = 3;
		//public static const MAX_COUNT:int = 20;
		public static var MAX_COUNT:int = 20;

		public static const KIND_IDX_NONE:int = 0;
		public static const KIND_IDX_YAKAZU:int = 1;
		public static const KIND_IDX_HIKYORI:int = 2;
		public static const KIND_IDX_SOKUSHA:int = 3;
		public static const KIND_IDX_KANTSUU:int = 4;
		public static const KIND_IDX_SHUUCHUU:int = 5;
		public static const KIND_IDX_SANRAN:int = 6;
		public static const KIND_IDX_WAZA_ITTEN:int = 7;
		public static const KIND_IDX_WAZA_BABABA:int = 8;
		public static const KIND_IDX_WAZA_HANABI:int = 9;
		public static const KIND_IDX_CHISHA:int = 10;		//遅射
		public static const KIND_IDX_WAZA_MAI:int = 11;		//技：舞	//20140606保留
		public static const KIND_IDX_WAZA_REN:int = 12;		//技：連
		public static const KIND_IDX_NOROI:int = 13;		//呪い
		public static const KIND_IDX_KYOKA_HANABI:int = 14;		//花火強化→3連		//20140704保留
		public static const KIND_IDX_KYOKA_HANABI2:int = 15;	//花火強化→火矢
		public static const KIND_IDX_KYOKA_BABABA:int = 16;		//花火強化→氷矢
		public static const KIND_IDX_WAZA_SOU:int = 17;		//技：送
		

		public static const kindName:Vector.<String> = new Vector.<String>;
		//static init
		{
			kindName[KIND_IDX_NONE]   = "";
			kindName[KIND_IDX_YAKAZU] = "矢数";
			kindName[KIND_IDX_HIKYORI] = "飛距離";
			kindName[KIND_IDX_SOKUSHA] = "速射";
			kindName[KIND_IDX_KANTSUU] = "貫通";
			kindName[KIND_IDX_SHUUCHUU] = "密集";
			kindName[KIND_IDX_SANRAN] = "散乱";
			kindName[KIND_IDX_WAZA_ITTEN]  = "技[一点射撃]";
			kindName[KIND_IDX_WAZA_BABABA] = "技[バババッ]";
			kindName[KIND_IDX_WAZA_HANABI] = "技[花火]";
			kindName[KIND_IDX_CHISHA] = "遅射";
			kindName[KIND_IDX_WAZA_MAI] = "技[舞]";
			kindName[KIND_IDX_WAZA_REN] = "技[連]";
			kindName[KIND_IDX_NOROI] = "[呪]";
			kindName[KIND_IDX_KYOKA_HANABI] = "技変化[花火]";
			kindName[KIND_IDX_KYOKA_HANABI2] = "技変化[火矢]";
			kindName[KIND_IDX_KYOKA_BABABA] = "技変化[氷矢]";
			kindName[KIND_IDX_WAZA_SOU] = "技[送]";
		}
		
		public static const isWaza:Vector.<Boolean> = new Vector.<Boolean>;
		//static init
		{
			isWaza[KIND_IDX_NONE]     = false;
			isWaza[KIND_IDX_YAKAZU]   = false;
			isWaza[KIND_IDX_HIKYORI]  = false;
			isWaza[KIND_IDX_SOKUSHA]  = false;
			isWaza[KIND_IDX_KANTSUU]  = false;
			isWaza[KIND_IDX_SHUUCHUU] = false;
			isWaza[KIND_IDX_SANRAN]   = false;
			isWaza[KIND_IDX_WAZA_ITTEN]  = true;
			isWaza[KIND_IDX_WAZA_BABABA] = true;
			isWaza[KIND_IDX_WAZA_HANABI] = true;
			isWaza[KIND_IDX_CHISHA]			= false;
			isWaza[KIND_IDX_WAZA_MAI]   	= true;
			isWaza[KIND_IDX_WAZA_REN]		= true;
			isWaza[KIND_IDX_NOROI]			= false;
			isWaza[KIND_IDX_KYOKA_HANABI]	= false;
			isWaza[KIND_IDX_KYOKA_HANABI2]	= false;
			isWaza[KIND_IDX_KYOKA_BABABA]	= false;
			isWaza[KIND_IDX_WAZA_SOU] = true;
		}

		public static const isWazaKyoka:Vector.<Boolean> = new Vector.<Boolean>;
		//static init
		{
			isWazaKyoka[KIND_IDX_NONE]     = false;
			isWazaKyoka[KIND_IDX_YAKAZU]   = false;
			isWazaKyoka[KIND_IDX_HIKYORI]  = false;
			isWazaKyoka[KIND_IDX_SOKUSHA]  = false;
			isWazaKyoka[KIND_IDX_KANTSUU]  = false;
			isWazaKyoka[KIND_IDX_SHUUCHUU] = false;
			isWazaKyoka[KIND_IDX_SANRAN]   = false;
			isWazaKyoka[KIND_IDX_WAZA_ITTEN]  = false;
			isWazaKyoka[KIND_IDX_WAZA_BABABA] = false;
			isWazaKyoka[KIND_IDX_WAZA_HANABI] = false;
			isWazaKyoka[KIND_IDX_CHISHA]		= false;
			isWazaKyoka[KIND_IDX_WAZA_MAI]		= false;
			isWazaKyoka[KIND_IDX_WAZA_REN]		= false;
			isWazaKyoka[KIND_IDX_NOROI]			= false;
			isWazaKyoka[KIND_IDX_KYOKA_HANABI]	= true;
			isWazaKyoka[KIND_IDX_KYOKA_HANABI2]	= true;
			isWazaKyoka[KIND_IDX_KYOKA_BABABA]	= true;
			isWazaKyoka[KIND_IDX_WAZA_SOU]	= false;
		}

	}
}