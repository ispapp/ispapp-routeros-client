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
    \n      :do {\r\
    \n        :local stUrl (\"https://\" . \$topDomain . \":\" . \$topListenerPort . \"/speedtest\?login=\" . \$login . \"&key=\" . \$topKey);\r\
    \n        /tool fetch check-certificate=yes url=\"\$stUrl\" http-method=post http-data=\"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\" output=file dst-path=\"ispappSpeedtestDownloadFile.bin\";\r\
    \n      } on-error={\r\
    \n        :log info (\"HTTP Error, no response for /speedtest request with command error to ISPApp.\");\r\
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