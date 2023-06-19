#!/bin/bash

## required files array, declary files directory
req_files=("available_tasks.txt" "task_history.txt" "task_log.txt" "user_list.txt" "master_task_list.txt" "daily_task_list.txt" "weekly_task_list.txt" "monthly_task_list.txt" "bi_annual_task_list.txt")
files_dir=/opt/task_tracker/files

## check if fzf is installed, and install if needed
if [ $(dpkg-query -W -f='${Status}' fzf 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt-get install fzf
  echo "Installing necessary packages..."
  sleep 5
else 
  echo "fzf is alredy installed."
fi

## create /opt directories and populate required files
if [ -d /opt/task_tracker ]; then
  echo "task_tracker directory already exists"
else
 mkdir -p /opt/task_tracker
fi


if [ -d /opt/task_tracker/files ]; then
  echo "files directory exists"
else
  mkdir -p /opt/task_tracker/files
fi


for file in ${req_files[@]}
do
  if [ -f $files_dir/$file ]; then
    echo "file exists"
  else
    touch $files_dir/$file
    chmod 666 $files_dir/*
  fi
done

clear

while [ 1 ]
do
  option=$(echo -e  "Yes\n" "No" | fzf --prompt "Would you like to add a user?")
  if [ "$option" = "Yes" ]; then
    echo -e "\n\nDo not inlcude spaces! If a space is necessary, use an underscore.\n"
    echo "Enter user's name: "
    read user
    echo $user >> $files_dir/user_list.txt
  else
    break
  fi
done


while [ 1 ]
do
  option=$(echo -e "Yes\n" "No" | fzf --prompt "Would you like to add a task?")
  if [ "$option" = "Yes" ]; then
    echo -e "\n\nDo not include spaces! If a space is necessary, use an underscore.\n"
    echo "Which task would you like to add? "
    read task
    interval=$(echo -e "Daily\n" "Weekly\n" "Monthly\n" "Bi_annually" | fzf --prompt "Select a time interval for this task: ")
    if [ "$interval" = "Daily" ]; then
      echo $task >> $files_dir/master_task_list.txt
      echo $task >> $files_dir/daily_task_list.txt
    elif [ "$interval" = " Weekly" ]; then
      echo $task >> $files_dir/master_task_list.txt
      echo $task >> $files_dir/weekly_task_list.txt
    elif [ "$interval" = " Monthly" ]; then
      echo $task >> $files_dir/master_task_list.txt
      echo $task >> $files_dir/monthly_task_list.txt
    elif [ "$interval" = " Bi_annually" ]; then
      echo $task >> $files_dir/master_task_list.txt
      echo $task >> $files_dir/bi_annual_task_list.txt
    else
      echo "continue" > /dev/null
    fi
  else
    break
  fi
done







## create options array in task_tracker.sh instead of using file
