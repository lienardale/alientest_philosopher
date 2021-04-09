#!/bin/bash

RED="\033[91m"
GREEN="\033[92m"
YELLOW="\033[93m"
BLUE="\033[94m"
PURPLE="\033[95m"
CYAN="\033[96m"
WHITE="\033[97m"

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
rm tmp_leak.log

for leak in ${PHILOSOPHES[*]}
do 
	philo=$leak

	echo -ne $CYAN
	echo Testing $philo
	echo -ne $WHITE

	echo >> leak.log
	echo $philo >> leak.log
	echo >> leak.log
	echo "Testing leaks with the death of one philosopher.">> leak.log
	echo >> leak.log

	echo -ne $GREEN
	echo "Testing leaks with the death of one philosopher."
	echo -ne $WHITE
	av_1=2
	av_2=10
	av_3=5
	av_4=5
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./../$philo/$philo $av_1 $av_2 $av_3 $av_4 2>tmp_leak.log
	cat tmp_leak.log >> leak.log
	test=$(cat tmp_leak.log | grep lost)
	if [ ! -z "$test" ];
	then
		echo -ne $RED
		echo -n "	----->	leaks :"
		echo -ne $WHITE
		echo -e "\033[0;31m x	\033[0m"
		echo -ne $RED
		echo "Check leak.log for detail, nothing should be lost in any way."
		echo -ne $WHITE
	else
		echo -ne $GREEN
		echo -n "	----->	leaks :"
		echo -ne $WHITE
		echo -e "\033[0;32m \xE2\x9C\x94	\033[0m"
	fi

	echo >> leak.log
	echo "Testing leaks with every philosopher eating at least one time.">> leak.log
	echo >> leak.log

	echo -ne $GREEN
	echo "Testing leaks with every philosopher eating at least one time."
	echo -ne $WHITE
	av_1=2
	av_2=10000
	av_3=5000
	av_4=5
	av_5=1
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./../$philo/$philo $av_1 $av_2 $av_3 $av_4 $av_5 2>tmp_leak.log
	cat tmp_leak.log >> leak.log
	test=$(cat tmp_leak.log | grep lost)
	if [ ! -z "$test" ];
	then
		echo -ne $RED
		echo -n "	----->	leaks :"
		echo -ne $WHITE
		echo -e "\033[0;31m x	\033[0m"
		echo -ne $RED
		echo "Check leak.log for detail, nothing should be lost in any way."
		echo -ne $WHITE
	else
		echo -ne $GREEN
		echo -n "	----->	leaks :"
		echo -ne $WHITE
		echo -e "\033[0;32m \xE2\x9C\x94	\033[0m"
	fi

	echo >> leak.log
	echo $philo >> leak.log
	echo >> leak.log
	echo "Testing leaks with only one philosopher.">> leak.log
	echo >> leak.log

	echo -ne $GREEN
	echo "Testing leaks with only one philosopher."
	echo -ne $WHITE
	av_1=1
	av_2=10
	av_3=5
	av_4=5
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./../$philo/$philo $av_1 $av_2 $av_3 $av_4 2>tmp_leak.log
	cat tmp_leak.log >> leak.log
	test=$(cat tmp_leak.log | grep lost)
	if [ ! -z "$test" ];
	then
		echo -ne $RED
		echo -n "	----->	leaks :"
		echo -ne $WHITE
		echo -e "\033[0;31m x	\033[0m"
		echo -ne $RED
		echo "Check leak.log for detail, nothing should be lost in any way."
		echo -ne $WHITE
	else
		echo -ne $GREEN
		echo -n "	----->	leaks :"
		echo -ne $WHITE
		echo -e "\033[0;32m \xE2\x9C\x94	\033[0m"
	fi

	echo >> leak.log
	echo $philo >> leak.log
	echo >> leak.log
	echo "Testing leaks with only one philosopher + av_5.">> leak.log
	echo >> leak.log

	echo -ne $GREEN
	echo "Testing leaks with only one philosopher + av_5."
	echo -ne $WHITE
	av_1=1
	av_2=10
	av_3=5
	av_4=5
	av_5=2
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./../$philo/$philo $av_1 $av_2 $av_3 $av_4 $av_5 2>tmp_leak.log
	cat tmp_leak.log >> leak.log
	test=$(cat tmp_leak.log | grep lost)
	if [ ! -z "$test" ];
	then
		echo -ne $RED
		echo -n "	----->	leaks :"
		echo -ne $WHITE
		echo -e "\033[0;31m x	\033[0m"
		echo -ne $RED
		echo "Check leak.log for detail, nothing should be lost in any way."
		echo -ne $WHITE
	else
		echo -ne $GREEN
		echo -n "	----->	leaks :"
		echo -ne $WHITE
		echo -e "\033[0;32m \xE2\x9C\x94	\033[0m"
	fi
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

- Syscall errors caused by sem_open are a normal behavior."
echo -ne $WHITE
