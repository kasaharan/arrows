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
	//****************

	//�R�~�b�g
	$pdo->commit();

	echo '&response=OK';

	// �ؒf
	$pdo = null;
?>
