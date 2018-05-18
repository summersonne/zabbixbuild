#base centos7
FROM centos:7
#Pre requisites instal
RUN yum -y update
RUN yum -y install rpm-build
RUN yum -y install redhat-rpm-config
RUN yum -y install make
RUN yum -y install gcc
RUN yum -y install wget
RUN yum -y install mysql-devel
RUN yum -y install postgresql-devel
RUN yum -y install net-snmp-devel
RUN yum -y install openldap-devel
RUN yum -y install gnutls-devel
RUN yum -y install sqlite-devel
RUN yum -y install unixODBC-devel
RUN yum -y install curl-devel
RUN yum -y install OpenIPMI-devel
RUN yum -y install libssh2-devel
RUN yum -y install java-devel
RUN yum -y install libxml2-devel
RUN wget http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/i/iksemel-1.4-6.el7.x86_64.rpm
RUN rpm -Uvh iksemel-1.4-6.el7.x86_64.rpm
RUN yum -y install iksemel
RUN wget http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/i/iksemel-devel-1.4-6.el7.x86_64.rpm
RUN rpm -Uvh iksemel-devel-1.4-6.el7.x86_64.rpm
RUN yum -y install iksemel-devel
#user setup

RUN useradd builder -u 1000 -m -G users,wheel
RUN echo "builder ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
USER builder
RUN mkdir -p /home/builder/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
RUN echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros
#build process start
RUN wget https://raw.githubusercontent.com/summersonne/zabbixbuild/master/rpmbuilder.sh -P /tmp/
RUN chmod +x /tmp/rpmbuilder.sh
RUN sh /tmp/rpmbuilder.sh
