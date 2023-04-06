/system script;
/system script add dont-require-permissions=no name=ispappDiagnoseConnection owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":put \"Diagnosing ISPApp Connection\\n\";\r\
    \n\r\
    \n# include functions\r\
    \n:global rosTsSec;\r\
    \n:global Split;\r\
    \n\r\
    \n:global login;\r\
    \n:global topDomain;\r\
    \n:global topKey;\r\
    \n:global topListenerPort;\r\
    \n:global urlEncodeFunct;\r\
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
    \n# config request without full data\r\
    \n\r\
    \n:local configUrl (\"https://\" . \$topDomain . \":\" . \$topListenerPort . \"/update\?login=\" . \$login . \"&key=\" . \$topKey);\r\
    \n\r\
    \n:put (\"\\nMaking HTTP GET config request without body data to: \" . \$configUrl . \"\\n\");\r\
    \n\r\
    \n:local configResponse;\r\
    \n\r\
    \n:do {\r\
    \n    :set configResponse ([/tool fetch check-certificate=yes mode=https http-method=get url=\$configUrl as-value output=user]);\r\
    \n\r\
    \n} on-error={\r\
    \n  :put (\"HTTP Error, no response for /config request to ISPApp.\");\r\
    \n  :error \"HTTP error with /config request, no response received.\";\r\
    \n}\r\
    \n\r\
    \n:put (\"ISPApp Listener responded with:\")\r\
    \n:put (\$configResponse);\r\
    \n\r\
    \n# config request with full data\r\
    \n\r\
    \n:local collectUpData \"{}\";\r\
    \n\r\
    \n:local configUrl (\"https://\" . \$topDomain . \":\" . \$topListenerPort . \"/update\?login=\" . \$login . \"&key=\" . \$topKey);\r\
    \n\r\
    \n:put (\"\\nMaking HTTP POST config request with body data to: \" . \$configUrl . \"\\n\");\r\
    \n\r\
    \n:put (\"HTTP POST Request Data:\");\r\
    \n:put (\$collectUpData . \"\\n\");\r\
    \n\r\
    \n:local configResponse;\r\
    \n\r\
    \n:do {\r\
    \n    :set configResponse ([/tool fetch check-certificate=yes mode=https http-method=post http-header-field=\"cache-control: no-cache, content-type: application/json\" http-data=\"\$collectUpData\" url=\$configUrl as-value output=user]);\r\
    \n\r\
    \n} on-error={\r\
    \n  :put (\"HTTP Error, no response for /config request to ISPApp, sent \" . [:len \$collectUpData] . \" bytes.\");\r\
    \n  :error \"HTTP error with /config request, no response received.\";\r\
    \n}\r\
    \n\r\
    \n:put (\"ISPApp Listener responded with:\")\r\
    \n:put (\$configResponse);\r\
    \n\r\
    \n# update request without full data\r\
    \n\r\
    \n:local updateUrl (\"https://\" . \$topDomain . \":\" . \$topListenerPort . \"/update\?login=\" . \$login . \"&key=\" . \$topKey);\r\
    \n\r\
    \n:put (\"\\nMaking HTTP GET update request without body data to: \" . \$updateUrl . \"\\n\");\r\
    \n\r\
    \n:local updateResponse;\r\
    \n\r\
    \n:do {\r\
    \n    :set updateResponse ([/tool fetch check-certificate=yes mode=https http-method=get url=\$updateUrl as-value output=user]);\r\
    \n\r\
    \n} on-error={\r\
    \n  :put (\"HTTP Error, no response for /update request to ISPApp.\");\r\
    \n  :error \"HTTP error with /update request, no response received.\";\r\
    \n}\r\
    \n\r\
    \n:put (\"ISPApp Listener responded with:\")\r\
    \n:put (\$updateResponse);\r\
    \n\r\
    \n# update request with full data\r\
    \n\r\
    \n:local collectUpData \"{\\\"collectors\\\":\$collectUpDataVal,\\\"wanIp\\\":\\\"\$wanIP\\\",\\\"uptime\\\":\$upSeconds}\";\r\
    \n\r\
    \n:local updateUrl (\"https://\" . \$topDomain . \":\" . \$topListenerPort . \"/update\?login=\" . \$login . \"&key=\" . \$topKey);\r\
    \n\r\
    \n:put (\"\\nMaking HTTP POST update request with body data to: \" . \$updateUrl . \"\\n\");\r\
    \n\r\
    \n:put (\"HTTP POST Request Data:\");\r\
    \n:put (\$collectUpData . \"\\n\");\r\
    \n\r\
    \n:local updateResponse;\r\
    \n\r\
    \n:do {\r\
    \n    :set updateResponse ([/tool fetch check-certificate=yes mode=https http-method=post http-header-field=\"cache-control: no-cache, content-type: application/json\" http-data=\"\$collectUpData\" url=\$updateUrl as-value output=user]);\r\
    \n\r\
    \n} on-error={\r\
    \n  :put (\"HTTP Error, no response for /update request to ISPApp, sent \" . [:len \$collectUpData] . \" bytes.\");\r\
    \n  :error \"HTTP error with /update request, no response received.\";\r\
    \n}\r\
    \n\r\
    \n:put (\"ISPApp Listener responded with:\")\r\
    \n:put (\$updateResponse);"