# alientest_philosopher

## Tester for 42_cursus "philosopher" project

## Usage
- Clone this repository **at the root** of your philosopher's directory **without changig its name**
```
git clone https://github.com/lienardale/alientest_philosopher.git && cd alientest_philosopher
```
- Run the script of your choosing (while remaining in the tester's dir)
```
bash all_test.sh
```

- ### It doesn't matter if you did the bonus or not, it's supposed to work either way (if not, dm me on slack @alienard)

- ### available tests
	- correction values (correction_test.sh)
	- leaks (leak_test.sh)
	- data-races (data_race_test.sh)
	- timestamp order (order.sh)
	- all of the above + norm (all_tests.sh)

- ### How to read the output : 
	green tick : test passed
	red cross : test failed

- ### check the log files :
	- norm
	- output
	- leaks
	- data_races

## Warnings
- This tester is not enough to validate the project, remember to also test :
	- each program without a 5th argument
	- check the coherence of the output
	- ask for explanations on the choices that were made and the issues encountered
- If you use this tester during this project
```
pgrep philo
```
will output the PID of every running philo process
```
pgrep philo | xargs kill
```
same but will also kill them

