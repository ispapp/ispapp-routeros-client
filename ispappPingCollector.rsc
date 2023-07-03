/system script add dont-require-permissions=no name=ispappPingCollector owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#------------- Ping Collector-----------------\r\
    \n\r\
    \n:local tempPingJsonString \"\";\r\
    \n:local pingHosts [:toarray \"\"];\r\
    \n:set (\$pingHosts->0) \"aws-us-east-1-ping.ispapp.co\";\r\
    \n:set (\$pingHosts->1) \"aws-us-west-1-ping.ispapp.co\";\r\
    \n:set (\$pingHosts->2) \"aws-eu-west-2-ping.ispapp.co\";\r\
    \n:set (\$pingHosts->3) \"aws-sa-east-1-ping.ispapp.co\";\r\
    \n:set (\$pingHosts->4) \"\$topDomain\";\r\
    \n\r\
    \n:for pc from=0 to=([:len \$pingHosts]-1) step=1 do={\r\
    \n  #:put (\"pinging host \$pc \" . \$pingHosts->\$pc);\r\
    \n\r\
    \n  :if (\$pc > 0) do={\r\
    \n    :set tempPingJsonString (\$tempPingJsonString . \",\");\r\
    \n  }\r\
    \n\r\
    \n  :local avgRtt 0;\r\
    \n  :local minRtt 0;\r\
    \n  :local maxRtt 0;\r\
    \n  :local toPingDomain (\$pingHosts->\$pc);\r\
    \n  :local totalpingsreceived 0;\r\
    \n  :local totalpingssend 5;\r\
    \n\r\
    \n  :do {\r\
    \n    /tool flood-ping count=\$totalpingssend size=64 address=[:resolve \$toPingDomain] do={\r\
    \n      :set totalpingsreceived (\$\"received\");\r\
    \n      :set avgRtt (\$\"avg-rtt\");\r\
    \n      :set minRtt (\$\"min-rtt\");\r\
    \n      :set maxRtt (\$\"max-rtt\");\r\ 
    \n    }\r\
    \n  } on-error={\r\
    \n    #:put (\"TOOL FLOOD_PING ERROR=====>>> \");\r\
    \n }\r\
    \n\r\
    \n:local calculateAvgRtt 0;\r\
    \n:local calculateMinRtt 0;\r\
    \n:local calculateMaxRtt 0;\r\
    \n:local percentage 0;\r\
    \n:local packetLoss 0;\r\
    \n\r\
    \n:set calculateAvgRtt ([:tostr (\$avgRtt)]);\r\
    \n#:put (\"avgRtt: \".\$calculateAvgRtt);\r\
    \n\r\
    \n:set calculateMinRtt ([:tostr (\$minRtt)]);\r\
    \n#:put (\"minRtt: \".\$calculateMinRtt);\r\
    \n\r\
    \n:set calculateMaxRtt ([:tostr (\$maxRtt)]);\r\
    \n#:put (\"maxRtt: \".\$calculateMaxRtt);\r\
    \n\r\
    \n# sent must be less than 100\r\
    \n# just use uintmax but they aren't normal in this language\r\
    \n:local oneStepPercent (100 / \$totalpingssend);\r\
    \n\r\
    \n:local percentage 0;\r\
    \nfor i from=0 to=(\$totalpingssend-1) do={\r\
    \n  if (\$i < \$totalpingsreceived) do={\r\
    \n    :set percentage (\$percentage + \$oneStepPercent);\r\
    \n  }\r\
    \n}\r\
    \n\r\
    \n:set percentage (100 - \$percentage);\r\
    \n:set tempPingJsonString (\$tempPingJsonString . \"{\\\"host\\\":\\\"\$toPingDomain\\\",\\\"avgRtt\\\":\$calculateAvgRtt,\\\"loss\\\":\$percentage,\\\"minRtt\\\":\$calculateMinRtt,\\\"maxRtt\\\":\
    \$calculateMaxRtt}\");\r\
    \n\r\
    \n}\r\
    \n:global pingJsonString \$tempPingJsonString;\r\
    \n"