#!/usr/bin/env sh
/usr/bin/java $JAVA_OPTS -Dlog4j2.formatMsgNoLookups=true -Dlog4j.configurationFile=log4j2.xml -jar server.jar "$@"