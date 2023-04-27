/system script add dont-require-permissions=no name=ispappUpdate owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":local sameScriptRunningCount [:len [/system script job find script=ispappUpdate]];\r\
    \n\r\
    \nif (\$sameScriptRunningCount > 1) do={\r\
    \n  :error (\"ispappUpdate script already running \" . \$sameScriptRunningCount . \" times\");\r\
    \n}\r\
    \n\r\
    \n# include functions\r\
    \n:global rosTsSec;\r\
    \n:global Split;\r\
    \n\r\
    \n# CMD and fastUpdate\r\
    \n\r\
    \n:global updateSequenceNumber;\r\
    \n:global connectionFailures;\r\
    \n:global configScriptSuccessSinceInit;\r\
    \n:global updateScriptSuccessSinceInit;\r\
    \n:global rosMajorVersion;\r\
    \n:global rosTimestringSec;\r\
    \n\r\
    \n:global topDomain;\r\
    \n:global topKey;\r\
    \n:global topListenerPort;\r\
    \n:global topServerPort;\r\
    \n:global topSmtpPort;\r\
    \n:global login;\r\
    \n:global ipbandswtestserver;\r\
    \n:global btuser;\r\
    \n:global btpwd;\r\
    \n:if ([:len \$topDomain] = 0 || [:len \$topKey] = 0 || [:len \$topListenerPort] = 0 || [:len \$topServerPort] = 0 || [:len \$topSmtpPort] = 0 || [:len \$login] = 0) do={\r\
    \n  /system script run ispappInit;\r\
    \n  :error \"required ISPApp environment variable was empty, running ispappInit\"\r\
    \n}\r\
    \n:global urlEncodeFunct;\r\
    \n\r\
    \n:global simpleRotatedKey;\r\
    \n\r\
    \n:global collectUpDataVal;\r\
    \n:if ([:len \$collectUpDataVal] = 0) do={\r\
    \n  :set collectUpDataVal \"{}\";\r\
    \n}\r\
    \n\r\
    \n# WAN Port IP Address\r\
    \n:global wanIP;\r\
    \n:do {\r\
    \n\r\
    \n  :local gatewayStatus ([:tostr [/ip route get [:pick [find dst-address=0.0.0.0/0 active=yes] 0] gateway-status]]);\r\
    \n\r\
    \n  #:put \"gatewayStatus: \$gatewayStatus\";\r\
    \n\r\
    \n  # split the gateway status into\r\
    \n  # IP/NM, reachable status, via, interface\r\
    \n  :local gwStatusArray [\$Split \$gatewayStatus \" \"];\r\
    \n  #:put \"\$gwStatusArray\";\r\
    \n\r\
    \n  # get ip address and netmask as IP/Netmask\r\
    \n  :local tempIpv4String [/ip address get [:pick [/ip address find interface=(\$gwStatusArray->3)] 0] address];\r\
    \n  # split by /\r\
    \n  :local wanIpv4Arr [\$Split \$tempIpv4String \"/\"];\r\
    \n  # set the wan ip\r\
    \n  :set wanIP (\$wanIpv4Arr->0);\r\
    \n\r\
    \n} on-error={\r\
    \n  :set wanIP \"\";\r\
    \n  #:log info (\"Error finding WAN IP.\");\r\
    \n}\r\
    \n\r\
    \n:local upTime [/system resource get uptime];\r\
    \n:local upSeconds [\$rosTsSec \$upTime];\r\
    \n\r\
    \n:local collectUpData \"{\\\"collectors\\\":\$collectUpDataVal,\\\"wanIp\\\":\\\"\$wanIP\\\",\\\"uptime\\\":\$upSeconds,\\\"sequenceNumber\\\":\$updateSequenceNumber}\";\r\
    \n\r\
    \n:local updateUrl (\"https://\" . \$topDomain . \":\" . \$topListenerPort . \"/update\?login=\" . \$login . \"&key=\" . \$topKey);\r\
    \n\r\
    \nif ( \$updateScriptSuccessSinceInit = false || \$configScriptSuccessSinceInit = false ) do={\r\
    \n  # show verbose output until the config script and update script succeed\r\
    \n  :put \"sending data to /update\";\r\
    \n  :put \$updateUrl;\r\
    \n  :put (\"\$collectUpData\");\r\
    \n}\r\
    \n\r\
    \n:local updateResponse;\r\
    \n:local cmdsArrayLenVal;\r\
    \n\r\
    \n:do {\r\
    \n    :set updateResponse ([/tool fetch check-certificate=yes mode=https http-method=post http-header-field=\"cache-control: no-cache, content-type: application/json\" http-data=\"\$collectUpData\" url=\$updateUrl as-value output=user]);\r\
    \n    if ( \$updateScriptSuccessSinceInit = false || \$configScriptSuccessSinceInit = false ) do={\r\
    \n      # show verbose output until the config script and update script succeed\r\
    \n      :put (\"updateResponse\");\r\
    \n      :put (\$updateResponse);\r\
    \n\t}\r\
    \n\r\
    \n} on-error={\r\
    \n  :log info (\"HTTP Error, no response for /update request to ISPApp, sent \" . [:len \$collectUpData] . \" bytes.\");\r\
    \n  :set connectionFailures (\$connectionFailures + 1);\r\
    \n  :error \"HTTP error with /update request, no response receieved.\";\r\
    \n}\r\
    \n:set updateSequenceNumber (\$updateSequenceNumber + 1);\r\
    \n\r\
    \n  #:put \"parsing json\";\r\
    \n\r\
    \n  :global JSONIn;\r\
    \n  :global JParseOut;\r\
    \n  :global fJParse;\r\
    \n    \r\
    \n  :set JSONIn (\$updateResponse->\"data\");\r\
    \n  :set JParseOut [\$fJParse];\r\
    \n    \r\
    \n  if ( [:len \$JParseOut] != 0 ) do={\r\
    \n\r\
    \n    # show the json output in the log\r\
    \n    #:log info \$JParseOut;\r\
    \n\r\
    \n    :local jsonError (\$JParseOut->\"error\");\r\
    \n\t\r\
    \n\tif ( \$jsonError = nil ) do={\r\
    \n\t  # there were no errors, set that the update script has succeeded since init\r\
    \n\t  :set updateScriptSuccessSinceInit true;\r\
    \n\t}\r\
    \n\r\
    \n    :set simpleRotatedKey (\$JParseOut->\"simpleRotatedKey\");\r\
    \n\r\
    \n    :local fwStatus (\$JParseOut->\"fwStatus\");\r\
    \n    if (\$fwStatus = \"pending\") do={\r\
    \n      :global upgrading;\r\
    \n\r\
    \n      if (\$upgrading = true) do={\r\
    \n        :error \"another upgrade is running\";\r\
    \n      }\r\
    \n      :set upgrading true;\r\
    \n\r\
    \n      :local upgradeUrl (\"https://\" . \$topDomain . \":\" . \$topServerPort . \"/host_fw\?login=\" . \$login . \"&key=\" . \$topKey);\r\
    \n\r\
    \n      :do {\r\
    \n        /tool fetch check-certificate=yes url=\"\$upgradeUrl\" output=file dst-path=\"ispapp-upgrade.rsc\";\r\
    \n      } on-error={\r\
    \n        :set upgrading false;\r\
    \n        :error \"HTTP error downloading upgrade file\";\r\
    \n      }\r\
    \n      :set upgrading false;\r\
    \n      /import \"/ispapp-upgrade.rsc\";\r\
    \n    }\r\
    \n\r\
    \n    :local rebootval (\$JParseOut->\"reboot\");\r\
    \n\r\
    \n    #:put \"rebootval: \$rebootval\";\r\
    \n\r\
    \n    if ( \$rebootval = \"1\" ) do={\r\
    \n\r\
    \n      :log info \"Reboot\";\r\
    \n      /system reboot;\r\
    \n\r\
    \n    } else={\r\
    \n\r\
    \n      # check if lastConfigChangeTsMs is different\r\
    \n      /system script run ispappLastConfigChangeTsMs;\r\
    \n      :global lastConfigChangeTsMs;\r\
    \n      :local dbl (\$JParseOut->\"lastConfigChangeTsMs\");\r\
    \n\r\
    \n      if (([:len \$dbl] != 0 && [:len \$lastConfigChangeTsMs] != 0) && (\$dbl != \$lastConfigChangeTsMs || \$jsonError != nil)) do={\r\
    \n        #:put \"update response indicates configuration changes\";\r\
    \n        :log info (\"update response indicates configuration changes, running ispappConfig script\");\r\
    \n        /system scheduler disable ispappUpdate;\r\
    \n        /system scheduler enable ispappConfig;\r\
    \n        :error \"there was a json error in the update response\";\r\
    \n\r\
    \n      } else={\r\
    \n        if ( \$jsonError != nil ) do={\r\
    \n          :log info (\"update request responded with an error: \" . \$jsonError);\r\
    \n          if ([:find \$jsonError \"invalid login\"] > -1) do={\r\
    \n            #:put \"invalid login, running ispappSetGlobalEnv to make sure login is set correctly\";\r\
    \n            /system script run ispappSetGlobalEnv;\r\
    \n            /system scheduler set interval=300s \"ispappConfig\";\r\
    \n            /system scheduler set interval=300s \"ispappUpdate\";\r\
    \n          }\r\
    \n        }\r\
    \n      }\r\
    \n\r\
    \n  # speedtest\r\
    \n  :local executeSpeedtest (\$JParseOut->\"executeSpeedtest\");\r\
    \n  :if ( \$executeSpeedtest = true) do={\r\
    \n    # run this in a thread\r\
    \n    :execute {\r\
    \n      # make the request\r\
    \n      :global speedtestRunning;\r\
    \n      :if ( \$speedtestRunning = true) do={\r\
    \n        :error \"speedtest already running\";\r\
    \n      }\r\
    \n      :set speedtestRunning true;\r\
    \n       :do {\r\
    \n      :local txAvg 0 \r\
    \n      :local rxAvg 0 \r\
    \n      :local txDuration \r\
    \n      :local rxDuration \r\
    \n      :local stUrl (\"https://\" . \$topDomain . \":\" . \$topListenerPort . \"/bandwidth\?login=\" . \$login . \"&key=\" . \$topKey);\r\
    \n      :local ds [/system clock get date];\r\
    \n      :local currentTime [/system clock get time];\r\
    \n      :set currentTime ([:pick \$currentTime 0 2].[:pick \$currentTime 3 5].[:pick \$currentTime 6 8])\r\
    \n    \r\
    \n      :set ds ([:pick \$ds 7 11].[:pick \$ds 0 3].[:pick \$ds 4 6])\r\
    \n      /tool bandwidth-test protocol=tcp direction=transmit address=\$ipbandswtestserver user=\$btuser password=\$btpwd duration=5s do={\r\
    \n        :set txAvg (\$\"tx-total-average\");\r\
    \n        :set txDuration (\$\"duration\")\r\
    \n        }\r\
    \n    \r\
    \n      /tool bandwidth-test protocol=tcp direction=receive address=\$ipbandswtestserver user=\$btuser password=\$btpwd duration=5s do={\r\
    \n      :set rxAvg (\$\"rx-total-average\");\r\
    \n      :set rxDuration (\$\"duration\")\r\
    \n      }\r\
    \n      :local jsonResult (\"{ \\\"date\\\": \\\"\" . \$ds . \"\\\", \\\"time\\\": \\\"\" . \$currentTime . \"\\\", \\\"txAvg\\\": \" . \$txAvg . \", \\\"rxAvg\\\": \" . \$rxAvg . \", \\\"rxDuration\\\": \\\"\" . \$rxDuration . \"\\\", \\\"txDuration\\\": \\\"\" . \$txDuration . \"\\\" }\")\r\
    \n      :log debug (\$jsonResult);\r\
    \n      :put \$stUrl\r\
    \n      :local result [/tool fetch mode=https url=\$stUrl http-method=post http-data=\$jsonResult http-header=\"Content-Type: application/json\" as-value output=user];\r\
    \n      :if (\$result->\"status\" = \"finished\") do={\r\
    \n        :if (\$result->\"data\" = \"Data received successfully\") do={\r\
    \n            :put (\$result->\"data\")\r\
    \n        }\r\
    \n    }\r\
    \n      } on-error={\r\
    \n        :log info (\"HTTP Error, no response for speedtest request with command error to ISPApp.\");\r\
    \n      }\r\
    \n      :set speedtestRunning false;\r\
    \n    }\r\
    \n  }\r\
    \n\r\
    \n\r\
    \n  # commands\r\
    \n\r\
    \n  :local cmds (\$JParseOut->\"cmds\");\r\
    \n\r\
    \n  :foreach cmdKey in=(\$cmds) do={\r\
    \n\r\
    \n    :local cmd (\$cmdKey->\"cmd\");\r\
    \n    :local stderr (\$cmdKey->\"stderr\");\r\
    \n    :local stdout (\$cmdKey->\"stdout\");\r\
    \n    :local uuidv4 (\$cmdKey->\"uuidv4\");\r\
    \n    :local wsid (\$cmdKey->\"ws_id\");\r\
    \n\r\
    \n    # create the command output filename with the uuidv4 in it\r\
    \n    :local outputFilename (\$uuidv4 . \"ispappCommandOutput.txt\");\r\
    \n\r\
    \n    # do not rerun the command if the file already exists\r\
    \n    :if ([:len [/file find name=\$outputFilename]] > 0) do={\r\
    \n      :error \"command already executed, not re-executing\";\r\
    \n    }\r\
    \n\r\
    \n    # create a system script with the command contents\r\
    \n    :if ([:len [/system script find name=\"ispappCommand\"]] = 0) do={\r\
    \n      /system script add name=\"ispappCommand\";\r\
    \n    }\r\
    \n\r\
    \n    /system script set \"ispappCommand\" source=\"\$cmd\";\r\
    \n\r\
    \n    :log info (\"ispapp is executing command: \" . \$cmd);\r\
    \n\r\
    \n    # run the script and place the output in a known file\r\
    \n    # this runs in the background if not ran with :put\r\
    \n    # resulting in the contents being empty\r\
    \n    :local scriptJobId [:execute script={/system script run ispappCommand;} file=\$outputFilename];\r\
    \n\r\
    \n    :local j ([:len [/system script job find where script=ispappCommand]]);\r\
    \n    :local scriptWaitCount 0;\r\
    \n\r\
    \n    # maximum wait time for a job\r\
    \n    # n * 500ms\r\
    \n    :local maxWaitCount 200;\r\
    \n\r\
    \n    :while (\$j > 0 && \$scriptWaitCount < \$maxWaitCount) do={\r\
    \n      # wait for script to finish\r\
    \n      :delay 500ms;\r\
    \n      :set scriptWaitCount (\$scriptWaitCount + 1);\r\
    \n      :set j ([:len [/system script job find where script=ispappCommand]]);\r\
    \n      #:log info (\"waiting for \" . \$j . \" at wait count \" . \$scriptWaitCount);\r\
    \n    }\r\
    \n\r\
    \n    # get the file size\r\
    \n    :local outputSize 0;\r\
    \n    :local waitForFileCount 0;\r\
    \n    :while (\$outputSize = 0 && \$waitForFileCount < 10) do={\r\
    \n      :delay 500ms;\r\
    \n      :set waitForFileCount (\$waitForFileCount + 1);\r\
    \n      #:log info (\"outputSize: \" . \$outputSize);\r\
    \n      if ([:len [/file find name=\$outputFilename]] > 0) do={\r\
    \n        :set outputSize ([/file get \$outputFilename size]);\r\
    \n      }\r\
    \n    }\r\
    \n\r\
    \n    :local timeoutError 0;\r\
    \n    if (\$scriptWaitCount = \$maxWaitCount) do={\r\
    \n      :do {\r\
    \n        # kill hanging job\r\
    \n        :log info (\"killing hanging job \" . \$cmd);\r\
    \n        /system script job remove \$scriptJobId;\r\
    \n        :set timeoutError 1;\r\
    \n      } on-error={\r\
    \n      }\r\
    \n    }\r\
    \n\r\
    \n    # base64 encoded\r\
    \n    :global base64EncodeFunct;\r\
    \n\r\
    \n    :local cmdJsonData \"\";\r\
    \n\r\
    \n    if (\$timeoutError = 1) do={\r\
    \n\r\
    \n      # send an error that the command experienced a timeout\r\
    \n\r\
    \n      :local output ([\$base64EncodeFunct stringVal=\"command timeout\"]);\r\
    \n      #:log info (\"base64: \" . \$output);\r\
    \n\r\
    \n      # make the request body\r\
    \n      :set cmdJsonData \"{\\\"ws_id\\\":\\\"\$wsid\\\",\\\"uuidv4\\\":\\\"\$uuidv4\\\",\\\"stderr\\\":\\\"\$output\\\",\\\"sequenceNumber\\\":\$updateSequenceNumber}\";\r\
    \n\r\
    \n      # make the request\r\
    \n      :do {\r\
    \n        :local cmdResponse ([/tool fetch check-certificate=yes mode=https http-method=post http-header-field=\"cache-control: no-cache, content-type: application/json\" http-data=\"\$cmdJsonData\" url=\$updateUrl as-value output=user]);\r\
    \n      } on-error={\r\
    \n        :log info (\"HTTP Error, no response for /update request with command error to ISPApp.\");\r\
    \n      }\r\
    \n      :set updateSequenceNumber (\$updateSequenceNumber + 1);\r\
    \n\r\
    \n      #:put \$cmdResponse;\r\
    \n\r\
    \n      # delete command output file\r\
    \n      /file remove \$outputFilename;\r\
    \n\r\
    \n    } else={\r\
    \n\r\
    \n    # successful command\r\
    \n    :log info (\"command output size: \" . \$outputSize);\r\
    \n\r\
    \n    # send via https if small enough to fit in a routeros variable\r\
    \n    # send via smtp if not, because smtp can send a file\r\
    \n    if (\$outputSize <= 4096) do={\r\
    \n\r\
    \n      # send an http request to /update with the command response\r\
    \n\r\
    \n      # file contents are small enough to fit in a routeros variable\r\
    \n      :local output ([/file get \$outputFilename contents]);\r\
    \n\r\
    \n      if ([:len \$output] = 0) do={\r\
    \n\r\
    \n        # routeros commands like add return nothing when successful\r\
    \n        :set output (\"success\");\r\
    \n\r\
    \n      }\r\
    \n\r\
    \n      :set output ([\$base64EncodeFunct stringVal=\$output]);\r\
    \n      #:log info (\"base64: \" . \$output);\r\
    \n\r\
    \n      # make the request body\r\
    \n      :set cmdJsonData \"{\\\"ws_id\\\":\\\"\$wsid\\\",\\\"uuidv4\\\":\\\"\$uuidv4\\\",\\\"stdout\\\":\\\"\$output\\\",\\\"sequenceNumber\\\":\$updateSequenceNumber}\";\r\
    \n\r\
    \n      #:put \$cmdJsonData;\r\
    \n      #:log info (\"ispapp command response json: \" . \$cmdJsonData);\r\
    \n\r\
    \n      # make the request\r\
    \n      :do {\r\
    \n        :local cmdResponse ([/tool fetch check-certificate=yes mode=https http-method=post http-header-field=\"cache-control: no-cache, content-type: application/json\" http-data=\"\$cmdJsonData\" url=\$updateUrl as-value output=user]);\r\
    \n      } on-error={\r\
    \n        :log info (\"HTTP Error, no response for /update request with command response to ISPApp.\");\r\
    \n      }\r\
    \n      :set updateSequenceNumber (\$updateSequenceNumber + 1);\r\
    \n\r\
    \n      #:put \$cmdResponse;\r\
    \n\r\
    \n      # delete command output file\r\
    \n      /file remove \$outputFilename;\r\
    \n\r\
    \n    } else={\r\
    \n\r\
    \n      # send an email to the instance with the command response on port 465\r\
    \n      # the routeros email tool allows files to be sent, but the fetch tool does not and the\r\
    \n      # variable size in routeros is limited at 4096 bytes\r\
    \n\r\
    \n      # make the request body\r\
    \n      :set cmdJsonData \"{\\\"ws_id\\\":\\\"\$wsid\\\", \\\"uuidv4\\\":\\\"\$uuidv4\\\"}\";\r\
    \n\r\
    \n      # these are accessed once in the :execute script before the next iteration of ispappUpdate\r\
    \n      :global lastSmtpCommandJsonData \$cmdJsonData;\r\
    \n      :global lastSmtpCommandOutputFilename \$outputFilename;\r\
    \n\r\
    \n      # run this in a thread\r\
    \n      :execute {\r\
    \n\r\
    \n        :global login;\r\
    \n        :global simpleRotatedKey;\r\
    \n        :global topDomain;\r\
    \n        :global topSmtpPort;\r\
    \n        :global lastSmtpCommandJsonData;\r\
    \n        :global lastSmtpCommandOutputFilename;\r\
    \n\r\
    \n        :local threadPersistantFilename \$lastSmtpCommandOutputFilename;\r\
    \n\r\
    \n        /tool e-mail send server=(\$topDomain) from=(\$login . \"@\" . \$simpleRotatedKey . \".ispapp.co\") to=(\"command@\" . \$topDomain) port=(\$topSmtpPort) file=\$threadPersistantFilename subject=\"c\" body=(\$lastSmtpCommandJsonData);\r\
    \n\r\
    \n        # wait 10 minutes for the upload to finish\r\
    \n        :delay 600s;\r\
    \n\r\
    \n        # delete command output file\r\
    \n        /file remove \$threadPersistantFilename;\r\
    \n\r\
    \n      };\r\
    \n\r\
    \n    }\r\
    \n\r\
    \n    }\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n  # configuration backups\r\
    \n  :do {\r\
    \n\r\
    \n      # /system history print does not work yet\r\
    \n      # test if configuration has changed\r\
    \n      #:local lastLocalConfigurationTime ([/system history get ([find]->0) date] . \" \" . [/system history get ([find]->0) time]);\r\
    \n      #:log info \$lastLocalConfigurationTime;\r\
    \n\r\
    \n      # get the unix timestamp\r\
    \n      #:local lastLocalConfigurationTs [\$rosTimestringSec \$lastLocalConfigurationTime];\r\
    \n      #:log info \$lastLocalConfigurationTs;\r\
    \n\r\
    \n      # get the timestamp of the last local configuration change from the JSON\r\
    \n      # /system history print does not work yet\r\
    \n\r\
    \n      :global lastLocalConfigurationBackupSendTs;\r\
    \n\r\
    \n      # non documented typeof value of nothing happens when you delete an environment variable, RouterOS 6.49.7\r\
    \n      if ([:typeof \$lastLocalConfigurationBackupSendTs] = \"nil\" || [:typeof \$lastLocalConfigurationBackupSendTs] = \"nothing\") do={\r\
    \n        # set first value\r\
    \n        :set lastLocalConfigurationBackupSendTs 0;\r\
    \n      }\r\
    \n\r\
    \n      #:log info (\"lastLocalConfigurationBackupSendTs\", [:typeof \$lastLocalConfigurationBackupSendTs], \$lastLocalConfigurationBackupSendTs);\r\
    \n\r\
    \n      :local currentTimestring ([/system clock get date] . \" \" . [/system clock get time]);\r\
    \n      :local currentTs [\$rosTimestringSec \$currentTimestring];\r\
    \n\r\
    \n      :local lastBackupDiffSec (\$currentTs - \$lastLocalConfigurationBackupSendTs);\r\
    \n      #:log info (\"lastBackupDiffSec\", \$lastBackupDiffSec);\r\
    \n\r\
    \n      if (\$lastBackupDiffSec > 60 * 60 * 12) do={\r\
    \n        # send a new local configuration backup every 12 hours\r\
    \n\r\
    \n        :log info (\"sending new local configuration backup\");\r\
    \n\r\
    \n        :execute {\r\
    \n\r\
    \n          # set last backup time\r\
    \n          :local lastLocalConfigurationBackupSendTimestring ([/system clock get date] . \" \" . [/system clock get time]);\r\
    \n          :global lastLocalConfigurationBackupSendTs [\$rosTimestringSec \$lastLocalConfigurationBackupSendTimestring];\r\
    \n\r\
    \n          # send backup\r\
    \n\r\
    \n          # run the script and place the output in a known file\r\
    \n          :local scriptJobId [:execute script={/export terse;} file=ispappBackup.txt];\r\
    \n\r\
    \n          # wait 10 minutes for the export to finish\r\
    \n          :delay 600s;\r\
    \n\r\
    \n          :global login;\r\
    \n          :global simpleRotatedKey;\r\
    \n          :global topDomain;\r\
    \n          :global topSmtpPort;\r\
    \n\r\
    \n          /tool e-mail send server=(\$topDomain) from=(\$login . \"@\" . \$simpleRotatedKey . \".ispapp.co\") to=(\"backup@\" . \$topDomain) port=(\$topSmtpPort) file=\"ispappBackup.txt\" subject=\"c\" body=\"{}\";\r\
    \n\r\
    \n        };\r\
    \n\r\
    \n      }\r\
    \n\r\
    \n  } on-error={\r\
    \n\r\
    \n    :log info (\"ISPApp, error with configuration backups.\");\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n        # enable updateFast if set to true\r\
    \n        :local updateFast (\$JParseOut->\"updateFast\");\r\
    \n        #:log info (\"updateFast: \" . \$updateFast);\r\
    \n        :if ( \$updateFast = true) do={\r\
    \n          :do {\r\
    \n            :local updateSchedulerInterval [/system scheduler get ispappUpdate interval ];\r\
    \n            :if (\$updateSchedulerInterval != \"00:00:02\") do={\r\
    \n              /system scheduler set interval=2s \"ispappUpdate\";\r\
    \n              /system scheduler set interval=2s \"ispappCollectors\";\r\
    \n              /system scheduler set interval=10s \"ispappPingCollector\";\r\
    \n            }\r\
    \n          } on-error={\r\
    \n          }\r\
    \n        } else={\r\
    \n          :do {\r\
    \n\r\
    \n              :global lastUpdateOffsetSec;\r\
    \n              :set lastUpdateOffsetSec (\$JParseOut->\"lastUpdateOffsetSec\");\r\
    \n\r\
    \n              :global lastColUpdateOffsetSec;\r\
    \n              :set lastColUpdateOffsetSec (\$JParseOut->\"lastColUpdateOffsetSec\");\r\
    \n\r\
    \n              :global updateIntervalSeconds;\r\
    \n              :global outageIntervalSeconds;\r\
    \n              :local secUntilNextUpdate (num(\$updateIntervalSeconds-\$lastColUpdateOffsetSec));\r\
    \n              :local secUntilNextOutage (num(\$outageIntervalSeconds-\$lastUpdateOffsetSec));\r\
    \n              :local setSec \$secUntilNextOutage;\r\
    \n\r\
    \n              if (\$secUntilNextUpdate <= \$setSec + 5) do={\r\
    \n                # the next update request that is an update not an outage update is when the update must be sent to allow the data to be collected (5 seconds max, on planet)\r\
    \n                # use updateIntervalSeconds to calculate the setSec\r\
    \n                :set setSec \$secUntilNextUpdate;\r\
    \n              }\r\
    \n\r\
    \n              if (\$setSec < 2) do={\r\
    \n\r\
    \n                # don't change the interval to 0, causing the script to no longer run\r\
    \n                # set to 2\r\
    \n                :local updateSchedulerInterval [/system scheduler get ispappUpdate interval ];\r\
    \n                :if (\$updateSchedulerInterval != \"00:00:02\") do={\r\
    \n                  /system scheduler set interval=2s \"ispappUpdate\";\r\
    \n                }\r\
    \n\r\
    \n             } else={\r\
    \n\r\
    \n                # set the update request interval if it is different than what is set\r\
    \n    \r\
    \n                :local updateSchedulerInterval [/system scheduler get ispappUpdate interval];\r\
    \n                :local tsSec [\$rosTsSec \$updateSchedulerInterval];\r\
    \n                :if (\$setSec != \$tsSec) do={\r\
    \n                  # set the scheduler to the correct interval\r\
    \n                  /system scheduler set interval=(\$setSec) \"ispappUpdate\";\r\
    \n                }\r\
    \n\r\
    \n            }\r\
    \n\r\
    \n            :local collSchedulerInterval [/system scheduler get ispappCollectors interval ];\r\
    \n            :if (\$collSchedulerInterval != \"00:01:00\") do={\r\
    \n                # set the ispappCollectors interval to default\r\
    \n    \r\
    \n                /system scheduler set interval=60s \"ispappCollectors\";\r\
    \n                /system scheduler set interval=60s \"ispappPingCollector\";\r\
    \n            }\r\
    \n\r\
    \n          } on-error={\r\
    \n            :log info (\"error parsing update interval\");\r\
    \n          }\r\
    \n\r\
    \n        }\r\
    \n\r\
    \n}\r\
    \n}"