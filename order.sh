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

# compiling
for compil in ${PHILO_DIRS[*]}
do
	make -C ../$compil
done

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

# lists from ls commands need to be cast into arrays for the while loop to work as intended 
a_dir=($PHILO_DIRS)
a_philo=($PHILOSOPHES)


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
		echo FAIL
		echo "
As the subject states it :

Any state change of a philosopher must be formatted as follows:
◦ timestamp_in_ms X has taken a fork
◦ timestamp_in_ms X is eating
◦ timestamp_in_ms X is sleeping
◦ timestamp_in_ms X is thinking
◦ timestamp_in_ms X died
Replace timestamp_in_ms with the current timestamp in milliseconds
and X with the philosopher number.
"
		echo -ne $WHITE
	elif (( error == 2 ))
	then
		echo -e $RED
		echo FAIL
		echo "
For some reason, no output was caught for this philo, rerun tests outside of tester to check.
"
		echo -ne $WHITE
	else
		echo -e $GREEN
		echo SUCCESS
		echo -ne $WHITE
	fi
    ((NB++))
done
