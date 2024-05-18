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

	////古いlogを削除
	//$stmt = $pdo->query('DELETE FROM ar_log WHERE date <= NOW() - INTERVAL 60 DAY');

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
	//ユーザデータ取得(ログイン用)
	$stmt = $pdo->prepare('
	SELECT name, scenario, exp, release_cnt, itemno, itemcnt, release_level, mix_level, DATE_FORMAT(login, "%Y%m%d%H%i%S") AS linfo FROM ar_user WHERE name = :name
	');
	$stmt->bindValue(':name', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	foreach ($result as $row)
	{
		$userdata = my_urlencodeE($row['name']).','.$row['scenario'].','.$row['exp'].','.$row['release_cnt'].','.$row['itemno'].','.$row['itemcnt'].','.$row['release_level'].','.$row['mix_level'].'|';
		$linfo = $row['linfo'];
		break;
	}
	print '&udata=' . $userdata;
	print '&linfo=' . $linfo;

	//アイテムデータ取得
	$stmt = $pdo->prepare('
	SELECT
		BASE.name, BASE.id, 
		IFNULL(A.count, 0) AS count1, IFNULL(A.kind, 0) AS kind1, IFNULL(A.value, 0) AS value1,
		IFNULL(B.count, 0) AS count2, IFNULL(B.kind, 0) AS kind2, IFNULL(B.value, 0) AS value2,
		IFNULL(C.count, 0) AS count3, IFNULL(C.kind, 0) AS kind3, IFNULL(C.value, 0) AS value3,
		IFNULL(A.mix, 0) AS mix
	FROM
	(
		SELECT
			name, id, date
		FROM ar_useritem
		WHERE name = :name0
		GROUP BY name, id
	) BASE
	LEFT JOIN
	(
		SELECT
			name, id, count, kind, value, mix
		FROM ar_useritem
		WHERE name = :name1
		AND count = 1
	) A ON (BASE.name = A.name AND BASE.id = A.id)
	LEFT JOIN
	(
		SELECT
			name, id, count, kind, value, mix
		FROM ar_useritem
		WHERE name = :name2
		AND count = 2
	) B ON (BASE.name = B.name AND BASE.id = B.id)
	LEFT JOIN
	(
		SELECT
		name, id, count, kind, value, mix
			FROM ar_useritem
		WHERE name = :name3
		AND count = 3
	) C ON (BASE.name = C.name AND BASE.id = C.id)
	ORDER BY date
	');
	$stmt->bindValue(':name0', $name, PDO::PARAM_STR);
	$stmt->bindValue(':name1', $name, PDO::PARAM_STR);
	$stmt->bindValue(':name2', $name, PDO::PARAM_STR);
	$stmt->bindValue(':name3', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$itemdata = '';
	foreach ($result as $row)
	{
		$itemdata .= my_urlencodeE($row['name']).','.my_urlencodeE($row['id']).','.$row['count1'].','.$row['kind1'].','.$row['value1'].','.$row['count2'].','.$row['kind2'].','.$row['value2'].','.$row['count3'].','.$row['kind3'].','.$row['value3'].','.$row['mix'].'|';
	}
	print '&idata=' . $itemdata;

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

	//お気に入りデータ取得
	$stmt = $pdo->prepare('
	SELECT fav FROM ar_favorite WHERE name = :name
	');
	$stmt->bindValue(':name', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$fdata = '';
	foreach ($result as $row)
	{
		$fdata = $row['fav'];
	}
	print '&fdata=' . $fdata;

	//道具ソート順取得
	$stmt = $pdo->prepare('
	SELECT sortdata FROM ar_itemsort WHERE name = :name
	');
	$stmt->bindValue(':name', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$sdata = '';
	foreach ($result as $row)
	{
		$sdata = $row['sortdata'];
	}
	print '&sdata=' . $sdata;

	//シルエットデータ取得
	$stmt = $pdo->prepare('SELECT name, pageno FROM ar_silhouette WHERE name = :name');
	$stmt->bindValue(':name', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$silhouette = '';
	foreach ($result as $row)
	{
		$silhouette .= my_urlencodeE($row['name']).','.$row['pageno'].'|';
	}
	print '&silhouette=' . $silhouette;
	//****************

	//コミット
	$pdo->commit();

	echo '&response=OK';

	// 切断
	$pdo = null;
?>
