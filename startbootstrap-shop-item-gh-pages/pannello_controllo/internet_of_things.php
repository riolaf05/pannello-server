<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Pannello di Controllo</title>

    <!-- Bootstrap Core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="css/shop-item.css" rel="stylesheet">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <style>
        .button {
          display: inline-block;
          padding: 15px 25px;
          font-size: 24px;
          cursor: pointer;
          text-align: center;
          text-decoration: none;
          outline: none;
          color: #fff;
          background-color: #0000ff;
          border: none;
          border-radius: 15px;
          box-shadow: 0 9px #999;
        }

        .button:hover {background-color: #0000ff}

        .button:active {
          background-color: #0000ff;
          box-shadow: 0 5px #666;
          transform: translateY(4px);
        }

        .green {
            background-image: -webkit-linear-gradient(top, #13fB04 0%, #58e343 50%, #ADED99 100%);
        }

        .orange {
            background-image: -webkit-linear-gradient(top, #f9a004 0%, #e0ac45 50%, #ead698 100%);
         }


        .red {
            background-image: -webkit-linear-gradient(top, #fb1304 0%, #e35843 50%, #edad99 100%);
        }


        .led {
            border-radius: 5px;
            width: 10px;
            height: 10px;
            box-shadow: 0px 0px 3px black;
            margin: 5px;
            zoom: 5;
         }

        .led:after {
            display: block;            
            content: '';
            margin-left: 1px;
            margin-right: 1px;
            width: 8px;
            height: 6px;
            -webkit-border-top-right-radius: 4px 3px;
            -webkit-border-top-left-radius: 4px 3px;
            -webkit-border-bottom-right-radius: 4px 3px;
            -webkit-border-bottom-left-radius: 4px 3px;
            background-image: -webkit-linear-gradient(top, rgba(255,255,255,0.8) 0%, rgba(255,255,255,0.2) 100%);
         }
​
    </style>

</head>

<body>

    

<?php

		include('session.php');
		
		//Scrittura temperatura CPU (grazie all'applicazione acpi) e memoria restante
		#$comando=shell_exec('/opt/vc/bin/vcgencmd measure_temp > /tmp/temperatura.txt && df -h / > /tmp/memoria.txt');
		
		//Lettura temperatura CPU 
		$fp = fopen('/tmp/temperatura.txt', r);
		if(!$fp) {
			$temperatura=0;
			}
		fseek($fp, 5, SEEK_SET); //Mi posiziono al 5° carattere
		$temperatura = fread($fp, 4); //Leggo 4 caratteri partendo dalla posizione corrente
		fclose($fp);
		

		//lettura spazio disponibile hard disk 
		$fp = fopen('/tmp/memoria.txt', r);
		if(!$fp) {
			$memoria_percentuale=0;
			}
		fseek($fp, 66, SEEK_SET);
		$memoria_tot = fread($fp, 2);
		fseek($fp, 71, SEEK_SET); 
		$memoria_usata = fread($fp, 2);
		fseek($fp, 82, SEEK_SET); 
		$memoria_percentuale = fread($fp, 2);
		fclose($fp);
		

	?>

    <!-- Navigation -->
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
        <div class="container">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">Start Bootstrap</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    <li>
                        <a href="#">About</a>
                    </li>
                    <li>
                        <a href="#">Services</a>
                    </li>
                    <li>
                        <a href="#">Contact</a>
                    </li>
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container -->
    </nav>

    <!-- Page Content -->
    <div class="container">
        <p class="lead">Home Server</p>
        <div class="row">

            <div class="col-md-3">
                
                <div class="list-group">
                    <a href="index.php" class="list-group-item active">Home</a>
                    <a href="boards.php" class="list-group-item">Boards</a>
                    <a href="server_status.php" class="list-group-item">Server Status</a>
                    <a href="http://riohomecloud.ddns.net:9000" class="list-group-item">Containers</a>
                    <a href="#" class="list-group-item">Internet of Things</a>
					<a href="http://<?php echo $_SERVER['HTTP_HOST']; ?>:8081" class="list-group-item">Camera Monitor</a>
                    <a href="http://<?php echo $_SERVER['HTTP_HOST']; ?>:8123" class="list-group-item">Home Assistant</a>
                    <a href="carica_file.php" class="list-group-item">File Browser</a>
                    <a href="http://<?php echo $_SERVER['HTTP_HOST']; ?>:8200" class="list-group-item">Media Server</a>
                </div>
            </div>


            <div class="col-md-8 col-md-offset-1">

                
                
                    
                
            <nav class="nav nav-pills nav-justified">
                <li class="nav-item">
                    <a class="nav-link active" href="#">Smart Garden</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link disabled" href="#" tabindex="-1" aria-disabled="true">New Device</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link disabled" href="#" tabindex="-1" aria-disabled="true">New Device</a>
                </li>
                <li class="nav-item">
                    <a class="nav-item nav-link disabled" href="#" tabindex="-1" aria-disabled="true">New Device</a>
                </li>

                    <?php
                        
                        $sql =  "select Status from Smart_Garden_Status where Name = 'smart_garden' order by ID desc limit 1;";
                    
                        $result = mysqli_query($db_sg,$sql);
                        
                        $row = mysqli_fetch_array($result,MYSQLI_ASSOC);

                        $status = $row['Status'];
                            
                        if($status == "ON"){
                            ?>
                            <div class="green led"></div>
                            
                            <?php
                        }
                        else{
                            ?>
                            <div class="red led"></div>
                        <?php
                        }
                    ?>


                <h2>Smart Garden</h2>


                <div class="row">
                    
                    <div class="col-6">

                        <form action='' method='post'>
                            <input type="submit" name="submit" value="Acqua" class="button">
                        </form>

                    </div>
                    
                </div>


                <?php

                if(isset($_POST['submit'])){

                        $output = shell_exec('mosquitto_pub -h 192.168.1.0 -t pump_activation -m "ON"'); //TODO: change hard coded broker IP!!
                    }

                ?>
                


                <span style="display:inline-block; width: 50;"></span>



                <div class="row">


                    <iframe width="450" height="260" style="border: 1px solid #cccccc;" src="https://thingspeak.com/channels/689988/widgets/88557"></iframe>



                    <iframe width="450" height="260" style="border: 1px solid #cccccc;" src="https://thingspeak.com/channels/689988/charts/1?bgcolor=%23ffffff&color=%23d62020&dynamic=true&max=100&min=0&results=60&title=Umidit%C3%A0++&type=line&yaxismax=100&yaxismin=0"></iframe>


                    
                    <iframe width="450" height="260" style="border: 1px solid #cccccc;" src="https://thingspeak.com/channels/911024/widgets/119332"></iframe>


                </div>
                



            
                    

            </nav>     

                
				

            </div>

        </div>

    </div>
    <!-- /.container -->

    <div class="container">

        <hr>

        <!-- Footer -->
        <footer>
            <div class="row">
                <div class="col-lg-12">
                    <p>Copyright &copy; Rosario Laface 2016-2019</p>
                </div>
            </div>
        </footer>

    </div>
    <!-- /.container -->

    <!-- jQuery -->
    <script src="js/jquery.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="js/bootstrap.min.js"></script>

</body>

</html>
