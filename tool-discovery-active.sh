
#!/bin/bash

#Author: Rodrigo Hernandez Carmona

#Colours
  greenColour="\e[0;32m\033[1m"
  endColour="\033[0m\e[0m"
  redColour="\e[0;31m\033[1m"
  blueColour="\e[0;34m\033[1m"
  yellowColour="\e[0;33m\033[1m"
 purpleColour="\e[0;35m\033[1m"
 turquoiseColour="\e[0;36m\033[1m"
 grayColour="\e[0;37m\033[1m"
 trap ctrl_c INT

 
clear 


function banner(){

echo -e "${blueColour}************************************************************ \n ${endColour}"
echo -e "${greenColour}************************************************************ \n ${endColour}"
echo -e "${yellowColour}************************************************************ \n ${endColour}"
echo -e "${redColour}************************************************************ \n ${endColour}"
echo -e "${purpleColour}************************************************************ \n ${endColour}"
echo -e "${grayColour}************************************************************ \n ${endColour}"          
echo -e "${turquoiseColour}************************************************************ \n ${endColour}"

}

 function ctrl_c () {
     echo -e "${grayColour}[*] Saliendo... ${endColour}" 2>/dev/null 2>&1
     tput cnorm
     exit 0
 }

 function helpPanel(){
 echo -e "${blueColour}\t****************************************************** \n ${endColour}"
 echo -e "${blueColour}\t [-h]   mostrar este panel de ayuda \n${endColour}"
 echo -e "${blueColour}\t [*]USO:  tool-discovery-active.sh  [IP] ${endColour}"
 echo -e "${blueColour}\t****************************************************** ${endColour}"
exit 1
 }

if [ -z "$1" ] ; then
    helpPanel
fi  
    banner

    echo -e "${greenColour}\t\t\t\t\t\t \n ************************* NMAP ***************************** \n\n ${endColour}" > resultados
    echo -e "${greenColour} Arrancando Nmap ${endColour}"
    nmap -Pn -sS -n  $1 -T5 | tail -n 10 | head -n 7  >> resultados
    tput civis
    echo -e "${greenColour}\n Arrancando PING  ${endColour}" >> resultados
 
   declare -i ttl=`ping -c 4 $1 | grep "ttl" | head -n 1 | cut -d " " -f 6 | cut -d "=" -f 2`
   

   
   if [ $ttl -eq 128 ]; then
       echo -e "${greenColour}\n Sistema operativo [WINDOWS] \n${endColour}" >> resultados
   elif [ $ttl -eq 64 ]; then 
       echo -e "${greenColour}\n Sistema operativo [LINUX] \n${endColour}" >> resultados


   else
       echo -e "${greenColour}\n Sistema operativo [desconocido-No Responde] \n${endColour}" >> resultados
   fi

   
while read line
 do
              if [[ $line == *open* ]] && [[ $line == *http* ]]; then
                  echo -e "${yellowColour} Arrancando Gobuster ${endColour}"
                  gobuster dir -u $1 -w dic.txt -qz  > temp1 
        
                  echo -e "${yellowColour} Arrancando WhatWeb ${endColour}"
                   whatweb $1 -v > temp2
              fi
done < resultados


    if [ -e temp1 ]; then
    echo -e "${greenColour}\n*************** resultados de gobuster **************\n\n${endColour}">>resultados
    cat temp1 >> resultados
    rm temp1
    fi
    if [ -e temp2 ]; then
           
     echo -e "${greenColour}\n*************** resultados de Whatweb ************** \n\n${endColour}">>resultados
    cat temp2 >> resultados
    rm temp2
    fi 

 
cat resultados
tput cnorm 
