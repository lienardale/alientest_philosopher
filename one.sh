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

if [ $6 != "" ];
then
	./../$philo/$philo $2 $3 $4 $5 $6
else
	./../$philo/$philo $2 $3 $4 $5
fi
