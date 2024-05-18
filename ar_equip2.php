<?php
	require_once("ar_common.php");
	write_log(basename(__FILE__));

	$name = post('name');
	$equip1 = post('equip1');
	$equip2 = post('equip2');
	$equip3 = post('equip3');
	$sortdata = post('sortdata');

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime').my_urlencode($name).$equip1);

	echo 'dummy=' . mt_rand();

	//======== トランザクション開始 ========
	$pdo->beginTransaction();
	//================

	$array = array($equip1, $equip2, $equip3);
	for ($i = 0; $i < count($array); $i++)
	{
		$stmt = $pdo->prepare('
		INSERT INTO ar_equipitem (name, count, id, date) VALUES (:name, :count, :id1, NOW())
		ON DUPLICATE KEY UPDATE id=:id2, date=NOW()
		');
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':count', ($i + 1));
		$stmt->bindValue(':id1', $array[$i]);
		$stmt->bindValue(':id2', $array[$i]);
		$stmt->execute();
	}

	//--------
	$stmt = $pdo->prepare('
	INSERT INTO ar_itemsort (name, sortdata, date) VALUES (:name, :sortdata, NOW())
	ON DUPLICATE KEY UPDATE sortdata=:sortdata, date=NOW()
	');
	$stmt->bindValue(':name', $name);
	$stmt->bindValue(':sortdata', $sortdata);
	$stmt->execute();

	//****************
	//装備データ取得
	$stmt = $pdo->prepare('
	SELECT name, count, id FROM ar_equipitem WHERE name = :name
	');
	$stmt->bindValue(':name', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$edata = '';
	foreach ($result as $row)
	{
		$edata .= my_urlencodeE($row['name']).','.my_urlencodeE($row['count']).','.$row['id'].'|';
	}
	print '&edata=' . $edata;
	//****************

	//======== コミット ========
	$pdo->commit();
	//================

	echo '&response=OK';

	// 切断
	$pdo = null;
?>
