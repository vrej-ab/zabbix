#!/bin/bash

### Variables
next_script_to_run=''

if [ -f './VARIABLES.sh' ] ;then
        source ./VARIABLES.sh
fi

if [ -f './FUNCTIONS.sh' ] ;then
        source ./FUNCTIONS.sh
fi

check_if_container_exists "${zabbix_web_container_name}" # Otherwise create a new one.
if [ "$?" -eq 0 ] ;then
  docker run -d \
	--name "${zabbix_web_container_name}" \
	--net "${net_name}" \
	-e DB_SERVER_HOST="${db_container_name}" \
	-e MYSQL_USER="${zabbix_mysq_user_name}" \
	-e MYSQL_PASSWORD="${zabbix_mysq_user_pass}" \
	-e ZBX_SERVER_HOST="${zabbix_container_name}" \
	-e PHP_TZ="${PHP_TZ}" \
	$( if [ "${behind_reverse_proxy}" != 'true' ]; then
		echo '-p 8080:8080 -p 8443:8443'
	fi ) \
	"${zabbix_web_image}"
else
        check_if_container_is_running "${zabbix_web_container_name}"
fi

##check_next_script_to_run && \
##        ./"${next_script_to_run}"

exit 0
