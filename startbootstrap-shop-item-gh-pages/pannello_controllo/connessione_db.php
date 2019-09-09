<?php 
 
       include("config.php"); 
 
        //collegamento
    $col = "mysql:host=$host;dbname=$db_name";
 
        try {
          echo 'Connessione a: ' .$host;
          echo "<br>";
          echo "Database: " .$db_name;
	  echo "<br>"; 
           //tentativo di connessione
          $db = new PDO($col , "$db_user", "$db_psw");
        }
                    //gestione errori
            catch(PDOException $e) {
 
              echo 'Attenzione errore: '.$e->getMessage();
            }       
 
?>
