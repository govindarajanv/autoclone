#!/bin/bash

proxies=(   "https://dummyproxy.com:1234" # India proxy
            "https://dummyproxy.com:1233" # Different geography
            "https://dummyproxy.com:1235" 
            "https://dummyproxy.com:1236"
        )

COUNTER=0
repo=$1
echo -e "\nAvailable number of proxies: ${#proxies[@]}\n"
for str in ${proxies[@]}; do
  echo -e "checking if the proxy url $str works...\n"
  git clone --quiet $repo--config $str > /dev/null 2>&1
if (( $? == 0 )); then
    echo -e "proxy $str works\n"
    echo -e "repo $repo is cloned successfully\n"
    break
else
    echo "proxy $str does not work."
    COUNTER=$((COUNTER+1))
fi
echo -e "\n"

done

if [ $COUNTER -eq ${#proxies[@]} ]; then
    echo -e "None of the proxies worked.Please contact the trainer\n"
fi

