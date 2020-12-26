#!/bin/bash

ssh_agent_pid=($(pgrep ssh-agent))
error(){
	printf "\033[35mError:\t\033[31m${1}\033[0m\n"
	exit 1
}

remove_zombies(){
	zombie_count=${1}
	for ((i=0;$i < $zombie_count;i++))
	do
		printf "Removing: ${ssh_agent_pid[$i]}\n"
		kill -9 "${ssh_agent_pid[$i]}"
		sleep 1
	done
}

execute_zombie_removal(){
	if [ ${#ssh_agent_pid[*]} -gt 4 ];
	then
		_remove=$(expr ${#ssh_agent_pid[*]} - 4)
		printf "Found: ${#ssh_agent_pid[*]}\n"
		printf "Removing, ${_remove}\n"
		remove_zombies ${_remove}
	fi
}

usage(){
	printf "\033[36mUSAGE:\033[0m\n"
	printf "\033[35m$0 \033[32m--action=\033[36m[flush|free|trunc]\033[0m\n"
}

commands(){
	printf "\033[36mCOMMANDS:\033[0m\n"
	printf "\033[35mEliminate Zombies\t\033[32mflush, free, trunc\033[0m\n"
	printf "\n"
}

help_menu(){
	printf "\033[36mSSH Agent Wrapper\033[0m\n"
	printf "\033[35mSet Action\t\t\033[32m[ action ]\033[0m\n"
	commands
	usage
	exit 0
}

for args in $@
do
	case $args in
		--action=*|action:*)
		_action=$(echo "$args" | cut -d':' -f2 | cut -d'=' -f2)
		;;
		-h|-help|--help) help_menu;;
	esac
done

case $_action in
	flush|trunc|free) execute_zombie_removal;;
	*)error "Missing or invalid parameter was given";;
esac
