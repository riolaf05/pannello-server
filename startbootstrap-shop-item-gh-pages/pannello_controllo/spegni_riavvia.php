<?php 
if (isset($_POST['avvia_mediatomb'])) {
	$test=shell_exec('mediatomb');
	
}
if (isset($_POST['arresta_mediatomb'])) {
    //$test=shell_exec("touch /tmp/reboot");
	
}
header("location: /pannello_controllo/index.php");
?>