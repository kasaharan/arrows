<?php
	require_once("ar_common.php");
	//write_log(basename(__FILE__));

	$name = post('name');

	/* ハッシュチェック */
	check_hash(post('dummy').post('sendtime').my_urlencode($name));

	echo 'dummy=' . mt_rand();

	//======== トランザクション開始 ========
	$pdo->beginTransaction();
	//================


	$stmt = $pdo->prepare("
	SELECT
		L.no,
		DATE_FORMAT(NOW(), '%Y%m%d') AS seed,
		(CASE WHEN DATE_FORMAT(NOW(), '%Y%m%d') = Q.yyyymmdd THEN 1 ELSE 0 END) AS clear
	FROM (
		SELECT 1 AS no FROM DUAL
		UNION ALL
		SELECT 2 AS no FROM DUAL
		UNION ALL
		SELECT 3 AS no FROM DUAL
	) AS L
	LEFT JOIN ar_quest AS Q ON (L.no = Q.no AND Q.name = :name)
	");
	$stmt->bindValue(':name', $name);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$quest = '';
	foreach ($result as $row)
	{
		$quest .= $row['no'].','.$row['seed'].','.$row['clear'].'|';
	}
	print '&quest=' . $quest;


	//======== コミット ========
	$pdo->commit();
	//================

	echo '&response=OK';

	// 切断
	$pdo = null;
?>
