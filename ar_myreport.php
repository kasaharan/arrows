<?php
	require_once("ar_common.php");
	//write_log(basename(__FILE__));

	$name = post('name');
	$loadtype = post('loadtype');

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime').my_urlencode($name));

	echo 'dummy=' . mt_rand();

//	//トランザクション開始
//	$pdo->beginTransaction();

	if ($loadtype == '1')
	{
		$stmt = $pdo->prepare('SELECT name, type, title, manage, image1, image2, image3 FROM ar_make WHERE name = :name');
		$stmt->bindValue(':name', $name, PDO::PARAM_STR);
		$stmt->execute();
		$result = $stmt->fetchAll(PDO::FETCH_NAMED);
		foreach ($result as $row)
		{
			print '&rdata=' . my_urlencodeE($row['name']).','.$row['type'].','.$row['title'].','.$row['manage'].','.$row['image1'].','.$row['image2'].','.$row['image3'].'|';
			break;
		}
	}

	//報告書作成可否
	$stmt = $pdo->prepare('SELECT report FROM ar_system');
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	foreach ($result as $row)
	{
		print '&ismake=' . $row['report'];
		break;
	}

//	//コミット
//	$pdo->commit();

	echo '&response=OK';

	// 切断
	$pdo = null;
?>
