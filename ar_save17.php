<?php
	require_once("ar_common.php");
	write_log(basename(__FILE__));

	$name = post('name');
	$pwd = post('pwd');
	$scenarioIdx = post('scenarioIdx');
	$scenarioNo = post('scenarioNo');
	$exp = post('exp');		//20140722 dummyとする
	$magatama = post('magatama');
	$noroi = post('noroi');
	$clearframecnt = post('clearframecnt');
	$cleartime = post('cleartime');
	$personcnt = post('personcnt');
	$win = post('win');
	$dmgrate = post('dmgrate');
	$addexp = post('addexp');
	$ch = post('ch');
	$sac = post('sac');
	$linfo = post('linfo');
	$pageno = post('pageno');

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime').my_urlencode($name).$pwd.$scenarioIdx.$exp.$magatama.$noroi.$clearframecnt.$win.$personcnt.$dmgrate.$addexp.$ch);

	$response = 'OK';

	echo 'dummy=' . mt_rand();

	//--------
	//チート対策
	if ($ch != '0')
	{
		log_write_db('Fusei[' . $ch . ']' . $exp . '(' . $addexp . ')');

		if ($ch == '10')
		{
			$addexp = mt_rand(-10000, 0);
			$dmgrate = 0;
		}
		if ($ch == '40')
		{
			$addexp = mt_rand(-10000, 0);
			$dmgrate = 0;
		}
		if ($ch == '50')
		{
			$addexp = mt_rand(-10000, 0);
			$dmgrate = 0;
		}
		if ($ch == '20')
		{
			$addexp = mt_rand(-1000, 0);
			$dmgrate = 0;
		}
		if ($ch == '25')
		{
			$addexp = mt_rand(-10, 0);
			$dmgrate = 0;
		}
		if ($ch == '60')
		{
			$addexp = mt_rand(-10000, 0);
			$dmgrate = 0;
		}
	}
	//--------

	//トランザクション開始
	$pdo->beginTransaction();

	//--------
	//多重ログインチェック
	$stmt = $pdo->prepare('SELECT DATE_FORMAT(login, "%Y%m%d%H%i%S") AS linfo FROM ar_user WHERE name = :name');
	$stmt->bindValue(':name', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	foreach ($result as $row)
	{
		if ((0 < strlen($linfo)) && ($linfo != $row['linfo']))
		{
			log_write_db('LOGIN OLD[' . $linfo . ':' . $row['linfo'] . ']');

			//0729まだ保留にする。関係ない人が引っかからないのを確認したら再テストしてコメントはずす
			/*
			print '&response=OLD';
			$pdo->rollBack();
			$pdo = null;
			exit();
			*/
			//--------
			
		}
		break;
	}
	//--------

	//--------勾玉変換しても経験値＋技
	$expup = 0;
	if ($magatama == 1)
	{
		$stmt = $pdo->prepare("
		SELECT
			IFNULL(MAX(rate), 0) AS rate
		FROM (
			SELECT
				CASE
				WHEN id = 'EXP5'  THEN 5
				WHEN id = 'EXP10' THEN 10
				WHEN id = 'EXP15' THEN 15
				WHEN id = 'EXP20' THEN 20
				WHEN id = 'EXP25' THEN 25
				ELSE 0 END AS rate
			FROM ar_useryumi
			WHERE name = :name
			AND id IN ('EXP5', 'EXP10', 'EXP15', 'EXP20', 'EXP25')
		) AS TMP
		");
		$stmt->bindValue(':name', $name, PDO::PARAM_STR);
		$stmt->execute();
		$result = $stmt->fetchAll(PDO::FETCH_NAMED);
		$rate = 0;
		foreach ($result as $row)
		{
			$rate = intval($row['rate']);
			$expup = intval($addexp * $rate * 0.01);
			log_write_db('EXP UP:' . $addexp . '->' . $expup);
			$addexp = $expup;
			echo '&expup=' . $expup;
			break;
		}
	}

	// --------勾玉ゲット--------
	$uniqueID = '';
	$isItemGet = FALSE;
	if ($magatama == 1)
	{
		//勾玉取得処理
		$type = 0;
		if ((35 <= $scenarioNo) && ($scenarioNo <= 41))
		{
			//報告書用
			$type = mt_rand(0, 2);
		}

		$stmt = $pdo->prepare('
		SELECT
			scenario_no, count, kind, min_value, max_value, rate
		FROM ar_item
		WHERE scenario_no = :scenario_no
		AND   type = :type
		ORDER BY count
		');
		$stmt->bindValue(':scenario_no', $scenarioNo, PDO::PARAM_STR);
		$stmt->bindValue(':type', $type, PDO::PARAM_STR);
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
				//$value = mt_rand($row['min_value'] + $noroiInt, $row['max_value'] + $noroiInt);

				//--------
				$minValue = $row['min_value'] + $noroiInt;
				$maxValue = $row['max_value'] + $noroiInt;
				//与えたダメージで最大値変化
				if (100 <= $dmgrate)
				{
					//nop
				}
				else if (66 <= $dmgrate)
				{
					$maxValue = (int)($row['max_value'] * 0.8);
				}
				else if (33 <= $dmgrate)
				{
					$maxValue = (int)($row['max_value'] * 0.5);
				}
				else
				{
					$maxValue = (int)($row['max_value'] * 0.2);
				}
				
				if ($maxValue < $minValue)
				{
					$maxValue = $minValue;
				}
				log_write_db('magatama:' . $dmgrate . '#' . $noroiInt . '@' . $row['min_value'] . ':' . $row['max_value'] . '->' . $minValue . ':' . $maxValue);
				//--------
				
				
				$value = mt_rand($minValue, $maxValue);
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
	//if ($magatama == 1)
	if (($magatama == 1) && ($expup == 0))
	{
		//save
		$stmt = $pdo->prepare('UPDATE ar_user SET scenario = :scenario, login = NOW() WHERE name = :name AND pwd = :pwd');
		$stmt->bindValue(':scenario', $scenarioIdx);
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':pwd', $pwd);
		$stmt->execute();
	}
	else
	{
		//save
		$stmt = $pdo->prepare('UPDATE ar_user SET scenario = :scenario, exp = exp + :addexp, login = NOW() WHERE name = :name AND pwd = :pwd');
		$stmt->bindValue(':scenario', $scenarioIdx);
		$stmt->bindValue(':addexp', $addexp);
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':pwd', $pwd);
		$stmt->execute();
	}

//ar_clear はやめた20140911
/*
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
*/
//record はやめた20140906
/*
	// --------
	$stmt = $pdo->prepare('
	INSERT INTO ar_record (name, person_cnt, scenario_no, framecnt, noroi, date) VALUES (:name, :person_cnt, :scenario_no, :framecnt, :noroi, NOW())
	');
	$stmt->bindValue(':name', $name);
	$stmt->bindValue(':person_cnt', $personcnt);
	$stmt->bindValue(':scenario_no', $scenarioNo);
	$stmt->bindValue(':framecnt', $clearframecnt);
	$stmt->bindValue(':noroi', $noroi);
	$stmt->execute();
*/
	// --------
	if (($win == '1') && (35 <= $scenarioNo))
	{
		$stmt = $pdo->prepare('
		INSERT INTO ar_silhouette (name, pageno) VALUES (:name, :pageno)
		');
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':pageno', $pageno);
		$stmt->execute();

		//報告書Lv6から
		if (40 <= $scenarioNo)
		{
			$stmt = $pdo->prepare('
			INSERT INTO ar_count (scenario_no, pageno, cnt) VALUES (:scenario_no, :pageno, 1)
			ON DUPLICATE KEY UPDATE cnt=cnt+1
			');
			$stmt->bindValue(':scenario_no', $scenarioNo);
			$stmt->bindValue(':pageno', $pageno);
			$stmt->execute();
		}
	}

	//勾玉経験値UP
	if ((2 <= $personcnt) && (33 <= $dmgrate))
	{
		$stmt = $pdo->prepare("SELECT enable FROM ar_useryumi WHERE name = :name AND id = 'DOCHO'");
		$stmt->bindValue(':name', $name, PDO::PARAM_STR);
		$stmt->execute();
		$result = $stmt->fetchAll(PDO::FETCH_NAMED);
		$docho = '';
		foreach ($result as $row)
		{
			$docho = $row['enable'];
		}
		if ($docho == '1')
		{
			$stmt = $pdo->prepare('SELECT id FROM ar_equipitem WHERE name = :name');
			$stmt->bindValue(':name', $name, PDO::PARAM_STR);
			$stmt->execute();
			$result = $stmt->fetchAll(PDO::FETCH_NAMED);
			foreach ($result as $row)
			{
				$stmt = $pdo->prepare('
				INSERT INTO ar_magatama_exp (name, id, exp, level) VALUES (:name, :id, 1, 1)
				ON DUPLICATE KEY UPDATE exp = (CASE WHEN exp < 100 THEN exp + 1 ELSE exp + 0 END)
				');
				$stmt->bindValue(':name', $name);
				$stmt->bindValue(':id', $row['id']);
				$stmt->execute();
			}
		}
		
		print '&docho=1';
	}
	else
	{
		print '&docho=0';
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
	//****************

	//コミット
	$pdo->commit();

	echo '&response='. $response;

	// 切断
	$pdo = null;
?>
