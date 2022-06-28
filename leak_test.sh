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
 ' pgrep YOUR_PHILO_NAME | xargs kill ' "
echo -ne $WHITE

echo -e $YELLOW
echo -n "If you want to test all philo / are not doing philo_bonus -> 'bash test.sh'
To test only one philo (if you are doing the bonus) : -> bash test.sh YOUR_DIRECTORY
Exemple : bash test.sh philo_bonus"
echo -ne $WHITE


# Setting up lists for directories and executables
DIR=$(ls ../ | grep Makefile)
var="$1"
if [ -n "$var" ]
then
	PHILOSOPHES=$1
else
    echo -e $RED
    read  -n 1 -p "
/!\ WARNING /!\\

    You have selected tests for all philo, there is going to be a lot of forks involved for philo_three / philo_bonus.
    Be sure that you kill/exit most forks with manual tests + ''pgrep | philo' before you go ahead.
    Otherwise, it could make your machine crash.

    If you are sure, press enter, if not, ctrl+C

/!\ WARNING /!\\
" input
    echo -ne $WHITE
	if [ -z "$DIR" ];
	then
		PHILOSOPHES=$(ls ../ | grep -v "README" | grep -v alientest_philosopher)
		PHILO_DIRS=$(ls ../ | grep -v "README" | grep -v alientest_philosopher)
	else
		PHILOSOPHES="philo"
		PHILO_DIRS="."
	fi
fi
if [ -n "$var" ]
then
	PHILO_DIRS=$1
fi

# cleaning
for clean in ${PHILO_DIRS[*]}
do
	make -C ../$clean fclean
done

# compiling
for compil in ${PHILO_DIRS[*]}
do
	make -C ../$compil
done

# lists from ls commands need to be cast into arrays for the while loop to work as intended 
a_dir=($PHILO_DIRS)
a_philo=($PHILOSOPHES)

rm leak.log
rm tmp_leak.log

NB=0
while (( NB < ${#a_philo[@]} ))
do
	philo="${a_philo[$NB]}"
	philo_dir="${a_dir[$NB]}"/

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
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./../$philo_dir$philo $av_1 $av_2 $av_3 $av_4 2>tmp_leak.log
	cat tmp_leak.log >> leak.log
	test=$(cat tmp_leak.log | grep lost)
	if [ ! -z "$test" ];
	then
		echo -ne $RED
		echo -n "	---->	leaks :"
		echo -ne $WHITE
		echo -e "\033[0;31m x	\033[0m"
	else
		echo -ne $GREEN
		echo -n "	---->	leaks :"
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
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./../$philo_dir$philo $av_1 $av_2 $av_3 $av_4 $av_5 2>tmp_leak.log
	cat tmp_leak.log >> leak.log
	test=$(cat tmp_leak.log | grep lost)
	if [ ! -z "$test" ];
	then
		echo -ne $RED
		echo -n "	---->	leaks :"
		echo -ne $WHITE
		echo -e "\033[0;31m x	\033[0m"
	else
		echo -ne $GREEN
		echo -n "	---->	leaks :"
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
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./../$philo_dir$philo $av_1 $av_2 $av_3 $av_4 2>tmp_leak.log
	cat tmp_leak.log >> leak.log
	test=$(cat tmp_leak.log | grep lost)
	if [ ! -z "$test" ];
	then
		echo -ne $RED
		echo -n "	---->	leaks :"
		echo -ne $WHITE
		echo -e "\033[0;31m x	\033[0m"
	else
		echo -ne $GREEN
		echo -n "	---->	leaks :"
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
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./../$philo_dir$philo $av_1 $av_2 $av_3 $av_4 $av_5 2>tmp_leak.log
	cat tmp_leak.log >> leak.log
	test=$(cat tmp_leak.log | grep lost)
	if [ ! -z "$test" ];
	then
		echo -ne $RED
		echo -n "	---->	leaks :"
		echo -ne $WHITE
		echo -e "\033[0;31m x	\033[0m"
	else
		echo -ne $GREEN
		echo -n "	---->	leaks :"
		echo -ne $WHITE
		echo -e "\033[0;32m \xE2\x9C\x94	\033[0m"
	fi
	((NB++))
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