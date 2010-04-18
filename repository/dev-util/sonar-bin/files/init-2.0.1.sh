#!/sbin/runscript

depend() {
    need net
    use dns logger
}

RUN_AS=sonar

checkconfig() {
    return 0
}

start() {
    checkconfig || return 1

    ebegin "Starting ${SVCNAME}"
    su $RUN_AS -c "/opt/sonar/sonar-2.0.1/bin/linux-x86-32/sonar.sh start"
    eend $?
}

stop() {
    ebegin "Stopping ${SVCNAME}"
    su $RUN_AS -c "/opt/sonar/sonar-2.0.1/bin/linux-x86-32/sonar.sh stop"
    eend $?
}
