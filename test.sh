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
echo "If you want to test all philo -> 'bash test.sh'
To test only philo_one : 'bash test.sh 1'
To test only philo_two : 'bash test.sh 2'
To test only philo_three : 'bash test.sh 3'"
echo -e $WHITE

echo "Testing Norm"
norm=$(~/.norminette/norminette.rb ../ | grep Error)
if [ -z "$norm" ];
then
	echo -n "Norm :"
	echo -ne "\033[0;32m \xE2\x9C\x94	\033[0m"
else
	echo -n "Norm :"
	echo -ne "\033[0;31m x	\033[0m"
	echo $norm
fi
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

for philosophe in ${PHILOSOPHES[*]}
do 
	echo
	echo -ne $CYAN
	echo $philosophe
	echo -ne $WHITE
	philo=$philosophe

	echo -ne $GREEN
	echo ARGS 5 800 200 200 X
	echo -ne $WHITE
	# 5 800 200 200

	av_1=5
	av_2=800
	av_3=200
	av_4=200
	av_5=1

	while [ $av_5 -le 10 ]
	do
		./../$philo/$philo $av_1 $av_2 $av_3 $av_4 $av_5 > test.log 
		nb=$(( av_1*av_5 ))
		test=$(cat test.log | grep eating | wc | cut -b $cut_2,$cut_3)
		if [ "$test" -lt "$nb" ];
		then
			echo -n "Test $av_5 :"
			echo -ne "\033[0;31m x	\033[0m"
		else
			echo -n "Test $av_5 :"
			echo -ne "\033[0;32m \xE2\x9C\x94	\033[0m"
		fi
		av_5=$(( $av_5 + 1 ))
	done

	echo
	echo -ne $GREEN
	echo ARGS 4 410 200 200 X
	echo -ne $WHITE
	# 4 410 200 200

	av_1=4
	av_2=410
	av_3=200
	av_4=200
	av_5=1

	while [ $av_5 -le 10 ]
	do
		./../$philo/$philo $av_1 $av_2 $av_3 $av_4 $av_5 > test.log 
		nb=$(( av_1*av_5 ))
		test=$(cat test.log | grep eating | wc | cut -b $cut_2,$cut_3)
		if [ "$test" -lt "$nb" ];
		then
			echo -n "Test $av_5 :"
			echo -ne "\033[0;31m x	\033[0m"
		else
			echo -n "Test $av_5 :"
			echo -ne "\033[0;32m \xE2\x9C\x94	\033[0m"
		fi
		av_5=$(( $av_5 + 1 ))
	done

	echo
	echo -ne $GREEN
	echo ARGS 4 310 200 100 X
	echo -ne $WHITE
	# 4 310 200 100

	av_1=4
	av_2=310
	av_3=200
	av_4=100
	av_5=2

	while [ $av_5 -le 11 ]
	do
		./../$philo/$philo $av_1 $av_2 $av_3 $av_4 $av_5 > test.log 
		nb=$(( av_1*av_5 ))
		test=$(cat test.log | grep died)
		if [ -z "$test" ];
		then
			echo -n "Test $av_5 :"
			echo -ne "\033[0;31m x	\033[0m"
		else
			echo -n "Test $(( $av_5 - 1 )) :"
			echo -ne "\033[0;32m \xE2\x9C\x94	\033[0m"
		fi
		av_5=$(( $av_5 + 1 ))
	done

	echo
	echo -ne $GREEN
	echo GOING BIG 50 1300 100 100 X
	echo -ne $WHITE

	av_1=50
	av_2=1300
	av_3=100
	av_4=100
	av_5=1

	while [ $av_5 -le 10 ]
	do
		./../$philo/$philo $av_1 $av_2 $av_3 $av_4 $av_5 > test.log 
		nb=$(( av_1*av_5 ))
		test=$(cat test.log | grep eating | wc | cut -b $cut_1,$cut_2,$cut_3)
		if [ "$test" -lt "$nb" ];
		then
			echo -n "Test $av_5 :"
			echo -ne "\033[0;31m x	\033[0m"
		else
			echo -n "Test $av_5 :"
			echo -ne "\033[0;32m \xE2\x9C\x94	\033[0m"
		fi
		av_5=$(( $av_5 + 1 ))
	done
	echo

	echo -ne $GREEN
	echo ONLY ONE PHILOSOPHE
	echo -ne $WHITE
	test=$(./../$philo/$philo 1 10 5 5 | grep died)
	if [ ! -z "$test" ];
	then
		echo -n "Test with only one philosophe - $philo :"
		echo -ne "\033[0;32m \xE2\x9C\x94	\033[0m"
	else
		echo -n "Test with only one philosophe - $philo :"
		echo -ne "\033[0;31m x	\033[0m"
	fi
	echo

	echo -ne $GREEN
	echo ONLY ONE PHILOSOPHE + av_5
	echo -ne $WHITE
	test=$(./../$philo/$philo 1 10 5 5 1 | grep died)
	if [ ! -z "$test" ];
	then
		echo -n "Test with only one philosophe + av5 - $philo :"
		echo -ne "\033[0;32m \xE2\x9C\x94	\033[0m"
	else
		echo -n "Test with only one philosophe + av5 - $philo :"
		echo -ne "\033[0;31m x	\033[0m"
	fi
	echo

	echo -ne $GREEN
	echo 200 PHILOSOPHES
	echo -ne $WHITE
	test=$(./../$philo/$philo 200 200 100 100 | grep died)
	if [ ! -z "$test" ];
	then
		echo -n "Test 200 philosophes - $philo :"
		echo -ne "\033[0;32m \xE2\x9C\x94	\033[0m"
	else
		echo -n "Test 200 philosophes + av5 - $philo :"
		echo -ne "\033[0;31m x	\033[0m"
	fi
	echo

	echo -ne $CYAN
	echo "This one is heavy, if fail, rerun it outside of script to check."
	echo -ne $WHITE
	echo -ne $GREEN
	echo 200 PHILOSOPHES + av_5
	echo -ne $WHITE
	test=$(./../$philo/$philo 200 13000 100 100 10 | grep eating | wc | cut -b $cut_0,$cut_1,$cut_2,$cut_3)
	if [ "$test" -ge 2000 ];
	then
		echo -n "Test 200 philosophes + av5 - $philo :"
		echo -ne "\033[0;32m \xE2\x9C\x94	\033[0m"
	else
		echo -n "Test 200 philosophes + av5 - $philo :"
		echo -ne "\033[0;31m x	\033[0m"
	fi
	echo

done

echo
echo -ne $CYAN
echo "To test leaks, check leak.log, if no valgrind, run 'bash leak_test.sh' on VM and consider only these tests' results."
echo -ne $WHITE
echo

rm leak.log

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
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./../$philo/$philo $av_1 $av_2 $av_3 $av_4 2>> leak.log

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
