#!/bin/bash

option="${1}"
process=[PROCESS_OR_PROGRAM]
logfile=[LOGFILE]

error(){
	printf "\033[35mError:\t\033[31m${1}\033[0m\n"
	exit 1
}

getpid(){
	_pid=$(ps axww | egrep "${process}" | egrep -v 'grep' | awk '{print $1}')
	if [ ! -z "${_pid}" ];
	then
		echo ${_pid}
	else
		echo 0
	fi
}

kill_proc(){
	if [ `getpid` -gt 0 ];
	then
		printf "`getpid`\n"
		kill -9 "`getpid`"
		read -p "Remove old logs? [yes, no] " _confirm
		case $_confirm in
			y|yes) [ -e "${logfile}" ] && rm ${logfile};;
			*) printf "\033[35mExiting, no action was taken\033[0m\n";;
		esac
	else
		printf "No running process for ${process} was found.\n"
	fi
}

start_proc(){
	if [ `getpid` -eq 0 ];
	then
		printf "Starting, process ${process} as daemon.\n"
		nohup ${process} >> ${logfile} &> /dev/null &
		printf "Done\n"
	else
		printf "\033[35mProcess already running \033[32m[`getpid`]\033[0m\n"
	fi
}

query_proc(){
	if [ `getpid` -eq 0 ];
	then
		printf "No process running for ${process}\n"
	else
		printf "Process (${process}) running\nPID [`getpid`]\n"
	fi
}

help_menu(){
	printf "\033[36mProcess Daemonizer\033[0m\n"
	printf "\033[35mStart Process\t\033[32m[ -s, -start, --start ]\033[0m\n"
	printf "\033[35mKill Process\t\033[32m[ -k, -kill, --kill ]\033[0m\n"
	printf "\033[35mQuery Process\t\033[32m[ -q, -query, --query ]\033[0m\n"
	printf "\033[35mHelp Menu\t\033[32m[ -h, -help, --help ]\033[0m\n"
	exit 0
}

case ${option} in
	-s|-start|--start) start_proc;;
	-k|-kill|--kill) kill_proc;;
	-q|-query|--query) query_proc;;
	-h|-help|--help) help_menu;;
	*) error "Missing or invalid parameter was given";;
esac
