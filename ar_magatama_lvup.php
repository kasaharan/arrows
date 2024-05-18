<?php
	require_once("ar_common.php");
	write_log(basename(__FILE__));

	$name = post('name');
	$id = post('id');

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime').my_urlencode($name).$id);

	echo 'dummy=' . mt_rand();

	//======== トランザクション開始 ========
	$pdo->beginTransaction();
	//================

	$stmt = $pdo->prepare('
	SELECT exp, level FROM ar_magatama_exp WHERE name = :name AND id = :id
	');
	$stmt->bindValue(':name', $name);
	$stmt->bindValue(':id', $id);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$exp = 0;
	$level = 0;
	foreach ($result as $row)
	{
		$level = $row['level'];
		$exp = $row['exp'];
	}

	//能力値UP
	$isLvup = false;
	$needExp = array(20, 50, 100);
	for ($i = 0; $i < count($needExp); $i++)
	{
		if (($level == $i + 1) && ($needExp[$i] <= $exp))
		{
			$isLvup = true;

			$stmt = $pdo->prepare('
				UPDATE ar_useritem SET value = value + 1
				WHERE name = :name
				AND id = :id
				AND count = :cnt
				AND kind IN (1,2,3,4,5,6,10)
			');
			$stmt->bindValue(':name', $name);
			$stmt->bindValue(':id', $id);
			$stmt->bindValue(':cnt', ($i + 1));
			$stmt->execute();
			if ($stmt->rowCount() == 0)
			{
				print '&response=NOVALUE';
				$pdo->rollBack();
				$pdo = null;
				exit();
			}
			log_write_db('magatamaLvup[' . $id . ']count:' . ($i + 1));
			break;
		}
	}

	//レベルアップ
	if ($isLvup == true)
	{
		$stmt = $pdo->prepare('UPDATE ar_magatama_exp SET level = level + 1 WHERE name = :name AND id = :id');
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':id', $id);
		$stmt->execute();
		if ($stmt->rowCount() == 0)
		{
			print '&response=NG';
			$pdo->rollBack();
			$pdo = null;
			exit();
		}
		echo '&response=OK';
	}
	else
	{
		echo '&response=NONE';
	}

	//解放済みの勾玉の経験値データを消す
	$stmt = $pdo->prepare('
		SELECT name, id, exp, level FROM ar_magatama_exp AS M
		WHERE name = :name1
		AND NOT EXISTS(SELECT id FROM ar_useritem AS U WHERE name = :name2 AND M.id = U.id)
	');
	$stmt->bindValue(':name1', $name);
	$stmt->bindValue(':name2', $name);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	foreach ($result as $row)
	{
		//消すデータログに書いとく
		log_write_db('DEL ar_magatama_exp[' .$row['name'] . ':' . $row['id'] . ':' . $row['exp'] . ':' . $row['level'] . ']');

		$stmt = $pdo->prepare('
		DELETE FROM ar_magatama_exp
		WHERE name = :name
		AND id = :id
		');
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':id', $row['id']);
		$stmt->execute();
	}

	//****************
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

	//======== コミット ========
	$pdo->commit();
	//================

	// 切断
	$pdo = null;
?>
