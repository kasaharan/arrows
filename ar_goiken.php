<?php
	require_once('sg_common.php');

	$name = post('name');
	$msg = post('msg');

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime'));

	print 'dummy=0';


	$stmt = $pdo->prepare('INSERT INTO sg_goiken (name, goiken, ip, date) VALUES (:name, :msg, :ip, NOW())');
	$stmt->bindValue(':name', $name);
	$stmt->bindValue(':msg', $msg);
	$stmt->bindValue(':ip', $_SERVER['REMOTE_ADDR']);
	$aaa = $stmt->execute();


	print '&response=OK';

	// 切断
	$pdo = null;
?>
