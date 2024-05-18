<?php
	require_once("ar_common.php");
	write_log(basename(__FILE__));

	$name = post('name');
	$pwd = post('pwd');
	$scenarioIdx = post('scenarioIdx');
	$scenarioNo = post('scenarioNo');
	$exp = post('exp');
	$magatama = post('magatama');
	$noroi = post('noroi');

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime').my_urlencode($name).$pwd.$scenarioIdx.$exp.$magatama.$noroi);

	echo 'dummy=' . mt_rand();

	//トランザクション開始
	$pdo->beginTransaction();

	// --------勾玉ゲット--------
	$uniqueID = '';
	$isItemGet = FALSE;
	if ($magatama == 1)
	{
		//勾玉取得処理
		$stmt = $pdo->prepare('
		SELECT scenario_no, count, kind, min_value, max_value, rate FROM ar_item WHERE scenario_no = :scenario_no ORDER BY count
		');
		$stmt->bindValue(':scenario_no', $scenarioNo, PDO::PARAM_STR);
		$stmt->execute();
		$result = $stmt->fetchAll(PDO::FETCH_NAMED);

		$uniqueID = uniqid('', true);
		$isItemGet = FALSE;
		
		$noroiInt = 0;
		if ($noroi == '1')
		{
			$noroiInt = 2;
		}

		foreach ($result as $row)
		{
			if (mt_rand(1, 100) <= $row['rate'])
			{
				$value = mt_rand($row['min_value'] + $noroiInt, $row['max_value'] + $noroiInt);
				//アイテムゲット
				$stmt = $pdo->prepare('
				INSERT INTO ar_useritem
				(name, id, count, kind, value, date)
				VALUES
				(:name, :id, :count, :kind, :value, NOW())
				');
				$stmt->bindValue(':name', $name);
				$stmt->bindValue(':id', $uniqueID);
				$stmt->bindValue(':count', $row['count']);
				$stmt->bindValue(':kind', $row['kind']);
				$stmt->bindValue(':value', $value);
				$stmt->execute();
				$isItemGet = TRUE;
			}
		}
	}
	if ($isItemGet)
	{
		print '&giid=' . $uniqueID;
	}
	else
	{
		print '&giid=';
	}

	// --------保存--------
	if ($magatama == 1)
	{
		//save
		$stmt = $pdo->prepare('UPDATE ar_user SET scenario = :scenario WHERE name = :name AND pwd = :pwd');
		$stmt->bindValue(':scenario', $scenarioIdx);
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':pwd', $pwd);
		$stmt->execute();
	}
	else
	{
		//save
		$stmt = $pdo->prepare('UPDATE ar_user SET scenario = :scenario, exp = :exp WHERE name = :name AND pwd = :pwd');
		$stmt->bindValue(':scenario', $scenarioIdx);
		$stmt->bindValue(':exp', $exp);
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':pwd', $pwd);
		$stmt->execute();
	}
	
	// --------
	$stmt = $pdo->prepare('
	INSERT INTO ar_clear
	(name, scenario_no, cnt, date)
	VALUES
	(:name, :scenario_no, 1, NOW())
	ON DUPLICATE KEY UPDATE cnt=cnt+1
	');
	$stmt->bindValue(':name', $name);
	$stmt->bindValue(':scenario_no', $scenarioNo);
	$stmt->execute();

	//****************
	//ユーザデータ取得
	$stmt = $pdo->prepare('
	SELECT name, scenario, exp, release_cnt, itemno FROM ar_user WHERE name = :name
	');
	$stmt->bindValue(':name', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	foreach ($result as $row)
	{
		$userdata = my_urlencodeE($row['name']).','.$row['scenario'].','.$row['exp'].','.$row['release_cnt'].','.$row['itemno'].'|';
		break;
	}
	print '&udata=' . $userdata;

	//アイテムデータ取得
	$stmt = $pdo->prepare('
	SELECT
		BASE.name, BASE.id, 
		IFNULL(A.count, 0) AS count1, IFNULL(A.kind, 0) AS kind1, IFNULL(A.value, 0) AS value1,
		IFNULL(B.count, 0) AS count2, IFNULL(B.kind, 0) AS kind2, IFNULL(B.value, 0) AS value2,
		IFNULL(C.count, 0) AS count3, IFNULL(C.kind, 0) AS kind3, IFNULL(C.value, 0) AS value3
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
			name, id, count, kind, value
		FROM ar_useritem
		WHERE name = :name1
		AND count = 1
	) A ON (BASE.name = A.name AND BASE.id = A.id)
	LEFT JOIN
	(
		SELECT
			name, id, count, kind, value
		FROM ar_useritem
		WHERE name = :name2
		AND count = 2
	) B ON (BASE.name = B.name AND BASE.id = B.id)
	LEFT JOIN
	(
		SELECT
		name, id, count, kind, value
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
		$itemdata .= my_urlencodeE($row['name']).','.my_urlencodeE($row['id']).','.$row['count1'].','.$row['kind1'].','.$row['value1'].','.$row['count2'].','.$row['kind2'].','.$row['value2'].','.$row['count3'].','.$row['kind3'].','.$row['value3'].'|';
	}
	print '&idata=' . $itemdata;
	//****************

	//コミット
	$pdo->commit();

	echo '&response=OK';

	// 切断
	$pdo = null;
?>
