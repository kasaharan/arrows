<?php
	require_once("ar_common.php");
	//write_log(basename(__FILE__));

	$name = post('name');
	$pwd = post('pwd');
	$attack = post('attack');
	$type = post('type');
	$title = post('title');
	$mngdata = post('mngdata');
	$img1 = post('img1');
	$img2 = post('img2');
	$img3 = post('img3');
	$img4 = post('img4');
	$img5 = post('img5');

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime').my_urlencode($name).$pwd.$mngdata);

	echo 'dummy=' . mt_rand();

	//トランザクション開始
	$pdo->beginTransaction();


	//--------
	//ユーザチェック
	$stmt = $pdo->prepare('SELECT COUNT(*) AS cnt FROM ar_user WHERE name = :name AND pwd = :pwd');
	$stmt->bindValue(':name', $name, PDO::PARAM_STR);
	$stmt->bindValue(':pwd', $pwd, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	foreach ($result as $row)
	{
		if ($row['cnt'] != 1)
		{
			print '&response=NG';
			$pdo->rollBack();
			$pdo = null;
			exit();
		}
	}
	//--------

	//締め切りチェック


	//登録
	$stmt = $pdo->prepare('
	INSERT INTO ar_make
	(name, no, type, attack, title, manage, image1, image2, image3, image4, image5, date)
	VALUES
	(:name, 0, :type, :attack, :title, :manage, :image1, :image2, :image3, :image4, :image5, NOW())
	ON DUPLICATE KEY UPDATE type=:type, attack=:attack, title=:title, manage=:manage, image1=:image1, image2=:image2, image3=:image3, image4=:image4, image5=:image5, date=NOW()
	');
	$stmt->bindValue(':name', $name);
	$stmt->bindValue(':type', $type);
	$stmt->bindValue(':attack', $attack);
	$stmt->bindValue(':title', $title);
	$stmt->bindValue(':manage', $mngdata);
	$stmt->bindValue(':image1', $img1);
	$stmt->bindValue(':image2', $img2);
	$stmt->bindValue(':image3', $img3);
	$stmt->bindValue(':image4', $img4);
	$stmt->bindValue(':image5', $img5);
	$stmt->execute();


	//報告書取得
	$stmt = $pdo->prepare('SELECT name, type, attack, title, manage, image1, image2, image3, image4, image5 FROM ar_make WHERE name = :name');
	$stmt->bindValue(':name', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	foreach ($result as $row)
	{
		print '&rdata=' . my_urlencodeE($row['name']).','.$row['type'].','.$row['attack'].','.$row['title'].','.$row['manage'].','.$row['image1'].','.$row['image2'].','.$row['image3'].','.$row['image4'].','.$row['image5'].'|';
		break;
	}


	//コミット
	$pdo->commit();

	echo '&response=OK';

	// 切断
	$pdo = null;
?>
