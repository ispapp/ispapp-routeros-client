:put "Download and import clean.rsc"
:do {
  /tool fetch url="https://raw.githubusercontent.com/ispapp/ispapp-routeros-agent/v2/ispappClean.rsc" dst-path="ispappClean.rsc"
  /import ispappClean.rsc
  :delay 3s
} on-error={:put "Error fetching ispappClean.rsc"; :delay 1s}


:global topKey "#####HOST_KEY#####";
:global topDomain "#####DOMAIN#####";
:global topClientInfo "RouterOS-v3.0";
:global topListenerPort "8550";
:global topServerPort "443";
:global topSmtpPort "8465";
:global txAvg 0 ;
:global rxAvg 0 ;
:global ipbandswtestserver "#####bandswtest#####";
:global btuser "#####btest#####";
:global btpwd "#####btp#####";


:put "Download and import ispappDiagnoseConnection.rsc"
:do {
  /tool fetch url="https://raw.githubusercontent.com/ispapp/ispapp-routeros-agent/v2/ispappDiagnoseConnection.rsc" dst-path="ispappDiagnoseConnection.rsc"
  /import ispappDiagnoseConnection.rsc
  :delay 3s
} on-error={:put "Error fetching ispappDiagnoseConnection.rsc"; :delay 1s}

:put "Download and import ispappSetGlobalEnv.rsc"
:do {
  /tool fetch url="https://raw.githubusercontent.com/ispapp/ispapp-routeros-agent/v2/ispappSetGlobalEnv.rsc" dst-path="ispappSetGlobalEnv.rsc"
  /import ispappSetGlobalEnv.rsc
  :delay 3s
} on-error={:put "Error fetching ispappSetGlobalEnv.rsc"; :delay 1s}

:put "Download and import ispappInit.rsc"
:do {
  /tool fetch url="https://raw.githubusercontent.com/ispapp/ispapp-routeros-agent/v2/ispappInit.rsc" dst-path="ispappInit.rsc"
  /import ispappInit.rsc
  :delay 3s
} on-error={:put "Error fetching ispappInit.rsc"; :delay 1s}

:put "Download and import ispappFunctions.rsc"
:do {
  /tool fetch url="https://raw.githubusercontent.com/ispapp/ispapp-routeros-agent/v2/ispappFunctions.rsc" dst-path="ispappFunctions.rsc"
  /import ispappFunctions.rsc
  :delay 3s
} on-error={:put "Error fetching ispappFunctions.rsc"; :delay 1s}

:put "Download and import ispappPingCollector.rsc"
:do {
  /tool fetch url="https://raw.githubusercontent.com/ispapp/ispapp-routeros-agent/v2/ispappPingCollector.rsc" dst-path="ispappPingCollector.rsc"
  /import ispappPingCollector.rsc
  :delay 3s
} on-error={:put "Error fetching ispappPingCollector.rsc"; :delay 1s}

:put "Download and import ispappLteCollector.rsc"
:do {
  /tool fetch url="https://raw.githubusercontent.com/ispapp/ispapp-routeros-agent/v2/ispappLteCollector.rsc" dst-path="ispappLteCollector.rsc"
  /import ispappLteCollector.rsc
  :delay 3s
} on-error={:put "Error fetching ispappLteCollector.rsc"; :delay 1s}

:put "Download and import ispappCollectors.rsc"
:do {
  /tool fetch url="https://raw.githubusercontent.com/ispapp/ispapp-routeros-agent/v2/ispappCollectors.rsc" dst-path="ispappCollectors.rsc"
  /import ispappCollectors.rsc
  :delay 3s
} on-error={:put "Error fetching ispappCollectors.rsc"; :delay 1s}

:put "ispappConfig.rsc"
:do {
  /tool fetch url="https://raw.githubusercontent.com/ispapp/ispapp-routeros-agent/v2/ispappConfig.rsc" dst-path="ispappConfig.rsc"
  /import ispappConfig.rsc
  :delay 3s
} on-error={:put "Error fetching ispappConfig.rsc"; :delay 1s}

:put "ispappRemoveConfiguration.rsc"
:do {
  /tool fetch url="https://raw.githubusercontent.com/ispapp/ispapp-routeros-agent/v2/ispappRemoveConfiguration.rsc" dst-path="ispappRemoveConfiguration.rsc"
  /import ispappRemoveConfiguration.rsc
  :delay 3s
} on-error={:put "Error fetching ispappRemoveConfiguration.rsc"; :delay 1s}

:put "ispappUpdate.rsc"
:do {
  /tool fetch url="https://raw.githubusercontent.com/ispapp/ispapp-routeros-agent/v2/ispappUpdate.rsc" dst-path="ispappUpdate.rsc"
  /import ispappUpdate.rsc
  :delay 3s
} on-error={:put "Error fetching ispappUpdate.rsc"; :delay 1s}

:put "ispappAvgCpuCollector.rsc"
:do {
  /tool fetch url="https://raw.githubusercontent.com/ispapp/ispapp-routeros-agent/v2/ispappAvgCpuCollector.rsc" dst-path="ispappAvgCpuCollector.rsc"
  /import ispappAvgCpuCollector.rsc
  :delay 3s
} on-error={:put "Error fetching ispappAvgCpuCollector.rsc"; :delay 1s}

:put "ispappRemoveFiles.rsc"
:do {
  /tool fetch url="https://raw.githubusercontent.com/ispapp/ispapp-routeros-agent/v2/ispappRemoveFiles.rsc" dst-path="ispappRemoveFiles.rsc"
  /import ispappRemoveFiles.rsc
  :delay 3s
} on-error={:put "Error fetching ispappRemoveFiles.rsc"; :delay 1s}


:log info ("Starting Mikrotik Script")

/system scheduler
add name=ispappInit on-event=ispappInit policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
:log debug ("ispappInit scheduler added")

add interval=60s name=ispappPingCollector on-event=ispappPingCollector policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
:log debug ("ispappPingCollector scheduler added")

add interval=60s name=ispappCollectors on-event=ispappCollectors policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
:log debug ("ispappCollectors scheduler added")

add interval=15s name=ispappUpdate on-event=ispappUpdate policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
:log debug ("ispappUpdate scheduler added")

add interval=300s name=ispappConfig on-event=ispappConfig policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
:log debug ("ispappConfig scheduler added")

:log info ("Running ispappInit script")
/system script run ispappInit;

:log info ("Completed Mikrotik Script")

