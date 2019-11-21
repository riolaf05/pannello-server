<?php
		include('config.php');
   		session_start();

        $ses_sql = mysqli_query($db,"select status from sensor_status where name = 'smart_garden' ");
        $row = mysqli_fetch_array($ses_sql,MYSQLI_ASSOC);

        $status = $row['status'];
            
        if($status = on){
      		<div class="green led"></div>
   		}
        else{
            <div class="red led"></div>
        }
?>
