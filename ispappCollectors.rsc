/system script add dont-require-permissions=no name=ispappCollectors owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":global connectionFailures;\r\
    \n:global lteJsonString;\r\
    \n:global login;\r\
    \n:global collectorsRunning;\r\
    \nif (\$collectorsRunning = true) do={\r\
    \n  :error \"ispappCollectors is already running\";\r\
    \n}\r\
    \n:set collectorsRunning true;\r\
    \n:global pingJsonString;\r\
    \n\r\
    \n:global rosTsSec;\r\
    \n\r\
    \n:local hasWirelessConfigurationMenu 0;\r\
    \n:local hasWifiwave2ConfigurationMenu 0;\r\
    \n:local hasCapsmanConfigurationMenu 0;\r\
    \n\r\
    \n:do {\r\
    \n  :if ([:len [/interface wireless security-profiles find ]]>0) do={\r\
    \n    :set hasWirelessConfigurationMenu 1;\r\
    \n  }\r\
    \n} on-error={\r\
    \n  # no wireless\r\
    \n}\r\
    \n\r\
    \n:do {\r\
    \n  :if ([:len [/interface wifiwave2 find ]]>0) do={\r\
    \n    :set hasWifiwave2ConfigurationMenu 1;\r\
    \n  }\r\
    \n} on-error={\r\
    \n  # no wifiwave2\r\
    \n}\r\
    \n\r\
    \n:do {\r\
    \n  :if ([:len [/caps-man find ]]>0) do={\r\
    \n    :set hasCapsmanConfigurationMenu 1;\r\
    \n  }\r\
    \n} on-error={\r\
    \n  # no wifiwave2\r\
    \n}\r\
    \n\r\
    \n#------------- Interface Collector-----------------\r\
    \n\r\
    \n:local ifaceDataArray;\r\
    \n:local totalInterface ([/interface print as-value count-only]);\r\
    \n:local interfaceCounter 0;\r\
    \n\r\
    \n:foreach iface in=[/interface find] do={\r\
    \n\r\
    \n  :set interfaceCounter (\$interfaceCounter + 1);\r\
    \n\r\
    \n  :if ( [:len \$iface] != 0 ) do={\r\
    \n\r\
    \n    :local ifaceName [/interface get \$iface name];\r\
    \n    :local rxBytes 0;\r\
    \n    :local rxPackets 0;\r\
    \n    :local rxErrors 0;\r\
    \n    :local rxDrops 0;\r\
    \n    :local txBytes 0;\r\
    \n    :local txPackets 0;\r\
    \n    :local txErrors 0;\r\
    \n    :local txDrops 0;\r\
    \n    :local cChanges 0;\r\
    \n    :local macs 0;\r\
    \n\r\
    \n    :if ( [:len \$ifaceName] !=0 ) do={\r\
    \n\r\
    \n      # these all test the interface value first to maintain the variable value\r\
    \n      # as a number by leaving it as zero if there is no interface value\r\
    \n\r\
    \n      :local rxBytesVal [/interface get \$iface rx-byte];\r\
    \n      if ([:len \$rxBytesVal]>0) do={\r\
    \n        :set rxBytes \$rxBytesVal;\r\
    \n      }\r\
    \n      :local txBytesVal [/interface get \$iface tx-byte];\r\
    \n      if ([:len \$txBytesVal]>0) do={\r\
    \n        :set txBytes \$txBytesVal;\r\
    \n      }\r\
    \n\r\
    \n      :local rxPacketsVal [/interface get \$iface rx-packet];\r\
    \n      if ([:len \$rxPacketsVal]>0) do={\r\
    \n        :set rxPackets \$rxPacketsVal;\r\
    \n      }\r\
    \n      :local txPacketsVal [/interface get \$iface tx-packet];\r\
    \n      if ([:len \$txPacketsVal]>0) do={\r\
    \n        :set txPackets \$txPacketsVal\r\
    \n      }\r\
    \n\r\
    \n      :local rxErrorsVal [/interface get \$iface rx-error];\r\
    \n      if ([:len \$rxErrorsVal]>0) do={\r\
    \n        :set rxErrors \$rxErrorsVal;\r\
    \n      }\r\
    \n      :local txErrorsVal [/interface get \$iface tx-error];\r\
    \n      if ([:len \$txErrorsVal]>0) do={\r\
    \n        :set txErrors \$txErrorsVal\r\
    \n      }\r\
    \n\r\
    \n      :local rxDropsVal [/interface get \$iface rx-drop];\r\
    \n      if ([:len \$rxDropsVal]>0) do={\r\
    \n        :set rxDrops \$rxDropsVal;\r\
    \n      }\r\
    \n      :local txDropsVal [/interface get \$iface tx-drop];\r\
    \n      if ([:len \$txDropsVal]>0) do={\r\
    \n        :set txDrops \$txDropsVal;\r\
    \n      }\r\
    \n\r\
    \n      :local cChangesVal [/interface get \$iface link-downs];\r\
    \n      if ([:len \$cChangesVal]>0) do={\r\
    \n        :set cChanges \$cChangesVal;\r\
    \n      }\r\
    \n\r\
    \n      :local macsVal [:len [/ip arp find where interface=\$ifaceName]];\r\
    \n      if ([:len \$macsVal]>0) do={\r\
    \n        :set macs \$macsVal;\r\
    \n      }\r\
    \n\r\
    \n      :if (\$interfaceCounter != \$totalInterface) do={\r\
    \n        # not last interface\r\
    \n        :local ifaceData \"{\\\"if\\\":\\\"\$ifaceName\\\",\\\"recBytes\\\":\$rxBytes,\\\"recPackets\\\":\$rxPackets,\\\"recErrors\\\":\$rxErrors,\\\"recDrops\\\":\$rxDrops,\\\"sentBytes\\\":\$txBytes,\\\"sentPackets\\\":\$txPackets,\\\"sentErrors\\\":\$txErrors,\\\"sentDrops\\\":\$txDrops,\\\"carrierChanges\\\":\$cChanges,\\\"macs\\\":\$macs},\";\r\
    \n        :set ifaceDataArray (\$ifaceDataArray.\$ifaceData);\r\
    \n      }\r\
    \n      :if (\$interfaceCounter = \$totalInterface) do={\r\
    \n        # last interface\r\
    \n        :local ifaceData \"{\\\"if\\\":\\\"\$ifaceName\\\",\\\"recBytes\\\":\$rxBytes,\\\"recPackets\\\":\$rxPackets,\\\"recErrors\\\":\$rxErrors,\\\"recDrops\\\":\$rxDrops,\\\"sentBytes\\\":\$txBytes,\\\"sentPackets\\\":\$txPackets,\\\"sentErrors\\\":\$txErrors,\\\"sentDrops\\\":\$txDrops,\\\"carrierChanges\\\":\$cChanges,\\\"macs\\\":\$macs}\";\r\
    \n        :set ifaceDataArray (\$ifaceDataArray.\$ifaceData);\r\
    \n      }\r\
    \n\r\
    \n    }\r\
    \n  }\r\
    \n}\r\
    \n\r\
    \n#------------- Wap Collector-----------------\r\
    \n\r\
    \n:local wapArray;\r\
    \n:local wapCount 0;\r\
    \n\r\
    \nif (\$hasWirelessConfigurationMenu = 1) do={\r\
    \n  :foreach wIfaceId in=[/interface wireless find] do={\r\
    \n\r\
    \n    :local wIfName ([/interface wireless get \$wIfaceId name]);\r\
    \n    :local wIfSsid ([/interface wireless get \$wIfaceId ssid]);\r\
    \n\r\
    \n    # average the noise for the interface based on each connected station\r\
    \n    :local wIfNoise 0;\r\
    \n    :local wIfSig0 0;\r\
    \n    :local wIfSig1 0;\r\
    \n\r\
    \n    #:put (\"wireless interface \$wIfName ssid: \$wIfSsid\");\r\
    \n\r\
    \n    :local staJson;\r\
    \n    :local staCount 0;\r\
    \n\r\
    \n    :foreach wStaId in=[/interface wireless registration-table find where interface=\$wIfName] do={\r\
    \n\r\
    \n      :local wStaMac ([/interface wireless registration-table get \$wStaId mac-address]);\r\
    \n\r\
    \n      :local wStaRssi ([/interface wireless registration-table get \$wStaId signal-strength]);\r\
    \n      :set wStaRssi ([:pick \$wStaRssi 0 [:find \$wStaRssi \"dBm\"]]);\r\
    \n      :set wStaRssi ([:tonum \$wStaRssi]);\r\
    \n\r\
    \n      :local wStaNoise ([/interface wireless registration-table get \$wStaId signal-to-noise]);\r\
    \n      :set wStaNoise (\$wStaRssi - [:tonum \$wStaNoise]);\r\
    \n      #:put \"noise \$wStaNoise\"\r\
    \n\r\
    \n      :local wStaSig0 ([/interface wireless registration-table get \$wStaId signal-strength-ch0]);\r\
    \n      :set wStaSig0 ([:tonum \$wStaSig0]);\r\
    \n      #:put \"sig0 \$wStaSig0\"\r\
    \n\r\
    \n      :local wStaSig1 ([/interface wireless registration-table get \$wStaId signal-strength-ch1]);\r\
    \n      :set wStaSig1 ([:tonum \$wStaSig1]);\r\
    \n      if ([:len \$wStaSig1] = 0) do={\r\
    \n        :set wStaSig1 0;\r\
    \n      }\r\
    \n      #:put \"sig1 \$wStaSig1\"\r\
    \n\r\
    \n      :local wStaExpectedRate ([/interface wireless registration-table get \$wStaId p-throughput]);\r\
    \n      :local wStaAssocTime ([/interface wireless registration-table get \$wStaId uptime]);\r\
    \n\r\
    \n      # convert the associated time to seconds\r\
    \n      :local assocTimeSplit [\$rosTsSec \$wStaAssocTime];\r\
    \n      :set wStaAssocTime \$assocTimeSplit;\r\
    \n\r\
    \n      # set the interface values\r\
    \n      :set wIfNoise (\$wIfNoise + \$wStaNoise);\r\
    \n      :set wIfSig0 (\$wIfSig0 + \$wStaSig0);\r\
    \n      :set wIfSig1 (\$wIfSig1 + \$wStaSig1);\r\
    \n\r\
    \n      :local wStaIfBytes ([/interface wireless registration-table get \$wStaId bytes]);\r\
    \n      :local wStaIfSentBytes ([:pick \$wStaIfBytes 0 [:find \$wStaIfBytes \",\"]]);\r\
    \n      :local wStaIfRecBytes ([:pick \$wStaIfBytes 0 [:find \$wStaIfBytes \",\"]]);\r\
    \n\r\
    \n      :local wStaDhcpName ([/ip dhcp-server lease find where mac-address=\$wStaMac]);\r\
    \n\r\
    \n      if (\$wStaDhcpName) do={\r\
    \n        :set wStaDhcpName ([/ip dhcp-server lease get \$wStaDhcpName host-name]);\r\
    \n      } else={\r\
    \n        :set wStaDhcpName \"\";\r\
    \n      }\r\
    \n\r\
    \n      #:put (\"wireless station: \$wStaMac \$wStaRssi\");\r\
    \n\r\
    \n      :local newSta;\r\
    \n\r\
    \n      if (\$staCount = 0) do={\r\
    \n        :set newSta \"{\\\"mac\\\":\\\"\$wStaMac\\\",\\\"expectedRate\\\":\$wStaExpectedRate,\\\"assocTime\\\":\$wStaAssocTime,\\\"noise\\\":\$wStaNoise,\\\"signal0\\\":\$wStaSig0,\\\"signal1\\\":\$wStaSig1,\\\"rssi\\\":\$wStaRssi,\\\"sentBytes\\\":\$wStaIfSentBytes,\\\"recBytes\\\":\$wStaIfRecBytes,\\\"info\\\":\\\"\$wStaDhcpName\\\"}\";\r\
    \n      } else={\r\
    \n        :set newSta \",{\\\"mac\\\":\\\"\$wStaMac\\\",\\\"expectedRate\\\":\$wStaExpectedRate,\\\"assocTime\\\":\$wStaAssocTime,\\\"noise\\\":\$wStaNoise,\\\"signal0\\\":\$wStaSig0,\\\"signal1\\\":\$wStaSig1,\\\"rssi\\\":\$wStaRssi,\\\"sentBytes\\\":\$wStaIfSentBytes,\\\"recBytes\\\":\$wStaIfRecBytes,\\\"info\\\":\\\"\$wStaDhcpName\\\"}\";\r\
    \n      }\r\
    \n\r\
    \n      :set staJson (\$staJson.\$newSta);\r\
    \n\r\
    \n      :set staCount (\$staCount + 1);\r\
    \n\r\
    \n    }\r\
    \n\r\
    \n    :if (\$staCount > 0) do={\r\
    \n      #:put \"averaging noise, \$wIfNoise / \$staCount\";\r\
    \n      :set wIfNoise (\$wIfNoise / \$staCount);\r\
    \n    }\r\
    \n\r\
    \n    #:put \"if noise: \$wIfNoise\";\r\
    \n\r\
    \n    :if (\$wIfSig0 != 0) do={\r\
    \n      #:put \"averaging sig0, \$wIfSig0 / \$staCount\";\r\
    \n      :set wIfSig0 (\$wIfSig0 / \$staCount);\r\
    \n    }\r\
    \n\r\
    \n    :if (\$wIfSig1 != 0) do={\r\
    \n      #:put \"averaging sig0, \$wIfSig1 / \$staCount\";\r\
    \n      :set wIfSig1 (\$wIfSig1 / \$staCount);\r\
    \n    }\r\
    \n\r\
    \n    :local newWapIf;\r\
    \n\r\
    \n    if (\$wapCount = 0) do={\r\
    \n      :set newWapIf \"{\\\"stations\\\":[\$staJson],\\\"interface\\\":\\\"\$wIfName\\\",\\\"ssid\\\":\\\"\$wIfSsid\\\",\\\"noise\\\":\$wIfNoise,\\\"signal0\\\":\$wIfSig0,\\\"signal1\\\":\$wIfSig1}\";\r\
    \n    } else={\r\
    \n      :set newWapIf \",{\\\"stations\\\":[\$staJson],\\\"interface\\\":\\\"\$wIfName\\\",\\\"ssid\\\":\\\"\$wIfSsid\\\",\\\"noise\\\":\$wIfNoise,\\\"signal0\\\":\$wIfSig0,\\\"signal1\\\":\$wIfSig1}\";\r\
    \n    }\r\
    \n\r\
    \n    :set wapCount (\$wapCount + 1);\r\
    \n\r\
    \n    :set wapArray (\$wapArray.\$newWapIf);\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n}\r\
    \n\r\
    \nif (\$hasWifiwave2ConfigurationMenu = 1) do={\r\
    \n\r\
    \n  :foreach wIfaceId in=[/interface wifiwave2 find] do={\r\
    \n\r\
    \n    :local wIfName ([/interface wifiwave2 get \$wIfaceId name]);\r\
    \n    :local wIfSsid ([/interface wifiwave2 get \$wIfaceId configuration.ssid]);\r\
    \n\r\
    \n    # average the noise for the interface based on each connected station\r\
    \n    :local wIfNoise 0;\r\
    \n    :local wIfSig0 0;\r\
    \n    :local wIfSig1 0;\r\
    \n\r\
    \n    #:put (\"wifiwave2 interface \$wIfName ssid: \$wIfSsid\");\r\
    \n\r\
    \n    :local staJson;\r\
    \n    :local staCount 0;\r\
    \n\r\
    \n    :foreach wStaId in=[/interface wifiwave2 registration-table find where interface=\$wIfName] do={\r\
    \n\r\
    \n      :local wStaMac ([/interface wifiwave2 registration-table get \$wStaId mac-address]);\r\
    \n\r\
    \n      :local wStaRssi ([/interface wifiwave2 registration-table get \$wStaId signal]);\r\
    \n      :set wStaRssi ([:tonum \$wStaRssi]);\r\
    \n\r\
    \n      :local wStaAssocTime ([/interface wifiwave2 registration-table get \$wStaId uptime]);\r\
    \n\r\
    \n      # convert the associated time to seconds\r\
    \n      :local assocTimeSplit [\$rosTsSec \$wStaAssocTime];\r\
    \n      :set wStaAssocTime \$assocTimeSplit;\r\
    \n\r\
    \n      :local wStaIfBytes ([/interface wifiwave2 registration-table get \$wStaId bytes]);\r\
    \n      :local wStaIfSentBytes ([:pick \$wStaIfBytes 0 [:find \$wStaIfBytes \",\"]]);\r\
    \n      :local wStaIfRecBytes ([:pick \$wStaIfBytes 0 [:find \$wStaIfBytes \",\"]]);\r\
    \n\r\
    \n      :local wStaDhcpName ([/ip dhcp-server lease find where mac-address=\$wStaMac]);\r\
    \n\r\
    \n      if (\$wStaDhcpName) do={\r\
    \n        :set wStaDhcpName ([/ip dhcp-server lease get \$wStaDhcpName host-name]);\r\
    \n      } else={\r\
    \n        :set wStaDhcpName \"\";\r\
    \n      }\r\
    \n\r\
    \n      #:put (\"wifiwave2 station: \$wStaMac \$wStaRssi\");\r\
    \n\r\
    \n      :local newSta;\r\
    \n\r\
    \n      if (\$staCount = 0) do={\r\
    \n        :set newSta \"{\\\"mac\\\":\\\"\$wStaMac\\\",\\\"assocTime\\\":\$wStaAssocTime,\\\"rssi\\\":\$wStaRssi,\\\"sentBytes\\\":\$wStaIfSentBytes,\\\"recBytes\\\":\$wStaIfRecBytes,\\\"info\\\":\\\"\$wStaDhcpName\\\"}\";\r\
    \n      } else={\r\
    \n        :set newSta \",{\\\"mac\\\":\\\"\$wStaMac\\\",\\\"assocTime\\\":\$wStaAssocTime,\\\"rssi\\\":\$wStaRssi,\\\"sentBytes\\\":\$wStaIfSentBytes,\\\"recBytes\\\":\$wStaIfRecBytes,\\\"info\\\":\\\"\$wStaDhcpName\\\"}\";\r\
    \n      }\r\
    \n\r\
    \n      :set staJson (\$staJson.\$newSta);\r\
    \n\r\
    \n      :set staCount (\$staCount + 1);\r\
    \n\r\
    \n    }\r\
    \n\r\
    \n    :local newWapIf;\r\
    \n\r\
    \n    if (\$wapCount = 0) do={\r\
    \n      :set newWapIf \"{\\\"stations\\\":[\$staJson],\\\"interface\\\":\\\"\$wIfName\\\",\\\"ssid\\\":\\\"\$wIfSsid\\\",\\\"noise\\\":\$wIfNoise,\\\"signal0\\\":\$wIfSig0,\\\"signal1\\\":\$wIfSig1}\";\r\
    \n    } else={\r\
    \n      :set newWapIf \",{\\\"stations\\\":[\$staJson],\\\"interface\\\":\\\"\$wIfName\\\",\\\"ssid\\\":\\\"\$wIfSsid\\\",\\\"noise\\\":\$wIfNoise,\\\"signal0\\\":\$wIfSig0,\\\"signal1\\\":\$wIfSig1}\";\r\
    \n    }\r\
    \n\r\
    \n    :set wapCount (\$wapCount + 1);\r\
    \n\r\
    \n    :set wapArray (\$wapArray.\$newWapIf);\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n}\r\
    \n\r\
    \nif (\$hasCapsmanConfigurationMenu = 1) do={\r\
    \n  #------------- caps-man Collector-----------------\r\
    \n\r\
    \n  :foreach wIfaceId in=[/caps-man interface find] do={\r\
    \n\r\
    \n    :local wIfName ([/caps-man interface get \$wIfaceId name]);\r\
    \n    :local wIfConfName ([/caps-man interface get \$wIfName configuration]);\r\
    \n    :local wIfSsid ([/caps-man configuration get \$wIfConfName ssid]);\r\
    \n\r\
    \n    # average the noise for the interface based on each connected station\r\
    \n    :local wIfNoise 0;\r\
    \n    :local wIfSig0 0;\r\
    \n    :local wIfSig1 0;\r\
    \n\r\
    \n    #:put (\"caps-man interface \$wIfName ssid: \$wIfSsid\");\r\
    \n\r\
    \n    :local staJson;\r\
    \n    :local staCount 0;\r\
    \n\r\
    \n    :foreach wStaId in=[/caps-man registration-table find where interface=\$wIfName] do={\r\
    \n\r\
    \n      :local wStaMac ([/caps-man registration-table get \$wStaId mac-address]);\r\
    \n      #:put \"station mac: \$wStaMac\";\r\
    \n\r\
    \n      :local wStaRssi ([/caps-man registration-table get \$wStaId signal-strength]);\r\
    \n      :set wStaRssi ([:pick \$wStaRssi 0 [:find \$wStaRssi \"dBm\"]]);\r\
    \n      :set wStaRssi ([:tonum \$wStaRssi]);\r\
    \n\r\
    \n      :local wStaNoise ([/caps-man registration-table get \$wStaId signal-to-noise]);\r\
    \n      :set wStaNoise (\$wStaRssi - [:tonum \$wStaNoise]);\r\
    \n      #:put \"noise \$wStaNoise\"\r\
    \n\r\
    \n      :local wStaSig0 ([/caps-man registration-table get \$wStaId signal-strength-ch0]);\r\
    \n      :set wStaSig0 ([:tonum \$wStaSig0]);\r\
    \n      #:put \"sig0 \$wStaSig0\"\r\
    \n\r\
    \n      :local wStaSig1 ([/caps-man registration-table get \$wStaId signal-strength-ch1]);\r\
    \n      :set wStaSig1 ([:tonum \$wStaSig1]);\r\
    \n      if ([:len \$wStaSig1] = 0) do={\r\
    \n        :set wStaSig1 0;\r\
    \n      }\r\
    \n      #:put \"sig1 \$wStaSig1\"\r\
    \n\r\
    \n      :local wStaExpectedRate ([/caps-man registration-table get \$wStaId p-throughput]);\r\
    \n      :local wStaAssocTime ([/caps-man registration-table get \$wStaId uptime]);\r\
    \n\r\
    \n      # convert the associated time to seconds\r\
    \n      :local assocTimeSplit [\$rosTsSec \$wStaAssocTime];\r\
    \n      :set wStaAssocTime \$assocTimeSplit;\r\
    \n\r\
    \n      # set the interface values\r\
    \n      :set wIfNoise (\$wIfNoise + \$wStaNoise);\r\
    \n      :set wIfSig0 (\$wIfSig0 + \$wStaSig0);\r\
    \n      :set wIfSig1 (\$wIfSig1 + \$wStaSig1);\r\
    \n\r\
    \n      :local wStaIfBytes ([/caps-man registration-table get \$wStaId bytes]);\r\
    \n      :local wStaIfSentBytes ([:pick \$wStaIfBytes 0 [:find \$wStaIfBytes \",\"]]);\r\
    \n      :local wStaIfRecBytes ([:pick \$wStaIfBytes 0 [:find \$wStaIfBytes \",\"]]);\r\
    \n\r\
    \n      :local wStaDhcpName ([/ip dhcp-server lease find where mac-address=\$wStaMac]);\r\
    \n\r\
    \n      if (\$wStaDhcpName) do={\r\
    \n        :set wStaDhcpName ([/ip dhcp-server lease get \$wStaDhcpName host-name]);\r\
    \n      } else={\r\
    \n        :set wStaDhcpName \"\";\r\
    \n      }\r\
    \n\r\
    \n      #:put (\"caps-man station: \$wStaMac \$wStaRssi\");\r\
    \n      #:put (\"bytes: \$wStaIfSentBytes \$wStaIfRecBytes\");\r\
    \n      #:put (\"dhcp lease host-name: \$wStaDhcpName\");\r\
    \n\r\
    \n      :local newSta;\r\
    \n\r\
    \n      if (\$staCount = 0) do={\r\
    \n        :set newSta \"{\\\"mac\\\":\\\"\$wStaMac\\\",\\\"expectedRate\\\":\$wStaExpectedRate,\\\"assocTime\\\":\$wStaAssocTime,\\\"noise\\\":\$wStaNoise,\\\"signal0\\\":\$wStaSig0,\\\"signal1\\\":\$wStaSig1,\\\"rssi\\\":\$wStaRssi,\\\"sentBytes\\\":\$wStaIfSentBytes,\\\"recBytes\\\":\$wStaIfRecBytes,\\\"info\\\":\\\"\$wStaDhcpName\\\"}\";\r\
    \n      } else={\r\
    \n        :set newSta \",{\\\"mac\\\":\\\"\$wStaMac\\\",\\\"expectedRate\\\":\$wStaExpectedRate,\\\"assocTime\\\":\$wStaAssocTime,\\\"noise\\\":\$wStaNoise,\\\"signal0\\\":\$wStaSig0,\\\"signal1\\\":\$wStaSig1,\\\"rssi\\\":\$wStaRssi,\\\"sentBytes\\\":\$wStaIfSentBytes,\\\"recBytes\\\":\$wStaIfRecBytes,\\\"info\\\":\\\"\$wStaDhcpName\\\"}\";\r\
    \n      }\r\
    \n\r\
    \n      :set staJson (\$staJson.\$newSta);\r\
    \n\r\
    \n      :set staCount (\$staCount + 1);\r\
    \n\r\
    \n    }\r\
    \n\r\
    \n    :if (\$staCount > 0) do={\r\
    \n      #:put \"averaging noise, \$wIfNoise / \$staCount\";\r\
    \n      :set wIfNoise (-\$wIfNoise / \$staCount);\r\
    \n    }\r\
    \n\r\
    \n    #:put \"if noise: \$wIfNoise\";\r\
    \n\r\
    \n    :if (\$wIfSig0 != 0) do={\r\
    \n      #:put \"averaging sig0, \$wIfSig0 / \$staCount\";\r\
    \n      :set wIfSig0 (\$wIfSig0 / \$staCount);\r\
    \n    }\r\
    \n\r\
    \n    :if (\$wIfSig1 != 0) do={\r\
    \n      #:put \"averaging sig0, \$wIfSig1 / \$staCount\";\r\
    \n      :set wIfSig1 (\$wIfSig1 / \$staCount);\r\
    \n    }\r\
    \n\r\
    \n    :local newWapIf;\r\
    \n\r\
    \n    if (\$wapCount = 0) do={\r\
    \n      :set newWapIf \"{\\\"stations\\\":[\$staJson],\\\"interface\\\":\\\"\$wIfName\\\",\\\"ssid\\\":\\\"\$wIfSsid\\\",\\\"noise\\\":\$wIfNoise,\\\"signal0\\\":\$wIfSig0,\\\"signal1\\\":\$wIfSig1}\";\r\
    \n    } else={\r\
    \n      :set newWapIf \",{\\\"stations\\\":[\$staJson],\\\"interface\\\":\\\"\$wIfName\\\",\\\"ssid\\\":\\\"\$wIfSsid\\\",\\\"noise\\\":\$wIfNoise,\\\"signal0\\\":\$wIfSig0,\\\"signal1\\\":\$wIfSig1}\";\r\
    \n    }\r\
    \n\r\
    \n    :set wapCount (\$wapCount + 1);\r\
    \n\r\
    \n    :set wapArray (\$wapArray.\$newWapIf);\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n}\r\
    \n\r\
    \n#----- lte -----\r\
    \n\r\
    \n  # add the lte interfaces to the wapArray json if they exist\r\
    \n  if ([:len \$lteJsonString] > 0) do={\r\
    \n    if ([:len \$wapArray] = 0) do={\r\
    \n      :set wapArray (\$lteJsonString);\r\
    \n    } else={\r\
    \n      :set wapArray (\$wapArray . \",\" . \$lteJsonString);\r\
    \n    }\r\
    \n  }\r\
    \n\r\
    \n  #:put \$wapArray;\r\
    \n\r\
    \n#------------- System Collector-----------------\r\
    \n\r\
    \n:global cpuLoad;\r\
    \nif ([:len \$cpuLoad] = 0) do={\r\
    \n  :set cpuLoad 0;\r\
    \n}\r\
    \n\r\
    \n# memory\r\
    \n\r\
    \n:local totalMem 0;\r\
    \n:local freeMem 0;\r\
    \n:local memBuffers 0;\r\
    \n:local cachedMem 0;\r\
    \n:set totalMem ([/system resource get total-memory])\r\
    \n:set freeMem ([/system resource get free-memory])\r\
    \n:set memBuffers 0\r\
    \n\r\
    \n# disks\r\
    \n\r\
    \n:local diskJsonString \"\";\r\
    \n:do {\r\
    \n\r\
    \n:foreach disk in=[/disk find] do={\r\
    \n\r\
    \n  :local diskName \"\";\r\
    \n  :local diskFree 0;\r\
    \n  :local diskSize 0;\r\
    \n  :local diskUsed 0;\r\
    \n\r\
    \n  :if (\$totalDisks != 0) do={\r\
    \n    :set diskName [/disk get \$disk slot];\r\
    \n    :set diskFree [/disk get \$disk free];\r\
    \n    :set diskSize [/disk get \$disk size];\r\
    \n    :if ([:len \$diskFree] = 0) do={\r\
    \n      :set diskFree 0;\r\
    \n    }\r\
    \n    :if ([:len \$diskSize] = 0) do={\r\
    \n      :set diskSize 0;\r\
    \n    }\r\
    \n    :set diskUsed ((\$diskSize - \$diskFree));\r\
    \n  }\r\
    \n\r\
    \n  :if ([:len \$diskName] > 0) do={\r\
    \n    :local diskData \"{\\\"mount\\\":\\\"\$diskName\\\",\\\"used\\\":\$diskUsed,\\\"avail\\\":\$diskFree},\";\r\
    \n    :set diskJsonString (\$diskJsonString.\$diskData);\r\
    \n  }\r\
    \n}\r\
    \n:if ([:len \$diskJsonString] > 0) do={\r\
    \n  # remove last character from diskJsonString\r\
    \n  :set diskJsonString [:pick \$diskJsonString 0 ([:len \$diskJsonString] - 1)];\r\
    \n}\r\
    \n} on-error={\r\
    \n  # no /disk (smips devices)\r\
    \n}\r\
    \n\r\
    \n:local processCount [:len [/system script job find]];\r\
    \n:local systemArray \"{\\\"load\\\":{\\\"one\\\":\$cpuLoad,\\\"five\\\":\$cpuLoad,\\\"fifteen\\\":\$cpuLoad,\\\"processCount\\\":\$processCount},\\\"memory\\\":{\\\"total\\\":\$totalMem,\\\"free\\\":\$freeMem,\\\"buffers\\\":\$memBuffers,\\\"cached\\\":\$cachedMem},\\\"disks\\\":[\$diskJsonString],\\\"connDetails\\\":{\\\"connectionFailures\\\":\$connectionFailures}}\";\r\
    \n\r\
    \n# count the number of dhcp leases\r\
    \n:local dhcpLeaseCount [:len [/ip dhcp-server lease find]];\r\
    \n:do {\r\
    \n  # add IPv6 leases\r\
    \n  :set dhcpLeaseCount (\$dhcpLeaseCount + [:len [/ipv6 address find]]);\r\
    \n} on-error={\r\
    \n}\r\
    \n\r\
    \n:global collectUpDataVal \"{\\\"ping\\\":[\$pingJsonString],\\\"wap\\\":[\$wapArray], \\\"interface\\\":[\$ifaceDataArray],\\\"system\\\":\$systemArray,\\\"gauge\\\":[{\\\"name\\\":\\\"Total DHCP Leases\\\",\\\"point\\\":\$dhcpLeaseCount}]}\";\r\
    \n:set collectorsRunning false;"