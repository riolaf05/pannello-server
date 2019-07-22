<?php
session_start(); //inizio la sessione
//includo i file necessari a collegarmi al db con relativo script di accesso
include("config.php"); 

$host="localhost";
$db__user="root";
$db_psw="onslario89";
$username="rio";
$password="onslario89";

//mi collego
$connection = new mysqli('locahost', 'root', 'onslario89', 'users');

//$username=$_POST['username']; //faccio l'escape dei caratteri dannosi
//$password=$_POST['password']; // usare $password=sha1($_POST['password']);,  sha1 cifra la password anche qui in questo modo corrisponde con quella del db

// Check connection
if ($connection->connect_error) {
  die("Connection failed: " . $connection->connect_error);
} 
echo "Connected successfully";


$query = $connection->query("SELECT * FROM login WHERE usr_username = '$username' AND usr_password = '$password' ");
if($query->num_rows) {
  echo "Accesso consentito";
} else {
  echo "Accesso rifiutato";
}

/*Prelevo l'identificativo dell'utente */
$cod=$query['usr_username'];

/* Effettuo il controllo */
if ($cod == NULL) $trovato = 0 ;
else $trovato = 1;  

/* Username e password corrette */
if($trovato === 1) {

 /*Registro la sessione*/
  session_register('autorizzato');

  $_SESSION["autorizzato"] = 1;

  /*Registro il codice dell'utente*/
  $_SESSION['cod'] = $cod;

 /*Redirect alla pagina riservata*/
   echo '<script language=javascript>document.location.href="index.php"</script>'; 

} else {

/*Username e password errati, redirect alla pagina di login*/
 echo '<script language=javascript>document.location.href="login.php"</script>';

}
?>