#!/bin/bash
make -C ../philo_one
make -C ../philo_two
make -C ../philo_three

PHILOSOPHES=( philo_one philo_two philo_three )

for philosophe in ${PHILOSOPHES[*]}
do 
	# PHILO_ONE
	echo
	echo $philosophe
	philo=$philosophe

	echo ARGS 5 800 200 200 X
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
		test=$(cat test.log | grep eating | wc)
		ok=$(echo $test | grep $nb)
		if [ -z "$ok" ];
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
	echo ARGS 4 410 200 200 X
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
		test=$(cat test.log | grep eating | wc)
		ok=$(echo $test | grep $nb)
		if [ -z "$ok" ];
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
	echo ARGS 4 310 200 100 X
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
		# ok=$(echo $test | grep $nb)
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
done

echo "This tester is not enough to validate the project, remember to also test :
- norm
- leaks
- each program without a 5th argument"