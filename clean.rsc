:if ([:len [/system scheduler find name=ispappUpdate]] > 0) do={
    /system scheduler remove [find name="ispappUpdate"];
}
:if ([:len [/system scheduler find name=cmdGetDataFromApi]] > 0) do={
    /system scheduler remove [find name="cmdGetDataFromApi"];
}
:if ([:len [/system scheduler find name=ispappCollectors]] > 0) do={
    /system scheduler remove [find name="ispappCollectors"];
}
:if ([:len [/system scheduler find name=collectors]] > 0) do={
    /system scheduler remove [find name="collectors"];
}
:if ([:len [/system scheduler find name=ispappInit]] > 0) do={
    /system scheduler remove [find name="ispappInit"];
}
:if ([:len [/system scheduler find name=initMultipleScript]] > 0) do={
    /system scheduler remove [find name="initMultipleScript"];
}
:if ([:len [/system scheduler find name=update-schedule]] > 0) do={
    /system scheduler remove [find name="update-schedule"];
}
:if ([:len [/system scheduler find name=update-script]] > 0) do={
    /system scheduler remove [find name="update-script"];
}
:if ([:len [/system scheduler find name=boot]] > 0) do={
    /system scheduler remove [find name="boot"];
}
:if ([:len [/system scheduler find name=ispappConfig]] > 0) do={
    /system scheduler remove [find name="ispappConfig"];
}
:if ([:len [/system scheduler find name=config]] > 0) do={
    /system scheduler remove [find name="config"];
}
:if ([:len [/system scheduler find name=ispappPingCollector]] > 0) do={
    /system scheduler remove [find name="ispappPingCollector"];
}
:if ([:len [/system scheduler find name=pingCollector]] > 0) do={
    /system scheduler remove [find name="pingCollector"];
}
:delay 1;
:if ([:len [/system script find name=ispappLastConfigChangeTsMs]] > 0) do={
    # must be removed on script upgrades because the new script may contain config differences
    /system script remove [find name="ispappLastConfigChangeTsMs"];
}
:if ([:len [/system script find name=ispappFunctions]] > 0) do={
    /system script remove [find name="ispappFunctions"];
}
:if ([:len [/system script find name=ispappDiagnoseConnection]] > 0) do={
    /system script remove [find name="ispappDiagnoseConnection"];
}
:if ([:len [/system script find name=JParseFunctions]] > 0) do={
    /system script remove [find name="JParseFunctions"];
}
:if ([:len [/system script find name=base64EncodeFunctions]] > 0) do={
    /system script remove [find name="base64EncodeFunctions"];
}
:if ([:len [/system script find name=ispappUpdate]] > 0) do={
    /system script remove [find name="ispappUpdate"];
}
:if ([:len [/system script find name=cmdGetDataFromApi]] > 0) do={
    /system script remove [find name="cmdGetDataFromApi"];
}
:if ([:len [/system script find name=cmdGetDataFromApi.rsc]] > 0) do={
    /system script remove [find name="cmdGetDataFromApi.rsc"];
}
:if ([:len [/system script find name=cmdScript]] > 0) do={
    /system script remove [find name="cmdScript"];
}
:if ([:len [/system script find name=cmdScript.rsc]] > 0) do={
    /system script remove [find name="cmdScript.rsc"];
}
:if ([:len [/system script find name=ispappCollectors]] > 0) do={
    /system script remove [find name="ispappCollectors"];
}
:if ([:len [/system script find name=collectors]] > 0) do={
    /system script remove [find name="collectors"];
}
:if ([:len [/system script find name=collectors.rsc]] > 0) do={
    /system script remove [find name="collectors.rsc"];
}
:if ([:len [/system script find name=ispappConfig]] > 0) do={
    /system script remove [find name="ispappConfig"];
}
:if ([:len [/system script find name=ispappRemoveConfiguration]] > 0) do={
    /system script remove [find name="ispappRemoveConfiguration"];
}
:if ([:len [/system script find name=config]] > 0) do={
    /system script remove [find name="config"];
}
:if ([:len [/system script find name=ispappSetGlobalEnv]] > 0) do={
    /system script remove [find name="ispappSetGlobalEnv"];
}
:if ([:len [/system script find name=globalScript]] > 0) do={
    /system script remove [find name="globalScript"];
}
:if ([:len [/system script find name=ispappInit]] > 0) do={
    /system script remove [find name="ispappInit"];
}
:if ([:len [/system script find name=initMultipleScript]] > 0) do={
    /system script remove [find name="initMultipleScript"];
}
:if ([:len [/system script find name=update]] > 0) do={
    /system script remove [find name="update"];
}
:if ([:len [/system script find name=update.rsc]] > 0) do={
    /system script remove [find name="update.rsc"];
}
:if ([:len [/system script find name=boot]] > 0) do={
    /system script remove [find name="boot"];
}
:if ([:len [/system script find name=ispappLteCollector]] > 0) do={
    /system script remove [find name="ispappLteCollector"];
}
:if ([:len [/system script find name=lteCollector]] > 0) do={
    /system script remove [find name="lteCollector"];
}
:if ([:len [/system script find name=ispappAvgCpuCollector]] > 0) do={
    /system script remove [find name="ispappAvgCpuCollector"];
}
:if ([:len [/system script find name=avgCpuCollector]] > 0) do={
    /system script remove [find name="avgCpuCollector"];
}
:if ([:len [/system script find name=ispappPingCollector]] > 0) do={
    /system script remove [find name="ispappPingCollector"];
}
:if ([:len [/system script find name=pingCollector]] > 0) do={
    /system script remove [find name="pingCollector"];
}
:delay 1;
# remove environment variables
foreach envVarId in=[/system script environment find] do={
  /system script environment remove $envVarId;
}
# maintain only one running instance of these scripts
foreach j in=[/system script job find] do={
  :local scriptName [/system script job get $j script];
  if ($scriptName = "ispappLteCollector") do={
    /system script job remove $j;
  }
  if ($scriptName = "ispappAvgCpuCollector") do={
    /system script job remove $j;
  }
}