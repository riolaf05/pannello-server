<?php
   define('DB_SERVER', '192.168.1.1');  
   define('DB_USERNAME', 'root');
   define('DB_PASSWORD', 'onslario89');
   define('DB_DATABASE', 'Login');
   define('DB_SG', 'SmartGarden');
   
   $db = mysqli_connect(DB_SERVER,DB_USERNAME,DB_PASSWORD,DB_DATABASE, 3306);

   $db_sg = mysqli_connect(DB_SERVER,DB_USERNAME,DB_PASSWORD,DB_SG, 3306);

?>
