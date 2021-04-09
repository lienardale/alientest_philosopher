
read  -n 1 -p "
Usage : bash valgrind.sh philo_one_or_two_or_three (1 for philo_one, 2 for philo_two, 3 for philo_three) Nb_philo T_to_die T_to_eat T_to_sleep

ex : bash valgrind.sh 1 2 10 5 5 -> (launches valgrind ./philo_one 2 10 5 5)

if you dit it right, press enter, if not, ctrl+C
" input

if [ "$1" == "1" ];
then
	philo="philo_one"
elif [ $1 == 2 ];
then
	philo="philo_two"
elif [ $1 == 3 ];
then
	philo="philo_three"
fi

make -C ../$philo

if [ "$6" != "" ];
then
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./../$philo/$philo $2 $3 $4 $5 $6 2>tmp_leak.log
	cat tmp_leak.log
	test=$(cat tmp_leak.log | grep lost)
	if [ ! -z "$test" ];
	then
		echo -ne $RED
		echo -n "	----->	leaks :"
		echo -ne $WHITE
		echo -e "\033[0;31m x	\033[0m"
		echo -ne $RED
		echo "Check tmp_leak.log for detail, nothing should be lost in any way."
		echo -ne $WHITE
	else
		echo -ne $GREEN
		echo -n "	----->	leaks :"
		echo -ne $WHITE
		echo -e "\033[0;32m \xE2\x9C\x94	\033[0m"
	fi
else
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./../$philo/$philo $2 $3 $4 $5 2>tmp_leak.log
	cat tmp_leak.log
	test=$(cat tmp_leak.log | grep lost)
	if [ ! -z "$test" ];
	then
		echo -ne $RED
		echo -n "	----->	leaks :"
		echo -ne $WHITE
		echo -e "\033[0;31m x	\033[0m"
		echo -ne $RED
		echo "Check tmp_leak.log for detail, nothing should be lost in any way."
		echo -ne $WHITE
	else
		echo -ne $GREEN
		echo -n "	----->	leaks :"
		echo -ne $WHITE
		echo -e "\033[0;32m \xE2\x9C\x94	\033[0m"
	fi
fi
