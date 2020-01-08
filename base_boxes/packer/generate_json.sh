#!/bin/sh


# To generate packer json files to build base box

OSs="Ubuntu1604 RHEL8u1 RHEL8u0 RHEL7u7 RHEL7u6 RHEL7u5 RHEL7u4 RHEL7u3 RHEL7u2 RHEL7u1 RHEL7 RHEL6u9 RHEL6u8 RHEL6u7 RHEL6u6 RHEL6u5 RHEL6u4 RHEL5u11 RHEL5u10 RHEL5u9 OL7u2 OL7u1 OL7 OL6u6 OL6u5 OL6u4 SLES15sp1 SLES15 SLES12sp1 SLES12 SLES11sp4 SLES11sp3 SLES11sp2 SLES11sp1 Solaris10u11 Solaris10u10 Solaris10u9 Solaris11u2 Solaris11u3 Solaris12u0"

# Ubuntu
Products_Ubuntu1604="NONE"

# RHEL
Products_RHEL8u1="NONE"
Products_RHEL8u0="NONE"
Products_RHEL7u7="NONE"
Products_RHEL7u6="NONE"
Products_RHEL7u5="NONE"
Products_RHEL7u4="NONE"
Products_RHEL7u3="NONE"
Products_RHEL7u2="NONE"
Products_RHEL7u1="NONE"
Products_RHEL7="NONE"
Products_RHEL6u9="NONE"
Products_RHEL6u8="NONE"
Products_RHEL6u7="NONE"
Products_RHEL6u6="NONE"
Products_RHEL6u5="NONE"
Products_RHEL6u4="NONE"
Products_RHEL5u11="NONE"
Products_RHEL5u10="NONE"
Products_RHEL5u9="NONE"

# Oracle Linux
Products_OL7u2="NONE"
Products_OL7u1="NONE"
Products_OL7="NONE"
Products_OL6u7="NONE"
Products_OL6u6="NONE"
Products_OL6u5="NONE"
Products_OL6u4="NONE"

# SLES
Products_SLES11sp4="NONE"
Products_SLES11sp3="NONE"
Products_SLES11sp2="NONE"
Products_SLES11sp1="NONE"
Products_SLES12="NONE"
Products_SLES12sp1="NONE"
Products_SLES15="NONE"
Products_SLES15sp1="NONE"

# Solaris
Products_Solaris10u9="NONE"
Products_Solaris10u10="NONE"
Products_Solaris10u11="NONE"
Products_Solaris11u2="NONE"
Products_Solaris11u3="NONE"
Products_Solaris12u0="NONE"

echo

for os in ${OSs}; do

    var="Products_${os}"
    eval prods=\$$var

    for prod in $prods; do

        # generate packer json for supported products on the OS
        echo "Generating packer json to build base box with ${os} + ${prod} ..."

        filename_os=`echo $os | tr [A-Z] [a-z]`;
        filename_prod=`echo $prod | tr [A-Z] [a-z]`;
        if [ "x${filename_prod}" = "xnone" ]; then
            filename_prod="only"
        fi
        filename="${filename_os}_${filename_prod}.json"
        echo "    $filename"
        echo

        # if the json file already exists, skip
        if [ -f "$filename" ]; then
            continue
        fi

        # check if template file exists
        templatefile=
        if [ -f "json_templates/${filename_os}.json" ]; then
            templatefile="json_templates/${filename_os}.json"
        else
            filename1=`echo $filename_os | sed -e "s/u[0-9]*$//;s/sp[0-9]*$//"`
            if [ -f "json_templates/${filename1}.json" ]; then
                templatefile="json_templates/${filename1}.json"
            else
                filename1=`echo $filename_os | sed -e "s/u[0-9]*$//;s/sp[0-9]*$//;s/[0-9]*$//"`
                if [ -f "json_templates/${filename1}.json" ]; then
                    templatefile="json_templates/${filename1}.json"
                fi
            fi
        fi

        if [ ! -z "$templatefile" ]; then
            sed "s/_OS_/${filename_os}/g;s/_PROD_/${filename_prod}/g" $templatefile > $filename
        fi

    done;

done;

