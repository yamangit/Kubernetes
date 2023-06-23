#!/bin/sh
export path=$path$(pwd)
while true
do
clear
echo "The list of available option that can be performed with this program are as follows:"
echo "Press 1 to install k8s"
echo "Press 0 to exit"
echo -n "Enter your option then press [Enter]:"

read  opt
if [ $opt = 1 ];then
sleep 1s
clear
echo "Initailizing k8s installation"
{
find $path/src/init_k8s.sh -type f -exec chmod 777 {} \;
sh $path/src/init_k8s.sh
}
exit 1

elif [ $opt = 0 ];then
sleep 1s
clear
echo "The program will now exit"
sleep 2s
exit 2

else
clear
 echo "Invalid option"
 echo "Please enter a correct option"
sleep 2s
fi

done
