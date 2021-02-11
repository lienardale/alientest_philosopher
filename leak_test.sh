#!/bin/bash

if [ "$(uname -s)" != "Linux" ]
then
	cut_0=5
	cut_1=6
	cut_2=7
	cut_3=8
	RED="\033[91m"
	GREEN="\033[92m"
	YELLOW="\033[93m"
	BLUE="\033[94m"
	PURPLE="\033[95m"
	CYAN="\033[96m"
	WHITE="\033[97m"
else
	cut_0=4
	cut_1=5
	cut_2=6
	cut_3=7
	RED="\e[91m"
	GREEN="\e[92m"
	YELLOW="\e[93m"
	BLUE="\e[94m"
	PURPLE="\e[95m"
	CYAN="\e[96m"
	WHITE="\e[97m"
fi

echo -e $YELLOW
echo "If you are still developing and this tester causes you to have multiple processes still alive, use this to kill them :
 ' ps aux | grep -ie YOUR_PHILO_NAME | awk '{print $2}' | xargs kill -9 ' "
echo -e $WHITE

echo -e $YELLOW
echo "If you want to test all philo -> 'bash leak_test.sh'
To test only philo_one : 'bash leak_test.sh 1'
To test only philo_two : 'bash leak_test.sh 2'
To test only philo_three : 'bash leak_test.sh 3'"
echo -e $WHITE

echo
echo -ne $CYAN
echo "To test leaks, check leak.log, if no valgrind, re-run script on VM and consider only these tests' results."
echo -ne $WHITE
echo

make -C ../philo_one
make -C ../philo_two
make -C ../philo_three

if [ "$1" == "1" ];
then
	PHILOSOPHES=( philo_one )
elif [ "$1" == 2 ];
then
	PHILOSOPHES=( philo_two )
elif [ "$1" == 3 ];
then
	PHILOSOPHES=( philo_three )
else
	PHILOSOPHES=( philo_one philo_two philo_three )
fi

rm leak.log

for leak in ${PHILOSOPHES[*]}
do 
	philo=$leak

	echo -ne $GREEN >> leak.log
	echo $philo >> leak.log
	echo -ne $WHITE >> leak.log
	av_1=2
	av_2=10
	av_3=5
	av_4=5
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./../$philo/$philo $av_1 $av_2 $av_3 $av_4 2>> leak.log
	av_1=2
	av_2=10000
	av_3=5000
	av_4=5
	av_5=1
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./../$philo/$philo $av_1 $av_2 $av_3 $av_4 $av_5 2>> leak.log
done 

echo
echo -ne $CYAN
echo "Valgrind tests finished to execute, check leak.log :
- any HEAP SUMMARY that doesnt say 
	'in use at exit: 0 bytes in 0 blocks'
	and
	'All heap blocks were freed -- no leaks are possible'
	
	means that the program is leaking memory in some way or another.

- it IS possible to free the memory allocated by pthread_create with a proper use of pthread_join
as indicated in pthread_create's manual, RTFM

- Syscall errors caused by sem_open are a normal behavior"
echo -ne $WHITE
