<?php
	require_once('ar_common.php');

	$name = post('name');
	$log  = post('log');

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime').my_urlencode($name));

	print 'dummy=0';

	$stmt = $pdo->prepare('INSERT INTO ar_log (name, ip, log, date) VALUES (:name, :ip, :log, NOW())');
	$stmt->bindValue(':name', $name);
	$stmt->bindValue(':ip', $_SERVER['REMOTE_ADDR']);
	$stmt->bindValue(':log', $log);
	$stmt->execute();

	print '&response=OK';

	// 切断
	$pdo = null;
?>
