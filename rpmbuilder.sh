#The script will do all inside build work

rpmver='zabbix-4.0.0-2.el7.src.rpm' #what version we need to build
mainpath='/home/builder/rpmbuild/'   #where we store all things
/bin/echo "mainpth = $mainpath"

#Cleaning the directories. Not necessary inside Docker but can be useful on standalone Linux

mypath=( $( /bin/ls -l /home/builder/rpmbuild/ | /usr/bin/awk '{print $9}' ) )
/bin/echo ${mypath[@]}
for mpt in "${mypath[@]}"; do
   /bin/echo "mpt = $mpt"
      path_delete="$mainpath$mpt/*"
      /bin/echo "path delete = $path_delete"
      /bin/rm -rf $path_delete
done

/usr/bin/rm -f /tmp/$rpmver          #cleaning previously downloaded file
/bin/echo "Done cleaning"
/usr/bin/wget https://repo.zabbix.com/zabbix/4.0/rhel/7/SRPMS/$rpmver -P /tmp/ #downloading SRPM
/usr/bin/rpm -i /tmp/$rpmver #extacting source from SRPM
#Downloading SPEC and patch files from Github
url_download_path=""
file_git_download=()
file_patch="zabbixpatch.patch"
file_spec="zabbix.spec"
file_git_download+=($file_patch)
file_git_download+=($file_spec)
/bin/echo "Downloading from git = " ${file_git_download[@]}

#starting working with github files

for fgt in "${file_git_download[@]}"; do
    /bin/echo "fgt = $fgt"
    /bin/echo "Starting"
    #patch
    if [ "$fgt" = "$file_patch" ]; then
            /usr/bin/wget https://raw.githubusercontent.com/summersonne/zabbixbuild/blob/master/zabbixpatch.patch
    fi
    #spec
    if [ "$fgt" = "$file_spec" ]; then
            /usr/bin/wget https://raw.githubusercontent.com/summersonne/zabbixbuild/master/zabbix.spec
    fi
done

#copying files to SPEC and SOURCE

/bin/echo "Files downloaded now we copy it"
dest_rpmpatch="/home/builder/rpmbuild/SOURCES/"
dest_rpmspec="/home/builder/rpmbuild/SPECS/"
for fgt1 in "${file_git_download[@]}"; do
    /bin/echo "fgt1 = $fgt1"
    #patch
    if [ "$fgt1" = "$file_patch" ]; then
        /bin/cp $fgt1 $dest_rpmpatch
        /bin/rm $fgt1
    fi
    #spec
    if [ "$fgt1" = "$file_spec" ]; then
        /bin/cp $fgt1 $dest_rpmspec
        /bin/rm $fgt1
    fi
done

#And final step - we starting build process. This may take a while

/bin/echo "Starting building"
/usr/bin/rpmbuild -ba /home/builder/rpmbuild/SPECS/zabbix.spec
#that's all folks
