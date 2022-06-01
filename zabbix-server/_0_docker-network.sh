#!/bin/bash

### Variables
next_script_to_run='./_1_install-mysql-database.sh'

if [ -f './VARIABLES.sh' ] ;then
	source ./VARIABLES.sh
fi

if [ -f './FUNCTIONS.sh' ] ;then
	source ./FUNCTIONS.sh
fi


check_network_availability
create_network
check_next_script_to_run && \
	"${next_script_to_run}"

exit 0
