<?php
	require_once("ar_common.php");
	write_log(basename(__FILE__));

	//$login = post('login');
	$pwd = post('pwd');
	$name = post('name');

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime').my_urlencode($name).$pwd);

	echo 'dummy=' . mt_rand();

	//トランザクション開始
	$pdo->beginTransaction();

	//login
	$stmt = $pdo->prepare('UPDATE ar_user SET login = NOW(), ip = :ip WHERE name = :name AND pwd = :pwd');
	$stmt->bindValue(':name', $name);
	$stmt->bindValue(':ip', $_SERVER['REMOTE_ADDR']);
	$stmt->bindValue(':pwd', $pwd);
	$stmt->execute();
	if ($stmt->rowCount() === 0)
	{
		print '&response=NG';
		$pdo->rollBack();
		$pdo = null;
		exit();
	}

	//****************
	//ユーザデータ取得
	$stmt = $pdo->prepare('
	SELECT name, scenario, exp FROM ar_user WHERE name = :name
	');
	$stmt->bindValue(':name', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	foreach ($result as $row)
	{
		$userdata = my_urlencodeE($row['name']).','.$row['scenario'].','.$row['exp'].'|';
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
