/import clean.rsc

:global topKey "#####HOST_KEY#####";
:global topDomain "#####DOMAIN#####";
:global topClientInfo "RouterOS-v2.46";
:global topListenerPort "8550";
:global topServerPort "443";
:global topSmtpPort "8465";

/import ispappDiagnoseConnection.rsc
/import ispappSetGlobalEnv.rsc
/import ispappInit.rsc
/import ispappFunctions.rsc
/import ispappPingCollector.rsc
/import ispappLteCollector.rsc
/import ispappCollectors.rsc
/import ispappConfig.rsc
/import ispappRemoveConfiguration.rsc
/import ispappUpdate.rsc
/import ispappAvgCpuCollector.rsc

/system scheduler
add name=ispappInit on-event=ispappInit policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add interval=60s name=ispappPingCollector on-event=ispappPingCollector policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add interval=60s name=ispappCollectors on-event=ispappCollectors policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add interval=15s name=ispappUpdate on-event=ispappUpdate policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add interval=300s name=ispappConfig on-event=ispappConfig policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
/system script run ispappInit;
