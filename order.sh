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
    stdbuf -oL ./../$philo_dir$philo $av_1 $av_2 $av_3 $av_4 | 
    while read -r line; 
    do 
        echo "$line" >> order_test_$philo.log 
    done &

    # PID=$(pgrep $philo)
    sleep 10
    pgrep philo | xargs kill
    # for one in ${PID[*]}
    # do
    #     kill "$one"
    #     echo "process " "$one" " killed"
	# done
    ((NB++))
done