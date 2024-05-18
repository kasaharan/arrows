<?php
	require_once("ar_common.php");
	//write_log(basename(__FILE__));

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime'));

	echo 'dummy=' . mt_rand();

	//トランザクション開始
	$pdo->beginTransaction();


	$stmt = $pdo->prepare('
	SELECT name, stage, type, title, manage, image1, image2, image3 FROM ar_report WHERE stage <= 1 ORDER BY stage, no, date
	');
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$imgdata = '';
	foreach ($result as $row)
	{
		$imgdata .= my_urlencodeE($row['name']).','.$row['stage'].','.$row['type'].','.my_urlencodeE($row['title']).','.$row['manage'].','.$row['image1'].','.$row['image2'].','.$row['image3'].'|';
	}
	print '&imgdata=' . $imgdata;


	//コミット
	$pdo->commit();

	echo '&response=OK';

	// 切断
	$pdo = null;
?>
