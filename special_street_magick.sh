# This script summon Dockerfile, build envinonment for Zabbix and create RPM packages.
# All needed scripts downloaded from Github (https://github.com/summersonne/zabbixbuild)
# Repository contains all scripts also patch and SPEC files for building PRM packages of Zabbix server
# Can be usen inside Jenkins or standalone Linux server with installed Docker
#           ____ __
#          { --.\  |          .)%%%)%%
#           '-._\\ | (\___   %)%%(%%(%%%
#               `\\|{/ ^ _)-%(%%%%)%%;%%%
#           .'^^^^^^^  /`    %%)%%%%)%%%'
#          //\   ) ,  /       '%%%%(%%'
#    ,  _.'/  `\<-- \<
#     `^^^`     ^^   ^^
#
# Beware here be dragons

/bin/echo "Downloading Dockerfile"
/bin/wget https://raw.githubusercontent.com/summersonne/zabbixbuild/master/Dockerfile
/bin/echo "Starting building process. This will take a while"
/bin/docker build -q -t="rpmbuilder" .
/bin/docker run -dit --rm rpmbuilder
contID=$(docker ps -a -q)
/bin/echo "Container ID is:"$contID
/bin/echo "Now script will copy files from container to curren dir"
docker cp $contID:/home/builder/rpmbuild/RPMS/x86_64/ .
