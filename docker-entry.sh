#!/bin/sh

/opt/altimeter-manager/mysql/support-files/mysql.server start --skip-grant-tables

if [[ $? != 0 ]]; then
    echo "MYSQL Server failed to start: $?"
    exit $?
fi

/opt/altimeter-manager/tomcat/bin/catalina.sh run

