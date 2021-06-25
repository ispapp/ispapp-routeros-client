:global topUrl "https://demo.ispapp.co:8550/";
:global topClientInfo "RouterOS-v0.23";
:global topKey "ioddl34";

:if ([:len [/system scheduler find name=cmdGetDataFromApi]] > 0) do={
    /system scheduler remove [find name="cmdGetDataFromApi"]
}
:if ([:len [/system scheduler find name=collectors]] > 0) do={
    /system scheduler remove [find name="collectors"]
}
:if ([:len [/system scheduler find name=initMultipleScript]] > 0) do={
    /system scheduler remove [find name="initMultipleScript"]
}
:if ([:len [/system scheduler find name=update-schedule]] > 0) do={
    /system scheduler remove [find name="update-schedule"]
}
:delay 1;

:if ([:len [/system script find name=JParseFunctions]] > 0) do={
    /system script remove [find name="JParseFunctions"]
}
:if ([:len [/system script find name=base64EncodeFunctions]] > 0) do={
    /system script remove [find name="base64EncodeFunctions"]
}
:if ([:len [/system script find name=cmdGetDataFromApi]] > 0) do={
    /system script remove [find name="cmdGetDataFromApi"]
}
:if ([:len [/system script find name=cmdGetDataFromApi.rsc]] > 0) do={
    /system script remove [find name="cmdGetDataFromApi.rsc"]
}
:if ([:len [/system script find name=cmdScript.rsc]] > 0) do={
    /system script remove [find name="cmdScript.rsc"]
}
:if ([:len [/system script find name=collectors]] > 0) do={
    /system script remove [find name="collectors"]
}
:if ([:len [/system script find name=collectors.rsc]] > 0) do={
    /system script remove [find name="collectors.rsc"]
}
:if ([:len [/system script find name=config]] > 0) do={
    /system script remove [find name="config"]
}
:if ([:len [/system script find name=globalScript]] > 0) do={
    /system script remove [find name="globalScript"]
}
:if ([:len [/system script find name=initMultipleScript]] > 0) do={
    /system script remove [find name="initMultipleScript"]
}
:if ([:len [/system script find name=update]] > 0) do={
    /system script remove [find name="update"]
}
:if ([:len [/system script find name=update.rsc]] > 0) do={
    /system script remove [find name="update.rsc"]
}
:delay 1;

/system script
add dont-require-permissions=no name=globalScript owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    global startEncode 1;\r\
    \n:global isSend 1;\r\
    \n:global isRequest 1;\r\
    \n\r\
    \n:global currentUrlVal;\r\
    \n:global currentUrl\r\
    \n:set \$currentUrl (\"https://demo.ispapp.co:8550/\");\r\
    \n\r\
    \n# Key for Collect\r\
    \n:global key;\r\
    \n:set \$key \"ioddl34\";\r\
    \n\r\
    \n#Client Info\r\
    \n:global clientInfo;\r\
    \n:set \$clientInfo \"$topClientInfo\"\r\
    \n\r\
    \n# Get MAC address from wireless or ethernet and use as login\r\
    \n:global login;\r\
    \n:global interfaceWifiFind 0;\r\
    \n:do {\r\
    \n  :delay 2;\r\
    \n  :set \$interfaceWifiFind ([/interface wireless find]);\r\
    \n  :if ([:len \$interfaceWifiFind]>0) do={\r\
    \n    :set \$login ([/interface wireless get 0 mac-address]);\r\
    \n  };\r\
    \n  :if ([:len \$interfaceWifiFind]<1) do={\r\
    \n    :set \$login ([/interface ethernet get 0 mac-address]);\r\
    \n  };\r\
    \n  :log info (\$login);\r\
    \n\r\
    \n} on-error={\r\
    \n  :delay 5;\r\
    \n  :set \$interfaceWifiFind ([/interface wireless find]);\r\
    \n  :if ([:len \$interfaceWifiFind]>0) do={\r\
    \n    :set \$login ([/interface wireless get 0 mac-address]);\r\
    \n  };\r\
    \n  :if ([:len \$interfaceWifiFind]<1) do={\r\
    \n    :set \$login ([/interface ethernet get 0 mac-address]);\r\
    \n  };\r\
    \n  :log info (\"LOGIN ERROR=====>>> \");\r\
    \n  :log info (\$login);\r\
    \n}\r\
    \n\r\
    \n# Convert to lowercase\r\
    \n:local low (\"a\",\"b\",\"c\",\"d\",\"e\",\"f\",\"g\",\"h\",\"i\",\"j\",\
    \"k\",\"l\",\"m\",\"n\",\"o\",\"p\",\"q\",\"r\",\"s\",\"t\",\"u\",\"v\",\"\
    w\",\"x\",\"y\",\"z\");\r\
    \n:local upp (\"A\",\"B\",\"C\",\"D\",\"E\",\"F\",\"G\",\"H\",\"I\",\"J\",\
    \"K\",\"L\",\"M\",\"N\",\"O\",\"P\",\"Q\",\"R\",\"S\",\"T\",\"U\",\"V\",\"\
    W\",\"X\",\"Y\",\"Z\");\r\
    \n:local new \"\";\r\
    \n\r\
    \n:for i from=0 to=([:len \$login] - 1) do={\r\
    \n  :local char [:pick \$login \$i];\r\
    \n  :local f [:find \"\$upp\" \"\$char\"];\r\
    \n  :if ( \$f < 0 ) do={\r\
    \n  :set new (\$new . \$char);\r\
    \n  }\r\
    \n  :for a from=0 to=([:len \$upp] - 1) do={\r\
    \n  :local l [:pick \$upp \$a];\r\
    \n  :if ( \$char = \$l) do={\r\
    \n    :local u [:pick \$low \$a];\r\
    \n    :set new (\$new .\$u);\r\
    \n    }\r\
    \n  }\r\
    \n}\r\
    \n:delay 2;\r\
    \n:set \$login \$new;\r\
    \n:log info (\"RUN GLOBAL SCRIPT OK=====>>>\");"
add dont-require-permissions=no name=JParseFunctions owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#\
    \_-------------------------------- JParseFunctions -------------------\r\
    \n:global fJParsePrint\r\
    \n:if (!any \$fJParsePrint) do={ :global fJParsePrint do={\r\
    \n  :global JParseOut\r\
    \n  :local TempPath\r\
    \n  :global fJParsePrint\r\
    \n\r\
    \n  :if ([:len \$1] = 0) do={\r\
    \n    :set \$1 \"\\\$JParseOut\"\r\
    \n    :set \$2 \$JParseOut\r\
    \n   }\r\
    \n  \r\
    \n  :foreach k,v in=\$2 do={\r\
    \n    :if ([:typeof \$k] = \"str\") do={\r\
    \n      :set k \"\\\"\$k\\\"\"\r\
    \n    }\r\
    \n    :set TempPath (\$1. \"->\" . \$k)\r\
    \n    :if ([:typeof \$v] = \"array\") do={\r\
    \n      :if ([:len \$v] > 0) do={\r\
    \n        \$fJParsePrint \$TempPath \$v\r\
    \n      } else={\r\
    \n        :put \"\$TempPath = [] (\$[:typeof \$v])\"\r\
    \n      }\r\
    \n    } else={\r\
    \n        :put \"\$TempPath = \$v (\$[:typeof \$v])\"\r\
    \n    }\r\
    \n  }\r\
    \n}}\r\
    \n# ------------------------------- fJParsePrintVar ----------------------\
    ------------------------------------------\r\
    \n:global fJParsePrintVar\r\
    \n:if (!any \$fJParsePrintVar) do={ :global fJParsePrintVar do={\r\
    \n  :global JParseOut\r\
    \n  :local TempPath\r\
    \n  :global fJParsePrintVar\r\
    \n  :local fJParsePrintRet \"\"\r\
    \n\r\
    \n  :if ([:len \$1] = 0) do={\r\
    \n    :set \$1 \"\\\$JParseOut\"\r\
    \n    :set \$2 \$JParseOut\r\
    \n   }\r\
    \n  \r\
    \n  :foreach k,v in=\$2 do={\r\
    \n    :if ([:typeof \$k] = \"str\") do={\r\
    \n      :set k \"\\\"\$k\\\"\"\r\
    \n    }\r\
    \n    :set TempPath (\$1. \"->\" . \$k)\r\
    \n    :if (\$fJParsePrintRet != \"\") do={\r\
    \n      :set fJParsePrintRet (\$fJParsePrintRet . \"\\r\\n\")\r\
    \n    }   \r\
    \n    :if ([:typeof \$v] = \"array\") do={\r\
    \n      :if ([:len \$v] > 0) do={\r\
    \n        :set fJParsePrintRet (\$fJParsePrintRet . [\$fJParsePrintVar \$T\
    empPath \$v])\r\
    \n      } else={\r\
    \n        :set fJParsePrintRet (\$fJParsePrintRet . \"\$TempPath = [] (\$[\
    :typeof \$v])\")\r\
    \n      }\r\
    \n    } else={\r\
    \n        :set fJParsePrintRet (\$fJParsePrintRet . \"\$TempPath = \$v (\$\
    [:typeof \$v])\")\r\
    \n    }\r\
    \n  }\r\
    \n  :return \$fJParsePrintRet\r\
    \n}}\r\
    \n# ------------------------------- fJSkipWhitespace ---------------------\
    -------------------------------------------\r\
    \n:global fJSkipWhitespace\r\
    \n:if (!any \$fJSkipWhitespace) do={ :global fJSkipWhitespace do={\r\
    \n  :global Jpos\r\
    \n  :global JSONIn\r\
    \n  :global Jdebug\r\
    \n  :while (\$Jpos < [:len \$JSONIn] and ([:pick \$JSONIn \$Jpos] ~ \"[ \\\
    r\\n\\t]\")) do={\r\
    \n    :set Jpos (\$Jpos + 1)\r\
    \n  }\r\
    \n  :if (\$Jdebug) do={:put \"fJSkipWhitespace: Jpos=\$Jpos Char=\$[:pick \
    \$JSONIn \$Jpos]\"}\r\
    \n}}\r\
    \n# -------------------------------- fJParse -----------------------------\
    ----------------------------------\r\
    \n:global fJParse\r\
    \n:if (!any \$fJParse) do={ :global fJParse do={\r\
    \n  :global Jpos\r\
    \n  :global JSONIn\r\
    \n  :global Jdebug\r\
    \n  :global fJSkipWhitespace\r\
    \n  :local Char\r\
    \n\r\
    \n  :if (!\$1) do={\r\
    \n    :set Jpos 0\r\
    \n   }\r\
    \n \r\
    \n  \$fJSkipWhitespace\r\
    \n  :set Char [:pick \$JSONIn \$Jpos]\r\
    \n  :if (\$Jdebug) do={:put \"fJParse: Jpos=\$Jpos Char=\$Char\"}\r\
    \n  :if (\$Char=\"{\") do={\r\
    \n    :set Jpos (\$Jpos + 1)\r\
    \n    :global fJParseObject\r\
    \n    :return [\$fJParseObject]\r\
    \n  } else={\r\
    \n    :if (\$Char=\"[\") do={\r\
    \n      :set Jpos (\$Jpos + 1)\r\
    \n      :global fJParseArray\r\
    \n      :return [\$fJParseArray]\r\
    \n    } else={\r\
    \n      :if (\$Char=\"\\\"\") do={\r\
    \n        :set Jpos (\$Jpos + 1)\r\
    \n        :global fJParseString\r\
    \n        :return [\$fJParseString]\r\
    \n      } else={\r\
    \n#        :if ([:pick \$JSONIn \$Jpos (\$Jpos+2)]~\"^-\\\?[0-9]\") do={\r\
    \n        :if (\$Char~\"[eE0-9.+-]\") do={\r\
    \n          :global fJParseNumber\r\
    \n          :return [\$fJParseNumber]\r\
    \n        } else={\r\
    \n\r\
    \n          :if (\$Char=\"n\" and [:pick \$JSONIn \$Jpos (\$Jpos+4)]=\"nul\
    l\") do={\r\
    \n            :set Jpos (\$Jpos + 4)\r\
    \n            :return []\r\
    \n          } else={\r\
    \n            :if (\$Char=\"t\" and [:pick \$JSONIn \$Jpos (\$Jpos+4)]=\"t\
    rue\") do={\r\
    \n              :set Jpos (\$Jpos + 4)\r\
    \n              :return true\r\
    \n            } else={\r\
    \n              :if (\$Char=\"f\" and [:pick \$JSONIn \$Jpos (\$Jpos+5)]=\
    \"false\") do={\r\
    \n                :set Jpos (\$Jpos + 5)\r\
    \n                :return false\r\
    \n              } else={\r\
    \n                :put \"Err.Raise 8732. No JSON object could be fJParseed\
    \"\r\
    \n                :set Jpos (\$Jpos + 1)\r\
    \n                :return []\r\
    \n              }\r\
    \n            }\r\
    \n          }\r\
    \n        }\r\
    \n      }\r\
    \n    }\r\
    \n  }\r\
    \n}}\r\
    \n\r\
    \n#-------------------------------- fJParseString ------------------------\
    ---------------------------------------\r\
    \n:global fJParseString\r\
    \n:if (!any \$fJParseString) do={ :global fJParseString do={\r\
    \n  :global Jpos\r\
    \n  :global JSONIn\r\
    \n  :global Jdebug\r\
    \n  :global fUnicodeToUTF8\r\
    \n  :local Char\r\
    \n  :local StartIdx\r\
    \n  :local Char2\r\
    \n  :local TempString \"\"\r\
    \n  :local UTFCode\r\
    \n  :local Unicode\r\
    \n\r\
    \n  :set StartIdx \$Jpos\r\
    \n  :set Char [:pick \$JSONIn \$Jpos]\r\
    \n  :if (\$Jdebug) do={:put \"fJParseString: Jpos=\$Jpos Char=\$Char\"}\r\
    \n  :while (\$Jpos < [:len \$JSONIn] and \$Char != \"\\\"\") do={\r\
    \n    :if (\$Char=\"\\\\\") do={\r\
    \n      :set Char2 [:pick \$JSONIn (\$Jpos + 1)]\r\
    \n      :if (\$Char2 = \"u\") do={\r\
    \n        :set UTFCode [:tonum \"0x\$[:pick \$JSONIn (\$Jpos+2) (\$Jpos+6)\
    ]\"]\r\
    \n        :if (\$UTFCode>=0xD800 and \$UTFCode<=0xDFFF) do={\r\
    \n# Surrogate pair\r\
    \n          :set Unicode  ((\$UTFCode & 0x3FF) << 10)\r\
    \n          :set UTFCode [:tonum \"0x\$[:pick \$JSONIn (\$Jpos+8) (\$Jpos+\
    12)]\"]\r\
    \n          :set Unicode (\$Unicode | (\$UTFCode & 0x3FF) | 0x10000)\r\
    \n          :set TempString (\$TempString . [:pick \$JSONIn \$StartIdx \$J\
    pos] . [\$fUnicodeToUTF8 \$Unicode])        \r\
    \n          :set Jpos (\$Jpos + 12)\r\
    \n        } else= {\r\
    \n# Basic Multilingual Plane (BMP)\r\
    \n          :set Unicode \$UTFCode\r\
    \n          :set TempString (\$TempString . [:pick \$JSONIn \$StartIdx \$J\
    pos] . [\$fUnicodeToUTF8 \$Unicode])\r\
    \n          :set Jpos (\$Jpos + 6)\r\
    \n        }\r\
    \n        :set StartIdx \$Jpos\r\
    \n        :if (\$Jdebug) do={:put \"fJParseString Unicode: \$Unicode\"}\r\
    \n      } else={\r\
    \n        :if (\$Char2 ~ \"[\\\\bfnrt\\\"]\") do={\r\
    \n          :if (\$Jdebug) do={:put \"fJParseString escape: Char+Char2 \$C\
    har\$Char2\"}\r\
    \n          :set TempString (\$TempString . [:pick \$JSONIn \$StartIdx \$J\
    pos] . [[:parse \"(\\\"\\\\\$Char2\\\")\"]])\r\
    \n          :set Jpos (\$Jpos + 2)\r\
    \n          :set StartIdx \$Jpos\r\
    \n        } else={\r\
    \n          :if (\$Char2 = \"/\") do={\r\
    \n            :if (\$Jdebug) do={:put \"fJParseString /: Char+Char2 \$Char\
    \$Char2\"}\r\
    \n            :set TempString (\$TempString . [:pick \$JSONIn \$StartIdx \
    \$Jpos] . \"/\")\r\
    \n            :set Jpos (\$Jpos + 2)\r\
    \n            :set StartIdx \$Jpos\r\
    \n          } else={\r\
    \n            :put \"Err.Raise 8732. Invalid escape\"\r\
    \n            :set Jpos (\$Jpos + 2)\r\
    \n          }\r\
    \n        }\r\
    \n      }\r\
    \n    } else={\r\
    \n      :set Jpos (\$Jpos + 1)\r\
    \n    }\r\
    \n    :set Char [:pick \$JSONIn \$Jpos]\r\
    \n  }\r\
    \n  :set TempString (\$TempString . [:pick \$JSONIn \$StartIdx \$Jpos])\r\
    \n  :set Jpos (\$Jpos + 1)\r\
    \n  :if (\$Jdebug) do={:put \"fJParseString: \$TempString\"}\r\
    \n  :return \$TempString\r\
    \n}}\r\
    \n\r\
    \n#-------------------------------- fJParseNumber ------------------------\
    ---------------------------------------\r\
    \n:global fJParseNumber\r\
    \n:if (!any \$fJParseNumber) do={ :global fJParseNumber do={\r\
    \n  :global Jpos\r\
    \n  :local StartIdx\r\
    \n  :global JSONIn\r\
    \n  :global Jdebug\r\
    \n  :local NumberString\r\
    \n  :local Number\r\
    \n\r\
    \n  :set StartIdx \$Jpos  \r\
    \n  :set Jpos (\$Jpos + 1)\r\
    \n  :while (\$Jpos < [:len \$JSONIn] and [:pick \$JSONIn \$Jpos]~\"[eE0-9.\
    +-]\") do={\r\
    \n    :set Jpos (\$Jpos + 1)\r\
    \n  }\r\
    \n  :set NumberString [:pick \$JSONIn \$StartIdx \$Jpos]\r\
    \n  :set Number [:tonum \$NumberString]\r\
    \n  :if ([:typeof \$Number] = \"num\") do={\r\
    \n    :if (\$Jdebug) do={:put \"fJParseNumber: StartIdx=\$StartIdx Jpos=\$\
    Jpos \$Number (\$[:typeof \$Number])\"}\r\
    \n    :return \$Number\r\
    \n  } else={\r\
    \n    :if (\$Jdebug) do={:put \"fJParseNumber: StartIdx=\$StartIdx Jpos=\$\
    Jpos \$NumberString (\$[:typeof \$NumberString])\"}\r\
    \n    :return \$NumberString\r\
    \n  }\r\
    \n}}\r\
    \n\r\
    \n#-------------------------------- fJParseArray -------------------------\
    --------------------------------------\r\
    \n:global fJParseArray\r\
    \n:if (!any \$fJParseArray) do={ :global fJParseArray do={\r\
    \n  :global Jpos\r\
    \n  :global JSONIn\r\
    \n  :global Jdebug\r\
    \n  :global fJParse\r\
    \n  :global fJSkipWhitespace\r\
    \n  :local Value\r\
    \n  :local ParseArrayRet [:toarray \"\"]\r\
    \n \r\
    \n  \$fJSkipWhitespace   \r\
    \n  :while (\$Jpos < [:len \$JSONIn] and [:pick \$JSONIn \$Jpos]!= \"]\") \
    do={\r\
    \n    :set Value [\$fJParse true]\r\
    \n    :set (\$ParseArrayRet->([:len \$ParseArrayRet])) \$Value\r\
    \n    :if (\$Jdebug) do={:put \"fJParseArray: Value=\"; :put \$Value}\r\
    \n    \$fJSkipWhitespace\r\
    \n    :if ([:pick \$JSONIn \$Jpos] = \",\") do={\r\
    \n      :set Jpos (\$Jpos + 1)\r\
    \n      \$fJSkipWhitespace\r\
    \n    }\r\
    \n  }\r\
    \n  :set Jpos (\$Jpos + 1)\r\
    \n#  :if (\$Jdebug) do={:put \"ParseArrayRet: \"; :put \$ParseArrayRet}\r\
    \n  :return \$ParseArrayRet\r\
    \n}}\r\
    \n\r\
    \n# -------------------------------- fJParseObject -----------------------\
    ----------------------------------------\r\
    \n:global fJParseObject\r\
    \n:if (!any \$fJParseObject) do={ :global fJParseObject do={\r\
    \n  :global Jpos\r\
    \n  :global JSONIn\r\
    \n  :global Jdebug\r\
    \n  :global fJSkipWhitespace\r\
    \n  :global fJParseString\r\
    \n  :global fJParse\r\
    \n# Syntax :local ParseObjectRet ({}) don't work in recursive call, use [:\
    toarray \"\"] for empty array!!!\r\
    \n  :local ParseObjectRet [:toarray \"\"]\r\
    \n  :local Key\r\
    \n  :local Value\r\
    \n  :local ExitDo false\r\
    \n \r\
    \n  \$fJSkipWhitespace\r\
    \n  :while (\$Jpos < [:len \$JSONIn] and [:pick \$JSONIn \$Jpos]!=\"}\" an\
    d !\$ExitDo) do={\r\
    \n    :if ([:pick \$JSONIn \$Jpos]!=\"\\\"\") do={\r\
    \n      :put \"Err.Raise 8732. Expecting property name\"\r\
    \n      :set ExitDo true\r\
    \n    } else={\r\
    \n      :set Jpos (\$Jpos + 1)\r\
    \n      :set Key [\$fJParseString]\r\
    \n      \$fJSkipWhitespace\r\
    \n      :if ([:pick \$JSONIn \$Jpos] != \":\") do={\r\
    \n        :put \"Err.Raise 8732. Expecting : delimiter\"\r\
    \n        :set ExitDo true\r\
    \n      } else={\r\
    \n        :set Jpos (\$Jpos + 1)\r\
    \n        :set Value [\$fJParse true]\r\
    \n        :set (\$ParseObjectRet->\$Key) \$Value\r\
    \n        :if (\$Jdebug) do={:put \"fJParseObject: Key=\$Key Value=\"; :pu\
    t \$Value}\r\
    \n        \$fJSkipWhitespace\r\
    \n        :if ([:pick \$JSONIn \$Jpos]=\",\") do={\r\
    \n          :set Jpos (\$Jpos + 1)\r\
    \n          \$fJSkipWhitespace\r\
    \n        }\r\
    \n      }\r\
    \n    }\r\
    \n  }\r\
    \n  :set Jpos (\$Jpos + 1)\r\
    \n#  :if (\$Jdebug) do={:put \"ParseObjectRet: \"; :put \$ParseObjectRet}\
    \r\
    \n  :return \$ParseObjectRet\r\
    \n}}\r\
    \n\r\
    \n# ------------------- fByteToEscapeChar ----------------------\r\
    \n:global fByteToEscapeChar\r\
    \n:if (!any \$fByteToEscapeChar) do={ :global fByteToEscapeChar do={\r\
    \n#  :set \$1 [:tonum \$1]\r\
    \n  :return [[:parse \"(\\\"\\\\\$[:pick \"0123456789ABCDEF\" ((\$1 >> 4) \
    & 0xF)]\$[:pick \"0123456789ABCDEF\" (\$1 & 0xF)]\\\")\"]]\r\
    \n}}\r\
    \n\r\
    \n# ------------------- fUnicodeToUTF8----------------------\r\
    \n:global fUnicodeToUTF8\r\
    \n:if (!any \$fUnicodeToUTF8) do={ :global fUnicodeToUTF8 do={\r\
    \n  :global fByteToEscapeChar\r\
    \n#  :local Ubytes [:tonum \$1]\r\
    \n  :local Nbyte\r\
    \n  :local EscapeStr \"\"\r\
    \n\r\
    \n  :if (\$1 < 0x80) do={\r\
    \n    :set EscapeStr [\$fByteToEscapeChar \$1]\r\
    \n  } else={\r\
    \n    :if (\$1 < 0x800) do={\r\
    \n      :set Nbyte 2\r\
    \n    } else={ \r\
    \n      :if (\$1 < 0x10000) do={\r\
    \n        :set Nbyte 3\r\
    \n      } else={\r\
    \n        :if (\$1 < 0x20000) do={\r\
    \n          :set Nbyte 4\r\
    \n        } else={\r\
    \n          :if (\$1 < 0x4000000) do={\r\
    \n            :set Nbyte 5\r\
    \n          } else={\r\
    \n            :if (\$1 < 0x80000000) do={\r\
    \n              :set Nbyte 6\r\
    \n            }\r\
    \n          }\r\
    \n        }\r\
    \n      }\r\
    \n    }\r\
    \n    :for i from=2 to=\$Nbyte do={\r\
    \n      :set EscapeStr ([\$fByteToEscapeChar (\$1 & 0x3F | 0x80)] . \$Esca\
    peStr)\r\
    \n      :set \$1 (\$1 >> 6)\r\
    \n    }\r\
    \n    :set EscapeStr ([\$fByteToEscapeChar (((0xFF00 >> \$Nbyte) & 0xFF) |\
    \_\$1)] . \$EscapeStr)\r\
    \n  }\r\
    \n  :return \$EscapeStr\r\
    \n}}\r\
    \n\r\
    \n# ------------------- End JParseFunctions----------------------"
add dont-require-permissions=no name=cmdGetDataFromApi.rsc owner=admin \
    policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    source="# Url for Collect . Note : Logs is  removed. Import urlEncodeFunct\
    \_from base64EncodeFuntion Script.\r\
    \n# CMD and fastUpdate added.Log mesajlar\FD kaldirildi.\r\
    \n\r\
    \n:global jstr;\r\
    \n:global cmdGetDataFromApi;\r\
    \n\r\
    \n:global urlEncodeFunct;\r\
    \n:set \$jstr ([\$cmdGetDataFromApi]);\r\
    \n\r\
    \n:global clientInfo;\r\
    \n\r\
    \n:global currentUrl;\r\
    \n\r\
    \n:global key;\r\
    \n:global login;\r\
    \n\r\
    \n#Update script scheduler name for fastUpdate.\r\
    \nglobal updateScriptSchedulerName;\r\
    \nset \$updateScriptSchedulerName \"update-schedule\"\r\
    \n\r\
    \n# ------------------- urlEncodeFunct ----------------------\r\
    \n:global urlEncodeFunct do={\r\
    \n  :put \"arg a=\$currentUrlVal\"; \r\
    \n  :put \"arg b=\$urlVal\"\r\
    \n\r\
    \n  :local urlEncoded;\r\
    \n  :for i from=0 to=([:len \$urlVal] - 1) do={\r\
    \n    :local char [:pick \$urlVal \$i]\r\
    \n\r\
    \n    :global chars { \"!\"=\"%21\"; \"#\"=\"%23\"; \"\$\"=\"%24\"; \"%\"=\
    \"%25\"; \"'\"=\"%27\"; \"(\"=\"%28\"; \")\"=\"%29\"; \"*\"=\"%2A\"; \"+\"\
    =\"%2B\"; \",\"=\"%2C\"; \"-\"=\"%2D\"; \".\"=\"%2E\"; \"/\"=\"%2F\"; \"; \
    \"=\"%3B\"; \"<\"=\"%3C\"; \">\"=\"%3E\"; \"@\"=\"%40\"; \"[\"=\"%5B\"; \"\
    \\\"=\"%5C\"; \"]\"=\"%5D\"; \"^\"=\"%5E\"; \"_\"=\"%5F\"; \"`\"=\"%60\"; \
    \"{\"=\"%7B\"; \"|\"=\"%7C\"; \"}\"=\"%7D\"; \"~\"=\"%7E\"; \" \"=\"%7F\"}\
    \r\
    \n\r\
    \n    :local EncChar;\r\
    \n    :set \$EncChar (\$chars->\$char)\r\
    \n    :if (any \$EncChar) do={\r\
    \n      :set \$char (\$chars->\$char)\r\
    \n    } else={\r\
    \n      :set \$char \$char\r\
    \n    }\r\
    \n\r\
    \n    :set urlEncoded (\$urlEncoded . \$char)\r\
    \n  }\r\
    \n  :local mergeUrl;\r\
    \n  :set \$mergeUrl (\$currentUrlVal . \$urlEncoded);\r\
    \n  :return (\$mergeUrl);\r\
    \n\r\
    \n}\r\
    \n\r\
    \n:global cmdCollectUpDataVal;\r\
    \n:global cmdCollectUpdataValLen ([:len \$cmdCollectUpDataVal])\r\
    \n:if (\$cmdCollectUpdataValLen = 0) do={\r\
    \n  :set \$cmdCollectUpDataVal \"[]\";\r\
    \n}\r\
    \n:global wanIP;\r\
    \n:global upSeconds;\r\
    \n:set \$upSecondsVal value=[:tostr \$upSeconds]\r\
    \n\r\
    \n:global cmdCollectUpData \"{\\\"login\\\":\\\"\$login\\\",\\\"key\\\":\\\
    \"\$key\\\",\\\"wanIp\\\":\\\"\$wanIP\\\",\\\"uptime\\\":\$upSecondsVal}\"\
    ;\r\
    \n\r\
    \n:global collectorsUrl \"update\"\r\
    \n\r\
    \n:global mergeUpdateCollectorsUrl;\r\
    \n:set \$mergeUpdateCollectorsUrl ([\$urlEncodeFunct currentUrlVal=\$curre\
    ntUrl urlVal=\$collectorsUrl]);\r\
    \n\r\
    \n:global cmdGetDataFromApi;\r\
    \n:global cmdsArrayLenVal;\r\
    \n:do {\r\
    \n  :global isRequest;\r\
    \n  :if (\$isRequest=1) do={\r\
    \n    :set \$cmdGetDataFromApi ([/tool fetch mode=https http-method=post h\
    ttp-header-field=\"cache-control: no-cache, content-type: application/json\
    \" http-data=\"\$cmdCollectUpData\" url=\$mergeUpdateCollectorsUrl as-valu\
    e output=user duration=10])\r\
    \n    :log info (\"CMD GET DATA OK =======>>>\", \$cmdGetDataFromApi);\r\
    \n  }\r\
    \n} on-error={\r\
    \n  :log info (\"CMD GET DATA ERROR =======>>>\");\r\
    \n}\r\
    \n\r\
    \n:global jstr;\r\
    \n:set \$jstr ([\$cmdGetDataFromApi]);\r\
    \n\r\
    \nif ( (\$jstr->\"status\") = \"finished\" ) do={\r\
    \n  \r\
    \n  /system script run \"JParseFunctions\"; global JSONIn; global JParseOu\
    t; global fJParse;\r\
    \n    \r\
    \n  # Parse data and print `ParsedResults[0].ParsedText` value\r\
    \n  :set JSONIn (\$jstr->\"data\")\r\
    \n    \r\
    \n  if ( [:len \$JSONIn] != 0 ) do={\r\
    \n    :set \$JParseOut [\$fJParse];\r\
    \n  \r\
    \n    :global rebootval;\r\
    \n    :set \$rebootval (\$JParseOut->\"reboot\");\r\
    \n\r\
    \n    if ( \$rebootval = \"1\" ) do={\r\
    \n      :global booturl \"config\?login=\$login&key=\$key\"\r\
    \n      :global mergeBootUrlFuct;\r\
    \n      :set \$mergeBootUrlFuct [\$urlEncodeFunct currentUrlVal=\$currentU\
    rl urlVal=\$booturl];\r\
    \n\r\
    \n      #For make reboot flag 1 to 0\r\
    \n      :do {\r\
    \n        /tool fetch keep-result=no url=\$mergeBootUrlFuct duration=10;\r\
    \n        :log info (\"REBOOT FUNCT URL OK ========>>>>\");\r\
    \n      } on-error={\r\
    \n        :log info (\"REBOOT FUNCT URL ERROR ========>>>>\");\r\
    \n      }\r\
    \n\r\
    \n      :log info \"Reboot\";\r\
    \n      #/system routerboard upgrade\r\
    \n      /system reboot\r\
    \n    } else={\r\
    \n\r\
    \n    :execute script={\r\
    \n        :global createCmdArray \r\
    \n        :global updateFast \"\";\r\
    \n\r\
    \n        # Parse data and print `ParsedResults[0].ParsedText` value\r\
    \n        :set \$updateFast (\$JParseOut->\"updateFast\");\r\
    \n        :global cmdArray;\r\
    \n        :global cmdsArray;\r\
    \n        :global tmpCmdsArray;\r\
    \n        :set \$cmdsArray (\$JParseOut->\"cmds\");\r\
    \n        :set \$cmdsArrayLenVal ([:len \"\$cmdsArray\"])\r\
    \n\r\
    \n        :if (\$cmdsArrayLenVal !=0 ) do={\r\
    \n          :set \$isRequest 0;\r\
    \n        }\r\
    \n\r\
    \n        :global tmpCmdsArrayLenVal ([:len \"\$tmpCmdsArray\"]);\r\
    \n        if (\$tmpCmdsArrayLenVal !=0) do={\r\
    \n          :foreach i in=\$cmdsArray do={\r\
    \n              :local tempArrVal \"\";\r\
    \n              :local tmpToArray \"{}\";\r\
    \n              :foreach j in=([:toarray \$tmpCmdsArray]) do={\r\
    \n                if (\$i->\"uuidv4\" != \$j->\"uuidv4\") do={\r\
    \n                  :local tmpCmd (\$i->\"cmd\");\r\
    \n                  :local tmpWsid (\$i->\"ws_id\");\r\
    \n                  :local tmpUuid4 (\$i->\"uuidv4\");\r\
    \n                  :local tmpStdout (\$i->\"stdout\");\r\
    \n                  :local tmpErr (\$i->\"stderr\");\r\
    \n\r\
    \n                  :set \$tempArrVal (\"{\\\"cmd\\\":\\\"\$tmpCmd\\\"; \\\
    \"ws_id\\\":\\\"\$tmpWsid\\\"; \\\"uuidv4\\\":\\\"\$tmpUuid4\\\"; \\\"stdo\
    ut\\\":\\\"\$tmpStdout\\\"; \\\"stderr\\\":\\\"\$tmpErr\\\"}\");\r\
    \n                  :set \$tmpToArray ([:toarray \$tempArrVal])\r\
    \n                }\r\
    \n              }\r\
    \n              :if (([:len \$tmpToArray]) > 0) do={\r\
    \n                :set (\$tmpCmdsArray->[:len \$tmpCmdsArray]) \$tmpToArra\
    y;\r\
    \n              }\r\
    \n          }\r\
    \n        }\r\
    \n\r\
    \n       if (\$tmpCmdsArrayLenVal = 0) do={\r\
    \n          :set \$tmpCmdsArray \$cmdsArray;\r\
    \n        }\r\
    \n\r\
    \n        :if ( \$updateFast = true) do={\r\
    \n          :do {\r\
    \n            :local cmdGetDataSchedulerInterval [/system scheduler get cm\
    dGetDataFromApi  interval ]\r\
    \n            :if (\$cmdGetDataSchedulerInterval != \"00:00:02\") do={\r\
    \n              /system scheduler set interval=2s \"cmdGetDataFromApi\"\r\
    \n              /system scheduler set interval=10s \"collectors\"\r\
    \n              /system scheduler set interval=10s \"update-schedule\"\r\
    \n            }\r\
    \n          } on-error={\r\
    \n            :log info (\"CMDGETDATAAPI FUNCT CHANGE SCHEDULER  ERROR ===\
    =====>>>>\");\r\
    \n          }      \r\
    \n        }\r\
    \n\r\
    \n        :if ( \$updateFast = false ) do={\r\
    \n          :do {\r\
    \n            :local cmdGetDataSchedulerInterval [/system scheduler get cm\
    dGetDataFromApi  interval ]\r\
    \n            :if (\$cmdGetDataSchedulerInterval != \"00:01:00\") do={\r\
    \n              /system scheduler set interval=1m \"cmdGetDataFromApi\"\r\
    \n              /system scheduler set interval=5m \"collectors\"\r\
    \n              /system scheduler set interval=1m \"update-schedule\"\r\
    \n            }\r\
    \n          } on-error={\r\
    \n            :log info (\"UPDATE FUNCT CHANGE SCHEDULER  ERROR ========>>\
    >>\");\r\
    \n          }      \r\
    \n        }\r\
    \n\r\
    \n        :global i;\r\
    \n        :global cmdsDataPutToArray;\r\
    \n        :set \$cmdsDataPutToArray \"\";\r\
    \n        :global tmpCmdsArrayLen;\r\
    \n\r\
    \n        :set \$tmpCmdsArrayLen ([:len \"\$tmpCmdsArray\"]-1)\r\
    \n        :global outFile;\r\
    \n        :set \$outFile \"cmdResult.txt\";\r\
    \n        if (\$tmpCmdsArrayLen != -1) do={\r\
    \n          \r\
    \n          :foreach cmdKey in=([:toarray \$tmpCmdsArray]) do={\r\
    \n\r\
    \n            :global cmdVal;\r\
    \n            :global cmdsData;\r\
    \n            :set \$cmdsData \"\";\r\
    \n\r\
    \n            #:global a {cmd=\"/interface print detail\"}\r\
    \n            #:put \$a;\r\
    \n            #:set (\$a->\"cmd\")\r\
    \n            #:put \$a;\r\
    \n            #cmd=/interface print detail;stderr=;stdout=;uuidv4=9ac559ac\
    -9678-493d-ae80-9e1e0fbf75fd;ws_id=6f88b67b94cbee7283fef50fe74f11d9;cmd=/i\
    nterface print detail2;stderr=;stdout=;uuidv4=8b1b95fb-485e-40ce-b616-6cd7\
    891f4488;ws_id=6f88b67b94cbee7283fef50fe74f11d9\r\
    \n            \r\
    \n            :global cmd;\r\
    \n            :global tmpCmd \"\";\r\
    \n            :global wsid;\r\
    \n            :global uuidv4;\r\
    \n            :global stdout \"\";\r\
    \n            :global stderr \"\";\r\
    \n\r\
    \n            :set \$cmd (\$cmdKey->\"cmd\");\r\
    \n            :set \$tmpCmd [:parse value=\"\$cmd\"];\r\
    \n            :set \$wsid (\$cmdKey->\"ws_id\");\r\
    \n            :set \$uuidv4 (\$cmdKey->\"uuidv4\");\r\
    \n            :set \$stdout (\$cmdKey->\"stdout\");\r\
    \n            :set \$stderr (\$cmdKey->\"stderr\");\r\
    \n\r\
    \n            #:set (\$tmpCmdsArray->\$cmdVal->\"cmd\")\r\
    \n            #:set (\$tmpCmdsArray->\$cmdKey->\"ws_id\")\r\
    \n            #:set (\$tmpCmdsArray->\$cmdKey->\"uuidv4\")\r\
    \n            #:set (\$tmpCmdsArray->\$cmdKey->\"stdout\")\r\
    \n            #:set (\$tmpCmdsArray->\$cmdKey->\"stderr\")\r\
    \n\r\
    \n            :local delete (\"\$cmdKey\")\r\
    \n            :local array [:toarray \"\"]\r\
    \n            :local aaa (\$tmpCmdsArray)\r\
    \n            :foreach i,ival in=\$aaa do={\r\
    \n              :if ( \$ival!=\$delete ) do={\r\
    \n                :if (\$ival !=\" \") do={\r\
    \n                  :set (\$array->[:len \$array]) ([:toarray \$ival])\r\
    \n                }\r\
    \n              }\r\
    \n            }\r\
    \n            :set aaa \$array\r\
    \n            :set \$tmpCmdsArray [:toarray \$array];\r\
    \n\r\
    \n            :global cmdRebootRebCtrl 0;\r\
    \n            :global cmdRebootSysCtrl ([:len ([:find \"\$cmd\" \"sys\"])]\
    );\r\
    \n            :if (\$cmdRebootSysCtrl != 0) do={\r\
    \n              :set \$cmdRebootRebCtrl ([:len ([:find \"\$cmd\" \"reb\"])\
    ]);\r\
    \n              :set \$tmpCmd \"\";\r\
    \n            }\r\
    \n\r\
    \n            :if ( ([:len \$cmd]) != 0) do={\r\
    \n\r\
    \n              :global cmdStdoutVal \"\";\r\
    \n              :do {\r\
    \n                :global cmdScriptFilename \"cmdScript.rsc\";\r\
    \n                :global cmdResultFilename \"cmdResult.txt\";      \r\
    \n\r\
    \n              \r\
    \n                :global isCmdScriptExist;\r\
    \n                :set \$isCmdScriptExist 0;\r\
    \n                :if ([:len [/system script find name=\"\$cmdScriptFilena\
    me\"]] > 0) do={\r\
    \n                  /system script set \$cmdScriptFilename source=\"\$cmd\
    \"\r\
    \n                  :set \$isCmdScriptExist 1;\r\
    \n                }\r\
    \n                :if (\$isCmdScriptExist = 0) do={\r\
    \n                  /system script add name=\$cmdScriptFilename source=\"\
    \$cmd\"\r\
    \n                }\r\
    \n                \r\
    \n                :if ([:len [/file find name=\"\$cmdResultFilename\"]] = \
    0) do={\r\
    \n                  /file print file=\"\$cmdResultFilename\"\r\
    \n                }\r\
    \n               \r\
    \n                {\r\
    \n                  if (\$cmdRebootRebCtrl = 0) do={\r\
    \n                    :local j [:execute script={[/system script run \$cmd\
    ScriptFilename]} file=\"\$cmdResultFilename\"];\r\
    \n                    :delay 400ms;\r\
    \n                  } else={\r\
    \n                    :local j [:execute script={[:put (\"For Reboot, you \
    can use the Reboot button above.\")]} file=cmdResult.txt];\r\
    \n                  }\r\
    \n                  \r\
    \n                }\r\
    \n\r\
    \n                :global cmdFileSize 0:\r\
    \n                :set \$cmdFileSize ([/file get \$cmdResultFilename size]\
    )\r\
    \n                :if ( \$cmdFileSize < 4096) do={\r\
    \n\r\
    \n                  #:set \$cmdStdoutVal ([/file get \$cmdResultFilename c\
    ontents ]);\r\
    \n                  :global addEndLineChar \"\";\r\
    \n                  {\r\
    \n                    :global content;\r\
    \n                    :set \$content ([:put [/file get [/file find name=\"\
    \$cmdResultFilename\"] contents]]);\r\
    \n                    :delay 300ms;\r\
    \n                    :global contentLen [:len \$content]\r\
    \n                    \r\
    \n                    :global lineEnd 0;\r\
    \n                    :global line \"\";\r\
    \n                    :global lastEnd 0;\r\
    \n\r\
    \n                    :if (\$contentLen = 0) do={\r\
    \n                      :set \$addEndLineChar \" \"\r\
    \n                    }\r\
    \n                    :while (\$lineEnd < \$contentLen) do={\r\
    \n                      :set lineEnd [:find \$content \"\\n\" \$lastEnd];\
    \r\
    \n                      :if ([:len \$lineEnd] = 0) do={\r\
    \n                        :set lineEnd \$contentLen;\r\
    \n                      }\r\
    \n                      :set line [:pick \$content \$lastEnd \$lineEnd];\r\
    \n                      :set \$line (\"\$line\" . \"\A3\");\r\
    \n                      :set \$addEndLineChar (\"\$addEndLineChar\" . \"\$\
    line\" );\r\
    \n                      :set lastEnd (\$lineEnd + 1);\r\
    \n                    } \r\
    \n                    :set \$cmdStdoutVal ([:tostr \$addEndLineChar]);\r\
    \n                  }\r\
    \n\r\
    \n                  {/file remove \$cmdResultFilename}\r\
    \n                } else={\r\
    \n                  :set \$cmdStdoutVal \"Error: The result is larger than\
    \_the MikroTik RouterOS 4096 byte limit.\";\r\
    \n                  {/file remove \$cmdResultFilename}\r\
    \n                }\r\
    \n              } on-error={\r\
    \n                :do {\r\
    \n                  :set \$cmdStdoutVal [\$tmpCmd]\r\
    \n                } on-error={\r\
    \n                  :set \$stderr (\$cmd . \" : Error: bad command name.\"\
    );\r\
    \n                }\r\
    \n              }\r\
    \n\r\
    \n              :global cmdStdoutValLen;\r\
    \n              :set \$cmdStdoutValLen ([:len \$cmdStdoutVal]);\r\
    \n              :global startEncode;\r\
    \n              :global isSend;\r\
    \n\r\
    \n              :if (\$cmdStdoutValLen > 0 and \$isSend=1) do={\r\
    \n                :execute script={\r\
    \n                  :set \$isSend 0;\r\
    \n                  :set \$cmdStdoutValLen 0;\r\
    \n                  # ----------- Call base64EncodeFunct from base64Encode\
    Funtion Script ----------------\r\
    \n                  :global base64EncodeFunct;\r\
    \n                  :set \$cmdStdoutVal ([\$base64EncodeFunct stringVal=\$\
    cmdStdoutVal]);\r\
    \n                  #:set \$cmdStdoutVal \"QVdTIERVREU=\";\r\
    \n                  \r\
    \n                  :global cmdData \"{\\\"ws_id\\\":\\\"\$wsid\\\", \\\"u\
    uidv4\\\":\\\"\$uuidv4\\\", \\\"stdout\\\":\\\"\$cmdStdoutVal\\\",\\\"stde\
    rr\\\":\\\"\$stderr\\\",\\\"login\\\":\\\"\$login\\\",\\\"key\\\":\\\"\$ke\
    y\\\"}\";\r\
    \n\r\
    \n                  :global collectCmdData;\r\
    \n\r\
    \n                  :global cmdUrlVal \"update\?login=\$login&key=\$key&ws\
    _id=\$wsid&uuidv4=\$uuidv4&stdout=\$cmdStdoutVal&stderr=\$stderr\"\r\
    \n                  :global mergeCmdsUrl;\r\
    \n                  :set \$mergeCmdsUrl ([\$urlEncodeFunct currentUrlVal=\
    \$currentUrl urlVal=\$cmdUrlVal]);\r\
    \n                  :do {\r\
    \n                    /tool fetch url=\$mergeCmdsUrl output=none;\r\
    \n                    :set \$isSend 1;\r\
    \n                    :set \$isRequest 1;\r\
    \n                    :log info (\"CMD  OK ========>>>>\");\r\
    \n                  } on-error={\r\
    \n                    :log info (\"CMD ERROR ========>>>>\");\r\
    \n                  }\r\
    \n                }\r\
    \n              } else={\r\
    \n                :log info (\"STDOUT IS EMPTY.DATA IS NOT SEND ========>>\
    >>\");\r\
    \n              }\r\
    \n            }\r\
    \n          }\r\
    \n          :set \$tmpCmdsArrayLenVal 0;\r\
    \n        } else={\r\
    \n          :log info (\"TMP CMD ARR LEN IS NONE ==>>\");\r\
    \n        }\r\
    \n    }\r\
    \n    }\r\
    \n  }\r\
    \n}"
add dont-require-permissions=no name=collectors.rsc owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#\
    Arp removed.\r\
    \n#------------- Ping For Collector-----------------\r\
    \n:global avgRtt 0;\r\
    \n:local minRtt 0;\r\
    \n:local maxRtt 0;\r\
    \n:global numPing 4;\r\
    \n:local toPingIP 172.217.1.206; #google.com\r\
    \n:local totalpingsreceived 0;\r\
    \n:local totalpingssend 0; \r\
    \n:for tmpA from=1 to=\$numPing step=1 do={\r\
    \n  :do {\r\
    \n    /tool flood-ping count=1 size=38 address=\$toPingIP do={\r\
    \n      :set \$totalpingssend (\$\"received\" + \$totalpingssend)\r\
    \n      :set \$totalpingsreceived (\$\"received\" + \$totalpingsreceived)\
    \r\
    \n      :set \$avgRtt (\$\"avg-rtt\" + \$avgRtt);\r\
    \n      :set \$minRtt (\$\"min-rtt\" + \$minRtt);\r\
    \n      :set \$maxRtt (\$\"max-rtt\" + \$maxRtt);\r\
    \n    }\r\
    \n    :delay 1;\r\
    \n  } on-error={\r\
    \n    :log info (\"TOOL FLOOD_PING ERROR=====>>> \");\r\
    \n }\r\
    \n}\r\
    \n:local calculateAvgRtt 0;\r\
    \n:local calculatMinRtt 0;\r\
    \n:local calculateMaxRtt 0;\r\
    \n:local percenttage 0;\r\
    \n:local packageLos 0;\r\
    \n\r\
    \nglobal pingArray;\r\
    \n:if (\$totalpingssend != 0 ) do={\r\
    \n\r\
    \n  :set \$calculateAvgRtt ([:tostr (\$avgRtt / \$totalpingssend )]);\r\
    \n  #:put (\"avgRtt: \".\$calculateAvgRtt);\r\
    \n\r\
    \n  :set \$calculatMinRtt ([:tostr (\$minRtt / \$totalpingssend )]);\r\
    \n  #:put (\"minRtt: \".\$calculatMinRtt);\r\
    \n\r\
    \n  :set \$calculateMaxRtt ([:tostr (\$maxRtt / \$totalpingssend )]);\r\
    \n  #:put (\"maxRtt: \".\$calculateMaxRtt);\r\
    \n  \r\
    \n  :set \$percentage (((\$totalpingsreceived)*100) / (\$totalpingssend));\
    \r\
    \n  \r\
    \n  :set \$packageLos ((100 - \$percentage));\r\
    \n  #:put (\"package Los: \". \$packageLos);\r\
    \n}\r\
    \n:set \$pingArray \"{\\\"host\\\":\\\"\$toPingIP\\\",\\\"avgRtt\\\":\$cal\
    culateAvgRtt,\\\"loss\\\":\$packageLos,\\\"minRtt\\\":\$calculatMinRtt,\\\
    \"maxRtt\\\":\$calculateMaxRtt}\";\r\
    \n\r\
    \n#------------- Interface For Collector-----------------\r\
    \n:global ifaceName \"0\";\r\
    \n:global rxBytes \"0\";\r\
    \n:global rxPackages \"0\";\r\
    \n:global rxErrors \"0\";\r\
    \n:global rxDrops \"0\";\r\
    \n:global txBytes \"0\";\r\
    \n:global txPackages \"0\";\r\
    \n:global txErrors \"0\";\r\
    \n:global txDrops \"0\";\r\
    \n:global ifaceDataArray \"\";\r\
    \n:global totalInterface;\r\
    \n:set \$totalInterface ([/interface print as-value count-only]);\r\
    \n\r\
    \n:local interfaceCounter 0;\r\
    \n:foreach iface in=[/interface find] do={\r\
    \n  :set \$interfaceCounter (\$interfaceCounter + 1);\r\
    \n  :if ( [:len \$iface] != 0 ) do={\r\
    \n\r\
    \n    :set ifaceName [/interface get \$iface name];\r\
    \n\r\
    \n    :if ( [:len \$ifaceName] !=0 ) do={\r\
    \n\r\
    \n      :local rxBytesVal [/interface get \$iface rx-byte];\r\
    \n      if ([:len \$rxBytesVal]>0) do={\r\
    \n        :set \$rxBytes \$rxBytesVal;\r\
    \n      }\r\
    \n      :local rxPackagesVal [/interface get \$iface rx-packet];\r\
    \n      if ([:len \$rxPackagesVal]>0) do={\r\
    \n        :set \$rxPackages \$rxPackagesVal;\r\
    \n      }\r\
    \n      :local rxErrorsVal [/interface get \$iface rx-error];\r\
    \n      if ([:len \$rxErrorsVal]>0) do={\r\
    \n        :set \$rxErrors \$rxErrorsVal;\r\
    \n      }\r\
    \n      :local rxDropsVal [/interface get \$iface rx-drop];\r\
    \n      if ([:len \$rxDropsVal]>0) do={\r\
    \n        :set \$rxDrops \$rxDropsVal;\r\
    \n      }\r\
    \n\r\
    \n      :local txBytesVal [/interface get \$iface tx-byte];\r\
    \n      if ([:len \$txBytesVal]>0) do={\r\
    \n        :set \$txBytes \$txBytesVal;\r\
    \n      }\r\
    \n      :local txPackagesVal [/interface get \$iface tx-packet];\r\
    \n      if ([:len \$txPackagesVal]>0) do={\r\
    \n        :set \$txPackages \$txPackagesVal\r\
    \n      }\r\
    \n      :local txErrorsVal [/interface get \$iface tx-error];\r\
    \n      if ([:len \$txErrorsVal]>0) do={\r\
    \n        :set \$txErrors \$txErrorsVal\r\
    \n      }\r\
    \n      :local txDropsVal [/interface get \$iface tx-drop];\r\
    \n      if ([:len \$txDropsVal]>0) do={\r\
    \n        :set \$txDrops \$txDropsVal;\r\
    \n      }\r\
    \n\r\
    \n      :if (\$interfaceCounter != \$totalInterface) do={\r\
    \n        :global ifaceData \"{\\\"if\\\":\\\"\$ifaceName\\\", \\\"recByte\
    s\\\":\$rxBytes, \\\"recPackets\\\":\$rxPackages, \\\"recErrors\\\":\$rxEr\
    rors, \\\"recDrops\\\":\$rxDrops, \\\"sentBytes\\\":\$txBytes, \\\"sentPac\
    kets\\\":\$txPackages, \\\"sentErrors\\\":\$txErrors, \\\"sentDrops\\\":\$\
    txDrops, \\\"rateSentBps\\\":0.1, \\\"rateRecBps\\\":0.1},\";\r\
    \n        :set \$ifaceDataArray (\$ifaceDataArray.\$ifaceData);\r\
    \n      }\r\
    \n      :if (\$interfaceCounter = \$totalInterface) do={\r\
    \n        :global ifaceData \"{\\\"if\\\":\\\"\$ifaceName\\\", \\\"recByte\
    s\\\":\$rxBytes, \\\"recPackets\\\":\$rxPackages, \\\"recErrors\\\":\$rxEr\
    rors, \\\"recDrops\\\":\$rxDrops, \\\"sentBytes\\\":\$txBytes, \\\"sentPac\
    kets\\\":\$txPackages, \\\"sentErrors\\\":\$txErrors, \\\"sentDrops\\\":\$\
    txDrops, \\\"rateSentBps\\\":0.1, \\\"rateRecBps\\\":0.1}\";\r\
    \n        :set \$ifaceDataArray (\$ifaceDataArray.\$ifaceData);\r\
    \n      }\r\
    \n    }\r\
    \n  }\r\
    \n}\r\
    \n\r\
    \n#------------- Wap For Collector-----------------\r\
    \n:global totalInterfaceForWap;\r\
    \n:set \$totalInterfaceForWap ([/interface wireless registration-table pri\
    nt as-value count-only]);\r\
    \n\r\
    \n:global wapInterface;\r\
    \n:do {\r\
    \n  :set \$wapInterface ([/interface wireless registration-table get 0 int\
    erface])\r\
    \n} on-error={\r\
    \n  :log info (\"Wap Interface Error ======>>>\")\r\
    \n}\r\
    \n:global wapStationDataArray \"\";\r\
    \n\r\
    \n:global wapMacAddress;\r\
    \n:global signalStrengt;\r\
    \n:global wapInterfaceNumber;\r\
    \nset \$wapInterfaceNumber  0;\r\
    \n:if ([:len [/interface wireless find ]]>0) do={\r\
    \n  :foreach wirelessClient  in=[/interface wireless registration-table fi\
    nd true] do={\r\
    \n    :set \$wapInterfaceNumber  (\$wapInterfaceNumber  + 1);\r\
    \n    :do {\r\
    \n\r\
    \n      :set \$wapMacAddress ([/interface wireless registration-table get \
    [ find .id=\$wirelessClient ] value-name=mac-address]);\r\
    \n\r\
    \n      :set \$signalStrengt ([/interface wireless registration-table get \
    [ find .id=\$wirelessClient ] value-name=signal-strength]);\r\
    \n\r\
    \n      :set \$signalStrengt ([:pick \$signalStrengt 0 [:find \$signalStre\
    ngt \"dBm\"]])\r\
    \n\r\
    \n    } on-error={\r\
    \n      :log info (\"WAP ERROR====>>>>>\");\r\
    \n    }\r\
    \n    :if (\$wapInterfaceNumber != \$totalInterfaceForWap) do={\r\
    \n      :global wapData \"{\\\"mac\\\":\\\"\$wapMacAddress\\\",\\\"rssi\\\
    \":\$signalStrengt},\";\r\
    \n      :set \$wapStationDataArray (\$wapStationDataArray.\$wapData);\r\
    \n    }\r\
    \n    :if (\$wapInterfaceNumber = \$totalInterfaceForWap) do={\r\
    \n      :global wapData \"{\\\"mac\\\":\\\"\$wapMacAddress\\\",\\\"rssi\\\
    \":\$signalStrengt}\";\r\
    \n      :set \$wapStationDataArray (\$wapStationDataArray.\$wapData);\r\
    \n    }   \r\
    \n  }\r\
    \n}\r\
    \nglobal wapArray \"{\\\"stations\\\":[\$wapStationDataArray],\\\"interfac\
    e\\\":\\\"\$wapInterface\\\"}\";\r\
    \n\r\
    \n#------------- System For Collector-----------------\r\
    \n# Name : Average CPU Load\r\
    \n# Set up the scheduler to run this at a 1 second intervals (Sample Rate)\
    \r\
    \n# Set info logs to echo to Terminal in System Logging\r\
    \n\r\
    \n:local cpuLoad 0;\r\
    \n:global cpuArrayForOneMinute;\r\
    \n:global cpuArrayForFiveMinute;\r\
    \n:global cpuArrayForFifteenMinute;\r\
    \n:local arrayLenForOneMinute 0;\r\
    \n:local arrayLenForFiveMinute 0;\r\
    \n:local arrayLenForFifteenMinute 0;\r\
    \n:local arrayPosForOneMinute 0;\r\
    \n:local arrayPosForFiveMinute 0;\r\
    \n:local arrayPosForFifteenMinute 0;\r\
    \n:local arrayTotForOneMinute 0;\r\
    \n:local arrayTotForFiveMinute 0;\r\
    \n:local arrayTotForFifteenMinute 0;\r\
    \n:global avgCpuLoadForOneMinute 0;\r\
    \n:global avgCpuLoadForFiveMinute 0;\r\
    \n:global avgCpuLoadForFifteenMinute 0;\r\
    \n:global highAvgCpuLoadForOneMinute;\r\
    \n:global highAvgCpuLoadForFiveMinute;\r\
    \n:global highAvgCpuLoadForFifteenMinute;\r\
    \n\r\
    \n# arraysize is the number of cpu-Load samples to keep\r\
    \n# Experiment with this value to incease or decrease the number of sample\
    s\r\
    \n# The greater the value the longer the time that the cpu-load average is\
    \_calculated for.\r\
    \n:local arraySizeForOneMinute 1\r\
    \n:local arraySizeForFiveMinute 5\r\
    \n:local arraySizeForFifteenMinute 15\r\
    \n\r\
    \n# Get cpu-load samples, limit cpuArray to array size\r\
    \n:set cpuLoad [/system resource get cpu-load]\r\
    \n\r\
    \n:set cpuArrayForOneMinute ( [:toarray \$cpuLoad] + \$cpuArrayForOneMinut\
    e )\r\
    \n:set cpuArrayForOneMinute [:pick \$cpuArrayForOneMinute 0 \$arraySizeFor\
    OneMinute]\r\
    \n\r\
    \n:set cpuArrayForFiveMinute ( [:toarray \$cpuLoad] + \$cpuArrayForFiveMin\
    ute )\r\
    \n:set cpuArrayForFiveMinute [:pick \$cpuArrayForFiveMinute 0 \$arraySizeF\
    orFiveMinute]\r\
    \n\r\
    \n:set cpuArrayForFifteenMinute ( [:toarray \$cpuLoad] + \$cpuArrayForFift\
    eenMinute )\r\
    \n:set cpuArrayForFifteenMinute [:pick \$cpuArrayForFifteenMinute 0 \$arra\
    ySizeForFifteenMinute]\r\
    \n\r\
    \n# add up all values in array\r\
    \n:set arrayPosForOneMinute 0\r\
    \n:set arrayLenForOneMinute [:len \$cpuArrayForOneMinute]\r\
    \n:while (\$arrayPosForOneMinute < \$arrayLenForOneMinute) do={\r\
    \n  :set arrayTotForOneMinute (\$arrayTotForOneMinute + [:pick \$cpuArrayF\
    orOneMinute \$arrayPosForOneMinute] );\r\
    \n:set arrayPosForOneMinute (\$arrayPosForOneMinute +1)}\r\
    \n\r\
    \n:set arrayPosForFiveMinute 0\r\
    \n:set arrayLenForFiveMinute [:len \$cpuArrayForFiveMinute]\r\
    \n:while (\$arrayPosForFiveMinute < \$arrayLenForFiveMinute) do={\r\
    \n  :set arrayTotForFiveMinute (\$arrayTotForFiveMinute + [:pick \$cpuArra\
    yForFiveMinute \$arrayPosForFiveMinute] );\r\
    \n:set arrayPosForFiveMinute (\$arrayPosForFiveMinute +1)}\r\
    \n\r\
    \n:set arrayPosForFifteenMinute 0\r\
    \n:set arrayLenForFifteenMinute [:len \$cpuArrayForFiveMinute]\r\
    \n:while (\$arrayPosForFifteenMinute < \$arrayLenForFifteenMinute) do={\r\
    \n  :set arrayTotForFifteenMinute (\$arrayTotForFifteenMinute + [:pick \$c\
    puArrayForFiveMinute \$arrayPosForFifteenMinute] );\r\
    \n:set arrayPosForFifteenMinute (\$arrayPosForFifteenMinute +1)}\r\
    \n\r\
    \n# divide sum of array values by the number of values in cpuArray\r\
    \n:set avgCpuLoadForOneMinute (\$arrayTotForOneMinute / [:len \$cpuArrayFo\
    rOneMinute])\r\
    \n:if ([:len \$highAvgCpuLoadForOneMinute] = 0) do={:set highAvgCpuLoadFor\
    OneMinute \$avgCpuLoadForOneMinute}\r\
    \n:if ([\$highAvgCpuLoadForOneMinute] < [\$avgCpuLoadForOneMinute]) do={:s\
    et highAvgCpuLoadForOneMinute \$avgCpuLoadForOneMinute}\r\
    \n\r\
    \n:set avgCpuLoadForFiveMinute (\$arrayTotForFiveMinute / [:len \$cpuArray\
    ForFiveMinute])\r\
    \n:if ([:len \$highAvgCpuLoadForFiveMinute] = 0) do={:set highAvgCpuLoadFo\
    rFiveMinute \$avgCpuLoadForFiveMinute}\r\
    \n:if ([\$highAvgCpuLoadForFiveMinute] < [\$avgCpuLoadForFiveMinute]) do={\
    :set highAvgCpuLoadForFiveMinute \$avgCpuLoadForFiveMinute}\r\
    \n\r\
    \n:set avgCpuLoadForFifteenMinute (\$arrayTotForFifteenMinute / [:len \$cp\
    uArrayForFifteenMinute])\r\
    \n:if ([:len \$highAvgCpuLoadForFifteenMinute] = 0) do={:set highAvgCpuLoa\
    dForFifteenMinute \$avgCpuLoadForFifteenMinute}\r\
    \n:if ([\$highAvgCpuLoadForFifteenMinute] < [\$avgCpuLoadForFifteenMinute]\
    ) do={:set highAvgCpuLoadForFifteenMinute \$avgCpuLoadForFifteenMinute}\r\
    \n\r\
    \n#Memory\r\
    \n:local totalMem 0;\r\
    \n:local freeMem 0;\r\
    \n:local memBuffers 0;\r\
    \n:local cachedMem 0;\r\
    \n:set \$totalMem ([/system resource get total-memory])\r\
    \n:set \$freeMem ([/system resource get free-memory])\r\
    \n:set \$memBuffers ([/system logging action get memory memory-lines])\r\
    \n:set \$cachedMem ([/ip route cache get cache-size])\r\
    \n\r\
    \n#Disks\r\
    \n:global diskDataArray \"\";\r\
    \n:global totalDisks;\r\
    \n:set \$totalDisks ([/disk print as-value count-only]);\r\
    \n\r\
    \n:local disksCounter 0;\r\
    \n:foreach disk in=[/disk find] do={\r\
    \n\r\
    \n  :local diskName \"\";\r\
    \n  :local diskFree 0;\r\
    \n  :local diskSize 0;\r\
    \n  :local diskUsed 0;\r\
    \n\r\
    \n  :if (\$totalDisks != 0) do={\r\
    \n    :set \$diskName [/disk get \$disksCounter name];\r\
    \n    :set \$diskFree [/disk get \$disksCounter free];\r\
    \n    :set \$diskSize [/disk get \$disksCounter size];\r\
    \n    :set \$diskUsed ((\$diskSize - \$diskFree));\r\
    \n  }\r\
    \n\r\
    \n  :if (\$totalDisks = 1) do={\r\
    \n    :global diskData \"{\\\"mount\\\":\\\"\$diskName\\\",\\\"used\\\":\$\
    diskUsed,\\\"avail\\\":\$diskFree}\";\r\
    \n    :set \$diskDataArray (\$diskDataArray.\$diskData);\r\
    \n  }\r\
    \n  :if (\$totalDisks > 1) do={\r\
    \n    :if (\$disksCounter != \$totalDisks) do={\r\
    \n      :global diskData \"{\\\"mount\\\":\\\"\$diskName\\\",\\\"used\\\":\
    \$diskUsed,\\\"avail\\\":\$diskFree},\";\r\
    \n      :set \$diskDataArray (\$diskDataArray.\$diskData);\r\
    \n    }\r\
    \n    :if (\$disksCounter = \$totalDisks) do={\r\
    \n      :global diskData \"{\\\"mount\\\":\\\"\$diskName\\\",\\\"used\\\":\
    \$diskUsed,\\\"avail\\\":\$diskFree}\";\r\
    \n      :set \$diskDataArray (\$diskDataArray.\$diskData);\r\
    \n    }\r\
    \n  }  \r\
    \n} \r\
    \n:global systemArray \"{\\\"load\\\":{\\\"one\\\":\$avgCpuLoadForOneMinut\
    e,\\\"five\\\":\$avgCpuLoadForFiveMinute,\\\"fifteen\\\":\$avgCpuLoadForFi\
    fteenMinute,\\\"processCount\\\":45},\\\"memory\\\":{\\\"total\\\":\$total\
    Mem,\\\"free\\\":\$freeMem,\\\"buffers\\\":\$memBuffers,\\\"cached\\\":\$c\
    achedMem},\\\"disks\\\":[\$diskDataArray]}\";\r\
    \n\r\
    \n:global collectUpDataVal \"{\\\"ping\\\":[\$pingArray],\\\"wap\\\":[\$wa\
    pArray], \\\"interface\\\":[\$ifaceDataArray],\\\"system\\\":\$systemArray\
    }\";\r\
    \n\r\
    \n#:global collectUpDataVal \"\";"
add dont-require-permissions=no name=update.rsc owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#\
    \_Url for Collect . Note : Sadece Collect datasi(ping , inerface, wap vs g\
    \F6nderiyor. Uptime D\FCzenlendi.).\r\
    \n\r\
    \n:global currentUrl\r\
    \n\r\
    \n:global key;\r\
    \n\r\
    \n#Client Info\r\
    \n:global clientInfo;\r\
    \n\r\
    \n# Get MAC address from wireless or ethernet and use as login\r\
    \n:global login;\r\
    \n\r\
    \n# version data\r\
    \n:local mymodel [/system routerboard get model];\r\
    \n:local myversion [/system package get 0 version];\r\
    \n\r\
    \n#WAN Port IP Address\r\
    \n:global gatewayStatus; \r\
    \n:do {\r\
    \n  :set \$gatewayStatus ([:tostr [/ip route get [:pick [find dst-address=\
    0.0.0.0/0 active=yes] 0] gateway-status]])\r\
    \n} on-error={\r\
    \n  :log info (\"Wan Port Error===>>\");\r\
    \n}\r\
    \n\r\
    \n:global getInterfaceIndex\r\
    \n:global interfaceIp;\r\
    \n:set \$getInterfaceIndex ([:find \"\$gatewayStatus\" \" \" -1])\r\
    \n\r\
    \n:set \$interfaceIp [:pick \$gatewayStatus 0 \$getInterfaceIndex]\r\
    \n\r\
    \n:global ipNetworkAddress;\r\
    \n:set \$ipNetworkAddress [:pick \$interfaceIp 0 ([:len \$interfaceIp ] - \
    1)]\r\
    \n:set \$ipNetworkAddress (\$ipNetworkAddress . \"0\");\r\
    \n:global iface\r\
    \n:set \$iface \$interface\r\
    \n:global wanIP;\r\
    \n:do {\r\
    \n  :set \$wanIP [/ip address  get [:pick [/ip address find network=\$ipNe\
    tworkAddress] 0] address ]\r\
    \n} on-error={\r\
    \n  :set \$wanIP \"\"\r\
    \n  :log info (\"WanIP Error===>>\");\r\
    \n}\r\
    \n\r\
    \n:if ([:len \$wanIP] = 0) do={\r\
    \n  :set \$wanIP ([/ip address get 0 address])\r\
    \n}\r\
    \n\r\
    \n:global upSeconds 0;\r\
    \n# All this is just to convert XwYdHH:MM:SS to seconds.\r\
    \n:local upTime [/system resource get uptime]\r\
    \n\r\
    \nglobal weeks 0;\r\
    \nif (([:find \$upTime \"w\"]) > 0 ) do={\r\
    \n  :set \$weeks ([:pick \$upTime 0 ([:find \$upTime \"w\"])]);\r\
    \n  :set upTime [:pick \$upTime ([:find \$upTime \"w\"]+1) [:len \$upTime]\
    ]\r\
    \n}\r\
    \nglobal days 0;\r\
    \nif (([:find \$upTime \"d\"]) > 0 ) do={\r\
    \n  :set \$days ([:pick \$upTime 0 [:find \$upTime \"d\"]]);\r\
    \n  :set upTime [:pick \$upTime ([:find \$upTime \"d\"]+1) [:len \$upTime]\
    ]\r\
    \n}\r\
    \n\r\
    \n:global hours [:pick \$upTime 0 [:find \$upTime \":\"]]\r\
    \n:set upTime [:pick \$upTime ([:find \$upTime \":\"]+1) [:len \$upTime]]\
    \r\
    \n\r\
    \n:global minutes [:pick \$upTime 0 [:find \$upTime \":\"]]\r\
    \n:set upTime [:pick \$upTime ([:find \$upTime \":\"]+1) [:len \$upTime]]\
    \r\
    \n\r\
    \n:global upSecondVal 0;\r\
    \n:set \$upSecondVal \$upTime;\r\
    \n\r\
    \n:set \$upSeconds value=[:tostr ((\$weeks*604800)+(\$days*86400)+(\$hours\
    *3600)+(\$minutes*60)+\$upSecondVal)]\r\
    \n\r\
    \n# ------------------- urlEncodeFunct ----------------------\r\
    \n:global urlEncodeFunct do={\r\
    \n  :put \"arg a=\$currentUrlVal\"; \r\
    \n  :put \"arg b=\$urlVal\"\r\
    \n\r\
    \n  :local urlEncoded;\r\
    \n  :for i from=0 to=([:len \$urlVal] - 1) do={\r\
    \n    :local char [:pick \$urlVal \$i]\r\
    \n\r\
    \n    :global chars { \"!\"=\"%21\"; \"#\"=\"%23\"; \"\$\"=\"%24\"; \"%\"=\
    \"%25\"; \"'\"=\"%27\"; \"(\"=\"%28\"; \")\"=\"%29\"; \"*\"=\"%2A\"; \"+\"\
    =\"%2B\"; \",\"=\"%2C\"; \"-\"=\"%2D\"; \".\"=\"%2E\"; \"/\"=\"%2F\"; \"; \
    \"=\"%3B\"; \"<\"=\"%3C\"; \">\"=\"%3E\"; \"@\"=\"%40\"; \"[\"=\"%5B\"; \"\
    \\\"=\"%5C\"; \"]\"=\"%5D\"; \"^\"=\"%5E\"; \"_\"=\"%5F\"; \"`\"=\"%60\"; \
    \"{\"=\"%7B\"; \"|\"=\"%7C\"; \"}\"=\"%7D\"; \"~\"=\"%7E\"; \" \"=\"%7F\"}\
    \r\
    \n\r\
    \n    :local EncChar;\r\
    \n    :set \$EncChar (\$chars->\$char)\r\
    \n    :if (any \$EncChar) do={\r\
    \n      :set \$char (\$chars->\$char)\r\
    \n    } else={\r\
    \n      :set \$char \$char\r\
    \n    }\r\
    \n\r\
    \n    :set urlEncoded (\$urlEncoded . \$char)\r\
    \n  }\r\
    \n  :local mergeUrl;\r\
    \n  :set \$mergeUrl (\$currentUrlVal . \$urlEncoded);\r\
    \n  :return (\$mergeUrl);\r\
    \n\r\
    \n}\r\
    \n\r\
    \n:global collectUpdataValLen;\r\
    \n:global collectUpDataVal;\r\
    \n:set \$collectUpdataValLen ([:len \$collectUpDataVal]);\r\
    \n:if (\$collectUpdataValLen = 0) do={\r\
    \n  :set \$collectUpDataVal \"[]\";\r\
    \n}\r\
    \n:global collectUpData \"{\\\"collectors\\\":\$collectUpDataVal,\\\"login\
    \\\":\\\"\$login\\\",\\\"key\\\":\\\"\$key\\\",\\\"clientInfo\\\":\\\"\$cl\
    ientInfo\\\", \\\"osVersion\\\":\\\"RB\$mymodel-\$myversion\\\", \\\"wanIp\
    \\\":\\\"\$wanIP\\\",\\\"uptime\\\":\$upSeconds}\";\r\
    \n\r\
    \n:global collectorsUrl \"update\"\r\
    \n\r\
    \n:global mergeUpdateCollectorsUrl;\r\
    \n:set \$mergeUpdateCollectorsUrl ([\$urlEncodeFunct currentUrlVal=\$curre\
    ntUrl urlVal=\$collectorsUrl]);\r\
    \n\r\
    \n:global collectUpdateData;\r\
    \n:do { \r\
    \n  :set \$collectUpdateData ([/tool fetch mode=https http-method=post htt\
    p-header-field=\"cache-control: no-cache, content-type: application/json\"\
    \_http-data=\"\$collectUpData\" url=\$mergeUpdateCollectorsUrl as-value ou\
    tput=user duration=10])\r\
    \n\r\
    \n  :global collectDebug;\r\
    \n\r\
    \n  /system script run \"JParseFunctions\"; global JSONIn; global JParseOu\
    t; global fJParse;\r\
    \n  # Parse data and print `ParsedResults[0].ParsedText` value\r\
    \n  :set \$collectDebug (\$collectUpdateData->\"data\");\r\
    \n\r\
    \n  :global errorCheck;\r\
    \n  :set \$errorCheck ([:find \$collectDebug \"error\"])\r\
    \n\r\
    \n  if (([:len \$errorCheck]) > 0 ) do={\r\
    \n    :log info (\"Update Req Error Status ===>>>>\" , \$collectDebug);\r\
    \n    \r\
    \n  } else={\r\
    \n      :log info (\"UPDATE FUNCT OK =======>>>\", \$collectUpdateData->\"\
    data\");\r\
    \n\r\
    \n      #initMultipleScript control.\r\
    \n      :global checkInitScriptCount 0;\r\
    \n      :do {\r\
    \n        :set \$checkInitScriptCount ([/system script get initMultipleScr\
    ipt run-count]);\r\
    \n        :if (\$checkInitScriptCount < 2) do={\r\
    \n          /execute script=\"initMultipleScript\";\r\
    \n          :log info (\"INITMULTIPLESCRIPT RUN OK ====>\");\r\
    \n        };\r\
    \n      } on-error={\r\
    \n        :log info (\"INITMULTIPLESCRIPT RUN ERROR ====>\");\r\
    \n      }\r\
    \n  }\r\
    \n\r\
    \n} on-error={\r\
    \n  :log info (\"UPDATE FUNCT ERROR =======>>>\");\r\
    \n};"
add dont-require-permissions=no name=update owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    "/execute script=\"update.rsc\""
add dont-require-permissions=no name=collectors owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    "/execute script=\"collectors.rsc\""
add dont-require-permissions=no name=config owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#\
    \_Write configuration to file, apply configuration.\r\
    \n# wait for internet connectivity\r\
    \n# Wireless command is added again.Wifi is working.Date:210621 \r\
    \n\r\
    \n:do { :delay 1 } while=([/ping 1.1.1.1 count=1] = 0);\r\
    \n\r\
    \n# Url for Collect\r\
    \n:global currentUrl;\r\
    \n\r\
    \n# Key for Collect\r\
    \n:global key;\r\
    \n\r\
    \n# client info for Collect\r\
    \n:global clientInfo;\r\
    \n\r\
    \n# Get MAC address from wireless or ethernet and use as login\r\
    \n:global login;\r\
    \n\r\
    \n:global login;\r\
    \n:global wifiModeCtrl;\r\
    \n:set \$wifiModeCtrl \"\"\r\
    \n:if ([:len [/interface wireless find ]]>0) do={\r\
    \n    :set \$wifiModeCtrl \"1\";\r\
    \n  };\r\
    \n:if ([:len [/interface wireless find ]]<1) do={\r\
    \n  :set \$wifiModeCtrl \"0\";\r\
    \n};\r\
    \n\r\
    \n# Prepare URL special characters and merge url function\r\
    \n:global urlEncodeFunct do={\r\
    \n  :put \"\$currentUrlVal\"; \r\
    \n  :put \"\$urlVal\"\r\
    \n\r\
    \n  :local urlEncoded;\r\
    \n  :for i from=0 to=([:len \$urlVal] - 1) do={\r\
    \n    :local char [:pick \$urlVal \$i]\r\
    \n    :if (\$char = \" \") do={\r\
    \n      :set \$char \"%20\"\r\
    \n    }\r\
    \n    :if (\$char = \"/\") do={\r\
    \n      :set \$char \"%2F\"\r\
    \n    }\r\
    \n    :if (\$char = \"-\") do={\r\
    \n      :set \$char \"%2D\"\r\
    \n    }\r\
    \n    :set urlEncoded (\$urlEncoded . \$char)\r\
    \n  }\r\
    \n  :local mergeUrl;\r\
    \n  :set \$mergeUrl (\$currentUrlVal . \$urlEncoded);\r\
    \n  :return (\$mergeUrl);\r\
    \n\r\
    \n}\r\
    \n\r\
    \n# Unix timestamp to number\r\
    \n:global fncBuildDate do={\r\
    \n:local months [:toarray \"Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,De\
    c\"];\r\
    \n:local jd\r\
    \n:local M [:pick \$1 0 3];\r\
    \n:local D [:pick \$1 4 6];\r\
    \n:local Y [:pick \$1 7 11];\r\
    \n:for x from=0 to=([:len \$months] - 1) do={\r\
    \n\r\
    \n  :if ([:tostr [:pick \$months \$x]] = \$M) do={:set M (\$x + 1) } \r\
    \n}\r\
    \n:if ( \$M = 1 || \$M = 2) do={\r\
    \n    :set Y (\$Y-1);\r\
    \n    :set M (\$M+12);\r\
    \n}\r\
    \n:local A (\$Y/100);\r\
    \n:local B (\$A/4);\r\
    \n:local C (2-\$A+\$B);\r\
    \n:local E (((\$Y+4716) * 36525)/100);\r\
    \n:local F ((306001*(\$M+1))/10000);\r\
    \n:local jd (\$C+\$D+\$E+\$F-1525);\r\
    \n:return \$jd\r\
    \n};\r\
    \n\r\
    \n:global fncBuildDate \$fncBuildDate;\r\
    \n\r\
    \n:global buildTime;\r\
    \n:set \$buildTime [/system resource get build-time];\r\
    \n\r\
    \n:global buildDate;\r\
    \n:global buildTimeValue;\r\
    \n:set \$parseDate [:find \$buildTime \" \"];\r\
    \n:if ([:len \$parseDate] != 0) do={\r\
    \n    :set \$buildDate [:pick \$buildTime 0 11];\r\
    \n    :set \$buildTimeValue [:pick \$buildTime 12 20];\r\
    \n}\r\
    \n\r\
    \n:global nowDate;\r\
    \n:set \$nowDate [\$fncBuildDate \$buildDate];\r\
    \n\r\
    \n:global currentTime;\r\
    \n:set \$currentTime \$buildTimeValue;\r\
    \n\r\
    \n:local days (\$nowDate - 2440587);\r\
    \n:local hour [:pick \$currentTime 0 2];\r\
    \n:local minute [:pick \$currentTime 3 5];\r\
    \n:local second [:pick \$currentTime 6 8];\r\
    \n:global osbuildate;\r\
    \n:set \$osbuildate [((((\$days * 86400) + (\$hour * 3600)) + (\$minute * \
    60)) + \$second)];\r\
    \n\r\
    \n:local osversion [/system package get 0 version];\r\
    \n:local os [/system package get 0 name];\r\
    \n:local hardwaremake [/system resource get platform];\r\
    \n:local hardwaremodel [/system resource get board-name];\r\
    \n:local boardmodelnumber [/system routerboard get model];\r\
    \n:local boardserialnumber [/system routerboard get serial-number];\r\
    \n:local cpu [/system resource get cpu];\r\
    \n:local boardfirmwaretype [/system routerboard get firmware-type];\r\
    \n:local boardcurrentfirmware [/system routerboard get current-firmware];\
    \r\
    \n\r\
    \n:global hwUrlValCollectData;\r\
    \n:set \$hwUrlValCollectData (\"{\\\"login\\\":\\\"\$login\\\",\\\"key\\\"\
    :\\\"\$key\\\",\\\"clientInfo\\\":\\\"\$clientInfo\\\", \\\"osVersion\\\":\
    \\\"\$osversion\\\", \\\"hardwareMake\\\":\\\"\$hardwaremake\\\",\\\"hardw\
    areModel\\\":\\\"\$hardwaremodel\\\",\\\"hardwareModelNumber\\\":\\\"\$boa\
    rdmodelnumber\\\",\\\"hardwareSerialNumber\\\":\\\"\$boardserialnumber\\\"\
    , \\\"hardwareCpuInfo\\\":\\\"\$cpu\\\",\\\"os\\\":\\\"\$os\\\",\\\"osBuil\
    dDate\\\":\$osbuildate,\\\"fw\\\":\\\"\$boardfirmwaretype\\\",\\\"fwVersio\
    n\\\":\\\"\$boardcurrentfirmware\\\"}\");\r\
    \n\r\
    \n:put (\$hwUrlValCollectData);\r\
    \n\r\
    \n:global collectorsUrl;\r\
    \n:set \$collectorsUrl \"config\";\r\
    \n\r\
    \n:global fetchHardwareBootUrlFuct;\r\
    \n:set \$fetchHardwareBootUrlFuct [\$urlEncodeFunct currentUrlVal=\$curren\
    tUrl urlVal=\$collectorsUrl];\r\
    \n\r\
    \n:global configSendData;\r\
    \n:do { \r\
    \n  :set \$configSendData [/tool fetch mode=https http-method=post http-he\
    ader-field=\"cache-control: no-cache, content-type: application/json\" htt\
    p-data=\"\$hwUrlValCollectData\" url=\$fetchHardwareBootUrlFuct  as-value \
    output=user duration=10]\r\
    \n  :log info (\"FETCH CONFIG HARDWARE FUNCT OK =======>>>\", \$configSend\
    Data);\r\
    \n} on-error={\r\
    \n  :log info (\"FETCH CONFIG HARDWARE FUNCT ERROR =======>>>\", \$configS\
    endData);\r\
    \n}\r\
    \n\r\
    \n:delay 1;\r\
    \n\r\
    \nif ( [:len \$configSendData] != 0 ) do={\r\
    \n\r\
    \n  :global jstr;\r\
    \n\r\
    \n  :set \$jstr [\$configSendData];\r\
    \n  /system script run \"JParseFunctions\"; global JSONIn; global JParseOu\
    t; global fJParse;\r\
    \n  # Parse data and print `ParsedResults[0].ParsedText` value\r\
    \n  :set JSONIn (\$jstr->\"data\");\r\
    \n  :set \$JParseOut [\$fJParse];\r\
    \n  \r\
    \n  :global lenval;\r\
    \n  :set \$lenval (\$JParseOut->\"host\"->\"wirelessConfigs\");\r\
    \n\r\
    \n  :global hostConfigs;\r\
    \n  :set \$hostConfigs (\$JParseOut->\"host\");\r\
    \n\r\
    \n  :global mode;\r\
    \n  :global channelwith;\r\
    \n  :global wifibeaconint;\r\
    \n\r\
    \n  :set \$mode (\$hostConfigs->\"wirelessMode\");\r\
    \n  :set \$channelwith (\$hostConfigs->\"wirelessChannel\");\r\
    \n  #:set \$wifibeaconint (\$hostConfigs->\"wirelessBeaconInt\");\r\
    \n\r\
    \n  :global hostname;\r\
    \n  :set \$hostname (\$JParseOut->\"host\"->\"name\");\r\
    \n\r\
    \n  if (\$wifiModeCtrl = \"1\") do={\r\
    \n\r\
    \n    :global getallwificount;\r\
    \n    :set \$getallwificount ([/interface wireless print count-only])\r\
    \n    :for wifinumber from=1 to=\$getallwificount do={\r\
    \n      :local wlanname (\"wlan\".\$wifinumber);\r\
    \n      :do {\r\
    \n        /interface wireless remove \$wlanname;\r\
    \n      } on-error={ \r\
    \n        :log info (\"Wifi Interface not removed ===>>\");\r\
    \n      };\r\
    \n      :log info (\"Removed Wifi Interface wlan\", \$wifinumber);\r\
    \n    }\r\
    \n\r\
    \n    :global indexVal;\r\
    \n    if ([:len [/interface wireless find name=wlan1]] > 0) do={\r\
    \n      :set \$indexVal  2;\r\
    \n    }\r\
    \n    if ([:len [/interface wireless find name=wlan2]] > 0) do={\r\
    \n      :set \$indexVal 3;\r\
    \n    }\r\
    \n\r\
    \n    :global i;\r\
    \n    :for i from=0 to=([:len \"\$lenval\"]-1) do={\r\
    \n      \r\
    \n      :global authenticationtypes;\r\
    \n      :global encryptionKey;\r\
    \n      :global ssid;\r\
    \n      :global vlanid;\r\
    \n      :global vlanmode;\r\
    \n      :global defaultforward;\r\
    \n      :global preamblemode;\r\
    \n      :set \$vlanmode \"use-tag\";\r\
    \n      :global dotw;\r\
    \n\r\
    \n      :set \$authenticationtypes (\$lenval->\$i->\"encType\");\r\
    \n      :set \$encryptionKey (\$lenval->\$i->\"encKey\");\r\
    \n      :set \$ssid (\$lenval->\$i->\"ssid\");\r\
    \n      :set \$vlanid (\$lenval->\$i->\"vlanId\");\r\
    \n      :set \$defaultforward (\$lenval->\$i->\"clientIsolation\");\r\
    \n      :set \$preamblemode (\$lenval->\$i->\"sp\");\r\
    \n      :set \$dotw (\$lenval->\$i->\"dotw\"); #TODO: Will be use after\r\
    \n\r\
    \n\r\
    \n      if (\$authenticationtypes = \"psk\") do={\r\
    \n        :set \$authenticationtypes \"wpa-psk\";\r\
    \n      }\r\
    \n      if (\$authenticationtypes = \"psk2\") do={\r\
    \n        :set \$authenticationtypes \"wpa2-psk\";\r\
    \n      }\r\
    \n      if (\$authenticationtypes = \"sae\") do={\r\
    \n        :set \$authenticationtypes \"wpa2-psk\";\r\
    \n      }\r\
    \n      if (\$authenticationtypes = \"sae-mixed\") do={\r\
    \n        :set \$authenticationtypes \"wpa2-psk\";\r\
    \n      }\r\
    \n      if (\$authenticationtypes = \"owe\") do={\r\
    \n        :set \$authenticationtypes \"wpa2-psk\";\r\
    \n      }\r\
    \n\r\
    \n      if (\$vlanid = 0) do={\r\
    \n        :set \$vlanid  1;\r\
    \n        :set \$vlanmode \"no-tag\"\r\
    \n      }\r\
    \n\r\
    \n      :global virtualAPControlFlag;\r\
    \n      :set \$virtualAPControlFlag \"True\";\r\
    \n      if ([:len \$vlanid] = 0) do={\r\
    \n        :set \$virtualAPControlFlag  \"False\";\r\
    \n      }\r\
    \n\r\
    \n      if ([:len \$authenticationtypes] = 0) do={\r\
    \n        :set \$virtualAPControlFlag  \"False\";\r\
    \n      }\r\
    \n\r\
    \n      if ( \$virtualAPControlFlag = \"True\") do={\r\
    \n        if (\$mode = \"ap_router\") do={\r\
    \n          :set \$mode \"ap-router\";\r\
    \n        }\r\
    \n        if (\$mode = \"ap_bridge\") do={\r\
    \n          :set \$mode \"ap-bridge\";\r\
    \n        }\r\
    \n        if (\$mode = \"sta\") do={\r\
    \n          :set \$mode \"station\";\r\
    \n        }\r\
    \n\r\
    \n        if (\$defaultforward = \"true\") do={\r\
    \n          :set \$defaultforward \"yes\";\r\
    \n        }\r\
    \n        if (\$defaultforward = \"false\") do={\r\
    \n          :set \$defaultforward \"no\";\r\
    \n        }\r\
    \n\r\
    \n        if (\$channelwith != \"auto\") do={\r\
    \n          :set \$channelwith \"20mhz\";\r\
    \n        }\r\
    \n\r\
    \n        if (\$preamblemode = \"true\") do={\r\
    \n          :set \$preamblemode \"long\";\r\
    \n        }\r\
    \n        if (\$preamblemode = \"false\") do={\r\
    \n          :set \$preamblemode \"short\";\r\
    \n        }\r\
    \n        \r\
    \n        #:log info (\"index ==>\" . \$i);\r\
    \n        #:log info (\"0==>\" . \$hostname);\r\
    \n        #:log info (\"1==>\" . \$authenticationtypes);\r\
    \n        #:log info (\"2==>\" . \$encryptionKey);\r\
    \n        #:log info (\"3==>\" . \$mode);\r\
    \n        #:log info (\"4==>\" . \$ssid);\r\
    \n        #:log info (\"5==>\" . \$vlanid);\r\
    \n        #:log info (\"6==>\" . \$channelwith);\r\
    \n        #:log info (\"7==>\" . \$defaultforward);\r\
    \n        #:log info (\"10==>\" . \$preamblemode);\r\
    \n        \r\
    \n        :global profileval;\r\
    \n        :global wlanval 0;\r\
    \n        :local index;\r\
    \n        :set \$index (\$i + \$indexVal);\r\
    \n        :set \$profileval \"profile\$index\";\r\
    \n        :set \$wlanval \"wlan\$index\";\r\
    \n        :global profilecontrol;\r\
    \n\r\
    \n        :log info (\$profileval);\r\
    \n        :log info (\$wlanval);\r\
    \n\r\
    \n        :set \$profilecontrol (\$profileval);\r\
    \n        :set \$wlancontrol (\$wlanval);\r\
    \n\r\
    \n        :do {[/interface wireless security-profiles get value-name=name \
    \$profileval] } on-error={ :set \$profilecontrol 0} ;\r\
    \n\r\
    \n        :do { [/interface wireless get value-name=name \$wlanval] } on-e\
    rror={ :set \$wlancontrol 0 };\r\
    \n\r\
    \n        if ( \$i = 0) do={\r\
    \n          :do { /interface wireless set wlan1 ssid=\$ssid vlan-id=\$vlan\
    id vlan-mode=\$vlanmode};\r\
    \n\r\
    \n          if (\$indexVal = 3) do={\r\
    \n            :do { /interface wireless set wlan2 ssid=\$ssid vlan-id=\$vl\
    anid vlan-mode=\$vlanmode};\r\
    \n          }\r\
    \n        }\r\
    \n\r\
    \n        if ( (\$i % 2) = 0) do={\r\
    \n\r\
    \n          if ( \$profilecontrol != 0) do={\r\
    \n            :do { /interface wireless security-profiles set \$profileval\
    \_authentication-types=\$authenticationtypes eap-methods=\"\" management-p\
    rotection=allowed mode=dynamic-keys supplicant-identity=\"\" wpa-pre-share\
    d-key=\$encryptionKey wpa2-pre-shared-key=\$encryptionKey };\r\
    \n            :delay 2;\r\
    \n\r\
    \n            if ( \$wlancontrol != 0) do={\r\
    \n              #for wlan2\r\
    \n              :do { /interface wireless set \$wlanval mode=\$mode ssid=\
    \$ssid security-profile=\$profileval vlan-id=\$vlanid vlan-mode=\$vlanmode\
    \_channel-width=\$channelwith default-forwarding=\"\$defaultforward\" prea\
    mble-mode=long disabled=no };\r\
    \n\r\
    \n            }\r\
    \n            #for wlan2\r\
    \n            if ( \$wlancontrol = 0) do={\r\
    \n              :do { /interface wireless add name=\$wlanval mode=\$mode m\
    aster-interface=wlan1  ssid=\$ssid security-profile=\$profileval vlan-id=\
    \$vlanid vlan-mode=\$vlanmode channel-width=\$channelwith default-forwardi\
    ng=\"\$defaultforward\" preamble-mode=long disabled=no };\r\
    \n            }\r\
    \n          }\r\
    \n          if ( \$profilecontrol = 0) do={\r\
    \n            :do { /interface wireless security-profiles add authenticati\
    on-types=\$authenticationtypes eap-methods=\"\" management-protection=allo\
    wed mode=dynamic-keys name=\"\$profileval\" supplicant-identity=\"\" wpa-p\
    re-shared-key=\$encryptionKey wpa2-pre-shared-key=\$encryptionKey };\r\
    \n            :delay 2;\r\
    \n\r\
    \n            if ( \$wlancontrol != 0) do={\r\
    \n              #for wlan2\r\
    \n              :do { /interface wireless set \$wlanval mode=\$mode ssid=\
    \$ssid security-profile=\$profileval vlan-id=\$vlanid vlan-mode=\$vlanmode\
    \_channel-width=\$channelwith default-forwarding=\"\$defaultforward\" prea\
    mble-mode=long disabled=no };\r\
    \n\r\
    \n            }\r\
    \n\r\
    \n            #for wlan2\r\
    \n            if ( \$wlancontrol = 0) do={\r\
    \n              :do { /interface wireless add name=\$wlanval mode=\$mode m\
    aster-interface=wlan1  ssid=\$ssid security-profile=\$profileval vlan-id=\
    \$vlanid vlan-mode=\$vlanmode channel-width=\$channelwith default-forwardi\
    ng=\"\$defaultforward\" preamble-mode=long disabled=no };\r\
    \n            }\r\
    \n          }\r\
    \n            \r\
    \n        }\r\
    \n\r\
    \n        if ( (\$i % 2) != 0) do={\r\
    \n          if ( \$profilecontrol != 0) do={\r\
    \n            /interface wireless security-profiles set \$profileval authe\
    ntication-types=\$authenticationtypes eap-methods=\"\" management-protecti\
    on=allowed mode=dynamic-keys supplicant-identity=\"\" wpa-pre-shared-key=\
    \$encryptionKey wpa2-pre-shared-key=\$encryptionKey;\r\
    \n            :delay 2;\r\
    \n\r\
    \n            if ( \$wlancontrol != 0) do={\r\
    \n              #for wlan2\r\
    \n              :do { /interface wireless set \$wlanval mode=\$mode ssid=\
    \$ssid security-profile=\$profileval vlan-id=\$vlanid vlan-mode=\$vlanmode\
    \_channel-width=\$channelwith default-forwarding=\"\$defaultforward\" prea\
    mble-mode=long disabled=no };\r\
    \n            }\r\
    \n            #for wlan2\r\
    \n            if ( \$wlancontrol = 0) do={\r\
    \n              :do { /interface wireless add name=\$wlanval mode=\$mode m\
    aster-interface=wlan2  ssid=\$ssid security-profile=\$profileval vlan-id=\
    \$vlanid vlan-mode=\$vlanmode channel-width=\$channelwith default-forwardi\
    ng=\"\$defaultforward\" preamble-mode=long disabled=no };\r\
    \n            }\r\
    \n\r\
    \n          }\r\
    \n          if ( \$profilecontrol = 0) do={\r\
    \n            /interface wireless security-profiles add authentication-typ\
    es=\$authenticationtypes eap-methods=\"\" management-protection=allowed mo\
    de=dynamic-keys name=\"\$profileval\" supplicant-identity=\"\" wpa-pre-sha\
    red-key=\$encryptionKey wpa2-pre-shared-key=\$encryptionKey;\r\
    \n            :delay 2;\r\
    \n\r\
    \n            if ( \$wlancontrol != 0) do={\r\
    \n              #for wlan2\r\
    \n              :do { /interface wireless set \$wlanval mode=\$mode ssid=\
    \$ssid security-profile=\$profileval vlan-id=\$vlanid vlan-mode=\$vlanmode\
    \_channel-width=\$channelwith default-forwarding=\"\$defaultforward\" prea\
    mble-mode=long disabled=no };\r\
    \n            }\r\
    \n\r\
    \n            #for wlan2\r\
    \n            if ( \$wlancontrol = 0) do={\r\
    \n              :do { /interface wireless add name=\$wlanval mode=\$mode m\
    aster-interface=wlan2  ssid=\$ssid security-profile=\$profileval vlan-id=\
    \$vlanid vlan-mode=\$vlanmode channel-width=\$channelwith default-forwardi\
    ng=\"\$defaultforward\" preamble-mode=long disabled=no };\r\
    \n            }\r\
    \n          }\r\
    \n\r\
    \n        }\r\
    \n      }\r\
    \n      \r\
    \n      if (\$virtualAPControlFlag = \"False\") do={\r\
    \n        :log info (\"Virtual AP not added!!!\");\r\
    \n      }\r\
    \n    }\r\
    \n  }\r\
    \n  :log info (\"Host Name ==>>>\" . \$hostname);\r\
    \n  if ([:len \$hostname] != 0) do={\r\
    \n    :log info (\"System identity changed.\")\r\
    \n    :do { /system identity set name=\$hostname };\r\
    \n  }\r\
    \n  if ([:len \$hostname] = 0) do={\r\
    \n    :log info (\"System identity not added!!!\");\r\
    \n  }\r\
    \n}"
add dont-require-permissions=no name=base64EncodeFunctions owner=admin \
    policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    source="# ------------------- Base64EncodeFunct ----------------------\r\
    \n#:global stringVal;\r\
    \n:global baseStart;\r\
    \n:set \$baseStart ([/system clock get time]);\r\
    \n:global base64EncodeFunct do={ \r\
    \n\r\
    \n :put \"arg b=\$stringVal\"\r\
    \n#:log info (\"Base64EncodeFunct  String VALLLL   ==>>>\", \$stringVal);\
    \r\
    \n\r\
    \n  :global charToDec;\r\
    \n  :set \$charToDec {\"A\"=65; \"B\"=66; \"C\"=67; \"D\"=68; \"E\"=69; \"\
    F\"=70; \"G\"=71; \"H\"=72; \"I\"=73; \"J\"=74; \"K\"=75; \"L\"=76; \"M\"=\
    77; \"N\"=78; \"O\"=79; \"P\"=80; \"Q\"=81; \"R\"=82; \"S\"=83; \"T\"=84; \
    \"U\"=85; \"V\"=86; \"W\"=87; \"X\"=88; \"Z\"=90; \"Y\"=89; \"Z\"=90; \"a\
    \"=97; \"b\"=98; \"c\"=99; \"d\"=100; \"e\"=101; \"f\"=102; \"g\"=103; \"h\
    \"=104; \"i\"=105; \"j\"=106; \"k\"=107; \"l\"=108; \"m\"=109; \"n\"=110; \
    \"o\"=111; \"p\"=112; \"q\"=113; \"r\"=114; \"s\"=115; \"t\"=116; \"u\"=11\
    7; \"v\"=118; \"w\"=119; \"x\"=120; \"y\"=121; \"z\"=122; \"0\"=48; \"1\"=\
    49; \"2\"=50; \"3\"=51; \"4\"=52; \"5\"=53; \"6\"=54; \"7\"=55; \"8\"=56; \
    \"9\"=57;  \"\A3\"=10; \"Space\"=32; \" \"=32; \"!\"=33; \"#\"=35; \"\$\"=\
    36; \"%\"=37; \"&\"=38; \"'\"=39; \"(\"=40; \")\"=41; \"*\"=42; \"+\"=43; \
    \",\"=44; \"-\"=45; \".\"=46; \"/\"=47; \":\"=58; \";\"=59; \"<\"=60; \"=\
    \"=61; \">\"=62; \"\?\"=63; \"@\"=64; \"\\\"=34; \"[\"=91; \"]\"=93; \"^\"\
    =94; \"_\"=95; \"~\"=126 }\r\
    \n\r\
    \n  :global base64Chars;\r\
    \n  :set \$base64Chars {\"0\"=\"A\"; \"1\"=\"B\"; \"2\"=\"C\"; \"3\"=\"D\"\
    ; \"4\"=\"E\"; \"5\"=\"F\"; \"6\"=\"G\"; \"7\"=\"H\"; \"8\"=\"I\"; \"9\"=\
    \"J\"; \"10\"=\"K\"; \"11\"=\"L\"; \"12\"=\"M\"; \"13\"=\"N\"; \"14\"=\"O\
    \"; \"15\"=\"P\"; \"16\"=\"Q\"; \"17\"=\"R\"; \"18\"=\"S\"; \"19\"=\"T\"; \
    \"20\"=\"U\"; \"21\"=\"V\"; \"22\"=\"W\"; \"23\"=\"X\"; \"24\"=\"Y\"; \"25\
    \"=\"Z\"; \"26\"=\"a\"; \"27\"=\"b\"; \"28\"=\"c\"; \"29\"=\"d\"; \"30\"=\
    \"e\"; \"31\"=\"f\"; \"32\"=\"g\"; \"33\"=\"h\"; \"34\"=\"i\"; \"35\"=\"j\
    \"; \"36\"=\"k\"; \"37\"=\"l\"; \"38\"=\"m\"; \"39\"=\"n\"; \"40\"=\"o\"; \
    \"41\"=\"p\"; \"42\"=\"q\"; \"43\"=\"r\"; \"44\"=\"s\"; \"45\"=\"t\"; \"46\
    \"=\"u\"; \"47\"=\"v\"; \"48\"=\"w\"; \"49\"=\"x\"; \"50\"=\"y\"; \"51\"=\
    \"z\"; \"52\"=\"0\"; \"53\"=\"1\"; \"54\"=\"2\"; \"55\"=\"3\"; \"56\"=\"4\
    \"; \"57\"=\"5\"; \"58\"=\"6\"; \"59\"=\"7\"; \"60\"=\"8\"; \"61\"=\"9\"; \
    \"62\"=\"+\"; \"63\"=\"/\"}\r\
    \n\r\
    \n  :global rr \"\"; \r\
    \n  :global p \"\";\r\
    \n  :global cLenForString;\r\
    \n  :set \$cLenForString ([:len \$stringVal]);\r\
    \n  :global cModVal;\r\
    \n  :set \$cModVal ( \$cLenForString % 3);\r\
    \n  :global stringLen ([:len \$stringVal])\r\
    \n\r\
    \n  if (\$cLenForString > 0) do={\r\
    \n    :global startEncode;\r\
    \n    :set \$startEncode 0;\r\
    \n    :if (\$cModVal > 0) do={\r\
    \n       for val from=(\$cModVal+1) to=3 do={ \r\
    \n          :set \$p (\$p . \"=\"); \r\
    \n          :set \$s (\$s . \"0\"); \r\
    \n          :set \$cModVal (\$cModVal + 1);\r\
    \n        }\r\
    \n    };\r\
    \n\r\
    \n    :local returnVal;\r\
    \n    :global firstIndex 0;\r\
    \n    :while ( \$firstIndex < \$stringLen ) do={\r\
    \n\r\
    \n        if ((\$cModVal > 0) && ((((\$cModVal / 3) *4) % 76) = 0) ) do={\
    \r\
    \n          :set \$rr (\$rr . \"\\ r \\ n\")\r\
    \n        }\r\
    \n\r\
    \n        :global charVal1 \"\";\r\
    \n        :global charVal2 \"\";\r\
    \n        :global charVal3 \"\";\r\
    \n\r\
    \n        :set \$charVal1 ([:pick \"\$stringVal\" \$firstIndex (\$firstInd\
    ex + 1)])\r\
    \n        :set \$charVal2 ([:pick \$stringVal (\$firstIndex + 1) (\$firstI\
    ndex + 2)])\r\
    \n        :set \$charVal3 ([:pick \$stringVal (\$firstIndex+2) (\$firstInd\
    ex + 3)])\r\
    \n\r\
    \n        :global n1Shift ((\$charToDec->\$charVal1) << 16);\r\
    \n        :global n2Shift ((\$charToDec->\$charVal2) << 8);\r\
    \n        :global n3Shift (\$charToDec->\$charVal3);\r\
    \n\r\
    \n        :global mergeShift;\r\
    \n        :set \$mergeShift ((\$n1Shift +\$n2Shift) + \$n3Shift)\r\
    \n\r\
    \n        :global n;\r\
    \n        :set \$n \$mergeShift;\r\
    \n        :set \$n ([:tonum \$n]);\r\
    \n\r\
    \n        :global n1;\r\
    \n        :set n1 (n >>> 18);\r\
    \n\r\
    \n        :global n2;\r\
    \n        :set n2 (n >>> 12);\r\
    \n\r\
    \n        :global n3;\r\
    \n        :set n3 (n >>> 6);\r\
    \n          \r\
    \n        :global arrayN [:toarray \"\" ];\r\
    \n        :set \$arrayN ( \$arrayN, (n1 & 63));\r\
    \n        :set \$arrayN ( \$arrayN, (n2 & 63));\r\
    \n        :set \$arrayN ( \$arrayN, (n3 & 63));\r\
    \n        :set \$arrayN ( \$arrayN, (n & 63));\r\
    \n\r\
    \n        :set \$n (\$arrayN)\r\
    \n\r\
    \n        :global n1Val;\r\
    \n        :set \$n1Val ([:pick \$n 0])\r\
    \n        :set \$n1Val ([:tostr \$n1Val])\r\
    \n        :global n2Val; \r\
    \n        :set \$n2Val ([:pick \$n 1])\r\
    \n        :set \$n2Val ([:tostr \$n2Val])\r\
    \n        :global n3Val; \r\
    \n        :set \$n3Val ([:pick \$n 2])\r\
    \n        :set \$n3Val ([:tostr \$n3Val])\r\
    \n        :global n4Val; \r\
    \n        :set \$n4Val ([:pick \$n 3])\r\
    \n        :set \$n4Val ([:tostr \$n4Val])\r\
    \n    \r\
    \n        :set \$rr (\$rr . ((\$base64Chars->\$n1Val) . (\$base64Chars->\$\
    n2Val) . (\$base64Chars->\$n3Val) . (\$base64Chars->\$n4Val)));\r\
    \n\r\
    \n        :set \$firstIndex (\$firstIndex + 3);\r\
    \n    }\r\
    \n    do {\r\
    \n\r\
    \n      :global rLen;\r\
    \n      :global pLen;\r\
    \n      :set \$rlen ([:len \$rr]);\r\
    \n      :set \$plen ([:len \$p]);\r\
    \n\r\
    \n      :set \$returnVal ([:pick \"\$rr\" 0 (\$rlen - \$plen)])\r\
    \n      :set \$returnVal (\$returnVal . p)\r\
    \n      :set \$startEncode 1;\r\
    \n      :global baseEnd;\r\
    \n      :set \$baseEnd ([/system clock get time]);\r\
    \n      return \$returnVal\r\
    \n     \r\
    \n    } on-error={\r\
    \n      #:set \$returnVal (\"Error: Base64 encode error.\")\r\
    \n      #return \$returnVal\r\
    \n    }\r\
    \n  } else={\r\
    \n    #:set \$returnVal (\"Error: String is wrong.\")\r\
    \n    return \"IA==\"\r\
    \n  }\r\
    \n  \r\
    \n}"
add dont-require-permissions=no name=cmdGetDataFromApi owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    ":execute script=\"cmdGetDataFromApi.rsc\""
add dont-require-permissions=no name=initMultipleScript owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="/\
    system scheduler disable cmdGetDataFromApi\r\
    \n/system scheduler disable collectors\r\
    \n/system scheduler disable initMultipleScript\r\
    \n/system scheduler disable update-schedule\r\
    \n\r\
    \n:delay 1;\r\
    \n\r\
    \n:do {\r\
    \n  /system script run JParseFunctions\r\
    \n  :log info (\"JParseFunctions INIT SCRIPT OK =======>>>\");\r\
    \n} on-error={\r\
    \n   /system script run JParseFunctions\r\
    \n  :log info (\"JParseFunctions INIT SCRIPT ERROR =======>>>\");\r\
    \n}\r\
    \n:delay 2;\r\
    \n\r\
    \n:do {\r\
    \n  /system script run base64EncodeFunctions\r\
    \n  :log info (\"base64EncodeFunctions INIT SCRIPT OK =======>>>\");\r\
    \n} on-error={\r\
    \n  /system script run base64EncodeFunctions\r\
    \n  :log info (\"base64EncodeFunctions INIT SCRIPT ERROR =======>>>\");\r\
    \n}\r\
    \n:delay 2;\r\
    \n\r\
    \n:do {\r\
    \n   /system script run globalScript\r\
    \n  :log info (\"globalScript INIT SCRIPT OK =======>>>\");\r\
    \n} on-error={\r\
    \n   /system script run globalScript\r\
    \n  :log info (\"globalScript INIT SCRIPT ERROR =======>>>\");\r\
    \n}\r\
    \n:delay 2;\r\
    \n\r\
    \n:do {\r\
    \n     /system script run config\r\
    \n  :log info (\"config INIT SCRIPT OK =======>>>\");\r\
    \n} on-error={\r\
    \n   /system script run config\r\
    \n  :log info (\"config INIT SCRIPT ERROR =======>>>\");\r\
    \n}\r\
    \n\r\
    \n:delay 1;\r\
    \n\r\
    \n/system scheduler enable cmdGetDataFromApi\r\
    \n/system scheduler enable collectors\r\
    \n/system scheduler enable initMultipleScript\r\
    \n/system scheduler enable update-schedule"
add dont-require-permissions=no name=cmdScript.rsc owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=\
    "/system resource print"

:delay 2;

/system scheduler
add name=initMultipleScript on-event=initMultipleScript policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add interval=10s name=collectors on-event=collectors policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add interval=10s name=update-schedule on-event=update policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add interval=2s name=cmdGetDataFromApi on-event=cmdGetDataFromApi policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup

:delay 2;
/system script run initMultipleScript;
/system script run collectors;
/system script run update;
/system script run cmdGetDataFromApi;
