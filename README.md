# task_tracker

Bash script to track simple tasks. Allows multiple users, and custom tasks. Tracks tasks on 4 time intervals. Daily, Weekly, Monthly, and Bi_Annually.

I installed it on my kid's desktop for them to track thier chores. It's been a great use case.

# Requirements

fzf package is required for this script. [apt-get install fzf]

# Initial setup notes

If your using a debian based system, set-up is simple. Run the "setup.sh" script with root privileges. fzf will be installed and the necessary files and directories will be created for you in the /opt directory. The script will alter the permissions of the necessary files, so that the task_tracker can be run by any user, and update/pull from the same list of tasks.

You will be prompted to input any user(s) and tasks.

You will be prompted to select the time interval for each task as well. 

After the initial execution of the setup script, it can be executed again without root privileges to add users or tasks.

# Additional notes

Script still needs some work. When I get some time, I plan on adding additional features. Such as removing tasks and users via the setup script.  

For now, to remove tasks, access the /opt/task_tracker/files/ directory, and remove the tasks from the master_task_list and associated time interval list. The user_list can also be found in this directory.
