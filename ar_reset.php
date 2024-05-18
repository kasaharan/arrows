<?php
	require_once('ar_common.php');
	write_log(basename(__FILE__));

	$name = post('name');
	$oldpwd = post('oldpwd');
	$newpwd = post('newpwd');

	//ハッシュチェック
	check_hash(post('dummy').post('sendtime').my_urlencode($name).$oldpwd.$newpwd);

	echo 'dummy=' . mt_rand();

	//トランザクション開始
	$pdo->beginTransaction();


	//reset
	$stmt = $pdo->prepare('UPDATE ar_user SET pwd = :newpwd, login = NOW(), ip = :ip WHERE name = :name AND pwd = :oldpwd');
	$stmt->bindValue(':name', $name);
	$stmt->bindValue(':ip', $_SERVER['REMOTE_ADDR']);
	$stmt->bindValue(':newpwd', $newpwd);
	$stmt->bindValue(':oldpwd', $oldpwd);
	$stmt->execute();
	if ($stmt->rowCount() === 0)
	{
		print '&response=NG';
		$pdo->rollBack();
		$pdo = null;
		exit();
	}


	//コミット
	$pdo->commit();

	echo '&response=OK';

	// 切断
	$pdo = null;
?>
