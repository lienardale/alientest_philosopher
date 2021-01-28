

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
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./../$philo/$philo $2 $3 $4 $5 $6
else
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./../$philo/$philo $2 $3 $4 $5
fi