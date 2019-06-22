### SCRIPT PER LA CONVERSIONE AUTOMATICA DEI FILE CARICATI - ITA 

N.B Il file \pannello-server\startbootstrap-shop-item-gh-pages\pannello_controllo\invia_file.php deve essere modificato per puntare alla cartella dove verranno caricati i file..

### Prerequisites

Preparazione..
Installare Inotify-Tools
Copiare in /transferred_files gli script..
* file_conversion.sh
* inotify_check.sh

Il file file_converion.sh serve a selezionare il tipo di file che viene inviato alla cartella /transferred_files.
Se è un mp3 lo invia alla cartella "MUSICA"
Se è un mp4 o un mkv con codifica errata ne modifica il flusso video e lo salva nella cartella "FILM" 

Il file inotify_check.sh serve per settare un watcher di inotify tool sulla cartella /transferred_files. Quando rileva un nuovo file lo invia allo script file_converion.sh

TODO: check upload di più file video contemporaneamente e vedere se le conversioni vengono fatte parallelamente!!
TODO: inserire FTP direttamente dentro il docker 

