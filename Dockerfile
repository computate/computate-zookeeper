FROM openshift/base-centos7:latest

MAINTAINER Christopher Tate <computate@computate.org>

EXPOSE 8080
EXPOSE 8081

ENV ZK_VERSION=3.5.3 \
    ZK_DIST=zookeeper-$ZK_VERSION \
    ZK_CLIENT_PORT=8080 \
    ZK_ADMIN_PORT=8081 \
    INSTALL_PKGS="gettext tar zip unzip hostname nmap-ncat java-1.8.0-openjdk ivy lsof maven ant autoreconf automake cppunit-devel libtool"

RUN yum install -y $INSTALL_PKGS
RUN mkdir /usr/local/src/zookeeper
RUN git clone https://github.com/apache/zookeeper.git /usr/local/src/zookeeper
WORKDIR /usr/local/src/zookeeper
RUN cd /usr/local/src/zookeeper && git checkout release-$ZK_VERSION
RUN ant package
RUN mv /usr/local/src/zookeeper/build/zookeeper-$ZK_VERSION-beta /opt/zookeeper
RUN mkdir /opt/zookeeper/data
RUN touch /opt/zookeeper/conf/zoo.cfg
RUN chmod -R a+rw /opt/zookeeper

WORKDIR "/opt/zookeeper"
CMD echo "tickTime=2000" | tee /opt/zookeeper/conf/zoo.cfg && echo "dataDir=/opt/zookeeper/data" | tee -a /opt/zookeeper/conf/zoo.cfg && echo "clientPort=$ZK_CLIENT_PORT" | tee -a /opt/zookeeper/conf/zoo.cfg && echo "admin.serverPort=$ZK_ADMIN_PORT" | tee -a /opt/zookeeper/conf/zoo.cfg && /opt/zookeeper/bin/zkServer.sh start-foreground

