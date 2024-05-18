<?php
	require_once("ar_common.php");

	$name = post('name');
	$friend = post('friend');
	$msg = post('msg');
	$type = post('type');
	$check = post('check');

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime').my_urlencode($name).my_urlencode($friend).$type);

	echo 'dummy=' . mt_rand();

	//======== トランザクション開始 ========
	$pdo->beginTransaction();
	//================

	if ($type == 'a')
	{
		//申請or承認
		$stmt = $pdo->prepare('
		INSERT INTO ar_friend (name, friend, date)
		SELECT :name, name, NOW() FROM ar_user WHERE name = :friend
		');
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':friend', $friend);
		$stmt->execute();
		if ($stmt->rowCount() === 0)
		{
			print '&response=NONE';
			$pdo->rollBack();
			$pdo = null;
			exit();
		}
	}
	else if ($type == 'd')
	{
		//削除
		$stmt = $pdo->prepare('
		DELETE FROM ar_friend WHERE name = :name AND friend = :friend
		');
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':friend', $friend);
		$stmt->execute();
	}
	else if ($type == 's')
	{
		//send
		$stmt = $pdo->prepare('
		INSERT INTO ar_friend_msg (name, friend, msg, date) VALUES (:name, :friend, :msg, NOW())
		');
		$stmt->bindValue(':name', $name);
		$stmt->bindValue(':friend', $friend);
		$stmt->bindValue(':msg', $msg);
		$stmt->execute();
	}


	//read list
	//1受信+0承認済み+2送信SQL
	$stmt = $pdo->prepare('
	SELECT
		sort, flag, friend, date
	FROM (
		SELECT
			0 AS sort, 1 AS flag, F1.name AS friend, F1.date
		FROM ar_friend AS F1
		LEFT JOIN ar_friend AS F2
			ON (F1.name = F2.friend AND F1.friend = F2.name)
		WHERE F1.friend = :name
		AND F2.name IS NULL

		UNION ALL

		SELECT
			1 AS sort, 0 AS flag, F1.friend, F1.date
		FROM ar_friend AS F1
		JOIN ar_friend AS F2
			ON (F1.name = F2.friend AND F1.friend = F2.name)
		WHERE F1.name = :name

		UNION ALL

		SELECT
			2 AS sort, 2 AS flag, F1.friend, F1.date
		FROM ar_friend AS F1
		LEFT JOIN ar_friend AS F2
			ON (F1.name = F2.friend AND F1.friend = F2.name)
		WHERE F1.name = :name
		AND F2.friend IS NULL
	) AS TMP
	ORDER BY sort, date DESC
	');
	$stmt->bindValue(':name', $name);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$str = '';
	foreach ($result as $row)
	{
		$str .= $row['flag'] . ',' . my_urlencodeE($row['friend']) . ',' . my_urlencodeE($row['date']) . '|';
	}
	print '&room=' . $str;

	//read
	$stmt = $pdo->prepare('
	SELECT
		name, friend, DATE_FORMAT(date, "%Y/%m/%d %H:%i:%S") as date, msg
	FROM ar_friend_msg AS M
	WHERE friend = :name
	AND   NOW() - INTERVAL 30 DAY < date
	');
	$stmt->bindValue(':name', $name);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$str = '';
	foreach ($result as $row)
	{
		$str .= my_urlencodeE($row['name']) . ',' . my_urlencodeE($row['friend']) . ',' . my_urlencodeE($row['date']) . ',' . my_urlencodeE($row['msg']) . '|';
	}
	print '&msg=' . $str;

	//新着チェック情報更新
	if ($check == '1')
	{
		$stmt = $pdo->prepare('
		INSERT INTO ar_friend_news (name, msg, friendrcv)
		SELECT
			:name
			,IFNULL((SELECT DATE_FORMAT(date, "%Y%m%d%H%i%S") FROM ar_friend_msg WHERE friend = :name ORDER BY date DESC LIMIT 1), "0") AS msg
			,IFNULL((SELECT DATE_FORMAT(date, "%Y%m%d%H%i%S") FROM ar_friend     WHERE friend = :name ORDER BY date DESC LIMIT 1), "0") AS friendrcv
		FROM DUAL
		ON DUPLICATE KEY UPDATE msg = VALUES(msg), friendrcv = VALUES(friendrcv)
		');
		$stmt->bindValue(':name', $name);
		$stmt->execute();
	}
	
	//****************
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

	//======== コミット ========
	$pdo->commit();
	//================

	echo '&response=OK';

	// 切断
	$pdo = null;
?>
