1. Creiamo un file sorgente per il nostro programma.\
Chiameremo questo file *cmd\_program.c*, dove *program* indica il nome del programma stesso.\
La struttura del file deve essere la seguente:

```c
// cmd_program.c

#include "commands.h"

void cmd_program(int argc, char **argv)
{
    [codice del programma]
}
```

A questo punto dobbiamo inserire *cmd_program.c* all'interno della path *mentos/src/ui/command*.\
Il file sarà dunque identificato dalla path *mentos/src/ui/command/cmd_program.c*

2. Aggiungiamo all'interno del file *mentos/inc/ui/command/commands.h* la seguente riga di codice:

```c
void cmd_program(int argc, char **argv);
```

3. Apriamo il file *mentos/src/ui/shell/shell.c* e dentro l'array *_shell_commands* aggiungiamo la seguente riga di codice:

```c
{ "mio_comando", cmd_program, "descrizione del mio comando" }
```

__Facendo attenzione ad aggiungere eventuali virgole di separazione tra gli elementi dell'array__.

Notiamo che è possibile cambiare il nome del comando che per questo esempio è *mio_comando*, ma che potrebbe tranquillamente essere *pippo* o *pluto*.

4. Apriamo il file *mentos/CMakeLists.txt* e individuiamo l'ultimo comando inserito che dovrebbe essere *src/ui/command/cmd_nice.c* (utilizzare la funzionalità di ricerca, quindi ctrl-f o equivalenti).\
Aggiungiamo la seguente riga sotto l'ultimo comando che abbiamo appena individuato:

```
src/ui/command/cmd_program.c
```

Risultando in qualcosa di simile:

```
...

src/ui/command/cmd_nice.c
src/ui/command/cmd_program.c

...
```

5. Una volta avviato MentOS possiamo avviare il nostro programma tramite il comando *mio_comando*.