<?php
	require_once("ar_common.php");
	write_log(basename(__FILE__));

	$name = post('name');
	$pwd = post('pwd');
	$scenario = post('scenario');
	$exp = post('exp');

	/* �n�b�V���`�F�b�N */
	check_hash(post('dummy').post('sendtime').my_urlencode($name).$pwd.$scenario.$exp);

	echo 'dummy=' . mt_rand();

	//�g�����U�N�V�����J�n
	$pdo->beginTransaction();

	//save
	$stmt = $pdo->prepare('UPDATE ar_user SET scenario = :scenario, exp = :exp WHERE name = :name AND pwd = :pwd');
	$stmt->bindValue(':scenario', $scenario);
	$stmt->bindValue(':exp', $exp);
	$stmt->bindValue(':name', $name);
	$stmt->bindValue(':pwd', $pwd);
	$stmt->execute();
	//[memo]�X�V�O�ƒl���ς��Ȃ��ꍇ��0���ɂȂ�
	/*
	if ($stmt->rowCount() === 0)
	{
		print '&response=NG';
		$pdo->rollBack();
		write_log("save NG");
		$pdo = null;
		exit();
	}
	*/

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
