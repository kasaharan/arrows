<?php
	require_once("ar_common.php");
	write_log(basename(__FILE__));

	$type = post('type');
	$name = post('name');
	$id = post('id');

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime').my_urlencode($name).$type.$id);

	echo 'dummy=' . mt_rand();

	//======== トランザクション開始 ========
	$pdo->beginTransaction();
	//================

	if ($type == 'data')
	{
		$stmt = $pdo->prepare('
		SELECT id, name, level, price, needid FROM ar_yumishi ORDER BY sort
		');
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
