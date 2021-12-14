#!/bin/sh

BOLD=$(tput bold)
NORMAL=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)

error()
{
	printf '%s%sERRORE%s: %s\n' "${BOLD}" "${RED}" "${NORMAL}" "$1"
}

warning()
{
	printf '%s%sATTENZIONE%s: %s\n' "${BOLD}" "${YELLOW}" "${NORMAL}" "$1"
}

success()
{
	printf '%s%sSUCCESSO%s: %s\n' "${BOLD}"  "${GREEN}" "${NORMAL}" "$1"
}

printf '\t %s%sMentOS%s %sPatcher%s\n\n' "${BOLD}" "${GREEN}" "${NORMAL}" "${BOLD}" "${NORMAL}"

usage="$(basename "$0") [MentOS directory]"

# Controllo validità argomenti
if [ $# -ne 1 ]; then
	error 'Argomenti non validi'
	printf '\nUtilizzo:\n\t%s\n' "$usage"
	exit 1
fi

# Controllo validità directory
if [ ! -d "$1" ]; then
	error 'Directory non valida'
	exit 1
fi

# Recupero la path assoluta della path ricevuta come argomento
path=$(realpath "$1")

# Controllo esistenza file CMakeLists.txt
if [ ! -f "$path/mentos/CMakeLists.txt" ]; then
	error 'File CMakeLists.txt non trovato nella directory selezionata'
	exit 1
fi

printf 'Applico le patch...\n\n'

# Controllo se è già stata applicata la patch per la compatibilità con GCC 10
# Vedere https://github.com/mentos-team/MentOS/commit/05397f24c9b32dc9d8ab1e7d4b51be95dd4134d4
if grep -q 'CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 10' "$path/mentos/CMakeLists.txt"; then
	warning 'Patch "GCC 10" già applicata'
else
	{
		printf '\nif (CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 10)\n'
		printf '    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fcommon")\n'
		printf 'endif()\n'
	} >> "$path/mentos/CMakeLists.txt"

	success 'Patch "GCC 10" applicata'
fi

# Controllo che non ci siano residui di sorgenti dentro la cartella prog
if [ -f "$path/files/prog/more.c" ]; then
	rm "$path/files/prog/more.c"
	success 'Patch "more.c" applicata'
else
	warning 'Patch "more.c" già applicata'
fi

printf '\n'

success 'Tutte le patch sono state applicate con successo'

