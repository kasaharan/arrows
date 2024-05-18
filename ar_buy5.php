<?php
	require_once("ar_common.php");
	write_log(basename(__FILE__));

	$name = post('name');
	$pwd = post('pwd');
	$itemno = post('itemno');

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime').my_urlencode($name).$pwd.$itemno);

	echo 'dummy=' . mt_rand();

	//======== トランザクション開始 ========
	$pdo->beginTransaction();
	//================

	if ($itemno == 10)
	{
		//購入処理（勾玉整頓術）
		$stmt = $pdo->prepare('
		UPDATE ar_user
		SET itemcnt = 30, release_cnt = release_cnt - (SELECT price FROM ar_shop WHERE itemno = :itemno)
		WHERE name = :name
		AND pwd = :pwd
		AND (SELECT price FROM ar_shop WHERE itemno = :itemno) <= release_cnt
		');
		$stmt->bindValue(':itemno', $itemno);
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':pwd', $pwd);
		$stmt->execute();
		//０件→霊銭足りない
		if ($stmt->rowCount() === 0)
		{
			print '&response=NOMONEY';
			$pdo->rollBack();
			$pdo = null;
			exit();
		}
	}
	else if ($itemno == 11)
	{
		//購入処理（勾玉解放術）
		$stmt = $pdo->prepare('
		UPDATE ar_user SET
			release_level = 1,
			release_cnt = release_cnt - (SELECT price FROM ar_shop WHERE itemno = :itemno)
		WHERE name = :name
		AND pwd = :pwd
		AND (SELECT price FROM ar_shop WHERE itemno = :itemno) <= release_cnt
		AND release_level = 0
		');
		$stmt->bindValue(':itemno', $itemno);
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':pwd', $pwd);
		$stmt->execute();
		//０件→霊銭足りない
		if ($stmt->rowCount() === 0)
		{
			print '&response=NOMONEY';
			$pdo->rollBack();
			$pdo = null;
			exit();
		}
	}
	else if ($itemno == 12)
	{
		//購入処理（勾玉合成+1）
		$stmt = $pdo->prepare('
		UPDATE ar_user SET
			mix_level = 1,
			release_cnt = release_cnt - (SELECT price FROM ar_shop WHERE itemno = :itemno)
		WHERE name = :name
		AND pwd = :pwd
		AND (SELECT price FROM ar_shop WHERE itemno = :itemno) <= release_cnt
		AND mix_level = 0
		');
		$stmt->bindValue(':itemno', $itemno);
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':pwd', $pwd);
		$stmt->execute();
		//０件→霊銭足りない
		if ($stmt->rowCount() === 0)
		{
			print '&response=NOMONEY';
			$pdo->rollBack();
			$pdo = null;
			exit();
		}
	}
	else if ($itemno == 13)
	{
		//購入処理（勾玉合成+2）
		$stmt = $pdo->prepare('
		UPDATE ar_user SET
			mix_level = 2,
			release_cnt = release_cnt - (SELECT price FROM ar_shop WHERE itemno = :itemno)
		WHERE name = :name
		AND pwd = :pwd
		AND (SELECT price FROM ar_shop WHERE itemno = :itemno) <= release_cnt
		AND mix_level = 1
		');
		$stmt->bindValue(':itemno', $itemno);
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':pwd', $pwd);
		$stmt->execute();
		//０件→霊銭足りない
		if ($stmt->rowCount() === 0)
		{
			print '&response=NOMONEY';
			$pdo->rollBack();
			$pdo = null;
			exit();
		}
	}
	else
	{
		//購入処理（服）
		$stmt = $pdo->prepare('
		UPDATE ar_user
		SET itemno = :itemno1, release_cnt = release_cnt - (SELECT price FROM ar_shop WHERE itemno = :itemno2)
		WHERE name = :name
		AND pwd = :pwd
		AND (SELECT price FROM ar_shop WHERE itemno = :itemno3) <= release_cnt
		');
		$stmt->bindValue(':itemno1', $itemno);
		$stmt->bindValue(':itemno2', $itemno);
		$stmt->bindValue(':itemno3', $itemno);
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':pwd', $pwd);
		$stmt->execute();
		//０件→霊銭足りない
		if ($stmt->rowCount() === 0)
		{
			print '&response=NOMONEY';
			$pdo->rollBack();
			$pdo = null;
			exit();
		}
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
	//****************

	//======== コミット ========
	$pdo->commit();
	//================

	echo '&response=OK';

	// 切断
	$pdo = null;
?>
