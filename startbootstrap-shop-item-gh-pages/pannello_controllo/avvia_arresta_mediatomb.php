<?php 
if (isset($_POST['avvia'])) {
	$test=shell_exec("mediatomb");
}
if (isset($_POST['arresta'])) {
    //da implementare spegnimento Mediatomb!
	
}
header("location: /pannello_controllo/index.php");
?>