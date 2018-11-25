<?php 
            
    $client = new SoapClient("http://192.168.1.9:8080/axis2/services/SpegniServer?wsdl");
	$result = $client->shutdown();
     
?>






