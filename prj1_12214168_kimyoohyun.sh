#!/bin/bash

if [ "$#" -ne 3 ]; then
	echo "usage: ./prj1_12214168_kimyoohyun.sh file1 file2 file3"
	exit 1
fi

file1=$1
file2=$2
file3=$3

f1(){
	read -p  "Do you want to get the Heung-Min Son's data? (y/n) :" input
	if [ "$input" = "y" ]; then
		cat $file2 | awk -F ',' '$1=="Heung-Min Son" {printf("Team:%s, Apperance:%d, Goal:%d, Assist:%d\n", $4, $6, $7, $8)}'
	fi
}
f2(){
	read -p "What do you wnat to get the team data of league_position[1~20] : " input
	cat $file1 | awk -F ',' -v input="$input" '$6==input {print $6, $1, $2/($2+$3+$4)}'
}
f3(){
	read -p "Do you wnat to know Top-3 attendance data and average attendance? (y/n) : " input
	if [ "$input" = "y" ]; then
		echo "***Top-3 Attendance Match***"
		cat $file3 | sort -r -t ',' -n -k 2 | awk -F ',' '{printf("\n%s vs %s (%s)\n%d %s\n", $3, $4, $1, $2, $7)}' | head -n 9
	fi
}
f4(){
	read -p "Do you want to get each team's ranking and the highest-scoring player? (y/n) : " input
	if [ "$input" = "y" ]; then
		echo ""
		for (( i=1; i<=20; i++ )); do
			cat $file1 | awk -F ',' -v col="$i" '$6==col {print $6, $1}'
			team=$(awk -F ',' -v col="$i" '$6==col {print $1}' "$file1" | sort -u)
			cat $file2 | awk -F ',' -v team="$team" '$4==team {print $7, $1, $7}' | sort -r -t',' -n -k 1 | head -n 1 | awk '{$1=""; sub(/^ */,"");print}'
			echo ""
		done
	fi
}
f5(){
	read -p "Do you want to modify the format of date? (y/n) : " input
	if [ "$input" = "y" ]; then
		cat $file3 | awk -F ',' 'NR!=1 {print $1}' | \
		sed -E 's/Jan/01/;s/Feb/02/;s/Mar/03/;s/Apr/04/;s/May/05/;s/Jun/06/;s/Jul/07/;s/Aug/08/;s/Sep/09/;s/Oct/10/;s/Nov/11/;s/Dec/12/' | \
		sed -E 's/([0-9]{2}) ([0-9]{2}) ([0-9]{4})/\3\/\1\/\2/' | \
		sed -E 's/ - / /' | \
		head -n 10
	fi
}
f6(){
	for (( i=1; i<=10; i++ )); do
		cat $file1 | awk -F ',' -v col="$i" 'NR==((col+1)) {printf("%2d) %-20s", col, $1)}'
		cat $file1 | awk -F ',' -v col="$i" 'NR==((col+11)) {printf("%d) %s\n", col+10, $1)}'
	done
	read -p "Enter your team number : " input
	team=$(awk -F ',' -v input="$input" 'NR==((input+1)) {print $1}' "$file1" | sort -u)
	maxi=$(cat $file3 | awk -F ',' -v team="$team" '$3==team {print (($5-$6))}' | awk '{if (max=="") max=$1; else if ($1>max) max=$1} END {print max}')
	cat $file3 | awk -F ',' -v team="$team" -v maxi="$maxi" '$3==team && (($5-$6))==maxi {printf("\n%s\n%s %d vs %d %s\n",$1, $3, $5, $6, $4)}'
}
f7(){
	echo "Bye!"
	exit 0
}

echo ************OSS1 - Project1************
echo "*       StudentID : 12214168          *"
echo "*       Name : YooHyun Kim            *"
echo \***************************************

while true; do
	echo ""
	echo "[MENU]"
	echo "1. Get the data of Heung-Min Son's Current Club, Appearances, Goals, Assists in players.csv"
	echo "2. Get the team data to enter a league position in teams.csv"
	echo "3. Get the Top-3 Attendance matches in matches.csv"
	echo "4. Get the team's league position and team's top scorer in teams.csv & players.csv"
	echo "5. Get the modified format of date_GMT in matches.csv"
	echo "6. Get the data of the winning team by the largest difference on home stadium in teams.csv"
	echo "7. Exit"

	read -p  "Enter your CHOICE (1~7) : " num

	case $num in
		1) f1;;
		2) f2;;
		3) f3;;
		4) f4;;
		5) f5;;
		6) f6;;
		7) f7;;
	esac
done
