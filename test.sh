#!/bin/bash
# creating numerical list
echo "creating a list"
crunch 1 6 1234567890 -o num.list &>/dev/null

echo "running fcrackzip as long if needed"
while [[ true ]];do
	file=$(ls | grep zip)
	fcrackzip -u -D -p num.list $file > result
	pwd=$(cat result | tr -d '\n' | awk '{print $5}')
	result=$(cat result | tr -d '\n' | grep FOUND)
	if [[-z $result ]]; then
		echo "no pass found in $file"
		break 2
	else
		echo "pass found"
		unzip -q -P "$pwd" "$file"
		rm $file
	fi
done

#cleaning up
rm -f result num.list