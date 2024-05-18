<?php
	//ini_set('magic_quotes_gpc', 'off');
	header("Content-Type: text/plain; charset=utf-8");

	//ユーザの切断を無視
	//ignore_user_abort(1);

	if (preg_match("(ar_common.php)", $_SERVER["PHP_SELF"]))
	{
		exit();
	}
	if ( $_SERVER["REQUEST_METHOD"] == "GET" )
	{
		exit();
	}

	try
	{
		// MySQLサーバへ接続
		$pdo = new PDO("mysql:host=localhost; dbname=game_arrows", "user_arrows", "pwd_arrows");
		//$pdo = new PDO("mysql:host=localhost; dbname=game_arrows", "user_arrows", "pwd_arrows", array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION));
		//文字コードセット
		$stmt = $pdo->query("SET NAMES utf8");
	}
	catch(PDOException $e)
	{
		echo "FAILED|";
		exit();
	}

	/* POSTデータ取得 */
	function post($key)
	{
		return isset($_POST[$key]) ? $_POST[$key] : '';
	}

	/* ハッシュチェック */
	function check_hash($str)
	{
		$hash = get_hash_code($str);
		if ($hash !== post("hash"))
		{
			log_write_db(post("hash") . "?" . $hash." ".$str);
			echo "NGHASH|";
			exit();
		}
	}

	/* Hashコード生成 */
	function get_hash_code($str)
	{
		$str .= "yumiyade";

		$sum = 0;
		$byte = unpack("C*", $str);	//ここで作られる配列は[1]から
		$hash = "";

		$i = 0;
		$sum += $byte[0+1] + $byte[1+1];

		for ( $i = 2; $i < count($byte); $i++,$i++ )
		{
			$sum += ($byte[$i+1] * 3 + $byte[$i-1+1] + $byte[$i-2+1] * 7) % $i;
			$hash .= pack("C", $sum%(90-65)+65); #65=A 90=Z
		}

		return $hash;
	}

	/* エンコードされない文字があるため自作 */
	function my_urlencode($str)
	{
		$str = str_replace("~", "%7E", rawurlencode($str));
		$str = str_replace(".", "%2E", $str);
		$str = str_replace("-", "%2D", $str);
		$str = str_replace("_", "%5F", $str);
		return $str;
	}

	/* カンマなどすべての文字が使用できるようにエスケープ含むエンコード */
	function my_urlencodeE($str)
	{
		$str = strtr($str, array('\\' => '\\\\'));
		$str = strtr($str, array(',' => '\\,'));
		$str = strtr($str, array('|' => '\\|'));
		return my_urlencode($str);
	}

	/* ログ出力 */ 
	function write_log($fn)
	{
		$log = "";
		foreach($_POST as $key => $value)
		{
			$log .= $key . '=' . post($key) . '&';
		}
		log_write_db($fn." ".urldecode($log));
	}

	/* DBにログ出力 */
	function log_write_db($log)
	{
		global $pdo;
		try
		{
			$stmt = $pdo->prepare("INSERT INTO ar_log2 (name, ip, log) VALUES (:name, :ip, :log)");
			//サーバーは magic_quotes_gpc = Off でした
			//$stmt->bindValue(':NAME', stripslashes(post('name')));
			$stmt->bindValue(':name', post('name'));
			$stmt->bindValue(':ip', $_SERVER['REMOTE_ADDR']);
			$stmt->bindValue(':log', $log);
			$stmt->execute();
		}
		catch(PDOException $e)
		{
			var_dump($e->getMessage());
		}
	}

	/* IPアドレスHash */
	function getIP2Hash( $ip )
	{
		$arg = split("\.", $ip);
		$sum = (int)$arg[0] + (int)$arg[1] + (int)$arg[2] + (int)$arg[3];
		$str = $arg[0].$arg[1].$arg[2].$arg[3];
		return (makeCode($sum, $str));
	}
	function makeCode( $key, $str )
	{
		$moji = substr($str."getIP2Hash_makeCode", 0, 16);

		$str = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
		$chr = str_split($str);

		$code = "";
		$sum = $key;
		for ( $i = 0; $i < strlen($moji); $i++ )
		{
			$tmp = substr( $moji, $i, 1 );
			$arr = unpack("C", $tmp);
			$sum += $arr[1];
			if ( ($i & 1) == 0 )
			{
				$code = $code.$chr[$sum % count($chr)];
			}
		}

		return $code;
	}
?>
