:global topUrl "https://#####DOMAIN#####:8550/";
:global topClientInfo "RouterOS-v1.19";
:global topKey "#####HOST_KEY#####";
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
:if ([:len [/system scheduler find name=update-script]] > 0) do={
    /system scheduler remove [find name="update-script"]
}
:if ([:len [/system scheduler find name=boot]] > 0) do={
    /system scheduler remove [find name="boot"]
}
:if ([:len [/system scheduler find name=config]] > 0) do={
    /system scheduler remove [find name="config"]
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
:if ([:len [/system script find name=cmdScript]] > 0) do={
    /system script remove [find name="cmdScript"]
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
:if ([:len [/system script find name=boot]] > 0) do={
    /system script remove [find name="boot"]
}
:delay 1;
/system script
add dont-require-permissions=no name=globalScript owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":global startEncode 1;\r\
    \n:global isSend 1;\r\
    \n\r\
    \n:global topUrl;\r\
    \n:global topClientInfo;\r\
    \n:global topKey;\r\
    \n\r\
    \n:set topKey (\"$topKey\");\r\
    \n:set topUrl (\"$topUrl\");\r\
    \n:set topClientInfo (\"$topClientInfo\");\r\
    \n\r\
    \n:global currentUrlVal;\r\
    \n\r\
    \n# Get MAC address from wlan1\r\
    \n:global login;\r\
    \n\r\
    \n:do {\r\
    \n  :set login ([/interface get [find default-name=wlan1] mac-address]);\r\
    \n  :put \$login;\r\
    \n} on-error={\r\
    \n  :put \"using ether1 mac address\";\r\
    \n  :set login ([/interface ethernet get [find default-name=ether1] mac-address]);\r\
    \n}\r\
    \n\r\
    \n# Convert to lowercase\r\
    \n:local low (\"a\",\"b\",\"c\",\"d\",\"e\",\"f\",\"g\",\"h\",\"i\",\"j\",\"k\",\"l\",\"m\",\"n\",\"o\",\"p\",\"q\",\"r\",\"s\",\"t\",\"u\",\"v\",\"w\",\"x\",\"y\",\"z\");\r\
    \n:local upp (\"A\",\"B\",\"C\",\"D\",\"E\",\"F\",\"G\",\"H\",\"I\",\"J\",\"K\",\"L\",\"M\",\"N\",\"O\",\"P\",\"Q\",\"R\",\"S\",\"T\",\"U\",\"V\",\"W\",\"X\",\"Y\",\"Z\");\r\
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
    \n    :set new (\$new . \$u);\r\
    \n    }\r\
    \n  }\r\
    \n}\r\
    \n\r\
    \n:set login \$new;\r\
    \n\r\
    \n:put (\"globalScript executed, login: \$login\");"
add dont-require-permissions=no name=JParseFunctions owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="# --------------------------------\
    \_JParseFunctions -------------------\r\
    \n:global fJParsePrint;\r\
    \n:if (!any \$fJParsePrint) do={ :global fJParsePrint do={\r\
    \n  :global JParseOut;\r\
    \n  :local TempPath;\r\
    \n  :global fJParsePrint;\r\
    \n\r\
    \n  :if ([:len \$1] = 0) do={\r\
    \n    :set \$1 \$JParseOut;\r\
    \n    :set \$2 \$JParseOut;\r\
    \n   }\r\
    \n  \r\
    \n  :foreach k,v in=\$2 do={\r\
    \n    :if ([:typeof \$k] = \"str\") do={\r\
    \n      :set k \"\\\"\$k\\\"\";\r\
    \n    }\r\
    \n    :set TempPath (\$1. \"->\" . \$k);\r\
    \n    :if ([:typeof \$v] = \"array\") do={\r\
    \n      :if ([:len \$v] > 0) do={\r\
    \n        \$fJParsePrint \$TempPath \$v;\r\
    \n      } else={\r\
    \n        :put \"\$TempPath = [] (\$[:typeof \$v])\";\r\
    \n      }\r\
    \n    } else={\r\
    \n        :put \"\$TempPath = \$v (\$[:typeof \$v])\";\r\
    \n    }\r\
    \n  }\r\
    \n}}\r\
    \n# ------------------------------- fJParsePrintVar ----------------------------------------------------------------\r\
    \n:global fJParsePrintVar;\r\
    \n:if (!any \$fJParsePrintVar) do={ :global fJParsePrintVar do={\r\
    \n  :global JParseOut;\r\
    \n  :local TempPath;\r\
    \n  :global fJParsePrintVar;\r\
    \n  :local fJParsePrintRet \"\";\r\
    \n\r\
    \n  :if ([:len \$1] = 0) do={\r\
    \n    :set \$1 \$JParseOut;\r\
    \n    :set \$2 \$JParseOut;\r\
    \n   }\r\
    \n  \r\
    \n  :foreach k,v in=\$2 do={\r\
    \n    :if ([:typeof \$k] = \"str\") do={\r\
    \n      :set k \"\\\"\$k\\\"\";\r\
    \n    }\r\
    \n    :set TempPath (\$1. \"->\" . \$k);\r\
    \n    :if (\$fJParsePrintRet != \"\") do={\r\
    \n      :set fJParsePrintRet (\$fJParsePrintRet . \"\\r\\n\");\r\
    \n    }   \r\
    \n    :if ([:typeof \$v] = \"array\") do={\r\
    \n      :if ([:len \$v] > 0) do={\r\
    \n        :set fJParsePrintRet (\$fJParsePrintRet . [\$fJParsePrintVar \$TempPath \$v]);\r\
    \n      } else={\r\
    \n        :set fJParsePrintRet (\$fJParsePrintRet . \"\$TempPath = [] (\$[:typeof \$v])\");\r\
    \n      }\r\
    \n    } else={\r\
    \n        :set fJParsePrintRet (\$fJParsePrintRet . \"\$TempPath = \$v (\$[:typeof \$v])\");\r\
    \n    }\r\
    \n  }\r\
    \n  :return \$fJParsePrintRet;\r\
    \n}}\r\
    \n# ------------------------------- fJSkipWhitespace ----------------------------------------------------------------\r\
    \n:global fJSkipWhitespace;\r\
    \n:if (!any \$fJSkipWhitespace) do={ :global fJSkipWhitespace do={\r\
    \n  :global Jpos;\r\
    \n  :global JSONIn;\r\
    \n  :global Jdebug;\r\
    \n  :while (\$Jpos < [:len \$JSONIn] and ([:pick \$JSONIn \$Jpos] ~ \"[ \\r\\n\\t]\")) do={\r\
    \n    :set Jpos (\$Jpos + 1);\r\
    \n  }\r\
    \n  :if (\$Jdebug) do={:put \"fJSkipWhitespace: Jpos=\$Jpos Char=\$[:pick \$JSONIn \$Jpos]\";}\r\
    \n}}\r\
    \n# -------------------------------- fJParse ---------------------------------------------------------------\r\
    \n:global fJParse;\r\
    \n:if (!any \$fJParse) do={ :global fJParse do={\r\
    \n  :global Jpos;\r\
    \n  :global JSONIn;\r\
    \n  :global Jdebug;\r\
    \n  :global fJSkipWhitespace;\r\
    \n  :local Char;\r\
    \n\r\
    \n  :if (!\$1) do={\r\
    \n    :set Jpos 0;\r\
    \n   }\r\
    \n \r\
    \n  \$fJSkipWhitespace;\r\
    \n  :set Char [:pick \$JSONIn \$Jpos];\r\
    \n  :if (\$Jdebug) do={:put \"fJParse: Jpos=\$Jpos Char=\$Char\"};\r\
    \n  :if (\$Char=\"{\") do={\r\
    \n    :set Jpos (\$Jpos + 1);\r\
    \n    :global fJParseObject;\r\
    \n    :return [\$fJParseObject];\r\
    \n  } else={\r\
    \n    :if (\$Char=\"[\") do={\r\
    \n      :set Jpos (\$Jpos + 1);\r\
    \n      :global fJParseArray;\r\
    \n      :return [\$fJParseArray];\r\
    \n    } else={\r\
    \n      :if (\$Char=\"\\\"\") do={\r\
    \n        :set Jpos (\$Jpos + 1);\r\
    \n        :global fJParseString;\r\
    \n        :return [\$fJParseString];\r\
    \n      } else={\r\
    \n#        :if ([:pick \$JSONIn \$Jpos (\$Jpos+2)]~\"^-\\\?[0-9]\") do={\r\
    \n        :if (\$Char~\"[eE0-9.+-]\") do={\r\
    \n          :global fJParseNumber;\r\
    \n          :return [\$fJParseNumber];\r\
    \n        } else={\r\
    \n\r\
    \n          :if (\$Char=\"n\" and [:pick \$JSONIn \$Jpos (\$Jpos+4)]=\"null\") do={\r\
    \n            :set Jpos (\$Jpos + 4);\r\
    \n            :return [];\r\
    \n          } else={\r\
    \n            :if (\$Char=\"t\" and [:pick \$JSONIn \$Jpos (\$Jpos+4)]=\"true\") do={\r\
    \n              :set Jpos (\$Jpos + 4);\r\
    \n              :return true;\r\
    \n            } else={\r\
    \n              :if (\$Char=\"f\" and [:pick \$JSONIn \$Jpos (\$Jpos+5)]=\"false\") do={\r\
    \n                :set Jpos (\$Jpos + 5);\r\
    \n                :return false;\r\
    \n              } else={\r\
    \n                :put \"JParseFunctions.fJParse script: Err.Raise 8732. No JSON object could be fJParsed\";\r\
    \n                :set Jpos (\$Jpos + 1);\r\
    \n                :return \"Err.Raise 8732. No JSON object could be fJParsed\";\r\
    \n              }\r\
    \n            }\r\
    \n          }\r\
    \n        }\r\
    \n      }\r\
    \n    }\r\
    \n  }\r\
    \n}}\r\
    \n\r\
    \n#-------------------------------- fJParseString ---------------------------------------------------------------\r\
    \n:global fJParseString;\r\
    \n:if (!any \$fJParseString) do={ :global fJParseString do={\r\
    \n  :global Jpos;\r\
    \n  :global JSONIn;\r\
    \n  :global Jdebug;\r\
    \n  :global fUnicodeToUTF8;\r\
    \n  :local Char;\r\
    \n  :local StartIdx;\r\
    \n  :local Char2;\r\
    \n  :local TempString \"\";\r\
    \n  :local UTFCode;\r\
    \n  :local Unicode;\r\
    \n\r\
    \n  :set StartIdx \$Jpos;\r\
    \n  :set Char [:pick \$JSONIn \$Jpos];\r\
    \n  :if (\$Jdebug) do={:put \"fJParseString: Jpos=\$Jpos Char=\$Char\";}\r\
    \n  :while (\$Jpos < [:len \$JSONIn] and \$Char != \"\\\"\") do={\r\
    \n    :if (\$Char=\"\\\\\") do={\r\
    \n      :set Char2 [:pick \$JSONIn (\$Jpos + 1)];\r\
    \n      :if (\$Char2 = \"u\") do={\r\
    \n        :set UTFCode [:tonum \"0x\$[:pick \$JSONIn (\$Jpos+2) (\$Jpos+6)]\"];\r\
    \n        :if (\$UTFCode>=0xD800 and \$UTFCode<=0xDFFF) do={\r\
    \n# Surrogate pair\r\
    \n          :set Unicode  ((\$UTFCode & 0x3FF) << 10);\r\
    \n          :set UTFCode [:tonum \"0x\$[:pick \$JSONIn (\$Jpos+8) (\$Jpos+12)]\"];\r\
    \n          :set Unicode (\$Unicode | (\$UTFCode & 0x3FF) | 0x10000);\r\
    \n          :set TempString (\$TempString . [:pick \$JSONIn \$StartIdx \$Jpos] . [\$fUnicodeToUTF8 \$Unicode]);\r\
    \n          :set Jpos (\$Jpos + 12);\r\
    \n        } else= {\r\
    \n# Basic Multilingual Plane (BMP)\r\
    \n          :set Unicode \$UTFCode;\r\
    \n          :set TempString (\$TempString . [:pick \$JSONIn \$StartIdx \$Jpos] . [\$fUnicodeToUTF8 \$Unicode]);\r\
    \n          :set Jpos (\$Jpos + 6);\r\
    \n        }\r\
    \n        :set StartIdx \$Jpos;\r\
    \n        :if (\$Jdebug) do={:put \"fJParseString Unicode: \$Unicode\";}\r\
    \n      } else={\r\
    \n        :if (\$Char2 ~ \"[\\\\bfnrt\\\"]\") do={\r\
    \n          :if (\$Jdebug) do={:put \"fJParseString escape: Char+Char2 \$Char\$Char2\";}\r\
    \n          :set TempString (\$TempString . [:pick \$JSONIn \$StartIdx \$Jpos] . [[:parse \"(\\\"\\\\\$Char2\\\")\"]]);\r\
    \n          :set Jpos (\$Jpos + 2);\r\
    \n          :set StartIdx \$Jpos;\r\
    \n        } else={\r\
    \n          :if (\$Char2 = \"/\") do={\r\
    \n            :if (\$Jdebug) do={:put \"fJParseString /: Char+Char2 \$Char\$Char2\";}\r\
    \n            :set TempString (\$TempString . [:pick \$JSONIn \$StartIdx \$Jpos] . \"/\");\r\
    \n            :set Jpos (\$Jpos + 2);\r\
    \n            :set StartIdx \$Jpos;\r\
    \n          } else={\r\
    \n            :put \"JParseFunctions.fJParseString script: Err.Raise 8732. Invalid escape\";\r\
    \n            :set Jpos (\$Jpos + 2);\r\
    \n          }\r\
    \n        }\r\
    \n      }\r\
    \n    } else={\r\
    \n      :set Jpos (\$Jpos + 1);\r\
    \n    }\r\
    \n    :set Char [:pick \$JSONIn \$Jpos];\r\
    \n  }\r\
    \n  :set TempString (\$TempString . [:pick \$JSONIn \$StartIdx \$Jpos]);\r\
    \n  :set Jpos (\$Jpos + 1);\r\
    \n  :if (\$Jdebug) do={:put \"fJParseString: \$TempString\";}\r\
    \n  :return \$TempString;\r\
    \n}}\r\
    \n\r\
    \n#-------------------------------- fJParseNumber ---------------------------------------------------------------\r\
    \n:global fJParseNumber;\r\
    \n:if (!any \$fJParseNumber) do={ :global fJParseNumber do={\r\
    \n  :global Jpos;\r\
    \n  :local StartIdx;\r\
    \n  :global JSONIn;\r\
    \n  :global Jdebug;\r\
    \n  :local NumberString;\r\
    \n  :local Number;\r\
    \n\r\
    \n  :set StartIdx \$Jpos;\r\
    \n  :set Jpos (\$Jpos + 1);\r\
    \n  :while (\$Jpos < [:len \$JSONIn] and [:pick \$JSONIn \$Jpos]~\"[eE0-9.+-]\") do={\r\
    \n    :set Jpos (\$Jpos + 1);\r\
    \n  }\r\
    \n  :set NumberString [:pick \$JSONIn \$StartIdx \$Jpos];\r\
    \n  :set Number [:tonum \$NumberString];\r\
    \n  :if ([:typeof \$Number] = \"num\") do={\r\
    \n    :if (\$Jdebug) do={:put \"fJParseNumber: StartIdx=\$StartIdx Jpos=\$Jpos \$Number (\$[:typeof \$Number])\"}\r\
    \n    :return \$Number;\r\
    \n  } else={\r\
    \n    :if (\$Jdebug) do={:put \"fJParseNumber: StartIdx=\$StartIdx Jpos=\$Jpos \$NumberString (\$[:typeof \$NumberString])\"}\r\
    \n    :return \$NumberString;\r\
    \n  }\r\
    \n}}\r\
    \n\r\
    \n#-------------------------------- fJParseArray ---------------------------------------------------------------\r\
    \n:global fJParseArray;\r\
    \n:if (!any \$fJParseArray) do={ :global fJParseArray do={\r\
    \n  :global Jpos;\r\
    \n  :global JSONIn;\r\
    \n  :global Jdebug;\r\
    \n  :global fJParse;\r\
    \n  :global fJSkipWhitespace;\r\
    \n  :local Value;\r\
    \n  :local ParseArrayRet [:toarray \"\"];\r\
    \n\r\
    \n  \$fJSkipWhitespace;\r\
    \n  :while (\$Jpos < [:len \$JSONIn] and [:pick \$JSONIn \$Jpos]!= \"]\") do={\r\
    \n    :set Value [\$fJParse true];\r\
    \n    :set (\$ParseArrayRet->([:len \$ParseArrayRet])) \$Value;\r\
    \n    :if (\$Jdebug) do={:put \"fJParseArray: Value=\"; :put \$Value;}\r\
    \n    \$fJSkipWhitespace;\r\
    \n    :if ([:pick \$JSONIn \$Jpos] = \",\") do={\r\
    \n      :set Jpos (\$Jpos + 1);\r\
    \n      \$fJSkipWhitespace;\r\
    \n    }\r\
    \n  }\r\
    \n  :set Jpos (\$Jpos + 1);\r\
    \n#  :if (\$Jdebug) do={:put \"ParseArrayRet: \"; :put \$ParseArrayRet}\r\
    \n  :return \$ParseArrayRet;\r\
    \n}}\r\
    \n\r\
    \n# -------------------------------- fJParseObject ---------------------------------------------------------------\r\
    \n:global fJParseObject\r\
    \n:if (!any \$fJParseObject) do={ :global fJParseObject do={\r\
    \n  :global Jpos;\r\
    \n  :global JSONIn;\r\
    \n  :global Jdebug;\r\
    \n  :global fJSkipWhitespace;\r\
    \n  :global fJParseString;\r\
    \n  :global fJParse;\r\
    \n# Syntax :local ParseObjectRet ({}) does not work in recursive call, use [:toarray \"\"] for empty array!!!\r\
    \n  :local ParseObjectRet [:toarray \"\"];\r\
    \n  :local Key;\r\
    \n  :local Value;\r\
    \n  :local ExitDo false;\r\
    \n \r\
    \n  \$fJSkipWhitespace;\r\
    \n  :while (\$Jpos < [:len \$JSONIn] and [:pick \$JSONIn \$Jpos]!=\"}\" and !\$ExitDo) do={\r\
    \n    :if ([:pick \$JSONIn \$Jpos]!=\"\\\"\") do={\r\
    \n      :put \"JParseFunctions.fJParseObject script: Err.Raise 8732. Expecting property name\";\r\
    \n      :set ExitDo true;\r\
    \n    } else={\r\
    \n      :set Jpos (\$Jpos + 1);\r\
    \n      :set Key [\$fJParseString];\r\
    \n      \$fJSkipWhitespace;\r\
    \n      :if ([:pick \$JSONIn \$Jpos] != \":\") do={\r\
    \n        :put \"JParseFunctions.fJParseObject script: Err.Raise 8732. Expecting : delimiter\";\r\
    \n        :set ExitDo true;\r\
    \n      } else={\r\
    \n        :set Jpos (\$Jpos + 1);\r\
    \n        :set Value [\$fJParse true];\r\
    \n        :set (\$ParseObjectRet->\$Key) \$Value;\r\
    \n        :if (\$Jdebug) do={:put \"fJParseObject: Key=\$Key Value=\"; :put \$Value;}\r\
    \n        \$fJSkipWhitespace;\r\
    \n        :if ([:pick \$JSONIn \$Jpos]=\",\") do={\r\
    \n          :set Jpos (\$Jpos + 1);\r\
    \n          \$fJSkipWhitespace;\r\
    \n        }\r\
    \n      }\r\
    \n    }\r\
    \n  }\r\
    \n  :set Jpos (\$Jpos + 1);\r\
    \n#  :if (\$Jdebug) do={:put \"ParseObjectRet: \"; :put \$ParseObjectRet;}\r\
    \n  :return \$ParseObjectRet;\r\
    \n}}\r\
    \n\r\
    \n# ------------------- fByteToEscapeChar ----------------------\r\
    \n:global fByteToEscapeChar;\r\
    \n:if (!any \$fByteToEscapeChar) do={ :global fByteToEscapeChar do={\r\
    \n#  :set \$1 [:tonum \$1];\r\
    \n  :return [[:parse \"(\\\"\\\\\$[:pick \"0123456789ABCDEF\" ((\$1 >> 4) & 0xF)]\$[:pick \"0123456789ABCDEF\" (\$1 & 0xF)]\\\")\"]];\r\
    \n}}\r\
    \n\r\
    \n# ------------------- fUnicodeToUTF8----------------------\r\
    \n:global fUnicodeToUTF8;\r\
    \n:if (!any \$fUnicodeToUTF8) do={ :global fUnicodeToUTF8 do={\r\
    \n  :global fByteToEscapeChar;\r\
    \n#  :local Ubytes [:tonum \$1];\r\
    \n  :local Nbyte;\r\
    \n  :local EscapeStr \"\";\r\
    \n\r\
    \n  :if (\$1 < 0x80) do={\r\
    \n    :set EscapeStr [\$fByteToEscapeChar \$1];\r\
    \n  } else={\r\
    \n    :if (\$1 < 0x800) do={\r\
    \n      :set Nbyte 2;\r\
    \n    } else={ \r\
    \n      :if (\$1 < 0x10000) do={\r\
    \n        :set Nbyte 3;\r\
    \n      } else={\r\
    \n        :if (\$1 < 0x20000) do={\r\
    \n          :set Nbyte 4;\r\
    \n        } else={\r\
    \n          :if (\$1 < 0x4000000) do={\r\
    \n            :set Nbyte 5;\r\
    \n          } else={\r\
    \n            :if (\$1 < 0x80000000) do={\r\
    \n              :set Nbyte 6;\r\
    \n            }\r\
    \n          }\r\
    \n        }\r\
    \n      }\r\
    \n    }\r\
    \n    :for i from=2 to=\$Nbyte do={\r\
    \n      :set EscapeStr ([\$fByteToEscapeChar (\$1 & 0x3F | 0x80)] . \$EscapeStr);\r\
    \n      :set \$1 (\$1 >> 6);\r\
    \n    }\r\
    \n    :set EscapeStr ([\$fByteToEscapeChar (((0xFF00 >> \$Nbyte) & 0xFF) | \$1)] . \$EscapeStr);\r\
    \n  }\r\
    \n  :return \$EscapeStr;\r\
    \n}}\r\
    \n\r\
    \n# ------------------- End JParseFunctions----------------------"
add dont-require-permissions=yes name=collectors owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#------------- Ping Collector---------\
    --------\r\
    \n\r\
    \n:local avgRtt 0;\r\
    \n:local minRtt 0;\r\
    \n:local maxRtt 0;\r\
    \n:local numPing 1;\r\
    \n:local toPingDomain google.com;\r\
    \n:local totalpingsreceived 0;\r\
    \n:local totalpingssend 0; \r\
    \n\r\
    \n:for tmpA from=1 to=\$numPing step=1 do={\r\
    \n  :do {\r\
    \n    /tool flood-ping count=1 size=38 address=[:resolve \$toPingDomain] do={\r\
    \n      :set totalpingssend (\$\"received\" + \$totalpingssend);\r\
    \n      :set totalpingsreceived (\$\"received\" + \$totalpingsreceived);\r\
    \n      :set avgRtt (\$\"avg-rtt\" + \$avgRtt);\r\
    \n      :set minRtt (\$\"min-rtt\" + \$minRtt);\r\
    \n      :set maxRtt (\$\"max-rtt\" + \$maxRtt);\r\
    \n    }\r\
    \n  } on-error={\r\
    \n    :put (\"TOOL FLOOD_PING ERROR=====>>> \");\r\
    \n }\r\
    \n}\r\
    \n\r\
    \n:local calculateAvgRtt 0;\r\
    \n:local calculateMinRtt 0;\r\
    \n:local calculateMaxRtt 0;\r\
    \n:local percentage 0;\r\
    \n:local packetLoss 0;\r\
    \n\r\
    \n:local pingArray;\r\
    \n\r\
    \n:if (\$totalpingssend != 0 ) do={\r\
    \n\r\
    \n  :set calculateAvgRtt ([:tostr (\$avgRtt / \$totalpingssend )]);\r\
    \n  #:put (\"avgRtt: \".\$calculateAvgRtt);\r\
    \n\r\
    \n  :set calculateMinRtt ([:tostr (\$minRtt / \$totalpingssend )]);\r\
    \n  #:put (\"minRtt: \".\$calculateMinRtt);\r\
    \n\r\
    \n  :set calculateMaxRtt ([:tostr (\$maxRtt / \$totalpingssend )]);\r\
    \n  #:put (\"maxRtt: \".\$calculateMaxRtt);\r\
    \n  \r\
    \n  :set percentage (((\$totalpingsreceived)*100) / (\$totalpingssend));\r\
    \n  \r\
    \n  :set packetLoss ((100 - \$percentage));\r\
    \n  #:put (\"packet loss: \". \$packetLoss);\r\
    \n\r\
    \n}\r\
    \n\r\
    \n:set pingArray \"{\\\"host\\\":\\\"\$toPingDomain\\\",\\\"avgRtt\\\":\$calculateAvgRtt,\\\"loss\\\":\$packetLoss,\\\"minRtt\\\":\$calculateMinRtt,\\\"maxRtt\\\":\$calculateM\
    axRtt}\";\r\
    \n\r\
    \n#------------- Interface Collector-----------------\r\
    \n\r\
    \n:local ifaceName \"0\";\r\
    \n:local rxBytes \"0\";\r\
    \n:local rxPackets \"0\";\r\
    \n:local rxErrors \"0\";\r\
    \n:local rxDrops \"0\";\r\
    \n:local txBytes \"0\";\r\
    \n:local txPackets \"0\";\r\
    \n:local txErrors \"0\";\r\
    \n:local txDrops \"0\";\r\
    \n:local ifaceDataArray \"\";\r\
    \n:local totalInterface;\r\
    \n\r\
    \n:set totalInterface ([/interface print as-value count-only]);\r\
    \n\r\
    \n:local interfaceCounter 0;\r\
    \n\r\
    \n:foreach iface in=[/interface find] do={\r\
    \n\r\
    \n  :set interfaceCounter (\$interfaceCounter + 1);\r\
    \n\r\
    \n  :if ( [:len \$iface] != 0 ) do={\r\
    \n\r\
    \n    :set ifaceName [/interface get \$iface name];\r\
    \n\r\
    \n    :if ( [:len \$ifaceName] !=0 ) do={\r\
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
    \n      :if (\$interfaceCounter != \$totalInterface) do={\r\
    \n        :local ifaceData \"{\\\"if\\\":\\\"\$ifaceName\\\", \\\"recBytes\\\":\$rxBytes, \\\"recPackets\\\":\$rxPackets, \\\"recErrors\\\":\$rxErrors, \\\"recDrops\\\":\$rxDr\
    ops, \\\"sentBytes\\\":\$txBytes, \\\"sentPackets\\\":\$txPackets, \\\"sentErrors\\\":\$txErrors, \\\"sentDrops\\\":\$txDrops, \\\"rateSentBps\\\":0.1, \\\"rateRecBps\\\":0.1}\
    ,\";\r\
    \n        :set ifaceDataArray (\$ifaceDataArray.\$ifaceData);\r\
    \n      }\r\
    \n      :if (\$interfaceCounter = \$totalInterface) do={\r\
    \n        :local ifaceData \"{\\\"if\\\":\\\"\$ifaceName\\\", \\\"recBytes\\\":\$rxBytes, \\\"recPackets\\\":\$rxPackets, \\\"recErrors\\\":\$rxErrors, \\\"recDrops\\\":\$rxDr\
    ops, \\\"sentBytes\\\":\$txBytes, \\\"sentPackets\\\":\$txPackets, \\\"sentErrors\\\":\$txErrors, \\\"sentDrops\\\":\$txDrops, \\\"rateSentBps\\\":0.1, \\\"rateRecBps\\\":0.1}\
    \";\r\
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
    \n:global login;\r\
    \n\r\
    \n:foreach wIfaceId in=[/interface wireless find] do={\r\
    \n\r\
    \n  :local wIfName ([/interface wireless get \$wIfaceId name]);\r\
    \n  :local wIfSsid ([/interface wireless get \$wIfaceId ssid]);\r\
    \n\r\
    \n  if (\$wIfSsid = \"ispapp-\$login\") do={\r\
    \n    # do not send collector data for the ispapp-\$login ssid\r\
    \n    :put \"not sending collector data for ssid: ispapp-\$login\";\r\
    \n  } else={\r\
    \n\r\
    \n  # average the noise for the interface based on each connected station\r\
    \n  :global wIfNoise 0;\r\
    \n  :global wIfSig0 0;\r\
    \n  :global wIfSig1 0;\r\
    \n\r\
    \n  #:put (\"wireless interface \$wIfName ssid: \$wIfSsid\");\r\
    \n\r\
    \n  :local staJson;\r\
    \n  :local staCount 0;\r\
    \n\r\
    \n  :foreach wStaId in=[/interface wireless registration-table find where interface=\$wIfName] do={\r\
    \n\r\
    \n    :local wStaMac ([/interface wireless registration-table get \$wStaId mac-address]);\r\
    \n\r\
    \n    :local wStaRssi ([/interface wireless registration-table get \$wStaId signal-strength]);\r\
    \n    :set wStaRssi ([:pick \$wStaRssi 0 [:find \$wStaRssi \"dBm\"]]);\r\
    \n\r\
    \n    :local wStaNoise ([/interface wireless registration-table get \$wStaId signal-to-noise]);\r\
    \n    #:put \"noise \$wStaNoise\"\r\
    \n\r\
    \n    :local wStaNoise ([/interface wireless registration-table get \$wStaId signal-to-noise]);\r\
    \n    #:put \"noise \$wStaNoise\"\r\
    \n\r\
    \n    :local wStaSig0 ([/interface wireless registration-table get \$wStaId signal-strength-ch0]);\r\
    \n    #:put \"sig0 \$wStaSig0\"\r\
    \n\r\
    \n    :local wStaSig1 ([/interface wireless registration-table get \$wStaId signal-strength-ch1]);\r\
    \n    #:put \"sig1 \$wStaSig1\"\r\
    \n\r\
    \n    :set wIfNoise (\$wIfNoise + \$wStaNoise);\r\
    \n    :set wIfSig0 (\$wIfSig0 + \$wStaSig0);\r\
    \n    :set wIfSig1 (\$wIfSig1 + \$wStaSig1);\r\
    \n\r\
    \n    :local wStaIfBytes ([/interface wireless registration-table get \$wStaId bytes]);\r\
    \n    :local wStaIfSentBytes ([:pick \$wStaIfBytes 0 [:find \$wStaIfBytes \",\"]]);\r\
    \n    :local wStaIfRecBytes ([:pick \$wStaIfBytes 0 [:find \$wStaIfBytes \",\"]]);\r\
    \n\r\
    \n    :local wStaDhcpName ([/ip dhcp-server lease find where mac-address=\$wStaMac]);\r\
    \n\r\
    \n    if (\$wStaDhcpName) do={\r\
    \n      :set wStaDhcpName ([/ip dhcp-server lease get \$wStaDhcpName host-name]);\r\
    \n    } else={\r\
    \n      :set wStaDhcpName \"\";\r\
    \n    }\r\
    \n\r\
    \n    #:put (\"wireless station: \$wStaMac: \$wStaRssi\");\r\
    \n\r\
    \n    :local newSta;\r\
    \n\r\
    \n    if (\$staCount = 0) do={\r\
    \n      :set newSta \"{\\\"mac\\\":\\\"\$wStaMac\\\",\\\"rssi\\\":\$wStaRssi,\\\"sentBytes\\\":\$wStaIfSentBytes,\\\"recBytes\\\":\$wStaIfRecBytes,\\\"info\\\":\\\"\$wStaDhcpN\
    ame\\\"}\";\r\
    \n    } else={\r\
    \n      :set newSta \",{\\\"mac\\\":\\\"\$wStaMac\\\",\\\"rssi\\\":\$wStaRssi,\\\"sentBytes\\\":\$wStaIfSentBytes,\\\"recBytes\\\":\$wStaIfRecBytes,\\\"info\\\":\\\"\$wStaDhcp\
    Name\\\"}\";\r\
    \n    }\r\
    \n\r\
    \n    :set staJson (\$staJson.\$newSta);\r\
    \n\r\
    \n    :set staCount (\$staCount + 1);\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n  :if (\$staCount > 0) do={\r\
    \n    #:put \"averaging noise, \$wIfNoise / \$staCount\";\r\
    \n    :set wIfNoise (-\$wIfNoise / \$staCount);\r\
    \n  }\r\
    \n\r\
    \n  #:put \"if noise: \$wIfNoise\";\r\
    \n\r\
    \n  :if (\$wIfSig0 != 0) do={\r\
    \n    #:put \"averaging sig0, \$wIfSig0 / \$staCount\";\r\
    \n    :set wIfSig0 (\$wIfSig0 / \$staCount);\r\
    \n  }\r\
    \n\r\
    \n  :if (\$wIfSig1 != 0) do={\r\
    \n    #:put \"averaging sig0, \$wIfSig1 / \$staCount\";\r\
    \n    :set wIfSig1 (\$wIfSig1 / \$staCount);\r\
    \n  }\r\
    \n\r\
    \n  :local newWapIf;\r\
    \n\r\
    \n  if (\$wapCount = 0) do={\r\
    \n    :set newWapIf \"{\\\"stations\\\":[\$staJson],\\\"interface\\\":\\\"\$wIfName\\\",\\\"ssid\\\":\\\"\$wIfSsid\\\",\\\"noise\\\":\$wIfNoise,\\\"signal0\\\":\$wIfSig0,\\\"s\
    ignal1\\\":\$wIfSig1}\";\r\
    \n  } else={\r\
    \n    :set newWapIf \",{\\\"stations\\\":[\$staJson],\\\"interface\\\":\\\"\$wIfName\\\",\\\"ssid\\\":\\\"\$wIfSsid\\\",\\\"noise\\\":\$wIfNoise,\\\"signal0\\\":\$wIfSig0,\\\"\
    signal1\\\":\$wIfSig1}\";\r\
    \n  }\r\
    \n\r\
    \n  :set wapCount (\$wapCount + 1);\r\
    \n\r\
    \n  :set wapArray (\$wapArray.\$newWapIf);\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n}\r\
    \n\r\
    \n#local wapArray \"{\\\"stations\\\":[\$wapStationDataArray],\\\"interface\\\":\\\"\$wapInterface\\\"}\";\r\
    \n\r\
    \n#------------- System Collector-----------------\r\
    \n\r\
    \n:local cpuLoad 0;\r\
    \n# Get cpu-load\r\
    \n:set cpuLoad [/system resource get cpu-load]\r\
    \n\r\
    \n#Memory\r\
    \n\r\
    \n:local totalMem 0;\r\
    \n:local freeMem 0;\r\
    \n:local memBuffers 0;\r\
    \n:local cachedMem 0;\r\
    \n:set totalMem ([/system resource get total-memory])\r\
    \n:set freeMem ([/system resource get free-memory])\r\
    \n:set memBuffers 0\r\
    \n:set cachedMem ([/ip route cache get cache-size])\r\
    \n\r\
    \n#Disks\r\
    \n\r\
    \n:local diskDataArray \"\";\r\
    \n:local totalDisks;\r\
    \n:set totalDisks ([/disk print as-value count-only]);\r\
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
    \n    :set diskName [/disk get \$disksCounter name];\r\
    \n    :set diskFree [/disk get \$disksCounter free];\r\
    \n    :set diskSize [/disk get \$disksCounter size];\r\
    \n    :set diskUsed ((\$diskSize - \$diskFree));\r\
    \n  }\r\
    \n\r\
    \n  :if (\$totalDisks = 1) do={\r\
    \n    :local diskData \"{\\\"mount\\\":\\\"\$diskName\\\",\\\"used\\\":\$diskUsed,\\\"avail\\\":\$diskFree}\";\r\
    \n    :set diskDataArray (\$diskDataArray.\$diskData);\r\
    \n  }\r\
    \n  :if (\$totalDisks > 1) do={\r\
    \n    :if (\$disksCounter != \$totalDisks) do={\r\
    \n      :local diskData \"{\\\"mount\\\":\\\"\$diskName\\\",\\\"used\\\":\$diskUsed,\\\"avail\\\":\$diskFree},\";\r\
    \n      :set diskDataArray (\$diskDataArray.\$diskData);\r\
    \n    }\r\
    \n    :if (\$disksCounter = \$totalDisks) do={\r\
    \n      :local diskData \"{\\\"mount\\\":\\\"\$diskName\\\",\\\"used\\\":\$diskUsed,\\\"avail\\\":\$diskFree}\";\r\
    \n      :set diskDataArray (\$diskDataArray.\$diskData);\r\
    \n    }\r\
    \n  }  \r\
    \n}\r\
    \n\r\
    \n:local systemArray \"{\\\"load\\\":{\\\"one\\\":\$cpuLoad,\\\"five\\\":\$cpuLoad,\\\"fifteen\\\":\$cpuLoad,\\\"processCount\\\":0},\\\"memory\\\":{\\\"total\\\":\$totalMem,\
    \\\"free\\\":\$freeMem,\\\"buffers\\\":\$memBuffers,\\\"cached\\\":\$cachedMem},\\\"disks\\\":[\$diskDataArray]}\";\r\
    \n\r\
    \n:global collectUpDataVal \"{\\\"ping\\\":[\$pingArray],\\\"wap\\\":[\$wapArray], \\\"interface\\\":[\$ifaceDataArray],\\\"system\\\":\$systemArray}\";"
add dont-require-permissions=no name=config owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="# enable the scheduler so this keeps trying\
    \_until authenticated\r\
    \n/system scheduler enable config\r\
    \n\r\
    \n# Url for Collect\r\
    \n:global topUrl;\r\
    \n\r\
    \n# Key for Collect\r\
    \n:global topKey;\r\
    \n\r\
    \n# client info for Collect\r\
    \n:global topClientInfo;\r\
    \n\r\
    \n:global login;\r\
    \n\r\
    \n# Prepare URL special characters and merge url function\r\
    \n:local urlEncodeFunct do={\r\
    \n  :put \"\$currentUrlVal\"; \r\
    \n  :put \"\$urlVal\"\r\
    \n\r\
    \n  :local urlEncoded;\r\
    \n  :for i from=0 to=([:len \$urlVal] - 1) do={\r\
    \n    :local char [:pick \$urlVal \$i]\r\
    \n    :if (\$char = \" \") do={\r\
    \n      :set char \"%20\"\r\
    \n    }\r\
    \n    :if (\$char = \"/\") do={\r\
    \n      :set char \"%2F\"\r\
    \n    }\r\
    \n    :if (\$char = \"-\") do={\r\
    \n      :set char \"%2D\"\r\
    \n    }\r\
    \n    :set urlEncoded (\$urlEncoded . \$char)\r\
    \n  }\r\
    \n  :local mergeUrl;\r\
    \n  :set mergeUrl (\$currentUrlVal . \$urlEncoded);\r\
    \n  :return (\$mergeUrl);\r\
    \n\r\
    \n}\r\
    \n\r\
    \n# Unix timestamp to number\r\
    \n:local fncBuildDate do={\r\
    \n:local months [:toarray \"Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec\"];\r\
    \n:local jd;\r\
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
    \n:return \$jd;\r\
    \n}\r\
    \n\r\
    \n:local buildTime [/system resource get build-time];\r\
    \n\r\
    \n:local buildDate;\r\
    \n:local buildTimeValue;\r\
    \n:local parseDate [:find \$buildTime \" \"];\r\
    \n:if ([:len \$parseDate] != 0) do={\r\
    \n    :set buildDate [:pick \$buildTime 0 11];\r\
    \n    :set buildTimeValue [:pick \$buildTime 12 20];\r\
    \n}\r\
    \n\r\
    \n:local nowDate [\$fncBuildDate \$buildDate];\r\
    \n\r\
    \n:local currentTime \$buildTimeValue;\r\
    \n\r\
    \n:local days (\$nowDate - 2440587);\r\
    \n:local hour [:pick \$currentTime 0 2];\r\
    \n:local minute [:pick \$currentTime 3 5];\r\
    \n:local second [:pick \$currentTime 6 8];\r\
    \n\r\
    \n:local osbuildate [((((\$days * 86400) + (\$hour * 3600)) + (\$minute * 60)) + \$second)];\r\
    \n\r\
    \n:local osversion [/system package get 0 version];\r\
    \n:local os [/system package get 0 name];\r\
    \n:local hardwaremake [/system resource get platform];\r\
    \n:local hardwaremodel [/system resource get board-name];\r\
    \n:local boardmodelnumber [/system routerboard get model];\r\
    \n:local boardserialnumber [/system routerboard get serial-number];\r\
    \n:local cpu [/system resource get cpu];\r\
    \n:do {\r\
    \n  :local boardfirmwaretype [/system routerboard get firmware-type];\r\
    \n  :local boardcurrentfirmware [/system routerboard get current-firmware];\r\
    \n} on-error={\r\
    \n  :local boardfirmwaretype \"n/a\";\r\
    \n  :local boardcurrentfirmware \"n/a\";\r\
    \n}\r\
    \n\r\
    \n:local hwUrlValCollectData (\"{\\\"login\\\":\\\"\$login\\\",\\\"key\\\":\\\"\$topKey\\\",\\\"clientInfo\\\":\\\"\$topClientInfo\\\", \\\"osVersion\\\":\\\"\$osversion\\\", \
    \\\"hardwareMake\\\":\\\"\$hardwaremake\\\",\\\"hardwareModel\\\":\\\"\$hardwaremodel\\\",\\\"hardwareModelNumber\\\":\\\"\$boardmodelnumber\\\",\\\"hardwareSerialNumber\\\":\
    \\\"\$boardserialnumber\\\", \\\"hardwareCpuInfo\\\":\\\"\$cpu\\\",\\\"os\\\":\\\"\$os\\\",\\\"osBuildDate\\\":\$osbuildate,\\\"fw\\\":\\\"\$boardfirmwaretype\\\",\\\"fwVersio\
    n\\\":\\\"\$boardcurrentfirmware\\\"}\");\r\
    \n\r\
    \n:local collectorsUrl \"config\";\r\
    \n\r\
    \n:local fetchHardwareBootUrlFuct [\$urlEncodeFunct currentUrlVal=\$topUrl urlVal=\$collectorsUrl];\r\
    \n\r\
    \n:put \"\$hwUrlValCollectData\";\r\
    \n\r\
    \n:local configSendData;\r\
    \n:do { \r\
    \n  :set configSendData [/tool fetch mode=https http-method=post http-header-field=\"cache-control: no-cache, content-type: application/json\" http-data=\"\$hwUrlValCollectDat\
    a\" url=\$fetchHardwareBootUrlFuct  as-value output=user duration=10]\r\
    \n  :put (\"FETCH CONFIG HARDWARE FUNCT OK =======>>>\");\r\
    \n} on-error={\r\
    \n  :put (\"FETCH CONFIG HARDWARE FUNCT ERROR =======>>>\");\r\
    \n}\r\
    \n\r\
    \n:delay 1;\r\
    \n\r\
    \n:local setConfig 0;\r\
    \n:local host;\r\
    \n\r\
    \n:put \"\\nconfigSendData (config request response before parsing):\\n\";\r\
    \n:put \$configSendData;\r\
    \n:put \"\\n\";\r\
    \n\r\
    \n# make sure there was a non empty response\r\
    \n# and that Err was not the first three characters, indicating an inability to parse\r\
    \nif ([:len \$configSendData] != 0 && [:find \$configSendData \"Err.Raise 8732\"] != 0) do={\r\
    \n\r\
    \n  :local jstr;\r\
    \n\r\
    \n  :set jstr [\$configSendData];\r\
    \n  /system script run \"JParseFunctions\";\r\
    \n  global JSONIn\r\
    \n  global JParseOut;\r\
    \n  global fJParse;\r\
    \n\r\
    \n  # Parse data\r\
    \n  :set JSONIn (\$jstr->\"data\");\r\
    \n  :set JParseOut [\$fJParse];\r\
    \n\r\
    \n  :set host (\$JParseOut->\"host\");\r\
    \n  :local jsonError (\$JParseOut->\"error\");\r\
    \n\r\
    \n  if ( [:len \$host] != 0 ) do={\r\
    \n\r\
    \n    # set outageIntervalSeconds and updateIntervalSeconds\r\
    \n    :global outageIntervalSeconds (\$host->\"outageIntervalSeconds\");\r\
    \n    :global updateIntervalSeconds (\$host->\"updateIntervalSeconds\");\r\
    \n\r\
    \n    # check if lastConfigChangeTsMs in the response\r\
    \n    # is larger than the last configuration application\r\
    \n\r\
    \n    :global lastConfigChangeTsMs;\r\
    \n\r\
    \n    :local lcf (\$host->\"lastConfigChangeTsMs\");\r\
    \n    :put \"response's lastConfigChangeTsMs: \$lcf\";\r\
    \n    :put \"current lastConfigChangeTsMs: \$lastConfigChangeTsMs\";\r\
    \n\r\
    \n    if (\$lcf != \$lastConfigChangeTsMs) do={\r\
    \n      :put \"new configuration must be applied\";\r\
    \n\r\
    \n      #set the value to that sent by the server\r\
    \n      :set lastConfigChangeTsMs \$lcf;\r\
    \n\r\
    \n      :set setConfig 1;\r\
    \n\r\
    \n    }\r\
    \n\r\
    \n    # the config response is authenticated, disable the scheduler\r\
    \n    # and enable cmdGetDataFromApi which is the update request loop\r\
    \n    # otherwise, keep making config requests so that after the host\r\
    \n    # is added and not an unknown host, it will actually make a config request\r\
    \n    # and get the configuration it should have\r\
    \n\r\
    \n    /system scheduler disable config;\r\
    \n    /system scheduler enable cmdGetDataFromApi;\r\
    \n    /system script run cmdGetDataFromApi;\r\
    \n\r\
    \n    :put \"setConfig: \$setConfig\";\r\
    \n\r\
    \n  } else={\r\
    \n\r\
    \n    # there was an error in the response\r\
    \n    :put (\"config request responded with an error: \" . \$jsonError);\r\
    \n\r\
    \n    if ([:find \$jsonError \"invalid login\"] > -1) do={\r\
    \n      :put \"invalid login, running globalScript to make sure login is set correctly\";\r\
    \n      /system script run globalScript;\r\
    \n    }\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n} else={\r\
    \n\r\
    \n  # there was a parsing error, the scheduler will continue repeating config requests and \$setConfig will not equal 1\r\
    \n  :put \"JSON parsing error with config request, config scheduler will continue retrying\";\r\
    \n\r\
    \n}\r\
    \n\r\
    \nif (\$setConfig = 1) do={\r\
    \n\r\
    \n  :put \"applying configuration, setConfig=1\";\r\
    \n\r\
    \n  :local lenval (\$host->\"wirelessConfigs\");\r\
    \n\r\
    \n  :local hostkey (\$host->\"key\");\r\
    \n  #:put \"hostkey: \$hostkey\";\r\
    \n  :do {\r\
    \n    # if the password is blank, set it to the hostkey\r\
    \n    /password new-password=\"\$hostkey\" confirm-new-password=\"\$hostkey\" old-password=\"\";\r\
    \n    # if the password was able to be modified, then disable ip services that are not required\r\
    \n    /ip service disable ftp\r\
    \n    /ip service disable api\r\
    \n    /ip service disable telnet\r\
    \n    /ip service disable www\r\
    \n    /ip service disable www-ssl\r\
    \n  } on-error={\r\
    \n    :put \"incorrect old-password, must be changed manually\";\r\
    \n  }\r\
    \n\r\
    \n# disable ip services that are not needed\r\
    \n\r\
    \n  :local hostname (\$host->\"name\");\r\
    \n  :put \"hostname: \$hostname\";\r\
    \n\r\
    \n  :put (\"Host Name ==>>>\" . \$hostname);\r\
    \n  if ([:len \$hostname] != 0) do={\r\
    \n    :put (\"System identity changed.\");\r\
    \n    :do { /system identity set name=\$hostname }\r\
    \n  }\r\
    \n  if ([:len \$hostname] = 0) do={\r\
    \n    :put (\"System identity not added!!!\");\r\
    \n  }\r\
    \n\r\
    \n  :local mode;\r\
    \n  :local channelwith;\r\
    \n  :local wifibeaconint;\r\
    \n\r\
    \n  :set mode (\$host->\"wirelessMode\");\r\
    \n  :set channelwith (\$host->\"wirelessChannel\");\r\
    \n  #:set wifibeaconint (\$host->\"wirelessBeaconInt\");\r\
    \n\r\
    \n  :local wifiModeCtrl \"0\";\r\
    \n  :if ([:len [/interface wireless find ]]>0) do={\r\
    \n    :set wifiModeCtrl \"1\";\r\
    \n  }\r\
    \n\r\
    \n  if (\$wifiModeCtrl = \"1\") do={\r\
    \n    # this device has wireless interfaces\r\
    \n\r\
    \n    :put \"device has wireless hardware\";\r\
    \n\r\
    \n    :global wanIP;\r\
    \n    :put \"wanIP: \$wanIP\";\r\
    \n\r\
    \n    :put \"wireless mode: \$mode with WAN interface: \$wanport\";\r\
    \n\r\
    \n     # add bridge\r\
    \n     if ([:len [/interface bridge find name=\"ispapp-wifi\"]] = 0) do={\r\
    \n       /interface bridge add name=\"ispapp-wifi\";\r\
    \n      :put \"created first ispapp-wifi bridge\";\r\
    \n      :do {\r\
    \n         /interface wireless security-profiles remove ispapp-hidden;\r\
    \n       } on-error={\r\
    \n       }\r\
    \n       # make the wpa2 key asdfasdf + the first 10 letters of the host key to ensure it is between 8 and 64 characters long\r\
    \n       :local asdf [:pick \"\$hostkey\" 1 10];\r\
    \n       /interface wireless security-profiles add name=ispapp-hidden mode=dynamic-keys authentication-types=wpa2-psk wpa2-pre-shared-key=\"asdfasdf\$asdf\";\r\
    \n    } else={\r\
    \n      :put \"ispapp-wifi bridge is already created\";\r\
    \n    }\r\
    \n\r\
    \n    # remove existing ispapp requirements for ap_router mode\r\
    \n    # dhcp server, ip pool, ip address, nat rule\r\
    \n    :do {\r\
    \n      /ip firewall nat remove [find comment=ispapp-wifi];\r\
    \n    } on-error={\r\
    \n    }\r\
    \n     :do {\r\
    \n      /ip dhcp-server remove [find interface=ispapp-wifi];\r\
    \n    } on-error={\r\
    \n    }\r\
    \n     :do {\r\
    \n      /ip dhcp-server network remove [find gateway=10.10.0.1];\r\
    \n    } on-error={\r\
    \n    }\r\
    \n     :do {\r\
    \n      /ip pool remove ispapp-wifi-pool;\r\
    \n    } on-error={\r\
    \n    }\r\
    \n     :do {\r\
    \n      /ip address remove [find interface=ispapp-wifi];\r\
    \n    } on-error={\r\
    \n    }\r\
    \n\r\
    \n     if (\$mode = \"ap_router\") do={\r\
    \n\r\
    \n        :put \"WAN <> ispapp-wifi with NAT\";\r\
    \n        /ip address add interface=ispapp-wifi address=10.10.0.1/16;\r\
    \n        /ip pool add ranges=10.10.0.10-10.10.254.254 name=ispapp-wifi-pool;\r\
    \n        /ip dhcp-server network add address=10.10.0.0/16 dns-server=8.8.8.8,8.8.4.4 gateway=10.10.0.1\r\
    \n        /ip dhcp-server add interface=ispapp-wifi address-pool=ispapp-wifi-pool disabled=no;\r\
    \n        /ip firewall nat add action=masquerade chain=srcnat comment=ispapp-wifi\r\
    \n\r\
    \n     } else={\r\
    \n\r\
    \n       :put \"WAN <> ispapp-wifi as BRIDGE\";\r\
    \n       :put \"\\nYOU NEED TO ADD THE WAN PORT TO THE 'ispapp-wifi' BRIDGE\\n/interface bridge port add bridge=ispapp-wifi interface=wan0\\n\";\r\
    \n\r\
    \n     }\r\
    \n\r\
    \n     # remove existing vaps and bridge ports\r\
    \n     :foreach wIfaceId in=[/interface wireless find] do={\r\
    \n\r\
    \n        :local wIfName ([/interface wireless get \$wIfaceId name]);\r\
    \n        :local wIfSsid ([/interface wireless get \$wIfaceId ssid]);\r\
    \n        :local isIspappIf ([:find \$wIfName \"ispapp-\"]);\r\
    \n\r\
    \n        if (\$isIspappIf = 0) do={\r\
    \n          :put \"deleting ispapp interface: \$wIfName\";\r\
    \n          /interface bridge port remove [find interface=\$wIfName];\r\
    \n          /interface wireless remove \$wIfName;\r\
    \n          /interface wireless security-profiles remove \$wIfName;\r\
    \n        } else={\r\
    \n          # if a non virtual ap is broadcasting the Mikrotik ssid, hide the ssid and set it to ispapp-\$login\r\
    \n          :put \"non virtual ap ssid: \$wIfSsid\";\r\
    \n          if (\$wIfSsid = \"MikroTik\") do={\r\
    \n            :put \"if ssid=Mikrotik, set to ispapp-\$login\";\r\
    \n            /interface wireless set ssid=\"ispapp-\$login\" hide-ssid=\"yes\" security-profile=ispapp-hidden \$wIfName;\r\
    \n          }\r\
    \n\r\
    \n        }\r\
    \n\r\
    \n      }\r\
    \n\r\
    \n    :local i;\r\
    \n    :for i from=0 to=([:len \"\$lenval\"]-1) do={\r\
    \n      # this is each configured ssid, there can be many\r\
    \n      \r\
    \n      :local vlanmode \"use-tag\";\r\
    \n\r\
    \n      :local authenticationtypes (\$lenval->\$i->\"encType\");\r\
    \n      :local encryptionKey (\$lenval->\$i->\"encKey\");\r\
    \n      :local ssid (\$lenval->\$i->\"ssid\");\r\
    \n      #:local vlanid (\$lenval->\$i->\"vlanId\");\r\
    \n      :local vlanid 0;\r\
    \n      :local defaultforward (\$lenval->\$i->\"clientIsolation\");\r\
    \n      :local preamblemode (\$lenval->\$i->\"sp\");\r\
    \n      :local dotw (\$lenval->\$i->\"dotw\");\r\
    \n\r\
    \n      if (\$authenticationtypes = \"psk\") do={\r\
    \n        :set authenticationtypes \"wpa2-psk\";\r\
    \n      }\r\
    \n      if (\$authenticationtypes = \"psk2\") do={\r\
    \n        :set authenticationtypes \"wpa2-psk\";\r\
    \n      }\r\
    \n      if (\$authenticationtypes = \"sae\") do={\r\
    \n        :set authenticationtypes \"wpa2-psk\";\r\
    \n      }\r\
    \n      if (\$authenticationtypes = \"sae-mixed\") do={\r\
    \n        :set authenticationtypes \"wpa2-psk\";\r\
    \n      }\r\
    \n      if (\$authenticationtypes = \"owe\") do={\r\
    \n        :set authenticationtypes \"wpa2-psk\";\r\
    \n      }\r\
    \n\r\
    \n      if (\$vlanid = 0) do={\r\
    \n        :set vlanid  1;\r\
    \n        :set vlanmode \"no-tag\"\r\
    \n      }\r\
    \n\r\
    \n      # change json values of configuration parameters to what routeros expects\r\
    \n      if (\$mode = \"sta\") do={\r\
    \n        :set mode \"station\";\r\
    \n      }\r\
    \n      if (\$defaultforward = \"true\") do={\r\
    \n        :set defaultforward \"yes\";\r\
    \n      }\r\
    \n      if (\$defaultforward = \"false\") do={\r\
    \n        :set defaultforward \"no\";\r\
    \n      }\r\
    \n      if (\$channelwith != \"auto\") do={\r\
    \n        :set channelwith \"20mhz\";\r\
    \n      }\r\
    \n      if (\$preamblemode = \"true\") do={\r\
    \n        :set preamblemode \"long\";\r\
    \n      }\r\
    \n      if (\$preamblemode = \"false\") do={\r\
    \n        :set preamblemode \"short\";\r\
    \n      }\r\
    \n\r\
    \n      :put \"\\nconfiguring wireless network \$ssid\";\r\
    \n      :put (\"index ==>\" . \$i);\r\
    \n      :put (\"hostname==>\" . \$hostname);\r\
    \n      :put (\"authtype==>\" . \$authenticationtypes);\r\
    \n      :put (\"enckey==>\" . \$encryptionKey);\r\
    \n      :put (\"ssid==>\" . \$ssid);\r\
    \n      :put (\"vlanid==>\" . \$vlanid);\r\
    \n      :put (\"chwidth==>\" . \$channelwith);\r\
    \n      :put (\"forwardmode==>\" . \$defaultforward);\r\
    \n      :put (\"preamblemode==>\" . \$preamblemode);\r\
    \n\r\
    \n      # for each wireless interface, create a vap\r\
    \n      :foreach wIfaceId in=[/interface wireless find] do={\r\
    \n\r\
    \n        :local wIfName ([/interface wireless get \$wIfaceId name]);\r\
    \n        :local wIfType ([/interface wireless get \$wIfaceId interface-type]);\r\
    \n\r\
    \n        :put \"wifi interface: \$wIfName, type: \$wIfType\";\r\
    \n\r\
    \n        /interface wireless enable \$wIfName;\r\
    \n        /interface wireless set \$wIfName mode=ap-bridge\r\
    \n\r\
    \n        if (\$wIfType != \"virtual\") do={\r\
    \n          /interface wireless security-profiles add name=\"ispapp-\$ssid-\$wIfName\" mode=dynamic-keys authentication-types=\"\$authenticationtypes\" wpa2-pre-shared-key=\"\
    \$encryptionKey\"\r\
    \n          /interface wireless add master-interface=\"\$wIfName\" ssid=\"\$ssid\" name=\"ispapp-\$ssid-\$wIfName\" security-profile=\"ispapp-\$ssid-\$wIfName\" wireless-proto\
    col=802.11 frequency=auto mode=ap-bridge;\r\
    \n          /interface wireless enable \"ispapp-\$ssid-\$wIfName\";\r\
    \n          /interface bridge port add bridge=ispapp-wifi interface=\"ispapp-\$ssid-\$wIfName\";\r\
    \n        }\r\
    \n\r\
    \n      }\r\
    \n\r\
    \n    }\r\
    \n  }\r\
    \n\r\
    \n}"
add dont-require-permissions=no name=base64EncodeFunctions owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="# ------------------- Base64\
    EncodeFunct ----------------------\r\
    \n:global stringVal;\r\
    \n:global baseStart;\r\
    \n:set baseStart ([/system clock get time]);\r\
    \n\r\
    \n:global base64EncodeFunct do={ \r\
    \n\r\
    \n  :put \"base64EncodeFunct arg b=\$stringVal\"\r\
    \n\r\
    \n  :global charToDec;\r\
    \n  :set charToDec {\"A\"=65; \"B\"=66; \"C\"=67; \"D\"=68; \"E\"=69; \"F\"=70; \"G\"=71; \"H\"=72; \"I\"=73; \"J\"=74; \"K\"=75; \"L\"=76; \"M\"=77; \"N\"=78; \"O\"=79; \"P\"\
    =80; \"Q\"=81; \"R\"=82; \"S\"=83; \"T\"=84; \"U\"=85; \"V\"=86; \"W\"=87; \"X\"=88; \"Z\"=90; \"Y\"=89; \"Z\"=90; \"a\"=97; \"b\"=98; \"c\"=99; \"d\"=100; \"e\"=101; \"f\"=10\
    2; \"g\"=103; \"h\"=104; \"i\"=105; \"j\"=106; \"k\"=107; \"l\"=108; \"m\"=109; \"n\"=110; \"o\"=111; \"p\"=112; \"q\"=113; \"r\"=114; \"s\"=115; \"t\"=116; \"u\"=117; \"v\"=1\
    18; \"w\"=119; \"x\"=120; \"y\"=121; \"z\"=122; \"0\"=48; \"1\"=49; \"2\"=50; \"3\"=51; \"4\"=52; \"5\"=53; \"6\"=54; \"7\"=55; \"8\"=56; \"9\"=57;  \"\A3\"=10; \"Space\"=32; \
    \" \"=32; \"!\"=33; \"#\"=35; \"\$\"=36; \"%\"=37; \"&\"=38; \"'\"=39; \"(\"=40; \")\"=41; \"*\"=42; \"+\"=43; \",\"=44; \"-\"=45; \".\"=46; \"/\"=47; \":\"=58; \";\"=59; \"<\
    \"=60; \"=\"=61; \">\"=62; \"\?\"=63; \"@\"=64; \"\\\"=34; \"[\"=91; \"]\"=93; \"^\"=94; \"_\"=95; \"~\"=126 };\r\
    \n\r\
    \n  :global base64Chars;\r\
    \n  :set base64Chars {\"0\"=\"A\"; \"1\"=\"B\"; \"2\"=\"C\"; \"3\"=\"D\"; \"4\"=\"E\"; \"5\"=\"F\"; \"6\"=\"G\"; \"7\"=\"H\"; \"8\"=\"I\"; \"9\"=\"J\"; \"10\"=\"K\"; \"11\"=\"\
    L\"; \"12\"=\"M\"; \"13\"=\"N\"; \"14\"=\"O\"; \"15\"=\"P\"; \"16\"=\"Q\"; \"17\"=\"R\"; \"18\"=\"S\"; \"19\"=\"T\"; \"20\"=\"U\"; \"21\"=\"V\"; \"22\"=\"W\"; \"23\"=\"X\"; \"\
    24\"=\"Y\"; \"25\"=\"Z\"; \"26\"=\"a\"; \"27\"=\"b\"; \"28\"=\"c\"; \"29\"=\"d\"; \"30\"=\"e\"; \"31\"=\"f\"; \"32\"=\"g\"; \"33\"=\"h\"; \"34\"=\"i\"; \"35\"=\"j\"; \"36\"=\"\
    k\"; \"37\"=\"l\"; \"38\"=\"m\"; \"39\"=\"n\"; \"40\"=\"o\"; \"41\"=\"p\"; \"42\"=\"q\"; \"43\"=\"r\"; \"44\"=\"s\"; \"45\"=\"t\"; \"46\"=\"u\"; \"47\"=\"v\"; \"48\"=\"w\"; \"\
    49\"=\"x\"; \"50\"=\"y\"; \"51\"=\"z\"; \"52\"=\"0\"; \"53\"=\"1\"; \"54\"=\"2\"; \"55\"=\"3\"; \"56\"=\"4\"; \"57\"=\"5\"; \"58\"=\"6\"; \"59\"=\"7\"; \"60\"=\"8\"; \"61\"=\"\
    9\"; \"62\"=\"+\"; \"63\"=\"/\"};\r\
    \n\r\
    \n  :global rr \"\"; \r\
    \n  :global p \"\";\r\
    \n  :global s \"\";\r\
    \n  :global cLenForString;\r\
    \n  :set cLenForString ([:len \$stringVal]);\r\
    \n  :global cModVal;\r\
    \n  :set cModVal ( \$cLenForString % 3);\r\
    \n  :global stringLen ([:len \$stringVal]);\r\
    \n  :local returnVal;\r\
    \n\r\
    \n  if (\$cLenForString > 0) do={\r\
    \n    :global startEncode;\r\
    \n    :set startEncode 0;\r\
    \n\r\
    \n    :if (\$cModVal > 0) do={\r\
    \n       for val from=(\$cModVal+1) to=3 do={\r\
    \n          :set p (\$p.\"=\"); \r\
    \n          :set s (\$s.\"0\"); \r\
    \n          :set cModVal (\$cModVal + 1);\r\
    \n        }\r\
    \n    }\r\
    \n\r\
    \n    :global firstIndex 0;\r\
    \n    :while ( \$firstIndex < \$stringLen ) do={\r\
    \n\r\
    \n        if ((\$cModVal > 0) && ((((\$cModVal / 3) *4) % 76) = 0) ) do={\r\
    \n          :set rr (\$rr . \"\\ r \\ n\");\r\
    \n        }\r\
    \n\r\
    \n        :global charVal1 \"\";\r\
    \n        :global charVal2 \"\";\r\
    \n        :global charVal3 \"\";\r\
    \n\r\
    \n        :set charVal1 ([:pick \"\$stringVal\" \$firstIndex (\$firstIndex + 1)]);\r\
    \n        :set charVal2 ([:pick \$stringVal (\$firstIndex + 1) (\$firstIndex + 2)]);\r\
    \n        :set charVal3 ([:pick \$stringVal (\$firstIndex+2) (\$firstIndex + 3)]);\r\
    \n\r\
    \n        :global n1Shift ((\$charToDec->\$charVal1) << 16);\r\
    \n        :global n2Shift ((\$charToDec->\$charVal2) << 8);\r\
    \n        :global n3Shift (\$charToDec->\$charVal3);\r\
    \n\r\
    \n        :global mergeShift;\r\
    \n        :set mergeShift ((\$n1Shift +\$n2Shift) + \$n3Shift);\r\
    \n\r\
    \n        :global n;\r\
    \n        :set n \$mergeShift;\r\
    \n        :set n ([:tonum \$n]);\r\
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
    \n        :set arrayN ( \$arrayN, (n1 & 63));\r\
    \n        :set arrayN ( \$arrayN, (n2 & 63));\r\
    \n        :set arrayN ( \$arrayN, (n3 & 63));\r\
    \n        :set arrayN ( \$arrayN, (n & 63));\r\
    \n\r\
    \n        :set n (\$arrayN);\r\
    \n\r\
    \n        :global n1Val;\r\
    \n        :set n1Val ([:pick \$n 0]);\r\
    \n        :set n1Val ([:tostr \$n1Val]);\r\
    \n        :global n2Val; \r\
    \n        :set n2Val ([:pick \$n 1]);\r\
    \n        :set n2Val ([:tostr \$n2Val]);\r\
    \n        :global n3Val; \r\
    \n        :set n3Val ([:pick \$n 2]);\r\
    \n        :set n3Val ([:tostr \$n3Val]);\r\
    \n        :global n4Val;\r\
    \n        :set n4Val ([:pick \$n 3]);\r\
    \n        :set n4Val ([:tostr \$n4Val]);\r\
    \n    \r\
    \n        :set rr (\$rr . ((\$base64Chars->\$n1Val) . (\$base64Chars->\$n2Val) . (\$base64Chars->\$n3Val) . (\$base64Chars->\$n4Val)));\r\
    \n\r\
    \n        :set firstIndex (\$firstIndex + 3);\r\
    \n    }\r\
    \n\r\
    \n    # checks for errors\r\
    \n    :do {\r\
    \n\r\
    \n      :global rLen;\r\
    \n      :global pLen;\r\
    \n      :set rLen ([:len \$rr]);\r\
    \n      :set pLen ([:len \$p]);\r\
    \n\r\
    \n      :set returnVal ([:pick \"\$rr\" 0 (\$rLen - \$pLen)]);\r\
    \n      :set returnVal (\$returnVal . \$p);\r\
    \n      :set startEncode 1;\r\
    \n      :global baseEnd;\r\
    \n      :set baseEnd ([/system clock get time]);\r\
    \n      :return \$returnVal;\r\
    \n     \r\
    \n    } on-error={\r\
    \n      :set returnVal (\"Error: Base64 encode error.\");\r\
    \n      :return \$returnVal;\r\
    \n    }\r\
    \n\r\
    \n  } else={\r\
    \n    :set returnVal (\"Error: String is wrong.\");\r\
    \n    :return \$returnVal;\r\
    \n  }\r\
    \n  \r\
    \n}"
add dont-require-permissions=no name=initMultipleScript owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="/system scheduler disable cmdGe\
    tDataFromApi\r\
    \n/system scheduler disable collectors\r\
    \n/system scheduler disable initMultipleScript\r\
    \n\r\
    \n:delay 1;\r\
    \n\r\
    \n:do {\r\
    \n  /system script run JParseFunctions;\r\
    \n} on-error={\r\
    \n  :log info (\"JParseFunctions INIT SCRIPT ERROR =======>>>\");\r\
    \n}\r\
    \n:delay 1;\r\
    \n\r\
    \n:do {\r\
    \n  /system script run base64EncodeFunctions;\r\
    \n  :put (\"base64EncodeFunctions INIT SCRIPT OK =======>>>\");\r\
    \n} on-error={\r\
    \n  :log info (\"base64EncodeFunctions INIT SCRIPT ERROR =======>>>\");\r\
    \n}\r\
    \n:delay 1;\r\
    \n\r\
    \n:do {\r\
    \n   /system script run globalScript;\r\
    \n} on-error={\r\
    \n  :log info (\"globalScript INIT SCRIPT ERROR =======>>>\");\r\
    \n}\r\
    \n:delay 1;\r\
    \n\r\
    \n:do {\r\
    \n     /system script run config;\r\
    \n  :put (\"config INIT SCRIPT OK =======>>>\");\r\
    \n} on-error={\r\
    \n  :log info (\"config INIT SCRIPT ERROR =======>>>\");\r\
    \n}\r\
    \n:delay 1;\r\
    \n\r\
    \n/system scheduler enable cmdGetDataFromApi\r\
    \n/system scheduler enable collectors\r\
    \n/system scheduler enable initMultipleScript"
add dont-require-permissions=no name=cmdGetDataFromApi owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="# CMD and fastUpdate\r\
    \n\r\
    \n:global jstr;\r\
    \n:global cmdGetDataFromApi;\r\
    \n\r\
    \n:global urlEncodeFunct;\r\
    \n:set jstr ([\$cmdGetDataFromApi]);\r\
    \n\r\
    \n:global topClientInfo;\r\
    \n\r\
    \n:global topUrl;\r\
    \n\r\
    \n:global topKey;\r\
    \n:global login;\r\
    \n\r\
    \n# ------------------- urlEncodeFunct ----------------------\r\
    \n:global urlEncodeFunct do={\r\
    \n  :put \"urlEncodeFunct arg a=\$currentUrlVal\"; \r\
    \n  :put \"urlEncodeFunct arg b=\$urlVal\"\r\
    \n\r\
    \n  :local urlEncoded;\r\
    \n  :for i from=0 to=([:len \$urlVal] - 1) do={\r\
    \n    :local char [:pick \$urlVal \$i];\r\
    \n\r\
    \n    :global chars { \"!\"=\"%21\"; \"#\"=\"%23\"; \"\$\"=\"%24\"; \"%\"=\"%25\"; \"'\"=\"%27\"; \"(\"=\"%28\"; \")\"=\"%29\"; \"*\"=\"%2A\"; \"+\"=\"%2B\"; \",\"=\"%2C\"; \"\
    -\"=\"%2D\"; \".\"=\"%2E\"; \"/\"=\"%2F\"; \"; \"=\"%3B\"; \"<\"=\"%3C\"; \">\"=\"%3E\"; \"@\"=\"%40\"; \"[\"=\"%5B\"; \"\\\"=\"%5C\"; \"]\"=\"%5D\"; \"^\"=\"%5E\"; \"_\"=\"%5\
    F\"; \"`\"=\"%60\"; \"{\"=\"%7B\"; \"|\"=\"%7C\"; \"}\"=\"%7D\"; \"~\"=\"%7E\"; \" \"=\"%7F\"};\r\
    \n\r\
    \n    :local EncChar;\r\
    \n    :set EncChar (\$chars->\$char);\r\
    \n    :if (any \$EncChar) do={\r\
    \n      :set char (\$chars->\$char);\r\
    \n    } else={\r\
    \n      :set char \$char;\r\
    \n    }\r\
    \n\r\
    \n    :set urlEncoded (\$urlEncoded . \$char);\r\
    \n  }\r\
    \n  :local mergeUrl;\r\
    \n  :set mergeUrl (\$currentUrlVal . \$urlEncoded);\r\
    \n  :return (\$mergeUrl);\r\
    \n\r\
    \n}\r\
    \n\r\
    \n:global collectUpdataValLen;\r\
    \n:global collectUpDataVal;\r\
    \n:set collectUpdataValLen ([:len \$collectUpDataVal]);\r\
    \n:if (\$collectUpdataValLen = 0) do={\r\
    \n  :set collectUpDataVal \"{}\";\r\
    \n}\r\
    \n\r\
    \n#WAN Port IP Address\r\
    \n:global gatewayStatus; \r\
    \n:do {\r\
    \n  :set gatewayStatus ([:tostr [/ip route get [:pick [find dst-address=0.0.0.0/0 active=yes] 0] gateway-status]]);\r\
    \n} on-error={\r\
    \n  :log info (\"Error finding default route.\");\r\
    \n}\r\
    \n\r\
    \n:global getInterfaceIndex;\r\
    \n:global interfaceIp;\r\
    \n:set getInterfaceIndex ([:find \"\$gatewayStatus\" \" \" -1]);\r\
    \n\r\
    \n:set interfaceIp [:pick \$gatewayStatus 0 \$getInterfaceIndex];\r\
    \n\r\
    \n:global ipNetworkAddress;\r\
    \n:set ipNetworkAddress [:pick \$interfaceIp 0 ([:len \$interfaceIp ] - 1)];\r\
    \n:set ipNetworkAddress (\$ipNetworkAddress . \"0\");\r\
    \n:global iface;\r\
    \n:set iface \$interface;\r\
    \n:global wanIP;\r\
    \n:do {\r\
    \n  :set wanIP [/ip address  get [:pick [/ip address find network=\$ipNetworkAddress] 0] address ];\r\
    \n} on-error={\r\
    \n  :set wanIP \"\";\r\
    \n  :log info (\"Error finding interface associated with default route.\");\r\
    \n}\r\
    \n\r\
    \n:global upSeconds 0;\r\
    \n# All this is just to convert XwYdHH:MM:SS to seconds.\r\
    \n:local upTime [/system resource get uptime];\r\
    \n\r\
    \nglobal weeks 0;\r\
    \nif (([:find \$upTime \"w\"]) > 0 ) do={\r\
    \n  :set weeks ([:pick \$upTime 0 ([:find \$upTime \"w\"])]);\r\
    \n  :set upTime [:pick \$upTime ([:find \$upTime \"w\"]+1) [:len \$upTime]];\r\
    \n}\r\
    \nglobal days 0;\r\
    \nif (([:find \$upTime \"d\"]) > 0 ) do={\r\
    \n  :set days ([:pick \$upTime 0 [:find \$upTime \"d\"]]);\r\
    \n  :set upTime [:pick \$upTime ([:find \$upTime \"d\"]+1) [:len \$upTime]];\r\
    \n}\r\
    \n\r\
    \n:global hours [:pick \$upTime 0 [:find \$upTime \":\"]];\r\
    \n:set upTime [:pick \$upTime ([:find \$upTime \":\"]+1) [:len \$upTime]];\r\
    \n\r\
    \n:global minutes [:pick \$upTime 0 [:find \$upTime \":\"]];\r\
    \n:set upTime [:pick \$upTime ([:find \$upTime \":\"]+1) [:len \$upTime]];\r\
    \n\r\
    \n:global upSecondVal 0;\r\
    \n:set upSecondVal \$upTime;\r\
    \n\r\
    \n:set upSeconds value=[:tostr ((\$weeks*604800)+(\$days*86400)+(\$hours*3600)+(\$minutes*60)+\$upSecondVal)];\r\
    \n\r\
    \n:global wanIP;\r\
    \n:local upSecondsVal value=[:tostr \$upSeconds];\r\
    \n\r\
    \n# version data\r\
    \n:local mymodel [/system routerboard get model];\r\
    \n:local myversion [/system package get 0 version];\r\
    \n\r\
    \n#:global collectUpData;\r\
    \n:global collectUpData \"{\\\"collectors\\\":\$collectUpDataVal,\\\"login\\\":\\\"\$login\\\",\\\"key\\\":\\\"\$topKey\\\",\\\"clientInfo\\\":\\\"\$topClientInfo\\\", \\\"osV\
    ersion\\\":\\\"RB\$mymodel-\$myversion\\\", \\\"wanIp\\\":\\\"\$wanIP\\\",\\\"uptime\\\":\$upSeconds}\";\r\
    \n\r\
    \n:put (\"\$collectUpData\");\r\
    \n\r\
    \n:global collectorsUrl \"update\";\r\
    \n\r\
    \n:global mergeUpdateCollectorsUrl;\r\
    \n:set mergeUpdateCollectorsUrl ([\$urlEncodeFunct currentUrlVal=\$topUrl urlVal=\$collectorsUrl]);\r\
    \n\r\
    \n:global cmdGetDataFromApi;\r\
    \n:global cmdsArrayLenVal;\r\
    \n\r\
    \n:do {\r\
    \n    :set cmdGetDataFromApi ([/tool fetch mode=https http-method=post http-header-field=\"cache-control: no-cache, content-type: application/json\" http-data=\"\$collectUpDat\
    a\" url=\$mergeUpdateCollectorsUrl as-value output=user duration=10]);\r\
    \n    :put (\"CMD GET DATA OK =======>>>\", \$cmdGetDataFromApi);\r\
    \n} on-error={\r\
    \n  :log info (\"Error with /update request to ISPApp.\");\r\
    \n\r\
    \n    # need to enable the config scheduler and disable cmdGetDataFromApi\r\
    \n    # so config requests are made as the first, return to online request\r\
    \n    # preventing the issue of a router that comes back online bringing itself up with an old configuration\r\
    \n    /system scheduler enable config;\r\
    \n    /system scheduler disable cmdGetDataFromApi;\r\
    \n}\r\
    \n\r\
    \n:global jstr;\r\
    \n:set jstr ([\$cmdGetDataFromApi]);\r\
    \n\r\
    \n:put \"jst: \$jstr\";\r\
    \n\r\
    \nif ( (\$jstr->\"status\") = \"finished\" ) do={\r\
    \n  \r\
    \n  /system script run \"JParseFunctions\"; global JSONIn; global JParseOut; global fJParse;\r\
    \n    \r\
    \n  # Parse data and print `ParsedResults[0].ParsedText` value\r\
    \n  :set JSONIn (\$jstr->\"data\");\r\
    \n    \r\
    \n  if ( [:len \$JSONIn] != 0 ) do={\r\
    \n\r\
    \n    :set JParseOut [\$fJParse];\r\
    \n\r\
    \n    :local jsonError (\$JParseOut->\"error\");\r\
    \n    :local updateFast (\$JParseOut->\"updateFast\");\r\
    \n\r\
    \n    :put \"JParseOut: \$JParseOut\";\r\
    \n  \r\
    \n    :local rebootval (\$JParseOut->\"reboot\");\r\
    \n\r\
    \n    :put \"rebootval: \$rebootval\";\r\
    \n\r\
    \n    if ( \$rebootval = \"1\" ) do={\r\
    \n      :global booturl \"config\?login=\$login&key=\$topKey\"\r\
    \n      :global mergeBootUrlFuct;\r\
    \n      :set mergeBootUrlFuct [\$urlEncodeFunct currentUrlVal=\$topUrl urlVal=\$booturl];\r\
    \n\r\
    \n      :log info \"Reboot\";\r\
    \n      /system reboot;\r\
    \n\r\
    \n    } else={\r\
    \n\r\
    \n      # check if lastConfigChangeTsMs is different\r\
    \n      :global lastConfigChangeTsMs;\r\
    \n\r\
    \n      :local lcf (\$JParseOut->\"lastConfigChangeTsMs\");\r\
    \n\r\
    \n      if (\$lcf != \$lastConfigChangeTsMs) do={\r\
    \n        :put \"update response indicates configuration changes\";\r\
    \n        /system scheduler enable config;\r\
    \n\r\
    \n      } else={\r\
    \n        :put \"update response indicates no configuration changes\";\r\
    \n      }\r\
    \n\r\
    \n    :execute script={\r\
    \n        :global createCmdArray;\r\
    \n        :global updateFast \"\";\r\
    \n\r\
    \n        # Parse data and print `ParsedResults[0].ParsedText` value\r\
    \n        :set updateFast (\$JParseOut->\"updateFast\");\r\
    \n        :global cmdArray;\r\
    \n        :global cmdsArray;\r\
    \n        :global tmpCmdsArray;\r\
    \n        :set cmdsArray (\$JParseOut->\"cmds\");\r\
    \n        :set cmdsArrayLenVal ([:len \"\$cmdsArray\"]);\r\
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
    \n                  :set tempArrVal (\"{\\\"cmd\\\":\\\"\$tmpCmd\\\"; \\\"ws_id\\\":\\\"\$tmpWsid\\\"; \\\"uuidv4\\\":\\\"\$tmpUuid4\\\"; \\\"stdout\\\":\\\"\$tmpStdout\\\"; \
    \\\"stderr\\\":\\\"\$tmpErr\\\"}\");\r\
    \n                  :set tmpToArray ([:toarray \$tempArrVal]);\r\
    \n                }\r\
    \n              }\r\
    \n              :if (([:len \$tmpToArray]) > 0) do={\r\
    \n                :set (\$tmpCmdsArray->[:len \$tmpCmdsArray]) \$tmpToArray;\r\
    \n              }\r\
    \n          }\r\
    \n        }\r\
    \n\r\
    \n       if (\$tmpCmdsArrayLenVal = 0) do={\r\
    \n          :set tmpCmdsArray \$cmdsArray;\r\
    \n        }\r\
    \n\r\
    \n        :if ( \$updateFast = true) do={\r\
    \n          :do {\r\
    \n            :local cmdGetDataSchedulerInterval [/system scheduler get cmdGetDataFromApi  interval ];\r\
    \n            :if (\$cmdGetDataSchedulerInterval != \"00:00:02\") do={\r\
    \n              /system scheduler set interval=2s \"cmdGetDataFromApi\";\r\
    \n              /system scheduler set interval=10s \"collectors\";\r\
    \n            }\r\
    \n          } on-error={\r\
    \n            :log info (\"CMDGETDATAAPI FUNC CHANGE SCHEDULER  ERROR ========>>>>\");\r\
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
    \n\r\
    \n              if (\$updateIntervalSeconds-\$lastColUpdateOffsetSec < 2 || \$updateIntervalSeconds-\$lastColUpdateOffsetSec > 300) do={\r\
    \n\r\
    \n                # don't let this change the interval to 0, causing the script to no longer run\r\
    \n                # set sane defaults that will be updated next time a request is successful\r\
    \n\r\
    \n                /system scheduler set interval=5s \"cmdGetDataFromApi\";\r\
    \n                /system scheduler set interval=60s \"collectors\";\r\
    \n\r\
    \n             } else={\r\
    \n\r\
    \n                /system scheduler set interval=(\$outageIntervalSeconds-\$lastUpdateOffsetSec) \"cmdGetDataFromApi\";\r\
    \n                /system scheduler set interval=(\$updateIntervalSeconds-\$lastColUpdateOffsetSec) \"collectors\";\r\
    \n\r\
    \n            }\r\
    \n\r\
    \n          } on-error={\r\
    \n            :log info (\"UPDATE FUNCT CHANGE SCHEDULER  ERROR ========>>>>\");\r\
    \n          }\r\
    \n\r\
    \n        }\r\
    \n\r\
    \n\r\
    \n        :global i;\r\
    \n        :global cmdsDataPutToArray;\r\
    \n        :set cmdsDataPutToArray \"\";\r\
    \n        :global tmpCmdsArrayLen;\r\
    \n\r\
    \n        :set tmpCmdsArrayLen ([:len \"\$tmpCmdsArray\"]-1);\r\
    \n        :global outFile;\r\
    \n        :set outFile \"cmdResult.txt\";\r\
    \n        if (\$tmpCmdsArrayLen != -1) do={\r\
    \n          \r\
    \n          :foreach cmdKey in=([:toarray \$tmpCmdsArray]) do={\r\
    \n\r\
    \n            :global cmdVal;\r\
    \n            :global cmdsData;\r\
    \n            :set cmdsData \"\";\r\
    \n\r\
    \n            #:global a {cmd=\"/interface print detail\"};\r\
    \n            #:put \$a;\r\
    \n            #:set (\$a->\"cmd\");\r\
    \n            #:put \$a;\r\
    \n            #cmd=/interface print detail;stderr=;stdout=;uuidv4=9ac559ac-9678-493d-ae80-9e1e0fbf75fd;ws_id=6f88b67b94cbee7283fef50fe74f11d9;cmd=/interface print detail2;stde\
    rr=;stdout=;uuidv4=8b1b95fb-485e-40ce-b616-6cd7891f4488;ws_id=6f88b67b94cbee7283fef50fe74f11d9\r\
    \n            \r\
    \n            :global cmd;\r\
    \n            :global tmpCmd \"\";\r\
    \n            :global wsid;\r\
    \n            :global uuidv4;\r\
    \n            :global stdout \"\";\r\
    \n            :global stderr \"\";\r\
    \n\r\
    \n            :set cmd (\$cmdKey->\"cmd\");\r\
    \n            :set tmpCmd [:parse value=\"\$cmd\"];\r\
    \n            :set wsid (\$cmdKey->\"ws_id\");\r\
    \n            :set uuidv4 (\$cmdKey->\"uuidv4\");\r\
    \n            :set stdout (\$cmdKey->\"stdout\");\r\
    \n            :set stderr (\$cmdKey->\"stderr\");\r\
    \n\r\
    \n            #:set (\$tmpCmdsArray->\$cmdVal->\"cmd\");\r\
    \n            #:set (\$tmpCmdsArray->\$cmdKey->\"ws_id\");\r\
    \n            #:set (\$tmpCmdsArray->\$cmdKey->\"uuidv4\");\r\
    \n            #:set (\$tmpCmdsArray->\$cmdKey->\"stdout\");\r\
    \n            #:set (\$tmpCmdsArray->\$cmdKey->\"stderr\");\r\
    \n\r\
    \n            :local delete (\"\$cmdKey\");\r\
    \n            :local array [:toarray \"\"];\r\
    \n            :local aaa (\$tmpCmdsArray);\r\
    \n            :foreach i,ival in=\$aaa do={\r\
    \n              :if ( \$ival!=\$delete ) do={\r\
    \n                :if (\$ival !=\" \") do={\r\
    \n                  :set (\$array->[:len \$array]) ([:toarray \$ival]);\r\
    \n                }\r\
    \n              }\r\
    \n            }\r\
    \n            :set aaa \$array;\r\
    \n            :set tmpCmdsArray [:toarray \$array];\r\
    \n\r\
    \n            :global cmdRebootRebCtrl 0;\r\
    \n            :global cmdRebootSysCtrl ([:len ([:find \"\$cmd\" \"sys\"])]);\r\
    \n            :if (\$cmdRebootSysCtrl != 0) do={\r\
    \n              :set cmdRebootRebCtrl ([:len ([:find \"\$cmd\" \"reb\"])]);\r\
    \n              :set tmpCmd \"\";\r\
    \n            }\r\
    \n\r\
    \n            :if ( ([:len \$cmd]) != 0) do={\r\
    \n\r\
    \n              :global cmdStdoutVal \"\";\r\
    \n              :do {\r\
    \n                :global cmdScriptFilename \"cmdScript\";\r\
    \n                :global cmdResultFilename \"cmdResult.txt\";      \r\
    \n\r\
    \n              \r\
    \n                :global isCmdScriptExist;\r\
    \n                :set isCmdScriptExist 0;\r\
    \n                :if ([:len [/system script find name=\"\$cmdScriptFilename\"]] > 0) do={\r\
    \n                  /system script set \$cmdScriptFilename source=\"\$cmd\";\r\
    \n                  :set isCmdScriptExist 1;\r\
    \n                }\r\
    \n                :if (\$isCmdScriptExist = 0) do={\r\
    \n                  /system script add name=\$cmdScriptFilename source=\"\$cmd\";\r\
    \n                }\r\
    \n                \r\
    \n                :if ([:len [/file find name=\"\$cmdResultFilename\"]] = 0) do={\r\
    \n                  /file print file=\"\$cmdResultFilename\";\r\
    \n                }\r\
    \n               \r\
    \n                {\r\
    \n                  if (\$cmdRebootRebCtrl = 0) do={\r\
    \n                    :local j [:execute script={[/system script run \$cmdScriptFilename]} file=\"\$cmdResultFilename\"];\r\
    \n                    :delay 400ms;\r\
    \n                  } else={\r\
    \n                    :local j [:execute script={[:put (\"For reboot, use the reboot button in ISPApp.\")]} file=cmdResult.txt];\r\
    \n                  }\r\
    \n                  \r\
    \n                }\r\
    \n\r\
    \n                :global cmdFileSize 0:\r\
    \n                :set cmdFileSize ([/file get \$cmdResultFilename size]);\r\
    \n                :if ( \$cmdFileSize < 4096) do={\r\
    \n\r\
    \n                  #:set cmdStdoutVal ([/file get \$cmdResultFilename contents ]);\r\
    \n                  :global addEndLineChar \"\";\r\
    \n                  {\r\
    \n                    :global content;\r\
    \n                    :set content ([:put [/file get [/file find name=\"\$cmdResultFilename\"] contents]]);\r\
    \n                    :delay 300ms;\r\
    \n                    :global contentLen [:len \$content]\r\
    \n                    \r\
    \n                    :global lineEnd 0;\r\
    \n                    :global line \"\";\r\
    \n                    :global lastEnd 0;\r\
    \n\r\
    \n                    :if (\$contentLen = 0) do={\r\
    \n                      :set addEndLineChar \" \";\r\
    \n                    }\r\
    \n                    :while (\$lineEnd < \$contentLen) do={\r\
    \n                      :set lineEnd [:find \$content \"\\n\" \$lastEnd];\r\
    \n                      :if ([:len \$lineEnd] = 0) do={\r\
    \n                        :set lineEnd \$contentLen;\r\
    \n                      }\r\
    \n                      :set line [:pick \$content \$lastEnd \$lineEnd];\r\
    \n                      :set line (\"\$line\" . \"\A3\");\r\
    \n                      :set addEndLineChar (\"\$addEndLineChar\" . \"\$line\" );\r\
    \n                      :set lastEnd (\$lineEnd + 1);\r\
    \n                    } \r\
    \n                    :set cmdStdoutVal ([:tostr \$addEndLineChar]);\r\
    \n                  }\r\
    \n\r\
    \n                  {/file remove \$cmdResultFilename;}\r\
    \n                } else={\r\
    \n                  :set cmdStdoutVal \"Error: The result is larger than the MikroTik RouterOS 4096 byte limit.\";\r\
    \n                  {/file remove \$cmdResultFilename;}\r\
    \n                }\r\
    \n              } on-error={\r\
    \n                :do {\r\
    \n                  :set cmdStdoutVal [\$tmpCmd];\r\
    \n                } on-error={\r\
    \n                  :set stderr (\$cmd . \" : Error: bad command name.\");\r\
    \n                }\r\
    \n              }\r\
    \n\r\
    \n              :global cmdStdoutValLen;\r\
    \n              :set cmdStdoutValLen ([:len \$cmdStdoutVal]);\r\
    \n              :global startEncode;\r\
    \n              :global isSend;\r\
    \n\r\
    \n              :if (\$cmdStdoutValLen > 0 and \$isSend=1) do={\r\
    \n                :execute script={\r\
    \n                  :set isSend 0;\r\
    \n                  :set cmdStdoutValLen 0;\r\
    \n                  # ----------- Call base64EncodeFunct from base64EncodeFuntion Script ----------------\r\
    \n                  :global base64EncodeFunct;\r\
    \n                  :set cmdStdoutVal ([\$base64EncodeFunct stringVal=\$cmdStdoutVal]);\r\
    \n                  #:set cmdStdoutVal \"QVdTIERVREU=\";\r\
    \n                  \r\
    \n                  :global cmdData \"{\\\"ws_id\\\":\\\"\$wsid\\\", \\\"uuidv4\\\":\\\"\$uuidv4\\\", \\\"stdout\\\":\\\"\$cmdStdoutVal\\\",\\\"stderr\\\":\\\"\$stderr\\\",\\\
    \"login\\\":\\\"\$login\\\",\\\"key\\\":\\\"\$topKey\\\"}\";\r\
    \n\r\
    \n                  :global collectCmdData;\r\
    \n\r\
    \n                  :global cmdUrlVal \"update\?login=\$login&key=\$topKey&ws_id=\$wsid&uuidv4=\$uuidv4&stdout=\$cmdStdoutVal&stderr=\$stderr\";\r\
    \n                  :global mergeCmdsUrl;\r\
    \n                  :set mergeCmdsUrl ([\$urlEncodeFunct currentUrlVal=\$topUrl urlVal=\$cmdUrlVal]);\r\
    \n                  :do {\r\
    \n                    /tool fetch url=\$mergeCmdsUrl output=none;\r\
    \n                    :set isSend 1;\r\
    \n                    :put (\"CMD  OK ========>>>>\");\r\
    \n                  } on-error={\r\
    \n                    :log info (\"CMD ERROR ========>>>>\");\r\
    \n                  }\r\
    \n                }\r\
    \n              } else={\r\
    \n                :log info (\"STDOUT IS EMPTY NO DATA SENT ========>>>>\");\r\
    \n              }\r\
    \n            }\r\
    \n          }\r\
    \n          :set tmpCmdsArrayLenVal 0;\r\
    \n        } else={\r\
    \n          #:log info (\"TMP CMD ARR LEN IS NONE ==>>\");\r\
    \n        }\r\
    \n    }\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n    }\r\
    \n  }\r\
    \n}"
/system scheduler
add name=initMultipleScript on-event=initMultipleScript policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add interval=10s name=collectors on-event=collectors policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add interval=15s name=cmdGetDataFromApi on-event=cmdGetDataFromApi policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add interval=15s name=config on-event=config policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
/system script run initMultipleScript;
