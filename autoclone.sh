#!/bin/bash

proxies=(   "https://dummyproxy.com:1234" # India proxy
            "https://dummyproxy.com:1233" # Different geography
            "https://dummyproxy.com:1235" 
            "https://dummyproxy.com:1236"
        )

COUNTER=0
read -p "Enter your name:" name

read -p "Enter your company email:" email
email_domain=$(echo $email | awk -F '@' '{print $NF}')
if [ $email_domain != "gmail.com" ]; then 
    echo -e "\nEmail domain validation not successful"
    exit 1
fi
read -p "Enter repo url to be cloned: " repo

if [[ $repo =~ ^https://github.com/.*/.*.git$ ]]; then 
    echo -e "\nurl validation is successful for $repo "
else
    echo -e "\nplease enter a valid git repo"
    exit 1
fi
echo -e "\nAvailable number of proxies: ${#proxies[@]}\n"
for str in ${proxies[@]}; do
  echo -e "checking if the proxy url $str works...\n"
  git clone --quiet $repo--config $str > /dev/null 2>&1
if (( $? == 0 )); then
    echo -e "proxy $str works\n"
    echo -e "repo $repo is cloned successfully\n"

    user_name=$(git config user.name)
    if [[ -z "${user_name}" ]]; then
       echo "Setting user name in git config"
       git config user.name $name
    fi
   
    user_email=$(git config user.email)
    if [[ -z "${user_email}" ]]; then
       echo "Setting user email in git config"
       git config user.email $email
    fi

    break
else
    echo "proxy $str does not work."
    COUNTER=$((COUNTER+1))
fi
echo -e "\n"

done

if [ $COUNTER -eq ${#proxies[@]} ]; then
    echo -e "None of the proxies worked.Please contact the trainer or core team\n"
fi

# open a new gitbash & kill $PPID