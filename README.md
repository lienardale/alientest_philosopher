# alientest_philosopher

Clone this repo at your philosopher's root (at the same level of your philo_one, philo_two and philo_three directories).

Usage : 'bash test.sh'

How to read the output : 
	green tick : test passed
	red cross : test failed

This tester is not enough to validate the project, remember to also test :
- norm
- leaks
- each program without a 5th argument

To run only one test or valgrind with your own args, you can use :
- bash one.sh 
- bash valgrind.sh
with the same args as if you were executing one of your philosophers + the nb of the philo you want to test as the first arg

ex : "bash one.sh 1 2 10 5 5" (launches ./philo_one 2 10 5 5)