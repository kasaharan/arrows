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

	//--------
	//勾玉データ整形(能力２つでcount1,3のものはcount1,2に修正する)
	$stmt = $pdo->prepare('
		SELECT COUNT(id) as ccnt, MAX(count) as cmax, MIN(count) AS cmin, id FROM ar_useritem
		WHERE name = :name
		AND count IN (1,2,3)
		GROUP BY id
		HAVING (ccnt = 2 AND cmin = 1 AND cmax = 3)
	');
	$stmt->bindValue(':name', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	foreach ($result as $row)
	{
		$stmt = $pdo->prepare('
			UPDATE ar_useritem SET count = 2
			WHERE name = :name
			AND id = :id
			AND count = 3
		');
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':id', $row['id']);
		$stmt->execute();
		log_write_db('勾玉データ整形[' . $stmt->rowCount() . ']' . $row['id']);
	}
	//--------

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

	//妖魔界討伐データ取得
	$stmt = $pdo->prepare('SELECT scenario_no, pageno, cnt FROM ar_count WHERE 0 < cnt ORDER BY scenario_no, cnt DESC');
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$tobatsu = '';
	foreach ($result as $row)
	{
		$tobatsu .= $row['scenario_no'].','.$row['pageno'].','.$row['cnt'].'|';
	}
	print '&tobatsu=' . $tobatsu;

	//弓強化データ取得
	$stmt = $pdo->prepare("
	SELECT id, name, onoff, enable
	FROM (
		SELECT Y.id, Y.name, Y.onoff, U.enable, Y.sort
		FROM ar_useryumi AS U
		JOIN ar_yumishi AS Y ON (U.id = Y.id)
		WHERE U.name = :name
		AND U.id != 'TADAN2'

		UNION ALL

		SELECT Y.id, Y.name, Y.onoff, U.enable, Y.sort
		FROM ar_useryumi AS U
		JOIN ar_yumishi AS Y ON (U.id = Y.id)
		WHERE U.name = :name
		AND   U.id = 'TADAN2'
		AND  NOT EXISTS (SELECT 'X' FROM ar_useryumi WHERE name = :name AND id = 'TADAN3')
	) AS TMP
	ORDER BY sort
	");
	$stmt->bindValue(':name', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$useryumi = '';
	foreach ($result as $row)
	{
		$useryumi .= $row['id'].','.my_urlencodeE($row['name']).','.$row['onoff'].','.$row['enable'].'|';
	}
	print '&useryumi=' . $useryumi;

	//呪２クリア情報取得
	$stmt = $pdo->prepare('SELECT scenario_idx FROM ar_clear_noroi2 WHERE name = :name ORDER BY scenario_idx');
	$stmt->bindValue(':name', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$n2clr = '';
	foreach ($result as $row)
	{
		$n2clr .= $row['scenario_idx'].'|';
	}
	print '&n2clr=' . $n2clr;

	//フレンドMSGチェック
	$stmt = $pdo->prepare('
	SELECT
		 (CASE WHEN (msg1 = msg2) OR (msg1 IS NULL AND msg2 IS NULL) THEN 0 ELSE 1 END) AS check1
		,(CASE WHEN (rcv1 = rcv2) OR (rcv1 IS NULL AND rcv2 IS NULL) THEN 0 ELSE 1 END) AS check2
	FROM
	(
		SELECT
			 IFNULL((SELECT DATE_FORMAT(date, "%Y%m%d%H%i%S") FROM ar_friend_msg WHERE friend = :name ORDER BY date DESC LIMIT 1), "0") AS msg1
			,IFNULL((SELECT DATE_FORMAT(date, "%Y%m%d%H%i%S") FROM ar_friend     WHERE friend = :name ORDER BY date DESC LIMIT 1), "0") AS rcv1
			,IFNULL((SELECT msg       FROM ar_friend_news WHERE name = :name), "0") AS msg2
			,IFNULL((SELECT friendrcv FROM ar_friend_news WHERE name = :name), "0") AS rcv2
		FROM DUAL
	) AS TMP
	');
	$stmt->bindValue(':name', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$friend = '';
	foreach ($result as $row)
	{
		$friend = $row['check1'].','.$row['check2'].'|';
	}
	print '&news=' . $friend;
	//****************

	//コミット
	$pdo->commit();

	echo '&response=OK';

	// 切断
	$pdo = null;
?>
