<?php
	require_once("ar_common.php");
	write_log(basename(__FILE__));

	$name = post('name');
	$yuko = post('yuko');

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime').my_urlencode($name).$yuko);

	echo 'dummy=' . mt_rand();

	//======== トランザクション開始 ========
	$pdo->beginTransaction();
	//================


	$stmt = $pdo->prepare('UPDATE ar_useryumi SET enable = 0 WHERE name = :name');
	$stmt->bindValue(':name', $name);
	$stmt->execute();

	$id = preg_split('/,/', $yuko);
	for ($i = 0; $i < count($id); $i++)
	{
		$stmt = $pdo->prepare('UPDATE ar_useryumi SET enable = 1 WHERE name = :name AND id = :id');
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':id', $id[$i]);
		$stmt->execute();
	}

	//****************
	//弓強化データ取得
	$stmt = $pdo->prepare('
	SELECT Y.id, Y.name, Y.onoff, U.enable
	FROM ar_useryumi AS U
	JOIN ar_yumishi AS Y ON (U.id = Y.id)
	WHERE U.name = :name
	');
	$stmt->bindValue(':name', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$useryumi = '';
	foreach ($result as $row)
	{
		$useryumi .= $row['id'].','.$row['name'].','.$row['onoff'].','.$row['enable'].'|';
	}
	print '&useryumi=' . $useryumi;
	//****************

	//======== コミット ========
	$pdo->commit();
	//================

	echo '&response=OK';

	// 切断
	$pdo = null;
?>
