rpmver='zabbix-3.0.16-1.el7.src.rpm'
mainpath='/home/builder/rpmbuild/'
/bin/echo "mainpth = $mainpath"
#Cleaning the directories
mypath=( $( /bin/ls -l /home/builder/rpmbuild/ | /usr/bin/awk '{print $9}' ) )
/bin/echo ${mypath[@]}
for mpt in "${mypath[@]}"; do
   /bin/echo "mpt = $mpt"
      path_delete="$mainpath$mpt/*"
      /bin/echo "path delete = $path_delete"
      /bin/rm -rf $path_delete
done

/usr/bin/rm -f /tmp/$rpmver #cleanind previously downloaded file
/bin/echo "Done cleaning"
/usr/bin/wget http://repo.zabbix.com/zabbix/3.0/rhel/7/SRPMS/$rpmver -P /tmp/
/usr/bin/rpm -i /tmp/$rpmver
#--------------------------------git files--------------
url_download_path=""
file_git_download=()
file_patch="zabbixpatch.patch"
file_spec="zabbix.spec"
file_git_download+=($file_patch)
file_git_download+=($file_spec)
/bin/echo "Downloading from git = " ${file_git_download[@]}

for fgt in "${file_git_download[@]}"; do
    /bin/echo "fgt = $fgt"
    /bin/echo "Starting"
    #patch
    if [ "$fgt" = "$file_patch" ]; then
            /usr/bin/wget https://github.com/summersonne/zabbixbuild/blob/master/zabbixpatch.patch
    fi
    #spec
    if [ "$fgt" = "$file_spec" ]; then
            /usr/bin/wget https://raw.githubusercontent.com/summersonne/zabbixbuild/master/zabbix.spec
    fi
done
#--------------------------------- copy downloaded files  -------------------------------------
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

/bin/echo "Starting building"
/usr/bin/rpmbuild -ba /home/builder/rpmbuild/SPECS/zabbix.spec
