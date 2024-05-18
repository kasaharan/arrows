<?php
	require_once("ar_common.php");
	write_log(basename(__FILE__));

	$type = post('type');
	$name = post('name');
	$id = post('id');
	$magatamaid = post('magatamaid');

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime').my_urlencode($name).$type.$id);

	echo 'dummy=' . mt_rand();

	//======== トランザクション開始 ========
	$pdo->beginTransaction();
	//================

	if ($type == 'data')
	{
		$stmt = $pdo->prepare("
		SELECT id, name, level, price, IFNULL(needid, '') AS needid FROM ar_yumishi
		WHERE id IN ('HP', 'EXP5', 'EXP10', 'EXP15', 'EXP20', 'EXP25', 'DOCHO', 'NOROI', 'TADAN2', 'TADAN3')
		ORDER BY sort
		");
		$stmt->execute();
		$result = $stmt->fetchAll(PDO::FETCH_NAMED);
		$yumishi = '';
		foreach ($result as $row)
		{
			$yumishi .= $row['id'].','.my_urlencodeE($row['name']).','.$row['level'].','.$row['price'].','.$row['needid'].'|';
		}
		print '&yumishi=' . $yumishi;
	}
	else if ($type == 'buy')
	{
		$stmt = $pdo->prepare('
		INSERT INTO ar_useryumi (name, id)
		SELECT :name, Y.id
		FROM ar_yumishi AS Y
		WHERE Y.price <= (SELECT release_cnt FROM ar_user WHERE name = :name)
		AND (Y.needid = (SELECT id FROM ar_useryumi WHERE name = :name AND id = Y.needid) OR Y.needid IS NULL)
		AND Y.id = :id
		');
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':id', $id);
		$stmt->execute();
		//０件
		if ($stmt->rowCount() === 0)
		{
			print '&response=NG';
			$pdo->rollBack();
			$pdo = null;
			exit();
		}

		//霊銭消費
		$stmt = $pdo->prepare('
		UPDATE ar_user SET
			release_cnt = release_cnt - (SELECT price FROM ar_yumishi WHERE id = :id)
		WHERE name = :name
		');
		$stmt->bindValue(':id', $id);
		$stmt->bindValue(':name', $name);
		$stmt->execute();

		//--------
		//[呪]効果付加
		if ($id == 'NOROI')
		{
			//消すデータログに残しとく
			$stmt = $pdo->prepare('
			SELECT id, count, kind, value FROM ar_useritem
			WHERE name = :name
			AND id = :id
			');
			$stmt->bindValue(':name', $name);
			$stmt->bindValue(':id', $magatamaid);
			$stmt->execute();
			$result = $stmt->fetchAll(PDO::FETCH_NAMED);
			$str = '';
			foreach ($result as $row)
			{
				$str .= $row['id'] . ':' . $row['count'] . ':' . $row['kind'] . ':' . $row['value'] . '|';
			}
			log_write_db($str);

			//消す
			$stmt = $pdo->prepare('
			DELETE FROM ar_useritem
			WHERE id = :id
			AND name = :name
			');
			$stmt->bindValue(':id', $magatamaid);
			$stmt->bindValue(':name', $name);
			$stmt->execute();
			if ($stmt->rowCount() === 0)
			{
				print '&response=NG';
				$pdo->rollBack();
				$pdo = null;
				exit();
			}
		}
		//--------
	}

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
	//****************

	//======== コミット ========
	$pdo->commit();
	//================

	echo '&response=OK';

	// 切断
	$pdo = null;
?>
