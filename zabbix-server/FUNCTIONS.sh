### Functions
check_network_availability(){
        get_network=$(docker network ls --filter name="${net_name}" --filter driver="${net_driver}" | tail -n +2 | awk '{print $2}')
}

create_network(){
        if [ "${get_network}" == '' ] ;then
                echo -e "\n[INFO]: \"${net_name}\" docker network not found."
                read -rp "[WARNING]: Confirm creating docker network \"${net_name}\" --driver \"${net_driver}\" - [y] to confirm:  " confirmation
                if [ "${confirmation}" != 'y' ] ;then
                        echo -e "\n[ERROR]: Creating docker network not confirmed, terminating process!\n"
                        exit 1
                fi

                docker network create "${net_name}" --driver "${net_driver}"

                if [ "$?" -ne 0 ] ;then
                        echo -e "\n[ERROR]: Failed to create docker network, terminating process!\n"
                        exit 1
                fi
        else
                echo -e "\n[INFO]: \"${net_name}\" docker network is available.\n"
        fi
}

check_next_script_to_run(){
        if ! [ -f "${next_script_to_run}" ] ;then
                echo -e "\n[ERROR]: ${next_script_to_run} - file not found.\n"
                exit 2
        elif ! [ -x "${next_script_to_run}" ] ;then
                echo -e "\n[ERROR]: ${next_script_to_run} - file is not executable.\n"
                exit 2
        else
		echo ""
                read -rp "[WARNING]: Confirm to run the \"${next_script_to_run}\" script - [y] to confirm: " confirmation
                if ! [ "${confirmation}" == 'y' ] ;then
                        echo -e "\n[ERROR]: Not confirmed to run the next script, exitting...\n"
                        exit 2
                else
                        return 0
                fi
        fi
}

check_if_container_exists(){
	local container_name="${1}"
	container_exists=$(docker ps -a --filter name="${container_name}" | tail -n +2 | awk '{print $NF}') # --filter status=running
	if [ "${container_exists}" == '' ] ;then
		echo -e "\n[INFO]: \"${container_name}\" container will be created."
		return 0
	else
		return 3
	fi
}

check_if_container_is_running(){
	local container_name="${1}"
	container_exists=$(docker ps -a --filter name="${container_name}" --filter status=running | tail -n +2 | awk '{print $NF}')
	if [ "${container_exists}" == '' ] ;then
		echo -e "\n[ERROR]: \"${container_name}\" container is available but not running, please check!\n"
		exit 3
	else
		echo -e "\n[INFO]: \"${container_name}\" container is available and running\n"
		return 0
	fi
}

create_local_directories(){
	if ! [ -d "${mount_root_path}" ] ;then
		mkdir -p "${mount_root_path}"
	fi
	if ! [ -d "${db_data_mount_path}" ] ;then
		mkdir -p "${db_data_mount_path}"
	fi
	if ! [ -d "${db_config_mount_path}" ] ;then
		mkdir -p "${db_config_mount_path}"
	fi
}

copy_mysql_user_config_files(){
	if [ -d "${mysql_extra_config_dir}" ] ;then
		\cp -i "${mysql_extra_config_dir}"/* "${db_config_mount_path}"
	fi
}
