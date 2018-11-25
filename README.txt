For the installation move the pannello_controllo/ folder under: /var/www/html

The PHP script uses some Linux commands to retrieve temperature and memory usage of the machine.
For those who face the "VCHI Initialization failed" error 
(showed in /temp/temperatura.txt file after opening index.php from client browser) the correct way to fixis is to 
add user www-data to video group. Below is the command:

sudo usermod -G video www-data

And then restart web server. (if you are trying to display this error on a php based webpage.

Default port for "motion" web stream display is 8081
