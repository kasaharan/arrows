<?php
	require_once("ar_common.php");
	write_log(basename(__FILE__));

	//$login = post('login');
	$pwd = post('pwd');
	$name = post('name');

	/* �n�b�V���`�F�b�N */
	check_hash(post('dummy').post('sendtime').my_urlencode($name).$pwd);

	echo 'dummy=' . mt_rand();

	//�g�����U�N�V�����J�n
	$pdo->beginTransaction();

	//login
	$stmt = $pdo->prepare('UPDATE ar_user SET login = NOW(), ip = :ip WHERE name = :name AND pwd = :pwd');
	$stmt->bindValue(':name', $name);
	$stmt->bindValue(':ip', $_SERVER['REMOTE_ADDR']);
	$stmt->bindValue(':pwd', $pwd);
	$stmt->execute();
	if ($stmt->rowCount() === 0)
	{
		print '&response=NG';
		$pdo->rollBack();
		$pdo = null;
		exit();
	}

	//****************
	//���[�U�f�[�^�擾
	$stmt = $pdo->prepare('
	SELECT name, scenario, exp FROM ar_user WHERE name = :name
	');
	$stmt->bindValue(':name', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	foreach ($result as $row)
	{
		$userdata = my_urlencodeE($row['name']).','.$row['scenario'].','.$row['exp'].'|';
		break;
	}
	print '&udata=' . $userdata;

	//�A�C�e���f�[�^�擾
	$stmt = $pdo->prepare('
	SELECT
		BASE.name, BASE.id, 
		IFNULL(A.count, 0) AS count1, IFNULL(A.kind, 0) AS kind1, IFNULL(A.value, 0) AS value1,
		IFNULL(B.count, 0) AS count2, IFNULL(B.kind, 0) AS kind2, IFNULL(B.value, 0) AS value2,
		IFNULL(C.count, 0) AS count3, IFNULL(C.kind, 0) AS kind3, IFNULL(C.value, 0) AS value3
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
			name, id, count, kind, value
		FROM ar_useritem
		WHERE name = :name1
		AND count = 1
	) A ON (BASE.name = A.name AND BASE.id = A.id)
	LEFT JOIN
	(
		SELECT
			name, id, count, kind, value
		FROM ar_useritem
		WHERE name = :name2
		AND count = 2
	) B ON (BASE.name = B.name AND BASE.id = B.id)
	LEFT JOIN
	(
		SELECT
		name, id, count, kind, value
			FROM ar_useritem
		WHERE name = :name3
		AND count = 3
	) C ON (BASE.name = C.name AND BASE.id = C.id)
	ORDER BY date
	');
	$stmt->bindValue(':name0', $name, PDO::PARAM_STR);
	$stmt->bindValue(':name1', $name, PDO::PARAM_STR);
	$stmt->bindValue(':name2', $name, PDO::PARAM_STR);
	$stmt->bindValue(':name3', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$itemdata = '';
	foreach ($result as $row)
	{
		$itemdata .= my_urlencodeE($row['name']).','.my_urlencodeE($row['id']).','.$row['count1'].','.$row['kind1'].','.$row['value1'].','.$row['count2'].','.$row['kind2'].','.$row['value2'].','.$row['count3'].','.$row['kind3'].','.$row['value3'].'|';
	}
	print '&idata=' . $itemdata;

	//�����f�[�^�擾
	$stmt = $pdo->prepare('
	SELECT name, count, id FROM ar_equipitem WHERE name = :name
	');
	$stmt->bindValue(':name', $name, PDO::PARAM_STR);
	$stmt->execute();
	$result = $stmt->fetchAll(PDO::FETCH_NAMED);
	$edata = '';
	foreach ($result as $row)
	{
		$edata .= my_urlencodeE($row['name']).','.my_urlencodeE($row['count']).','.$row['id'].'|';
	}
	print '&edata=' . $edata;
	//****************

	//�R�~�b�g
	$pdo->commit();

	echo '&response=OK';

	// �ؒf
	$pdo = null;
?>
