#!/bin/sh

BOLD=$(tput bold)
NORMAL=$(tput sgr0)
RED='\033[0;31m'
YELLOW='\033[1;33m'
LIGHT_GREEN='\033[1;32m'
NC='\033[0m' # No Color

error()
{
	echo "${RED}${BOLD}ERRORE${NORMAL}${NC}: $1"
}

warning()
{
	echo "${YELLOW}${BOLD}ATTENZIONE${NORMAL}${NC}: $1"
}

success()
{
	echo "${LIGHT_GREEN}${BOLD}SUCCESSO${NORMAL}${NC}: $1"
}

usage="$(basename "$0") [MentOS directory]"

echo "\t ${LIGHT_GREEN}MentOS${NC} ${BOLD}Patcher${NORMAL}\n"

# Controllo validità argomenti
if [ $# -ne 1 ]; then
	error "Argomenti non validi"
	echo "\nUtilizzo:\n\t$usage"
	exit 1
fi

# Controllo validità directory
if [ ! -d $1 ]; then
	error "Directory non valida"
	exit 1
fi

path=$(realpath $1)

# Controllo esistenza file CMakeLists.txt
if [ ! -f "$path/CMakeLists.txt" ]; then
	error "File CMakeLists.txt non trovato nella directory selezionata"
	exit 1
fi

echo "Applico le patch...\n"

# Controllo se è già stata applicata la patch per la compatibilità con GCC 10
# Vedere https://github.com/mentos-team/MentOS/commit/05397f24c9b32dc9d8ab1e7d4b51be95dd4134d4
if grep -q "CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 10" "$path/CMakeLists.txt"; then
	warning "Patch \"GCC 10\" già applicata"
else

	echo "if (CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 10)" >> "$path/CMakeLists.txt"
	echo "    set(CMAKE_C_FLAGS \"\${CMAKE_C_FLAGS} -fcommon\")" >> "$path/CMakeLists.txt"
	echo "endif()\n" >> "$path/CMakeLists.txt" >> "$path/CMakeLists.txt"

	success "Patch \"GCC 10\" applicata"
fi

# Controllo che non ci siano residui di sorgenti dentro la cartella prog
if [ -f "$path/files/prog/more.c" ]; then
	rm "$path/files/prog/more.c"
	success "Patch \"more.c\" applicata"
else
	warning "Patch \"more.c\" già applicata"
fi

echo ""

success "Tutte le patch sono state applicate con successo"

