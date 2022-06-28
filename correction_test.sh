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

# testing norm
echo "Testing Norm"
norm=$(norminette ../ | grep Error)
if [ -z "$norm" ];
then
	echo -n "Norm :"
	echo -ne "\033[0;32m \xE2\x9C\x94	\033[0m"
else
	echo -n "Norm :"
	echo -ne "\033[0;31m x	\033[0m"
	echo $norm > norm.log
	echo "Check norm.log for detail."
fi
echo

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


NB=0
while (( NB < ${#a_philo[@]} ))
do
	echo
	philo="${a_philo[$NB]}"
	philo_dir="${a_dir[$NB]}"/
	echo -ne $CYAN
	echo $philo
	echo -ne $WHITE

	echo -ne $GREEN
	echo ARGS 5 800 200 200 X
	echo -ne $WHITE
	# 5 800 200 200 -> first test values of correction, philosophers are not supposed to die

	av_1=5
	av_2=800
	av_3=200
	av_4=200
	av_5=1
	# we use an av_5 so we can count the 'eating' nb, since it is a standardised output mentionned in the subject
	# av_5 will go from 1 to 10
	while [ $av_5 -le 10 ]
	do
		./../$philo_dir$philo $av_1 $av_2 $av_3 $av_4 $av_5 > test.log
		# nb is av_1 * av_5 : the minimum number of times the 'eating' output is supposed to be printed
		nb=$(( av_1*av_5 ))
		# we use wc -l to count the number of 'eating' that were actualy present in the output
		# note that it is not tested whether these 'eating' correspond to each philosopher, as it is asked for in the subject.
		# you need to check that manually, try with low number of philosopher, or redirect the output in a log file so you can check thoroughly
		test=$(cat test.log | grep eating | wc -l)
		# we check if test < nb
		if [ "$test" -lt "$nb" ];
		then
			# if it is, then all philo cannot have eaten at least av_5 times
			echo -n "Test $av_5 :"
			echo -ne "\033[0;31m x	\033[0m"
		else
			# otherwise, we consider the test passed
			echo -n "Test $av_5 :"
			echo -ne "\033[0;32m \xE2\x9C\x94	\033[0m"
		fi
		# we increment av_5 value
		av_5=$(( $av_5 + 1 ))
	done

	echo
	echo -ne $GREEN
	echo ARGS 4 410 200 200 X
	echo -ne $WHITE
	# 4 410 200 200 -> second test values of correction, philosophers are not supposed to die

	av_1=4
	av_2=410
	av_3=200
	av_4=200
	av_5=1

	while [ $av_5 -le 10 ]
	do
		./../$philo_dir$philo $av_1 $av_2 $av_3 $av_4 $av_5 > test.log
		nb=$(( av_1*av_5 ))
		test=$(cat test.log | grep eating | wc -l)
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
	# 4 310 200 100 -> third test values of correction, one philo is supposed to die

	av_1=4
	av_2=310
	av_3=200
	av_4=100
	av_5=2

	# here, we search for 'died' in the output, since it is a standardised output mentionned in the subject
	while [ $av_5 -le 11 ]
	do
		./../$philo_dir$philo $av_1 $av_2 $av_3 $av_4 $av_5 > test.log
		# in this test, nb=1, since one, and only one philo is supposed to die
		nb=1
		test=$(cat test.log | grep died | wc -l)
		# we check if test == nb
		if [ "$test" -eq "$nb" ];
		then
			# if it is, we consider the test passed
            echo -n "Test $(( $av_5 - 1)) :"
			echo -ne "\033[0;32m \xE2\x9C\x94	\033[0m"
		else
			# if it is not, it can mean that :
				#	- there is a typo in the death output, it is mentionned in the subject that 'died' is supposed to appear in it
				# 	- no philosopher died (and something is wrong, you can grade 0 for this)
				# 	- more than one philosopher died (and it is a mistake, you can grade 0 for this)
                echo -n "Test $(( $av_5 - 1 )) :"
			echo -ne "\033[0;31m x	\033[0m"
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
# with these values, philosophers are not supposed to die
	while [ $av_5 -le 10 ]
	do
		./../$philo_dir$philo $av_1 $av_2 $av_3 $av_4 $av_5 > test.log
		nb=$(( av_1*av_5 ))
		test=$(cat test.log | grep eating | wc -l)
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
# the purpose of this test is to check if there is no deadlock/segfault, you can choose a different output than 'died'
	echo -ne $GREEN
	echo ONLY ONE PHILOSOPHE
	echo -ne $WHITE
	test=$(./../$philo_dir$philo 1 10 5 5 | grep died)
	if [ ! -z "$test" ];
	then
		echo -n "Test with only one philosophe - $philo :"
		echo -ne "\033[0;32m \xE2\x9C\x94	\033[0m"
	else
		echo -n "Test with only one philosophe - $philo :"
		echo -ne "\033[0;31m x	\033[0m"
		echo "the purpose of this test is to check if there is no deadlock/segfault with only one philosopher, if there is a red cross and that the script continues to run, it usualy means it's ok"
	fi
	echo
# the purpose of this test is to check if there is no deadlock/segfault, you can choose a different output than 'died'
	echo -ne $GREEN
	echo ONLY ONE PHILOSOPHE + av_5
	echo -ne $WHITE
	test=$(./../$philo_dir$philo 1 10 5 5 1 | grep died)
	if [ ! -z "$test" ];
	then
		echo -n "Test with only one philosophe + av5 - $philo :"
		echo -ne "\033[0;32m \xE2\x9C\x94	\033[0m"
	else
		echo -n "Test with only one philosophe + av5 - $philo :"
		echo -ne "\033[0;31m x	\033[0m"
		echo "the purpose of this test is to check if there is no deadlock/segfault with only one philosopher, if there is a red cross and that the script continues to run, it usualy means it's ok"
	fi
	echo

	echo -ne $GREEN
	echo 200 PHILOSOPHES
	echo -ne $WHITE
	test=$(./../$philo_dir$philo 200 200 100 100 | grep died)
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
	test=$(./../$philo_dir$philo 200 13000 100 100 10 | grep eating | wc -l)
	if [ "$test" -ge 2000 ];
	then
		echo -n "Test 200 philosophes + av5 - $philo :"
		echo -ne "\033[0;32m \xE2\x9C\x94	\033[0m"
	else
		echo -n "Test 200 philosophes + av5 - $philo :"
		echo -ne "\033[0;31m x	\033[0m"
	fi
	echo
	((NB++))
done