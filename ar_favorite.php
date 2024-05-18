<?php
	require_once("ar_common.php");
	write_log(basename(__FILE__));

	$name = post('name');
	$fav = post('fav');

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime').my_urlencode($name));

	echo 'dummy=' . mt_rand();

	//======== トランザクション開始 ========
	$pdo->beginTransaction();
	//================

	$stmt = $pdo->prepare('
	INSERT INTO ar_favorite (name, fav, date) VALUES (:name, :fav, NOW())
	ON DUPLICATE KEY UPDATE fav=:fav, date=NOW()
	');
	$stmt->bindValue(':name', $name);
	$stmt->bindValue(':fav', $fav);
	$stmt->execute();

	//======== コミット ========
	$pdo->commit();
	//================

	echo '&response=OK';

	// 切断
	$pdo = null;
?>
