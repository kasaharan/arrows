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

	//save
	$stmt = $pdo->prepare('UPDATE ar_user SET scenario = :scenario, exp = :exp WHERE name = :name AND pwd = :pwd');
	$stmt->bindValue(':scenario', $scenario);
	$stmt->bindValue(':exp', $exp);
	$stmt->bindValue(':name', $name);
	$stmt->bindValue(':pwd', $pwd);
	$stmt->execute();
	//[memo]更新前と値が変わらない場合は0件になる
	/*
	if ($stmt->rowCount() === 0)
	{
		print '&response=NG';
		$pdo->rollBack();
		write_log("save NG");
		$pdo = null;
		exit();
	}
	*/

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
