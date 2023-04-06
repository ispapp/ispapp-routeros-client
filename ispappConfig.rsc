/system script add dont-require-permissions=no name=ispappConfig owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":local sameScriptRunningCount [:len [/system script job find script=ispappConfig]];\r\
    \n\r\
    \nif (\$sameScriptRunningCount > 1) do={\r\
    \n  :error (\"ispappConfig script already running \" . \$sameScriptRunningCount . \" times\");\r\
    \n}\r\
    \n\r\
    \n:global login;\r\
    \nif (\$login = \"00:00:00:00:00:00\" || \$login = \"\") do={\r\
    \n  :system script run ispappSetGlobalEnv;\r\
    \n  :error \"ispappConfig not running with login 00:00:00:00:00:00 or blank, attempting login gain again.\";\r\
    \n} else={\r\
    \n\r\
    \n  :log info (\"ispappConfig script start\");\r\
    \n\r\
    \n  :global topDomain;\r\
    \n  :global topKey;\r\
    \n  :global topClientInfo;\r\
    \n  :global topListenerPort;\r\
    \n  :global rosTimestringSec;\r\
    \n  :global urlEncodeFunct;\r\
    \n  :local lcf;\r\
    \n  :local buildTime [/system resource get build-time];\r\
    \n  :local osbuilddate [\$rosTimestringSec \$buildTime];\r\
    \n  :set osbuilddate [:tostr \$osbuilddate];\r\
    \n  :local osversion [/system package get 0 version];\r\
    \n  :local os [/system package get 0 name];\r\
    \n  :local hardwaremake [/system resource get platform];\r\
    \n  :local hardwaremodel [/system resource get board-name];\r\
    \n  :local cpu [/system resource get cpu];\r\
    \n  :local hostname [/system identity get name];\r\
    \n  :local hasWirelessConfigurationMenu 0;\r\
    \n  :local hasWifiwave2ConfigurationMenu 0;\r\
    \n  :global configScriptSuccessSinceInit;\r\
    \n  :global updateScriptSuccessSinceInit;\r\
    \n\r\
    \n  :do {\r\
    \n    :if ([:len [/interface wireless security-profiles find ]]>0) do={\r\
    \n      :set hasWirelessConfigurationMenu 1;\r\
    \n    }\r\
    \n  } on-error={\r\
    \n    # no wireless\r\
    \n  }\r\
    \n\r\
    \n  :do {\r\
    \n    :if ([:len [/interface wifiwave2 find ]]>0) do={\r\
    \n      :set hasWifiwave2ConfigurationMenu 1;\r\
    \n    }\r\
    \n  } on-error={\r\
    \n    # no wifiwave2\r\
    \n  }\r\
    \n\r\
    \n  # ----- interfaces -------\r\
    \n\r\
    \n  :local ifaceDataArray;\r\
    \n  :local totalInterface ([/interface print as-value count-only]);\r\
    \n  :local interfaceCounter 0;\r\
    \n\r\
    \n  foreach iface in=[/interface find] do={\r\
    \n\r\
    \n    :set interfaceCounter (\$interfaceCounter + 1);\r\
    \n\r\
    \n    if ( [:len \$iface] != 0 ) do={\r\
    \n\r\
    \n      :local ifaceName [/interface get \$iface name];\r\
    \n      :local ifaceMac [/interface get \$iface mac-address];\r\
    \n\r\
    \n      :local ifaceDefaultName \"\";\r\
    \n\r\
    \n      :do {\r\
    \n        :set ifaceDefaultName [/interface get \$iface default-name];\r\
    \n      } on-error={\r\
    \n        # no default name, many interface types are this way\r\
    \n      }\r\
    \n\r\
    \n      #:put (\$ifaceName, \$ifaceMac);\r\
    \n\r\
    \n      if ( [:len \$ifaceName] !=0 ) do={\r\
    \n        if (\$interfaceCounter != \$totalInterface) do={\r\
    \n          # not last interface\r\
    \n          :local ifaceData \"{\\\"if\\\":\\\"\$ifaceName\\\",\\\"mac\\\":\\\"\$ifaceMac\\\",\\\"defaultIf\\\":\\\"\$ifaceDefaultName\\\"},\";\r\
    \n          :set ifaceDataArray (\$ifaceDataArray.\$ifaceData);\r\
    \n        }\r\
    \n        if (\$interfaceCounter = \$totalInterface) do={\r\
    \n          # last interface\r\
    \n          :local ifaceData \"{\\\"if\\\":\\\"\$ifaceName\\\",\\\"mac\\\":\\\"\$ifaceMac\\\",\\\"defaultIf\\\":\\\"\$ifaceDefaultName\\\"}\";\r\
    \n          :set ifaceDataArray (\$ifaceDataArray.\$ifaceData);\r\
    \n        }\r\
    \n\r\
    \n      }\r\
    \n    }\r\
    \n  }\r\
    \n\r\
    \n  # ----- wireless configs used for unknown hosts -----\r\
    \n\r\
    \n  :local wapArray;\r\
    \n  :local wapCount 0;\r\
    \n\r\
    \n  if (\$hasWirelessConfigurationMenu = 1) do={\r\
    \n\r\
    \n    :put \"has wireless configuration menu\";\r\
    \n\r\
    \n    :foreach wIfaceId in=[/interface wireless find] do={\r\
    \n\r\
    \n      :local wIfName ([/interface wireless get \$wIfaceId name]);\r\
    \n      :local wIfSsid ([/interface wireless get \$wIfaceId ssid]);\r\
    \n      :local wIfSecurityProfile ([/interface wireless get \$wIfaceId security-profile]);\r\
    \n\r\
    \n      :local wIfKey \"\";\r\
    \n      :local wIfKeyTypeString \"\";\r\
    \n\r\
    \n      :do {\r\
    \n        :set wIfKey ([/interface wireless security-profiles get [/interface wireless security-profiles find name=\$wIfSecurityProfile] wpa2-pre-shared-key]);\r\
    \n        :local wIfKeyType ([/interface wireless security-profiles get [/interface wireless security-profiles find name=\$wIfSecurityProfile] authentication-types]);\r\
    \n\r\
    \n        # convert the array \$wIfKeyType to the space delimited string \$wIfKeyTypeString\r\
    \n        :foreach kt in=\$wIfKeyType do={\r\
    \n          :set wIfKeyTypeString (\$wIfKeyTypeString . \$kt . \" \");\r\
    \n        }\r\
    \n\r\
    \n      } on-error={\r\
    \n        # no settings in security profile or profile does not exist\r\
    \n      }\r\
    \n\r\
    \n      # remove the last space if it exists\r\
    \n      if ([:len \$wIfKeyTypeString] > 0) do={\r\
    \n        :set wIfKeyTypeString [:pick \$wIfKeyTypeString 0 ([:len \$wIfKeyTypeString] -1)];\r\
    \n      }\r\
    \n\r\
    \n      # if the wpa2 key is empty, get the wpa key\r\
    \n      if ([:len \$wIfKey] = 0) do={\r\
    \n        :do {\r\
    \n          :set wIfKey ([/interface wireless security-profiles get [/interface wireless security-profiles find name=\$wIfSecurityProfile] wpa-pre-shared-key]);\r\
    \n        } on-error={\r\
    \n          # no security profile found\r\
    \n        }\r\
    \n      }\r\
    \n\r\
    \n      :local newWapIf;\r\
    \n\r\
    \n      if (\$wapCount = 0) do={\r\
    \n        # first wifi interface\r\
    \n        :set newWapIf \"{\\\"if\\\":\\\"\$wIfName\\\",\\\"ssid\\\":\\\"\$wIfSsid\\\",\\\"key\\\":\\\"\$wIfKey\\\",\\\"keytypes\\\":\\\"\$wIfKeyTypeString\\\"}\";\r\
    \n      } else={\r\
    \n        # not first wifi interface\r\
    \n        :set newWapIf \",{\\\"if\\\":\\\"\$wIfName\\\",\\\"ssid\\\":\\\"\$wIfSsid\\\",\\\"key\\\":\\\"\$wIfKey\\\",\\\"keytypes\\\":\\\"\$wIfKeyTypeString\\\"}\";\r\
    \n      }\r\
    \n\r\
    \n      :set wapCount (\$wapCount + 1);\r\
    \n\r\
    \n      :set wapArray (\$wapArray.\$newWapIf);\r\
    \n      \r\
    \n    }\r\
    \n  }\r\
    \n\r\
    \n  if (\$hasWifiwave2ConfigurationMenu = 1) do={\r\
    \n\r\
    \n    :put \"has wifiwave2 configuration menu\"\r\
    \n\r\
    \n    :foreach wIfaceId in=[/interface wifiwave2 find] do={\r\
    \n\r\
    \n      :local wIfName ([/interface wifiwave2 get \$wIfaceId name]);\r\
    \n      :local wIfSsid ([/interface wifiwave2 get \$wIfaceId configuration.ssid]);\r\
    \n\r\
    \n      :local wIfKey \"\";\r\
    \n      :local wIfKeyTypeString \"\";\r\
    \n\r\
    \n      :do {\r\
    \n        :set wIfKey ([/interface wifiwave2 get \$wIfaceId security.passphrase]);\r\
    \n        :local wIfKeyType ([/interface wifiwave2 get \$wIfaceId security.authentication-types]);\r\
    \n\r\
    \n        # convert the array \$wIfKeyType to the space delimited string \$wIfKeyTypeString\r\
    \n        :foreach kt in=\$wIfKeyType do={\r\
    \n          :set wIfKeyTypeString (\$wIfKeyTypeString . \$kt . \" \");\r\
    \n        }\r\
    \n\r\
    \n      } on-error={\r\
    \n      }\r\
    \n\r\
    \n      # remove the last space if it exists\r\
    \n      if ([:len \$wIfKeyTypeString] > 0) do={\r\
    \n        :set wIfKeyTypeString [:pick \$wIfKeyTypeString 0 ([:len \$wIfKeyTypeString] -1)];\r\
    \n      }\r\
    \n\r\
    \n      #:put (\"wifiwave2 interface \$wIfName, ssid: \$wIfSsid, key: \$wIfKey\");\r\
    \n\r\
    \n      :local newWapIf;\r\
    \n\r\
    \n      if (\$wapCount = 0) do={\r\
    \n        # first wifi interface\r\
    \n        :set newWapIf \"{\\\"if\\\":\\\"\$wIfName\\\",\\\"ssid\\\":\\\"\$wIfSsid\\\",\\\"key\\\":\\\"\$wIfKey\\\",\\\"keytypes\\\":\\\"\$wIfKeyTypeString\\\"}\";\r\
    \n      } else={\r\
    \n        # not first wifi interface\r\
    \n        :set newWapIf \",{\\\"if\\\":\\\"\$wIfName\\\",\\\"ssid\\\":\\\"\$wIfSsid\\\",\\\"key\\\":\\\"\$wIfKey\\\",\\\"keytypes\\\":\\\"\$wIfKeyTypeString\\\"}\";\r\
    \n      }\r\
    \n\r\
    \n      :set wapCount (\$wapCount + 1);\r\
    \n\r\
    \n      :set wapArray (\$wapArray.\$newWapIf);\r\
    \n\r\
    \n    }\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n  # ----- json config string -----\r\
    \n\r\
    \n  :local hwUrlValCollectData (\"{\\\"clientInfo\\\":\\\"\$topClientInfo\\\", \\\"osVersion\\\":\\\"\$osversion\\\", \\\"hardwareMake\\\":\\\"\$hardwaremake\\\",\\\"hardwareModel\\\":\\\"\$hardwaremodel\\\",\\\"hardwareCpuInfo\\\":\\\"\$cpu\\\",\\\"os\\\":\\\"\$os\\\",\\\"osBuildDate\\\":\$osbuilddate,\\\"fw\\\":\\\"\$topClientInfo\\\",\\\"hostname\\\":\\\"\$hostname\\\",\\\"interfaces\\\":[\$ifaceDataArray],\\\"wirelessConfigured\\\":[\$wapArray],\\\"webshellSupport\\\":true,\\\"bandwidthTestSupport\\\":true,\\\"firmwareUpgradeSupport\\\":true,\\\"wirelessSupport\\\":true}\");\r\
    \n\r\
    \n  if ( \$updateScriptSuccessSinceInit = false || \$configScriptSuccessSinceInit = false ) do={\r\
    \n    # show verbose output until the config script and update script succeed\r\
    \n    :put (\"config request url\", \"https://\" . \$topDomain . \":\" . \$topListenerPort . \"/config\?login=\" . \$login . \"&key=\" . \$topKey);\r\
    \n    :put (\"config request json\", \$hwUrlValCollectData);\r\
    \n  }\r\
    \n\r\
    \n  :local configSendData;\r\
    \n  :do { \r\
    \n    :set configSendData [/tool fetch check-certificate=yes mode=https http-method=post http-header-field=\"cache-control: no-cache, content-type: application/json\" http-data=\"\$hwUrlValCollectData\" url=(\"https://\" . \$topDomain . \":\" . \$topListenerPort . \"/config\?login=\" . \$login . \"&key=\" . \$topKey) as-value output=user]\r\
    \n      if ( \$updateScriptSuccessSinceInit = false || \$configScriptSuccessSinceInit = false ) do={\r\
    \n        # show verbose output until the config script and update script succeed\r\
    \n        :put \"\\nconfigSendData (config request response before parsing):\\n\";\r\
    \n        :put \$configSendData;\r\
    \n\t  }\r\
    \n  } on-error={\r\
    \n    :log info (\"HTTP Error, no response for /config request to ISPApp, sent \" . [:len \$hwUrlValCollectData] . \" bytes\");\r\
    \n  }\r\
    \n\r\
    \n  :delay 1;\r\
    \n\r\
    \n  :local setConfig 0;\r\
    \n  :local host;\r\
    \n\r\
    \n  # make sure there was a non empty response\r\
    \n  # and that Err was not the first three characters, indicating an inability to parse\r\
    \n  if ([:len \$configSendData] != 0 && [:find \$configSendData \"Err.Raise 8732\"] != 0) do={\r\
    \n\r\
    \n    :local jstr;\r\
    \n\r\
    \n    :set jstr [\$configSendData];\r\
    \n    global JSONIn\r\
    \n    global JParseOut;\r\
    \n    global fJParse;\r\
    \n\r\
    \n    # Parse data\r\
    \n    :set JSONIn (\$jstr->\"data\");\r\
    \n    :set JParseOut [\$fJParse];\r\
    \n\r\
    \n    :set host (\$JParseOut->\"host\");\r\
    \n    :local jsonError (\$JParseOut->\"error\");\r\
    \n\r\
    \n    if ( [:len \$host] != 0 ) do={\r\
    \n\t\r\
    \n\t  :set configScriptSuccessSinceInit true;\r\
    \n\r\
    \n      # set outageIntervalSeconds and updateIntervalSeconds\r\
    \n      :global outageIntervalSeconds (num(\$host->\"outageIntervalSeconds\"));\r\
    \n      :global updateIntervalSeconds (num(\$host->\"updateIntervalSeconds\"));\r\
    \n\r\
    \n      # check if lastConfigChangeTsMs in the response\r\
    \n      # is larger than the last configuration application\r\
    \n\r\
    \n      :set lcf (\$host->\"lastConfigChangeTsMs\");\r\
    \n      #:put \"response's lastConfigChangeTsMs: \$lcf\";\r\
    \n      if ( [:len [/system script find name=ispappLastConfigChangeTsMs]] > 0 ) do={\r\
    \n        /system script run ispappLastConfigChangeTsMs;\r\
    \n      } else={\r\
    \n        /system script add name=ispappLastConfigChangeTsMs;\r\
    \n      }\r\
    \n      :global lastConfigChangeTsMs;\r\
    \n      #:put \"current lastConfigChangeTsMs: \$lastConfigChangeTsMs\";\r\
    \n\r\
    \n      if (\$lcf != \$lastConfigChangeTsMs) do={\r\
    \n        #:put \"new configuration must be applied\";\r\
    \n\r\
    \n        :set setConfig 1;\r\
    \n\r\
    \n        :log info (\"ISPApp has responded with a configuration change\");\r\
    \n\r\
    \n      }\r\
    \n\r\
    \n      # set the value in the ispappLastConfigChangeTsMs script to that sent by the server\r\
    \n      /system script set \"ispappLastConfigChangeTsMs\" source=\":global lastConfigChangeTsMs; :set lastConfigChangeTsMs \$lcf;\";\r\
    \n\r\
    \n      # the config response is authenticated, disable the scheduler\r\
    \n      # and enable the ispappUpdate script\r\
    \n\r\
    \n      /system scheduler disable ispappConfig;\r\
    \n      /system scheduler enable ispappUpdate;\r\
    \n\r\
    \n    } else={\r\
    \n\r\
    \n      # there was an error in the response\r\
    \n      :log info (\"config request responded with an error: \" . \$jsonError);\r\
    \n\r\
    \n      if ([:find \$jsonError \"invalid login\"] > -1) do={\r\
    \n        #:put \"invalid login, running ispappSetGlobalEnv to make sure login is set correctly\";\r\
    \n        /system script run ispappSetGlobalEnv;\r\
    \n        /system scheduler set interval=300s \"ispappConfig\";\r\
    \n        /system scheduler set interval=300s \"ispappUpdate\";\r\
    \n      }\r\
    \n\r\
    \n    }\r\
    \n\r\
    \n  } else={\r\
    \n\r\
    \n    # there was a parsing error, the scheduler will continue repeating config requests and \$setConfig will not equal 1\r\
    \n    #:put \"JSON parsing error with config request, config scheduler will continue retrying\";\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n  if (\$setConfig = 1) do={\r\
    \n\r\
    \n    :put \"Configuring from ISPApp.\";\r\
    \n\r\
    \n    :local configuredSsids (\$host->\"wirelessConfigs\");\r\
    \n\r\
    \n    :local hostkey (\$host->\"key\");\r\
    \n    #:put \"hostkey: \$hostkey\";\r\
    \n    :do {\r\
    \n      # if the password is blank, set it to the hostkey\r\
    \n      /password new-password=\"\$hostkey\" confirm-new-password=\"\$hostkey\" old-password=\"\";\r\
    \n      # if the password was able to be modified, then disable ip services that are not required\r\
    \n      /ip service disable ftp;\r\
    \n      /ip service disable api;\r\
    \n      /ip service disable telnet;\r\
    \n      /ip service disable www;\r\
    \n      /ip service disable www-ssl;\r\
    \n    } on-error={\r\
    \n      :put \"existing password remains, ISPApp host key not set as password\";\r\
    \n    }\r\
    \n\r\
    \n    :local hostname (\$host->\"name\");\r\
    \n    #:put \"hostname: \$hostname\";\r\
    \n\r\
    \n    #:put (\"Host Name ==>>>\" . \$hostname);\r\
    \n    if ([:len \$hostname] != 0) do={\r\
    \n      #:put (\"System identity changed.\");\r\
    \n      :do { /system identity set name=\$hostname }\r\
    \n    }\r\
    \n    if ([:len \$hostname] = 0) do={\r\
    \n      #:put (\"System identity not added!!!\");\r\
    \n    }\r\
    \n\r\
    \n    :local mode;\r\
    \n    :local channelwidth;\r\
    \n    :local wifibeaconint;\r\
    \n\r\
    \n    :set mode (\$host->\"wirelessMode\");\r\
    \n    :set channelwidth (\$host->\"wirelessChannel\");\r\
    \n    #:set wifibeaconint (\$host->\"wirelessBeaconInt\");\r\
    \n\r\
    \n    :global wanIP;\r\
    \n    #:put \"wanIP: \$wanIP\";\r\
    \n\r\
    \n    #:put \"wireless mode: \$mode with WAN interface: \$wanport\";\r\
    \n\r\
    \n    # remove the existing ispapp configuration\r\
    \n    /system script run ispappRemoveConfiguration;\r\
    \n\r\
    \n    :put (\"configured ssids\", [:len \$configuredSsids]);\r\
    \n\r\
    \n    if ([:len \$configuredSsids] > 0) do={\r\
    \n      # this device has wireless interfaces and configurations have been sent from the server\r\
    \n      :put \"ISPApp configuring wireless\";\r\
    \n\r\
    \n      :local ssidIndex;\r\
    \n      :local ssidCount 0;\r\
    \n      :foreach ssidIndex in \$configuredSsids do={\r\
    \n        # this is each configured ssid, there can be many\r\
    \n        \r\
    \n        :local vlanmode \"use-tag\";\r\
    \n\r\
    \n        :local authenticationtypes (\$ssidIndex->\"encType\");\r\
    \n        :local encryptionKey (\$ssidIndex->\"encKey\");\r\
    \n        :local ssid (\$ssidIndex->\"ssid\");\r\
    \n        #:local vlanid (\$ssidIndex->\"vlanId\");\r\
    \n        :local vlanid 0;\r\
    \n        :local defaultforward (\$ssidIndex->\"clientIsolation\");\r\
    \n        :local preamblemode (\$ssidIndex->\"sp\");\r\
    \n        :local dotw (\$ssidIndex->\"dotw\");\r\
    \n\r\
    \n        if (\$authenticationtypes = \"psk\") do={\r\
    \n          :set authenticationtypes \"wpa-psk\";\r\
    \n        }\r\
    \n        if (\$authenticationtypes = \"psk2\") do={\r\
    \n          :set authenticationtypes \"wpa2-psk\";\r\
    \n        }\r\
    \n        if (\$authenticationtypes = \"sae\") do={\r\
    \n          :set authenticationtypes \"wpa2-psk\";\r\
    \n        }\r\
    \n        if (\$authenticationtypes = \"sae-mixed\") do={\r\
    \n          :set authenticationtypes \"wpa2-psk\";\r\
    \n        }\r\
    \n        if (\$authenticationtypes = \"owe\") do={\r\
    \n          :set authenticationtypes \"wpa2-psk\";\r\
    \n        }\r\
    \n\r\
    \n        if (\$vlanid = 0) do={\r\
    \n          :set vlanid  1;\r\
    \n          :set vlanmode \"no-tag\"\r\
    \n        }\r\
    \n\r\
    \n        # change json values of configuration parameters to what routeros expects\r\
    \n        if (\$mode = \"sta\") do={\r\
    \n          :set mode \"station\";\r\
    \n        }\r\
    \n        if (\$defaultforward = \"true\") do={\r\
    \n          :set defaultforward \"yes\";\r\
    \n        }\r\
    \n        if (\$defaultforward = \"false\") do={\r\
    \n          :set defaultforward \"no\";\r\
    \n        }\r\
    \n        if (\$channelwidth != \"auto\") do={\r\
    \n          :set channelwidth \"20mhz\";\r\
    \n        }\r\
    \n        if (\$preamblemode = \"true\") do={\r\
    \n          :set preamblemode \"long\";\r\
    \n        }\r\
    \n        if (\$preamblemode = \"false\") do={\r\
    \n          :set preamblemode \"short\";\r\
    \n        }\r\
    \n\r\
    \n        #:put \"\\nconfiguring wireless network \$ssid\";\r\
    \n        #:put (\"index ==>\" . \$ssidIndex);\r\
    \n        #:put (\"authtype==>\" . \$authenticationtypes);\r\
    \n        #:put (\"enckey==>\" . \$encryptionKey);\r\
    \n        #:put (\"ssid==>\" . \$ssid);\r\
    \n        #:put (\"vlanid==>\" . \$vlanid);\r\
    \n        #:put (\"chwidth==>\" . \$channelwidth);\r\
    \n        #:put (\"forwardmode==>\" . \$defaultforward);\r\
    \n        #:put (\"preamblemode==>\" . \$preamblemode);\r\
    \n\r\
    \n        if (\$hasWirelessConfigurationMenu = 1) do={\r\
    \n          :foreach wIfaceId in=[/interface wireless find] do={\r\
    \n\r\
    \n            :local wIfName ([/interface wireless get \$wIfaceId name]);\r\
    \n            :local wIfType ([/interface wireless get \$wIfaceId interface-type]);\r\
    \n\r\
    \n            if (\$wIfType != \"virtual\") do={\r\
    \n              # this is a physical interface\r\
    \n\r\
    \n              :put \"configuring wireless interface: \$wIfName, ssid: \$ssid, authenticationtypes: \$authenticationtypes\";\r\
    \n              :local scriptText \"\";\r\
    \n\r\
    \n              if (\$authenticationtypes != \"none\") do={\r\
    \n                :do {\r\
    \n                  :set scriptText \"/interface wireless security-profiles add name=\\\"ispapp-\$ssid-\$wIfName\\\" mode=dynamic-keys authentication-types=\\\"\$authenticationtypes\\\" wpa2-pre-shared-key=\\\"\$encryptionKey\\\";\";\r\
    \n                } on-error={\r\
    \n                }\r\
    \n              }\r\
    \n\r\
    \n              if (\$ssidCount = 0) do={\r\
    \n\r\
    \n                # set each physical wireless interface with the first ssid\r\
    \n                # and the comment \"ispapp\" to know that ispapp configured it\r\
    \n                if (\$authenticationtypes = \"none\") do={\r\
    \n                  :set scriptText (\$scriptText . \" /interface wireless set \$wIfName ssid=\\\"\$ssid\\\" wireless-protocol=802.11 frequency=auto mode=ap-bridge hide-ssid=no comment=ispapp; /interface wireless enable \$wIfName;\");\r\
    \n                } else={\r\
    \n                  :set scriptText (\$scriptText . \" /interface wireless set \$wIfName ssid=\\\"\$ssid\\\" security-profile=\\\"ispapp-\$ssid-\$wIfName\\\" wireless-protocol=802.11 frequency=auto mode=ap-bridge hide-ssid=no comment=ispapp; /interface wireless enable \$wIfName;\");\r\
    \n                }\r\
    \n\r\
    \n              } else={\r\
    \n                # create a virtual interface for any ssids after the first\r\
    \n                if (\$authenticationtypes = \"none\") do={\r\
    \n                  :set scriptText (\$scriptText . \" /interface wireless add master-interface=\\\"\$wIfName\\\" ssid=\\\"\$ssid\\\" name=\\\"ispapp-\$ssid-\$wIfName\\\" wireless-protocol=802.11 frequency=auto mode=ap-bridge; /interface wireless enable \\\"ispapp-\$ssid-\$wIfName\\\";\");\r\
    \n                } else={\r\
    \n                  :set scriptText (\$scriptText . \" /interface wireless add master-interface=\\\"\$wIfName\\\" ssid=\\\"\$ssid\\\" name=\\\"ispapp-\$ssid-\$wIfName\\\" security-profile=\\\"ispapp-\$ssid-\$wIfName\\\" wireless-protocol=802.11 frequency=auto mode=ap-bridge; /interface wireless enable \\\"ispapp-\$ssid-\$wIfName\\\";\");\r\
    \n                }\r\
    \n              }\r\
    \n              :execute script=\"\$scriptText\";\r\
    \n            }\r\
    \n\r\
    \n          }\r\
    \n        }\r\
    \n\r\
    \n        if (\$hasWifiwave2ConfigurationMenu = 1) do={\r\
    \n          :foreach wIfaceId in=[/interface wifiwave2 find] do={\r\
    \n\r\
    \n            :local wIfName ([/interface wifiwave2 get \$wIfaceId name]);\r\
    \n            :local wIfMasterIf ([/interface wifiwave2 get \$wIfaceId master-interface]);\r\
    \n\r\
    \n            if ([:len \$wIfMasterIf] = 0) do={\r\
    \n              # this is a physical interface\r\
    \n\r\
    \n              :put \"configuring wifiwave2 interface: \$wIfName, ssid: \$ssid, authenticationtypes: \$authenticationtypes\";\r\
    \n\r\
    \n              if (\$ssidCount = 0) do={\r\
    \n\r\
    \n                # set each physical wireless interface with the first ssid\r\
    \n                # and the comment \"ispapp\" to know that ispapp configured it\r\
    \n                if (\$authenticationtypes = \"none\") do={\r\
    \n                  :execute script=\"/interface wifiwave2 set \$wIfName configuration.ssid=\\\"\$ssid\\\" configuration.mode=ap configuration.hide-ssid=no comment=ispapp; /interface wifiwave2 enable \$wIfName;\";\r\
    \n                } else={\r\
    \n                  :execute script=\"/interface wifiwave2 set \$wIfName configuration.ssid=\\\"\$ssid\\\" security.passphrase=\\\"\$encryptionKey\\\" security.authentication-types=\\\"\$authenticationtypes\\\" configuration.mode=ap configuration.hide-ssid=no comment=ispapp; /interface wifiwave2 enable \$wIfName;\";\r\
    \n                }\r\
    \n\r\
    \n              } else={\r\
    \n                # create a virtual interface for any ssids after the first\r\
    \n                if (\$authenticationtypes = \"none\") do={\r\
    \n                  :execute script=\"/interface wifiwave2 add master-interface=\\\"\$wIfName\\\" configuration.ssid=\\\"\$ssid\\\" configuration.mode=ap configuration.hide-ssid=no comment=ispapp; /interface wifiwave2 enable \\\"ispapp-\$ssid-\$wIfName\\\";\";\r\
    \n                } else={\r\
    \n                  :execute script=\"/interface wifiwave2 add master-interface=\\\"\$wIfName\\\" configuration.ssid=\\\"\$ssid\\\" security.passphrase=\\\"\$encryptionKey\\\" security.authentication-types=\\\"\$authenticationtypes\\\" configuration.mode=ap configuration.hide-ssid=no comment=ispapp; /interface wifiwave2 enable \\\"ispapp-\$ssid-\$wIfName\\\";\";\r\
    \n                }\r\
    \n              }\r\
    \n            }\r\
    \n\r\
    \n          }\r\
    \n        }\r\
    \n\r\
    \n        :set ssidCount (\$ssidCount + 1);\r\
    \n\r\
    \n      }\r\
    \n    }\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n}"