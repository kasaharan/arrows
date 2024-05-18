<?php
	require_once("ar_common.php");
	write_log(basename(__FILE__));

	$name = post('name');
	$pwd = post('pwd');
	$matomeid = post('matomeid');
	$equip1 = post('equip1');
	$equip2 = post('equip2');
	$equip3 = post('equip3');


	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime').my_urlencode($name).$pwd);

	echo 'dummy=' . mt_rand();

	//======== トランザクション開始 ========
	$pdo->beginTransaction();
	//================

	$reisen = 0;
	$itemids = preg_split('/,/', $matomeid);
	for ($i = 0; $i < count($itemids); $i++)
	{
		$id = $itemids[$i];

		//消すデータログに残しとく
		$stmt = $pdo->prepare('
		SELECT id, count, kind, value FROM ar_useritem
		WHERE name = :name
		AND id = :id
		');
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':id', $id);
		$stmt->execute();
		$result = $stmt->fetchAll(PDO::FETCH_NAMED);
		$str = '';
		foreach ($result as $row)
		{
			$reisen += $row['value'];
			$str .= $i . '=' . $itemids[$i] . '#' . $row['id'] . ':' . $row['count'] . ':' . $row['kind'] . ':' . $row['value'];
		}
		log_write_db($str);

		//消す
		$stmt = $pdo->prepare('
		DELETE FROM ar_useritem
		WHERE id = :id
		AND name = (SELECT name FROM ar_user WHERE name = :name AND pwd = :pwd)
		');
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':pwd', $pwd);
		$stmt->bindValue(':id', $id);
		$stmt->execute();
	}
	$reisen = (int)($reisen / 5) + count($itemids);

	//装備保存
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

	//解放レベル取得
	$release_level = 0;
	$stmt = $pdo->prepare('SELECT release_level FROM ar_user WHERE name = :name');
	$stmt->bindValue(':name', $name);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	foreach ($result as $row)
	{
		$release_level = $row['release_level'];
	}

	if ($release_level == 0)
	{
		$reisen = count($itemids);
	}
	print '&reisen=' . $reisen;

	//解放数カウント
	$stmt = $pdo->prepare('UPDATE ar_user SET release_cnt = release_cnt + :reisen WHERE name = :name AND pwd = :pwd');
	$stmt->bindValue(':reisen', $reisen);
	$stmt->bindValue(':name', $name);
	$stmt->bindValue(':pwd', $pwd);
	$stmt->execute();

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

	//アイテムデータ取得
	$stmt = $pdo->prepare('
	SELECT
		BASE.name, BASE.id, 
		IFNULL(A.count, 0) AS count1, IFNULL(A.kind, 0) AS kind1, IFNULL(A.value, 0) AS value1,
		IFNULL(B.count, 0) AS count2, IFNULL(B.kind, 0) AS kind2, IFNULL(B.value, 0) AS value2,
		IFNULL(C.count, 0) AS count3, IFNULL(C.kind, 0) AS kind3, IFNULL(C.value, 0) AS value3,
		IFNULL(A.mix, 0) AS mix,
		IFNULL(D.exp, 0) AS exp,
		IFNULL(D.level, 1) AS level
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
	LEFT JOIN
	(
		SELECT
			name, id, exp, level
		FROM ar_magatama_exp
		WHERE name = :name4
	) D ON (BASE.name = D.name AND BASE.id = D.id)
	ORDER BY date
	');
	$stmt->bindValue(':name0', $name, PDO::PARAM_STR);
	$stmt->bindValue(':name1', $name, PDO::PARAM_STR);
	$stmt->bindValue(':name2', $name, PDO::PARAM_STR);
	$stmt->bindValue(':name3', $name, PDO::PARAM_STR);
	$stmt->bindValue(':name4', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$itemdata = '';
	foreach ($result as $row)
	{
		$itemdata .= my_urlencodeE($row['name']).','.my_urlencodeE($row['id']).','.$row['count1'].','.$row['kind1'].','.$row['value1'].','.$row['count2'].','.$row['kind2'].','.$row['value2'].','.$row['count3'].','.$row['kind3'].','.$row['value3'].','.$row['mix'].','.$row['exp'].','.$row['level'].'|';
	}
	print '&idata=' . $itemdata;

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
