<?php include('config.php'); ?>
<!DOCTYPE html>
<html>
<head>

    <title>Collegati per amministrare il sito - <?php echo $sito_internet ?></title>

    <!--Pannello di gestione creato da Mel Riccardo-->
    <link href="css/admin.css" rel="stylesheet" type="text/css" />

</head>
<body>

    <form id="login" action="verifica.php" method="post">
        <fieldset id="inputs">
            <input id="username" name="username" type="text" placeholder="Username" autofocus required>
            <input id="password" name="password" type="password" placeholder="Password" required>
        </fieldset>
        <fieldset id="actions">
            <input type="submit" id="submit" value="Collegati">
            <a href="index.php" id="back">Ritorna al sito</a>
        </fieldset>
    </form>

</body>
</html>
