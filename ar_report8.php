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
		name, stage, type, attack, title, manage, image1, image2, image3, ng
	FROM
	(
		SELECT
			name, no, stage, type, attack, title, manage, image1, image2, image3, ng, date
		FROM ar_report
		WHERE stage IN (0, 1)
		AND   ng = 0

		UNION ALL

		SELECT
			name, no, stage, type, attack, title, manage, image1, image2, image3, ng, date
		FROM ar_report
		WHERE stage = 2

		UNION ALL

		SELECT
			name, no, stage, type, attack, title, manage, image1, image2, image3, ng, date
		FROM ar_report
		WHERE stage = 3

		UNION ALL

		SELECT
			name, no, stage, type, attack, title, manage, image1, image2, image3, ng, date
		FROM ar_report
		WHERE stage = 4

		UNION ALL

		SELECT
			name, no, stage, type, attack, title, manage, image1, image2, image3, ng, date
		FROM ar_report
		WHERE stage = 5
	) TMP
	ORDER BY stage, no, date
	');
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$imgdata = '';
	foreach ($result as $row)
	{
		$imgdata .= my_urlencodeE($row['name']).','.$row['stage'].','.$row['type'].','.$row['attack'].','.my_urlencodeE($row['title']).','.$row['manage'].','.$row['image1'].','.$row['image2'].','.$row['image3'].','.$row['ng'].'|';
	}
	print '&imgdata=' . $imgdata;


	//コミット
	$pdo->commit();

	echo '&response=OK';

	// 切断
	$pdo = null;
?>
