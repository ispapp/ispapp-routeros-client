/system script add dont-require-permissions=no name=ispappAvgCpuCollector owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#:log info (\"ispappAvgCpuCollector\");\r\
    \n\r\
    \n:global cpuLoad;\r\
    \n:global cpuLoadArray;\r\
    \n\r\
    \nif ([:len cpuLoadCount] = 0) do={\r\
    \n  # set empty cpuLoadArray\r\
    \n  :set cpuLoadArray [:toarray \"\"];\r\
    \n}\r\
    \n\r\
    \nif ([:len \$cpuLoadArray] >= 15) do={\r\
    \n  # 15 iterations at 4 seconds is 1 minute\r\
    \n  :local cpuLoadTotal 0;\r\
    \n  foreach cpuLoadReading in \$cpuLoadArray do={\r\
    \n    :set cpuLoadTotal (\$cpuLoadTotal + \$cpuLoadReading);\r\
    \n  }\r\
    \n\r\
    \n  # set the 1m load\r\
    \n  :set cpuLoad (\$cpuLoadTotal / [:len \$cpuLoadArray]);\r\
    \n  # empty the array\r\
    \n  :set cpuLoadArray [:toarray \"\"];\r\
    \n}\r\
    \n\r\
    \n:set cpuLoadArray (\$cpuLoadArray, [/system resource get cpu-load]);\r\
    \n\r\
    \n#:log info (\"cpuLoadArray\", \$cpuLoadArray);\r\
    \n\r\
    \n# run this script again\r\
    \n:delay 4s;\r\
    \n:execute {/system script run ispappAvgCpuCollector};\r\
    \n:error \"ispappAvgCpuCollector iteration complete\";"