#!/bin/bash

file="$1"
tmp="/tmp/parser.tmp"
excludes="Python/bin/python\|/opt/icinga/libexec/check_atlas_ripper\|/opt/icinga/libexec/check_nt\ \|/opt/icinga/libexec/check_nrpe\|/opt/icinga/libexec/check_nrpe-2.15\| check_nrpe\ \| check_nt "
results="results/hostname_servicename_columns/normal_services"
HOSTLOCATION="icinga_hh/kunden"

if [[ -e $tmp ]];
then
  rm $tmp
fi

if [[ $2 == "gen" ]];
then
  for h in `find $HOSTLOCATION -name *.cmd`
    do 
      grep -H "^command\| command" $h | grep -v "$excludes" | awk -F " " '{$2=$4=""; print $0}' | awk '{gsub(":command","");print}' | awk '{gsub("'$HOSTLOCATION/'","");print}' | awk '{gsub("=/","/");print}' | awk '{gsub("= /","/");print}' | sed -e 's/[[:space:]]\{2,\}/\;/g' | sed -e 's/\(libexec\/\)[A-Za-z0-9\-\_\.]*/&;/g' | sed 's/\.cmd//g' | awk 'BEGIN{FS=";";OFS=FS} {base=$1;gsub(/.*\//,"",base);print base,$0}' | cut -d ";"  -f-1,3- | sed -e 's/srv-//g' | awk 'sub(/ *$/, "")' | sed -e 's/;$//g' | tee -a $tmp
      #| awk '{gsub("/check_nt ","/check_nt;");print}' > $file
    done 
  fi

if [[ -e $tmp ]];
then
  cat -v $tmp | sed 's/\^M//g' | awk 'sub(/ *$/, "")' | tee -a $file
  rm $tmp
fi

  commands=$(cat $file | awk -F ";" '{print $3}' | sort -u)

#echo "hostname;servicename;checkcommand;port;secret;warning;critical;params;"
  cat $file | while read line
    do
      hostname=$(echo $line | cut -d ";" -f1)
      servicename=$(echo $line | cut -d ";" -f2)
      checkcommand=$(echo $line | cut -d ";" -f3)
      last=$(echo $line | grep -o '[^;]*$')
      case $checkcommand in
        "/opt/icinga/libexec/check_icmp")
          crit=$(echo $last | egrep -o '(-c).[0-9\.\,\%]*' | sed 's/-c //g')
          warn=$(echo $last | egrep -o '(-w).[0-9\.\,\%]*' | sed 's/-w //g')
          packets=$(echo $last | egrep -o '(-p).\d+' | sed 's/-p //g')
          echo "$hostname;$servicename;$checkcommand;$crit;$warn;$packets;" >> "$results/check_icmp.csv"
          ;;
        "/opt/icinga/libexec/check_ping")
          crit=$(echo $last | egrep -o '(-c).[0-9\.\,\%]*' | sed 's/-c //g')
          warn=$(echo $last | egrep -o '(-w).[0-9\.\,\%]*' | sed 's/-w //g')
          packets=$(echo $last | egrep -o '(-p).\d+' | sed 's/-p //g')
          echo "$hostname;$servicename;$checkcommand;$crit;$warn;$packets;" >> "$results/check_icmp.csv"
          ;;
        "/opt/icinga/libexec/check_procs")
          crit=$(echo $last | egrep -o '(-c).[0-9\.\,\:]*' | sed 's/-c //g')
          warn=$(echo $last | egrep -o '(-w).[0-9\.\,\:]*' | sed 's/-w //g')
          arg=$(echo $last | egrep -o "(-a).[A-Za-z0-9\-\_]*" | sed 's/-a //g')
          argcommand=$(echo $last | egrep -o "(-C).[A-Za-z0-9\-\_]*" | sed 's/-C //g')
          echo "$hostname;$servicename;$checkcommand;$crit;$warn;$arg;$argcommand;" >> "$results/check_procs.csv"
          ;;
        #"/opt/icinga/libexec/check_snmp")
        #  crit=$(echo $last | egrep -o '(-c ).[0-9\.\,\:]*' | sed 's/-c //g')
        #  warn=$(echo $last | egrep -o '(-w ).[0-9\.\,\:]*' | sed 's/-w //g')
        #  community=$(echo $last | egrep -o "(-C ).[A-Za-z0-9\-\_]*" | sed 's/-C //g')
        #  oid=$(echo $last | egrep -o "(-o ).([\"\'A-Za-z0-9\-\_\.\:].*[\"\']|[\"\'A-Za-z0-9\-\_\.\:]*)" | sed 's/-o //g')
        #  label=$(echo $last | egrep -o "(-l ).[A-Za-z0-9\-\_\:\ \,\.]*" | sed 's/-l //g')
        #  unit=$(echo $last | egrep -o "(-u ).[a-zA-Z0-9\.\,\:\%]*" | sed 's/-u //g')
        #  echo "$hostname;$servicename;$checkcommand;$crit;$warn;$community;$oid;$label;$unit;" >> "$results/check_snmp.csv"
        #  ;;
        *)
          echo $line >> "$results/unsorted_services.csv"
          ;;
      esac
#      module=$(echo $last | egrep -o '(-v).\w+' | sed 's/-v //g')
#      secret=$(echo $last | egrep -o "(-s).[A-Za-z0-9\-\_\@]*" | sed 's/-s //g')
#      port=$(echo $last | egrep -o '(-p).\d+' | sed 's/-p //g')
#      warning=$(echo $last | egrep -o '(-w).\d+' | sed 's/-w //g')
#      critical=$(echo $last | egrep -o '(-c).\d+' | sed 's/-c //g')
#      params=$(echo $last | egrep -o "(-l).([\"\'A-Za-z0-9\-\_\.].*[\"\']|[\"\'A-Za-z0-9\-\_\.]*)" | sed 's/-l //g')
#      echo "$hostname;$servicename;$module;$port;$secret;$warning;$critical;$params;"
#
       echo "$hostname;$servicename;$checkcommand;$last"
    done

