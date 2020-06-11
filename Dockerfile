FROM registry.access.redhat.com/ubi8/ubi

MAINTAINER Christopher Tate <computate@computate.org>

ENV APP_NAME=zookeeper \
    APP_VERSION=3.6.0 \
    APP_REPO=https://github.com/apache/zookeeper.git \
    APP_TAG=release-3.6.0 \
    APP_SRC=/usr/local/src/zookeeper \
    APP_OPT=/opt/zookeeper \
    APP_DATA=/opt/zookeeper/data \
    APP_DIST=zookeeper-3.6.0 \
    APP_CLIENT_PORT=8080 \
    APP_ADMIN_PORT=8081 \
    INSTALL_PKGS="git java-1.8.0-openjdk-devel maven hostname"

EXPOSE $APP_CLIENT_PORT

RUN yum install -y $INSTALL_PKGS && yum clean all
RUN install -g 0 -m g=u -d $APP_SRC $APP_OPT $APP_DATA
RUN git clone $APP_REPO $APP_SRC --branch $APP_TAG
WORKDIR $APP_SRC
RUN mvn clean install -DskipTests
RUN tar xf $APP_SRC/$APP_NAME-assembly/target/apache-$APP_NAME-$APP_VERSION-bin.tar.gz -C $APP_OPT --strip-components=1
RUN install -d $APP_DATA

USER 1001
WORKDIR "$APP_OPT"
CMD echo "tickTime=2000" | tee $APP_OPT/conf/zoo.cfg && echo "dataDir=$APP_DATA" | tee -a $APP_OPT/conf/zoo.cfg && echo "clientPort=$APP_CLIENT_PORT" | tee -a $APP_OPT/conf/zoo.cfg && echo "admin.serverPort=$APP_ADMIN_PORT" | tee -a $APP_OPT/conf/zoo.cfg && $APP_OPT/bin/zkServer.sh start-foreground

