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
    Be sure that you kill/exit most forks with manual tests + 'pgrep philo | xargs kill' before you go ahead.
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

# not needed since VM not used anymore + School's computers on Linux
if [ "$(uname -s)" != "Linux" ]
then
	echo -ne $RED
	echo "/!\ WARNING /!\\

You're on Mac OS, valgrind cannot be properly implemented here.
Go on the VM and run 'bash leak_test.sh'.
You MUST do it, in order to thoroughly test the leaks.
A philosopher that leaks is a philosopher that deserves a zero.

/!\ WARNING /!\\"
	echo -ne $WHITE
	exit
elif ! command -v valgrind &> /dev/null
then
    echo -n "Installing valgrind..."
	sudo apt install valgrind &> install.log
	echo "complete."
fi

echo
echo -ne $CYAN
echo "Running leak tests, check leak.log once they are finished
Do not hesitate to test the leaks with other values using the 'valgrind.sh' script."
echo -ne $WHITE
echo

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

# 1. Create ProgressBar function
# 1.1 Input is currentState($1) and totalState($2)
function ProgressBar {
# Process data
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
# Build progressbar string lengths
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

# 1.2 Build progressbar strings and print the ProgressBar line
# 1.2.1 Output example:                           
# 1.2.1.1 Progress : [########################################] 100%
printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"

}

progress-bar() {
  local duration=${1}


    already_done() { for ((done=0; done<$elapsed; done++)); do printf "▇"; done }
    remaining() { for ((remain=$elapsed; remain<$duration; remain++)); do printf " "; done }
    percentage() { printf "| %s%%" $(( (($elapsed)*100)/($duration)*100/100 )); }
    clean_line() { printf "\r"; }

  for (( elapsed=1; elapsed<=$duration; elapsed++ )); do
      already_done; remaining; percentage
      sleep 1
      clean_line
  done
#   clean_line
}

NB=0
while (( NB < ${#a_philo[@]} ))
do
	philo="${a_philo[$NB]}"
	philo_dir="${a_dir[$NB]}"/
	echo
	echo -ne $CYAN
	echo $philo
	echo -ne $WHITE

    rm order_test_$philo.log

	echo -ne $GREEN
	echo ARGS 5 800 200 200
	echo -ne $WHITE
	# 5 800 200 200 -> first test values of correction, philosophers are not supposed to die

	av_1=5
	av_2=800
	av_3=200
	av_4=200
    ./../$philo_dir$philo $av_1 $av_2 $av_3 $av_4 &> order_test_$philo.log &
    # sleep 10
	echo -e $CYAN
	progress-bar 10
	echo -ne $WHITE
	echo
	echo "killing " $(pgrep philo)
    pgrep philo | xargs kill
	
	# sleep 2
	input="./order_test_$philo.log"
	previous=0
	error=0
	i=1
	_end=$(cat order_test_$philo.log | wc -l)
	if (( _end == 0 ))
	then
		error=2
	fi
    while IFS= read -r line; 
    do 
		# echo "$line" | cut -d " " -f 1
		echo -e $GREEN
		ProgressBar ${i} ${_end}
		echo -ne $WHITE
		current=$(echo "$line" | cut -d " " -f 1)
		if (( current < previous ))
		then
			echo -e $RED
			echo "ERROR : " "$current" " timestamp appears after " "$previous" " timestamp"
			echo -ne $WHITE
			error=1
			break ;
		fi
		previous=$(echo $current)
		(( i++ ))
    done < "$input"
	if (( error == 1 ))
	then
		echo -e $RED
		echo -n "TEST FAILED "
		echo -e "\033[0;31m x	\033[0m"
		echo "
If it is because of your output's format, please refer to the subject :

Any state change of a philosopher must be formatted as follows:
◦ timestamp_in_ms X has taken a fork
◦ timestamp_in_ms X is eating
◦ timestamp_in_ms X is sleeping
◦ timestamp_in_ms X is thinking
◦ timestamp_in_ms X died
Replace timestamp_in_ms with the current timestamp in milliseconds
and X with the philosopher number.

If it is because your timestamps are indeed not printing in the right order, please remember that time doesn't go backwards.
"
		echo -ne $WHITE
	elif (( error == 2 ))
	then
		echo -e $RED
		echo -n "TEST FAILED "
		echo -e "\033[0;31m x	\033[0m"
		echo "
For some reason, no output was caught for this philo, rerun tests outside of tester to check.
"
		echo -ne $WHITE
	else
		echo -e $GREEN
		echo -n "SUCCESS "
		echo -e "\033[0;32m \xE2\x9C\x94	\033[0m"
		echo -ne $WHITE
	fi
    ((NB++))
done