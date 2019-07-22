<?php
session_start(); //inizio la sessione
//includo i file necessari a collegarmi al db con relativo script di accesso
include("config.php"); 

//$username=$_POST['username']; //faccio l'escape dei caratteri dannosi
//$password=$_POST['password']; // usare $password=sha1($_POST['password']);,  sha1 cifra la password anche qui in questo modo corrisponde con quella del db

//mi collego
$connection = mysqli_connect("locahost", "root", "onslario89");

if (mysqli_connect_errno())
{
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
    //you need to exit the script, if there is an error
    exit();
}

// Check connection
if ($connection->connect_error) {
  die("Connection failed: " . $connection->connect_error);
} 
echo "Connected successfully";

//$sql_statement = "SELECT * FROM login WHERE usr_username = '" . $_POST['username'] ."'" . "AND usr_password ='" . $_POST['password'] ."'";
$sql= "SELECT * FROM users WHERE usr_username = 'rio' AND usr_password = 'onslario89'";
$query = mysqli_query($connection, $sql_statement);

/*Prelevo l'identificativo dell'utente */
$cod=$result['usr_username'];

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