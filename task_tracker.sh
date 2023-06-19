#!/bin/bash


## define location of lists
working_dir=/opt/task_tracker/files
master_task_list=$working_dir/master_task_list.txt
daily_task_list=$working_dir/daily_task_list.txt
weekly_task_list=$working_dir/weekly_task_list.txt
monthly_task_list=$working_dir/monthly_task_list.txt
bi_annual_task_list=$working_dir/bi_annual_task_list.txt
user_list=$working_dir/user_list.txt
options_list=$working_dir/options.txt



## populate arrays from task and user lists
readarray tasks < $master_task_list
readarray daily_tasks < $daily_task_list
readarray weekly_tasks < $weekly_task_list
readarray monthly_tasks < $monthly_task_list
readarray bi_annual_tasks < $bi_annual_task_list
readarray users < $user_list

echo "Task Tracker is Ready!"
sleep 1
clear

while [ 1 ]
do

  ## Select user
  user=$(cat $user_list | fzf --prompt "Enter User: ")

  ## get current date and time for comparing current time to the time the task was last completed.
  current_date=$(date +%s)

  ## get date for task log, makes it easier for humans to read.
  log_date=$(date | awk '{print $1, $2, $3, $4}')

  ## Clear available_tasks.txt list
  > $working_dir/available_tasks.txt


  ## Populate available tasks with daily tasks
  for task in "${daily_tasks[@]}"
    do
      previous_date=$(grep $task $working_dir/task_history.txt | awk '{print $1}')
      if [ $((current_date-previous_date)) -ge $((24*60*60)) ]; then
          echo $task >> $working_dir/available_tasks.txt
        else
          echo "Task does not need to be completed" > /dev/null
      fi

    done


  ## Populate available tasks with weekly tasks
  for task in "${weekly_tasks[@]}"
    do
      previous_date=$(grep $task $working_dir/task_history.txt | awk '{print $1}')
      if [ $((current_date-previous_date)) -ge $((24*7*60*60)) ]; then
          echo $task >> $working_dir/available_tasks.txt
        else
          echo "Task does not need to be completed" > /dev/null
      fi

    done


  ## Populate available tasks with monthly tasks
  for task in "${monthly_tasks[@]}"
    do
      previous_date=$(grep $task $working_dir/task_history.txt | awk '{print $1}')
      if [ $((current_date-previous_date)) -ge $((24*30*60*60)) ]; then
          echo $task >> $working_dir/available_tasks.txt
        else
          echo "Task does not need to be completed" > /dev/null
      fi

    done


  ## Populate available tasks with bi-annual tasks
  for task in "${bi_annual_tasks[@]}"
    do
      previous_date=$(grep $task $working_dir/task_history.txt | awk '{print $1}')
      if [ $((current_date-previous_date)) -ge $((24*180*60*60)) ]; then
          echo $task >> $working_dir/available_tasks.txt
        else
          echo "Task does not need to be completed" > /dev/null
      fi

    done


  ## select available task and append history and task log
  chosen_task=$(cat $working_dir/available_tasks.txt | fzf --prompt "Which task do you want to complete: ")

  echo "$current_date $user $chosen_task" >> $working_dir/task_history.txt


  echo -e "$user will complete $chosen_task\n"
  echo "$log_date : $user : $chosen_task" >> $working_dir/task_log.txt
  sleep 2


  ## present option to select another task or QUIT
  option=$(echo -e "QUIT\n" "Choose another task" | fzf --prompt "Would you like to choose another task? ")
  if [ "$option" = "QUIT" ]; then
      exit
    else
      echo "continue" > /dev/null
  fi


done

