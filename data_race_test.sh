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

    You have selected tests for all philo, there is going to be a lot of forks involved for philo_three.
    Be sure that you kill/exit most forks with manual tests + ''ps -ef | philo' before you go ahead.
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

echo
echo -ne $CYAN
echo "Running data_race tests, check data_race.log once they are finished
Do not hesitate to test the data_races with other values using the 'valgrind.sh' script."
echo -ne $WHITE
echo

rm data_race.log
rm tmp_data_race.log

NB=0
while (( NB < ${#a_philo[@]} ))
do
	philo="${a_philo[$NB]}"
	philo_dir="${a_dir[$NB]}"/

	echo -ne $CYAN
	echo Testing $philo
	echo -ne $WHITE

	echo >> data_race.log
	echo $philo >> data_race.log
	echo >> data_race.log
	echo "Testing data_races with the death of one philosopher.">> data_race.log
	echo >> data_race.log

	echo -ne $GREEN
	echo "Testing data_races with the death of one philosopher."
	echo -ne $WHITE
	av_1=2
	av_2=10
	av_3=5
	av_4=5
	valgrind --tool=helgrind ./../$philo_dir$philo $av_1 $av_2 $av_3 $av_4 2>tmp_data_race.log
	cat tmp_data_race.log >> data_race.log
	test=$(cat tmp_data_race.log | grep "data race")
	if [ ! -z "$test" ];
	then
		echo -ne $RED
		echo -n "	---->	data_races :"
		echo -ne $WHITE
		echo -e "\033[0;31m x	\033[0m"
	else
		echo -ne $GREEN
		echo -n "	---->	data_races :"
		echo -ne $WHITE
		echo -e "\033[0;32m \xE2\x9C\x94	\033[0m"
	fi

	echo >> data_race.log
	echo "Testing data_races with every philosopher eating at least one time.">> data_race.log
	echo >> data_race.log

	echo -ne $GREEN
	echo "Testing data_races with every philosopher eating at least one time."
	echo -ne $WHITE
	av_1=2
	av_2=10000
	av_3=5000
	av_4=5
	av_5=1
	valgrind --tool=helgrind ./../$philo_dir$philo $av_1 $av_2 $av_3 $av_4 $av_5 2>tmp_data_race.log
	cat tmp_data_race.log >> data_race.log
	test=$(cat tmp_data_race.log | grep "data race")
	if [ ! -z "$test" ];
	then
		echo -ne $RED
		echo -n "	---->	data_races :"
		echo -ne $WHITE
		echo -e "\033[0;31m x	\033[0m"
	else
		echo -ne $GREEN
		echo -n "	---->	data_races :"
		echo -ne $WHITE
		echo -e "\033[0;32m \xE2\x9C\x94	\033[0m"
	fi

	echo >> data_race.log
	echo $philo >> data_race.log
	echo >> data_race.log
	echo "Testing data_races with only one philosopher.">> data_race.log
	echo >> data_race.log

	echo -ne $GREEN
	echo "Testing data_races with only one philosopher."
	echo -ne $WHITE
	av_1=1
	av_2=10
	av_3=5
	av_4=5
	valgrind --tool=helgrind ./../$philo_dir$philo $av_1 $av_2 $av_3 $av_4 2>tmp_data_race.log
	cat tmp_data_race.log >> data_race.log
	test=$(cat tmp_data_race.log | grep "data race")
	if [ ! -z "$test" ];
	then
		echo -ne $RED
		echo -n "	---->	data_races :"
		echo -ne $WHITE
		echo -e "\033[0;31m x	\033[0m"
	else
		echo -ne $GREEN
		echo -n "	---->	data_races :"
		echo -ne $WHITE
		echo -e "\033[0;32m \xE2\x9C\x94	\033[0m"
	fi

	echo >> data_race.log
	echo $philo >> data_race.log
	echo >> data_race.log
	echo "Testing data_races with only one philosopher + av_5.">> data_race.log
	echo >> data_race.log

	echo -ne $GREEN
	echo "Testing data_races with only one philosopher + av_5."
	echo -ne $WHITE
	av_1=1
	av_2=10
	av_3=5
	av_4=5
	av_5=2
	valgrind --tool=helgrind ./../$philo_dir$philo $av_1 $av_2 $av_3 $av_4 $av_5 2>tmp_data_race.log
	cat tmp_data_race.log >> data_race.log
	test=$(cat tmp_data_race.log | grep "data race")
	if [ ! -z "$test" ];
	then
		echo -ne $RED
		echo -n "	---->	data_races :"
		echo -ne $WHITE
		echo -e "\033[0;31m x	\033[0m"
	else
		echo -ne $GREEN
		echo -n "	---->	data_races :"
		echo -ne $WHITE
		echo -e "\033[0;32m \xE2\x9C\x94	\033[0m"
	fi
	((NB++))
done

echo
echo -ne $CYAN
echo "Valgrind data_race tests finished to execute, check data_race.log"
echo -ne $WHITE