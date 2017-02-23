# docker build -t centosdev:7 .
FROM centos:7

RUN yum clean all
RUN yum -y upgrade
RUN yum -y install which wget ruby ruby-devel
RUN yum -y groupinstall "Development Tools"
RUN gem install fpm  
