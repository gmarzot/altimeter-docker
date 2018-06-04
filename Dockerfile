# Start with Centos
FROM centos

ARG ALT_PW
ARG MYSQL_PW

# Parameters
ENV JAVA_PKG=lib/server-jre-8u171-linux-x64.tar.gz \
    JAVA_HOME=/usr/java/default \
    RAMP_ALT_PKG=lib/altimeter-manager-v2.0.1-138661-rtm.zip \
    MYSQL_SRV_PKG=lib/mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz \
    MYSQL_CONJ_PKG=lib/mysql-connector-java-5.1.46.tar.gz \
    OPT_DIR=/opt \
    RAMP_ALT_INSTALL_DIR=/opt/altimeter-manager \
    RAMP_ALT_INSTALLER=docker-altimeter-install.sh

# Install Java Runtime
ADD $JAVA_PKG /usr/java/
RUN export JAVA_DIR=$(ls -1 -d /usr/java/*) && \
    ln -s $JAVA_DIR /usr/java/latest && \
    ln -s $JAVA_DIR /usr/java/default && \
    alternatives --install /usr/bin/java java $JAVA_DIR/bin/java 20000 && \
    alternatives --install /usr/bin/javac javac $JAVA_DIR/bin/javac 20000 && \
    alternatives --install /usr/bin/jar jar $JAVA_DIR/bin/jar 20000

# Copy Library Files
ADD $RAMP_ALT_PKG /tmp
RUN yum -y install less
RUN yum -y install unzip
RUN yum -y install rsync
RUN yum -y install libaio
RUN yum -y install numactl-devel
RUN yum -y install initscripts
RUN cd /tmp && unzip `basename $RAMP_ALT_PKG`

ADD $MYSQL_SRV_PKG $RAMP_ALT_INSTALL_DIR
ADD $MYSQL_CONJ_PKG $RAMP_ALT_INSTALL_DIR

RUN cd /tmp/altimeter-manager-v2.0.1 && printf "\n\n\n${ALT_PW}\n\n${MYSQL_PW}\n${RAMP_ALT_INSTALL_DIR}/mysql-5.7.22-linux-glibc2.12-x86_64\n${RAMP_ALT_INSTALL_DIR}/mysql-connector-java-5.1.46\n" | ./install.sh; service altimeter-manager stop
RUN sed -i 's/\(.*\)mysql.server start\(.*\)/\1mysql.server start --skip-grant-tables \2/' /etc/init.d/altimeter-manager
RUN ls -al ${RAMP_ALT_INSTALL_DIR}/license

CMD ["/sbin/init"]

