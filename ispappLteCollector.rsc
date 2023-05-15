/system script add dont-require-permissions=no name=ispappLteCollector owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="# if LTE logging is too verbose, disable it in your router's configuration\r\
    \n# /system logging print\r\
    \n# 4     lte       support\r\
    \n# /system logging disable 4\r\
    \n\r\
    \n:global Split;\r\
    \n\r\
    \n:global lteJsonString;\r\
    \n\r\
    \n#------------- Lte Collector-----------------\r\
    \n\r\
    \n:local lteArray;\r\
    \n:local lteCount 0;\r\
    \n\r\
    \n:foreach lteIfaceId in=[/interface lte find] do={\r\
    \n\r\
    \n  :local lteIfName ([/interface lte get \$lteIfaceId name]);\r\
    \n  #:put \"lte interface name: \$lteIfName\";\r\
    \n\r\
    \n  #:local lteIfDetail [/interface lte print detail as-value where name=\$lteIfName];\r\
    \n  #:put (\"lteIfDetail: \") . (\$lteIfDetail->0);\r\
    \n\r\
    \n  # send at-chat to the modem\r\
    \n  :local lteAt0 [:tostr  [/interface lte at-chat \$lteIfName input \"AT+CSQ\" as-value]];\r\
    \n  #:put \$lteAt0;\r\
    \n\r\
    \n  :local lteAt0Arr [\$Split \$lteAt0 \"\\n\"];\r\
    \n  #:put (\$lteAt0Arr->0);\r\
    \n\r\
    \n  :local snrArr [\$Split (\$lteAt0Arr->0) \" \"];\r\
    \n  # split the signal and the bit error rate by the comma\r\
    \n  :local sber [\$Split (\$snrArr->1) \",\"];\r\
    \n  :local signal [:tonum (\$sber->0)];\r\
    \n\r\
    \n  # convert the value to rssi\r\
    \n  # 2 equals -109\r\
    \n  # each value above 2 adds -2 and -109\r\
    \n  :local s (\$signal - 2);\r\
    \n  :set s (\$s * 2);\r\
    \n  :set signal (\$s + -109)\r\
    \n\r\
    \n  #:put \"signal: \$signal\";\r\
    \n\r\
    \n  :local lteAt1 [:tostr  [/interface lte at-chat \$lteIfName input \"AT+COPS\?\" as-value]];\r\
    \n  #:put \$lteAt1;\r\
    \n\r\
    \n  # if ERROR is in this string, then routeros' LTE is broken (happens often)\r\
    \n  :local mnc;\r\
    \n  if ([:find \$lteAt1 \"ERROR\"] > -1) do={\r\
    \n    :log info \"\$lteIfName not connected\";\r\
    \n  } else={\r\
    \n    # get the network name, at least the MNC (Mobile Network Code)\r\
    \n    :local mncArray [\$Split \$lteAt1 \",\"];\r\
    \n    # remove the first \" because \\\" cannot be passed to Split due to the routeros scripting language bug\r\
    \n    :set mnc [:pick (\$mncArray->2) 1 [:len (\$mncArray->2)]];\r\
    \n    # remove the last \"\r\
    \n    :set mnc [:pick \$mnc 0 ([:len \$mnc] - 1)];\r\
    \n    #:put \"MNC: \$mnc\";\r\
    \n  }\r\
    \n\r\
    \n  if (\$lteCount = 0) do={\r\
    \n    :set lteJsonString (\"{\\\"stations\\\":[],\\\"interface\\\":\\\"\$lteIfName\\\",\\\"ssid\\\":\\\"\$mnc\\\",\\\"signal0\\\":\$signal}\");\r\
    \n  } else={\r\
    \n    :set lteJsonString (\$lteJsonString . \",\" . \",{\\\"stations\\\":[],\\\"interface\\\":\\\"\$lteIfName\\\",\\\"ssid\\\":\\\"\$mnc\\\",\\\"signal0\\\":\$signal}\");\r\
    \n  }\r\
    \n\r\
    \n  :set lteCount (\$lteCount + 1);\r\
    \n\r\
    \n}\r\
    \n\r\
    \n#:log info (\"ispappLteCollector\");\r\
    \n\r\
    \n# run this script again\r\
    \n:delay 10s;\r\
    \n:execute {/system script run ispappLteCollector};\r\
    \n:error \"ispappLteCollector iteration complete\";"