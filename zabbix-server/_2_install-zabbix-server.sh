#!/bin/bash

### Variables
next_script_to_run='_3_install-zabbix-nginx.sh'

if [ -f './VARIABLES.sh' ] ;then
        source ./VARIABLES.sh
fi

if [ -f './FUNCTIONS.sh' ] ;then
        source ./FUNCTIONS.sh
fi

check_if_container_exists "${zabbix_container_name}" # Otherwise create a new one.
if [ "$?" -eq 0 ] ;then
  docker run -d \
	--name "${zabbix_container_name}" \
	--net "${net_name}" \
	-e MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD}" \
	-e MYSQL_USER="${zabbix_mysq_user_name}" \
	-e MYSQL_PASSWORD="${zabbix_mysq_user_pass}" \
	-e DB_SERVER_HOST="${db_container_name}" \
	-v "${zabbix_data_mount_path}:/var/lib/mysql" \
	-p "10051:10051" \
	"${zabbix_image}"
else
        check_if_container_is_running "${zabbix_container_name}"
fi

check_next_script_to_run && \
        ./"${next_script_to_run}"

exit 0
