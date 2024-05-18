<?php
	require_once("ar_common.php");
	//write_log(basename(__FILE__));

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime'));

	echo 'dummy=' . mt_rand();

	//トランザクション開始
	$pdo->beginTransaction();


	$stmt = $pdo->prepare('
	SELECT
		name, no, stage, type, attack, title, manage, image1, image2, image3, image4, image5, ng, hp
	FROM (
		SELECT
			name, no, stage, type, attack, title, manage, image1, image2, image3, image4, image5, ng, hp, date
		FROM ar_report
		WHERE stage BETWEEN 0 AND 7
		AND   ng = 0
		
		UNION ALL
		
		SELECT
			name, no, stage, type, attack, title, manage, image1, image2, image3, image4, image5, ng, hp, date
		FROM ar_report
		WHERE stage = 8
	) TMP
	ORDER BY stage, no, date
	
	');
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$imgdata = '';
	foreach ($result as $row)
	{
		$imgdata .= my_urlencodeE($row['name']).','.$row['stage'].','.$row['type'].','.$row['attack'].','.my_urlencodeE($row['title']).','.$row['manage'].','.$row['image1'].','.$row['image2'].','.$row['image3'].','.$row['image4'].','.$row['image5'].','.$row['ng'].','.$row['hp'].'|';
	}
	print '&imgdata=' . $imgdata;


	//コミット
	$pdo->commit();

	echo '&response=OK';

	// 切断
	$pdo = null;
?>
