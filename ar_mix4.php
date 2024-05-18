<?php
	require_once("ar_common.php");
	write_log(basename(__FILE__));

	$name = post('name');
	$magatama1 = post('magatama1');
	$magatama2 = post('magatama2');

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime').my_urlencode($name).$magatama1.$magatama2);

	echo 'dummy=' . mt_rand();

	//======== トランザクション開始 ========
	$pdo->beginTransaction();
	//================

	//支払い
	$stmt = $pdo->prepare('
	UPDATE ar_user
	SET release_cnt = release_cnt - 5
	WHERE name = :name
	AND   5 <= release_cnt
	');
	$stmt->bindValue(':name', $name);
	$stmt->execute();
	//０件→霊銭足りない
	if ($stmt->rowCount() === 0)
	{
		print '&response=NOMONEY';
		$pdo->rollBack();
		$pdo = null;
		exit();
	}

	//勾玉データ取得
	$stmt = $pdo->prepare('
	SELECT id, count, kind, value, mix
	FROM ar_useritem
	WHERE name = :name
	AND   id IN (:magatama1, :magatama2)
	');
	$stmt->bindValue(':name', $name);
	$stmt->bindValue(':magatama1', $magatama1);
	$stmt->bindValue(':magatama2', $magatama2);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);

	//２つの勾玉選んでるかチェック
	$magatamaIDcheck = array();
	//消すデータログに残しとく
	$logStr = '';

	foreach ($result as $row)
	{
		if ($row['mix'] == 1)
		{
			print '&response=MIXED';
			$pdo->rollBack();
			$pdo = null;
			exit();
		}
		$magatamaIDcheck[$row['id']] = 1;
		$logStr .= $row['id'] . ':' . $row['count'] . ':' . $row['kind'] . ':' . $row['value'] . '|';
	}

	//２つの勾玉選んでるかチェック
	if (count($magatamaIDcheck) != 2)
	{
		print '&response=NGTWO';
		$pdo->rollBack();
		$pdo = null;
		exit();
	}

	//消すデータログに残しとく
	log_write_db($logStr);

	//結果をシャッフル
	shuffle($result);

	//能力を選ぶ。
	$newMagatama = array();
	array_push($newMagatama, $result[0]);

	//能力の件数が3以上なら2つ目の能力を決める。選択済みの種類は選ばない
	if (3 <= count($result))
	{
		addAbility();
	}

	//能力の件数が5以上なら3つ目の能力を決める。選択済みの種類は選ばない
	if (5 <= count($result))
	{
		addAbility();
	}

	function addAbility()
	{
		global $result, $newMagatama;

		//技は２つにならないようにするための種類判定値。
		//技強化も重ならないようにする。
		//技強化との組み合わせはあり（１つの勾玉で火矢、氷矢が可能）
		// 7:技[一] 8:技[バババ] 9:技[花火] 11:技[舞] 12:技[連] 17:技[送] ⇒ 能力重複チェックで全て 77 扱い
		// 14:技強化[3連] 15:技強化[火矢] 16:技強化[氷矢] ⇒ 能力重複チェックで全て 99 扱い
		// ソートするので77,99と後ろに来るようにしとく
		//      index 0,1,2,3,4,5,6, 7, 8, 9,10,11,12,13,14,15,16,17
		$kind = array(0,1,2,3,4,5,6,77,77,77,10,77,77,13,99,99,99,77);

		$mlen = count($newMagatama);
		for ($r = 0; $r < count($result); $r++)
		{
			$isSelected = FALSE;
			for ($m = 0; $m < $mlen; $m++)
			{
				if ($kind[ $result[$r]['kind'] ] == $kind[ $newMagatama[$m]['kind'] ])
				{
					//付加しようとしている能力が付加済みなら次のresultへ
					$isSelected = TRUE;
					break;
				}
			}
			if ($isSelected == FALSE)
			{
				array_push($newMagatama, $result[$r]);
				return;
			}
		}

		return;
	}

	//勾玉合成レベル取得
	$mix_level = 0;
	$stmt = $pdo->prepare('SELECT mix_level FROM ar_user WHERE name = :name');
	$stmt->bindValue(':name', $name);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	foreach ($result as $row)
	{
		$mix_level = $row['mix_level'] + 1;
	}

	//値+1する能力数を決定
	$abilityCnt = mt_rand(1, count($newMagatama));
	if ($mix_level < $abilityCnt)
	{
		$abilityCnt = $mix_level;	//合成レベル以上の種類付加しない
	}
	for ($i = 0; $i < $abilityCnt; $i++)
	{
		$addValue = mt_rand(1, $mix_level);	//合成レベル以上の値付加しない
		$newMagatama[$i]['value'] = $newMagatama[$i]['value'] + $addValue;

		log_write_db('cnt_' . $abilityCnt . ':' . $addValue);
	}

	//ソート
	function compare($a, $b)
	{
		if ($a['kind'] == $b['kind'])
		{
			return 0;
		}
		return ($a['kind'] > $b['kind']) ? 1 : -1;
	}
	usort($newMagatama, "compare");

	//新勾玉保存
	$i = 1;
	$uniqueID = uniqid('', true);
	foreach ($newMagatama as $row)
	{
		$stmt = $pdo->prepare('
		INSERT INTO ar_useritem
		(name, id, count, kind, value, mix, date)
		VALUES
		(:name, :id, :count, :kind, :value, 1, NOW())
		');
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':id', $uniqueID);
		$stmt->bindValue(':count', $i);
		$stmt->bindValue(':kind', $row['kind']);
		$stmt->bindValue(':value', $row['value']);
		$ret = $stmt->execute();

		$i++;

		if ($ret == FALSE)
		{
			print '&response=NG';
			$pdo->rollBack();
			$pdo = null;
			exit();
		}
	}
	print '&giid=' . $uniqueID;

	//旧勾玉削除
	$stmt = $pdo->prepare('
	DELETE FROM ar_useritem
	WHERE name = :name
	AND   id IN (:magatama1, :magatama2)
	');
	$stmt->bindValue(':name', $name);
	$stmt->bindValue(':magatama1', $magatama1);
	$stmt->bindValue(':magatama2', $magatama2);
	$ret = $stmt->execute();
	if ($ret == FALSE)
	{
		print '&response=NG';
		$pdo->rollBack();
		$pdo = null;
		exit();
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

	print '&response=OK';

	// 切断
	$pdo = null;
?>
