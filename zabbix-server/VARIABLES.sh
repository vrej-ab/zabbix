### Variables configuration
## Global
net_name='monitoring-network'
net_driver='bridge'
mysql_extra_config_dir='./mysql-config'
mount_root_path='/DOCKER/zabbix'

## Database
db_container_name='zabbix-mysql'
db_data_mount_path="${mount_root_path}/mysql/mysql-data"
db_config_mount_path="${mount_root_path}/mysql/mysql-user-config"
db_image='mysql:8.0.29-debian'
MYSQL_ROOT_PASSWORD='123456'			# <-- CHANGE THIS
DB_SERVER_HOST="zabbix-mysql-server"

## Zabbix Server
# By default the zabbix server's port `10051` will be exposed to your host machine.
# This is needed when you want to configure your zabbix agents to connect to the server.
# It is recommended to configure firewall to access only from your trusted sources.
zabbix_container_name='zabbix-server'
zabbix_data_mount_path="${mount_root_path}/zabbix-server/zabbix-data"
zabbix_image='zabbix/zabbix-server-mysql:6.0.5-ubuntu'
zabbix_mysq_user_name='zabbix' 		# <-- CHANGE THIS
zabbix_mysq_user_pass='Zabbix'	# <-- CHANGE THIS

## Zabbix Web (Nginx)
zabbix_web_container_name='zabbix-web'
zabbix_web_image='zabbix/zabbix-web-nginx-mysql:6.0.5-ubuntu'
PHP_TZ='Europe/Helsinki'
# Set to `true` if you don't want to expose the zabbix-web ports on your host machine but make sure that you have a proper configured
# reverse proxy to `proxy_pass` the Zabbix-server traffic to Zabbix Web container in it's network.
# Default ports are `8080` and `8443` and hard coded in the script.
# Use `false` value for testing purposes.
# Either way, it is recommended to configure firewall to access only from your trusted sources.
behind_reverse_proxy='false'

