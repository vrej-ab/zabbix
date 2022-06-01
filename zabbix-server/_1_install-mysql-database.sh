#!/bin/bash

### Variables
next_script_to_run='_2_install-zabbix-server.sh'

if [ -f './VARIABLES.sh' ] ;then
        source ./VARIABLES.sh
fi

if [ -f './FUNCTIONS.sh' ] ;then
        source ./FUNCTIONS.sh
fi

check_if_container_exists "${db_container_name}" # Otherwise create a new one.
if [ "$?" -eq 0 ] ;then
  create_local_directories && \
  copy_mysql_user_config_files && \
  docker run -d \
	--name "${db_container_name}" \
	--net "${net_name}" \
	-v "${db_data_mount_path}:/var/lib/mysql" \
	-v "${db_config_mount_path}:/etc/mysql/conf.d" \
	-e MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD}" \
	"${db_image}"
  sleep 10
else
	check_if_container_is_running "${db_container_name}"
fi

check_next_script_to_run && \
        ./"${next_script_to_run}"

exit 0
