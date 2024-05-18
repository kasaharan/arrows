<?php
	require_once("ar_common.php");
	write_log(basename(__FILE__));

	$name = post('name');
	$pwd = post('pwd');
	$scenario = post('scenario');
	$exp = post('exp');

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime').my_urlencode($name).$pwd.$scenario.$exp);

	echo 'dummy=' . mt_rand();

	//トランザクション開始
	$pdo->beginTransaction();


	//短時間に複数ユーザ登録禁止
	$stmt = $pdo->prepare('
	SELECT
		ip
	FROM ar_user
	WHERE ip = :ip
	AND NOW() - INTERVAL 15 MINUTE < regist
	');
	$stmt->bindValue(':ip', $_SERVER['REMOTE_ADDR']);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	if (count($result) > 0)
	{
		print '&response=REGISTNG';
		$pdo->rollBack();
		$pdo = null;
		exit();
	}


	//登録
	$stmt = $pdo->prepare('
	INSERT INTO ar_user 
	(name, pwd, scenario, exp, ip, regist, login)
	VALUES
	(:name, :pwd, :scenario, :exp, :ip, NOW(), NOW())
	');
	$stmt->bindValue(':name', $name);
	$stmt->bindValue(':pwd', $pwd);
	$stmt->bindValue(':scenario', $scenario);
	$stmt->bindValue(':exp', $exp);
	$stmt->bindValue(':ip', $_SERVER['REMOTE_ADDR']);
	$stmt->execute();

	if ($stmt->errorCode() === '23000')
	{
		print '&response=USED';
		$pdo->rollBack();
		$pdo = null;
		exit();
	}

	//****************
	//ユーザデータ取得
	$stmt = $pdo->prepare('
	SELECT name, scenario, exp, release_cnt, itemno, itemcnt, release_level, mix_level FROM ar_user WHERE name = :name
	');
	$stmt->bindValue(':name', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	foreach ($result as $row)
	{
		$userdata = my_urlencodeE($row['name']).','.$row['scenario'].','.$row['exp'].','.$row['release_cnt'].','.$row['itemno'].','.$row['itemcnt'].','.$row['release_level'].','.$row['mix_level'].'|';
		break;
	}
	print '&udata=' . $userdata;
	//****************

	//コミット
	$pdo->commit();

	echo '&response=OK';

	// 切断
	$pdo = null;
?>
