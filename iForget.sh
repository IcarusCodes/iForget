#!/bin/bash
# The basis of the whole she-bang, the holy grail if you will:

# osascript -e 'display notification "Lorem ipsum dolor sit amet" with title "Title"'

# This will be added to a cron and triggered on the set date.
# The hard part will be the effective logic of time.

# Global Variables


# Colors and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
CYAN='\033[0;36m'
BOLD_CYAN='\033[1;36m'
BOLD_GREEN='\033[1;32m'
NEW_PS3=$'\e[01;32m>>> \e[0m'

#
##
### Utility
###########

assign_global()
{
local arg="$1"
IFS="" read -d "" $arg <<<"$2"
}



#
##           
### Doc Pages 
###############

### Print the help instructions
help_page()
{
echo -e "${BOLD_CYAN}#"
echo -e "##"
echo "###"
echo -e "#### iForget${NC} is a ${GREEN}fully customisable${NC} notification system.\n"
echo -e "You can ${BOLD_GREEN}easily:${NC}"
echo -e "\t-c, --create\t Create a one time or recurring notification."
echo -e "\t-e, --edit\t Edit an existing notification."
echo -e "\t-d, --delete\t Delete an existing notification."
echo -e "\t-l, --list\t List all of your notifications and their occurances."
echo -e "\t-h, --help\t Brings up this page."
echo -e "\t${RED}⌘q or ^C${NC}    \t At any time to quit the application."
}

### Check if the provided date is valid
validate_date()
{
if [[ $1 == [0-3][0-9]/[0-1][0-9]/[0-9][0-9][0-9][0-9] ]] ||
   [[ $1 == [0-3][0-9]-[0-1][0-9]-[0-9][0-9][0-9][0-9] ]] ||
   [[ $1 == [0-3][0-9].[0-1][0-9].[0-9][0-9][0-9][0-9] ]]; then
    echo "Something that will insert the cron. We also need a cron port"
#    eval ${n_date}="$1"
    trim_date=$(echo "$1" | xargs)
    assign_global n_date $trim_date
    echo "The trim date is: $trim_date"
    notify_once_hours_selector
else
    echo -e "${RED}\nInvalid date format.\n${NC}"
    notify_once_date_selector # Go back and try again
fi
}


### Check if the provided hours are valid
validate_hours()
{
echo "Sunt in hours si dau date: ${n_date}"
if [[ $1 == [0-3][0-4]:[0-5][0-9] ]] ||
   [[ $1 == [0-3][0-4][\s][0-5][0-9] ]]; then
    echo "Ba jnebun a mers preg-match"
    echo "Acum declar variabila globala pe care o ia cronu'"
#    eval ${n_hours}="$1"
    trim_hours=$(echo "$1" | xargs)
    assign_global n_hours $trim_hours
    echo -e "The notification will be repeated at: $trim_date $trim_hours"
    notify_text_selector
else 
    echo "Pei nu e bine bobitz, mai incearca odat'"
    notify_once_hours_selector
fi
}

### Check text to only contain letters and numbers
validate_text()
{
echo "Sunt in text si dau date"
if [[ $1 != *[[:punct:]]* ]]; then
 echo "For security reasons no punctuation is allowed, only letters and digits."
 notify_text_selector
else
 echo "nu e alpha deloc, fckking simp"
fi

}

### The date select menu
notify_once_date_selector()
{
echo -e "Enter the date you don't want to forget, dummy:"
echo -e "*** DD-MM-YYYY"
echo -e "*** DD/MM/YYYY"
echo -e "*** DD.MM.YYYY"
echo -e $NEW_PS3 | tr -d '\n'; read input_date
validate_date $input_date
}

### The hours selec menu
notify_once_hours_selector()
{
echo -e "Enter the time you want the notification to pop up at, fucktard:"
echo -e "*** HH:MM"
echo -e "*** HH MM"
echo -e $NEW_PS3 | tr -d '\n'; read input_hours
validate_hours $input_hours
}


notify_text_selector()
{
echo -e "Enter the title of your notification:"
echo -e $NEW_PS3 | tr -d '\n'; read notification_title
validate_text $notification_title

echo -e "Enter the body of your notification:"
echo -e $NEW_PS3 | tr -d '\n'; read notification_body
validate_text $notification_body

}



### Create flow 
create_notification()
{
echo -e "\n${BOLD_CYAN}>>> ${NC}I want to create a notification that will be ${GREEN}repeated${NC}:"
export PS3=$NEW_PS3
options=("Once" "Every..." "Exit")
select option in "${options[@]}"
do
    case $REPLY in
	1) notify_once_date_selector; break
	;;
 	2) echo -e "Everybooooodeeee hateeezsss mooldooovaaa"
	;;
	3) echo -e "Quitting the application..."; exit 0
	;;
	*) echo -e "Invalid option, please choose from 1-3. \n...you dumb fuck."
	;;
    esac
done
}


#
##
###
#### Crons
##########
make_one_time_cron()
{
 echo "one time cron"
}



#########################################
#####             Main             ######
#########################################
# Converting cli arg to lowercase
FLOW=$(echo "$1" | awk '{print tolower($0)}')


# Decide the flow of the application
if [ $# -eq 0 ] || [ $1 = "-h" ] || [ $1 = "--help" ]; then
   help_page
elif [ $FLOW = "-c" ] || [ $FLOW = "--create" ]; then 
   create_notification
elif [ $FLOW = "-e" ] || [ $FLOW = "--edit" ]; then
   $edit_notification
   echo "Edit notification flow"
elif [ $FLOW = "-d" ] || [ $FLOW = "--delete" ]; then
   $delete_notification
   echo "Delete notification"
elif [ $FLOW = "-l" ] || [ $FLOW = "--list" ]; then
   $list_notifications
   echo "List notifications"
else
   echo -e "${RED}Try again${NC} ${GREEN}bruv${NC}, ${RED}no function needed for this${NC} ${BOLD_CYAN}i say${NC}"
fi




