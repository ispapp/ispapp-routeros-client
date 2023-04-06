/system script add dont-require-permissions=no name=ispappFunctions owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="# -------------------------------- JParseFunctions -------------------\r\
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
    \n        #:put \"\$TempPath = [] (\$[:typeof \$v])\";\r\
    \n      }\r\
    \n    } else={\r\
    \n        #:put \"\$TempPath = \$v (\$[:typeof \$v])\";\r\
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
    \n                #:put \"JParseFunctions.fJParse script: Err.Raise 8732. No JSON object could be fJParsed\";\r\
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
    \n            #:put \"JParseFunctions.fJParseString script: Err.Raise 8732. Invalid escape\";\r\
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
    \n      #:put \"JParseFunctions.fJParseObject script: Err.Raise 8732. Expecting property name\";\r\
    \n      :set ExitDo true;\r\
    \n    } else={\r\
    \n      :set Jpos (\$Jpos + 1);\r\
    \n      :set Key [\$fJParseString];\r\
    \n      \$fJSkipWhitespace;\r\
    \n      :if ([:pick \$JSONIn \$Jpos] != \":\") do={\r\
    \n        #:put \"JParseFunctions.fJParseObject script: Err.Raise 8732. Expecting : delimiter\";\r\
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
    \n# ------------------- End JParseFunctions----------------------\r\
    \n\r\
    \n# ------------------- Base64EncodeFunct ----------------------\r\
    \n\r\
    \n:global base64EncodeFunct do={ \r\
    \n\r\
    \n  #:put \"base64EncodeFunct arg b=\$stringVal\"\r\
    \n\r\
    \n  :local charToDec [:toarray \"\"];\r\
    \n# newline character is needed\r\
    \n:set (\$charToDec->\"\\n\") \"10\";\r\
    \n:set (\$charToDec->\" \") \"32\";\r\
    \n:set (\$charToDec->\"!\") \"33\";\r\
    \n:set (\$charToDec->\"#\") \"35\";\r\
    \n:set (\$charToDec->\"\\\$\") \"36\";\r\
    \n:set (\$charToDec->\"%\") \"37\";\r\
    \n:set (\$charToDec->\"&\") \"38\";\r\
    \n:set (\$charToDec->\"'\") \"39\";\r\
    \n:set (\$charToDec->\"(\") \"40\";\r\
    \n:set (\$charToDec->\")\") \"41\";\r\
    \n:set (\$charToDec->\"*\") \"42\";\r\
    \n:set (\$charToDec->\"+\") \"43\";\r\
    \n:set (\$charToDec->\",\") \"44\";\r\
    \n:set (\$charToDec->\"-\") \"45\";\r\
    \n:set (\$charToDec->\".\") \"46\";\r\
    \n:set (\$charToDec->\"/\") \"47\";\r\
    \n:set (\$charToDec->\"0\") \"48\";\r\
    \n:set (\$charToDec->\"1\") \"49\";\r\
    \n:set (\$charToDec->\"2\") \"50\";\r\
    \n:set (\$charToDec->\"3\") \"51\";\r\
    \n:set (\$charToDec->\"4\") \"52\";\r\
    \n:set (\$charToDec->\"5\") \"53\";\r\
    \n:set (\$charToDec->\"6\") \"54\";\r\
    \n:set (\$charToDec->\"7\") \"55\";\r\
    \n:set (\$charToDec->\"8\") \"56\";\r\
    \n:set (\$charToDec->\"9\") \"57\";\r\
    \n:set (\$charToDec->\":\") \"58\";\r\
    \n:set (\$charToDec->\";\") \"59\";\r\
    \n:set (\$charToDec->\"<\") \"60\";\r\
    \n:set (\$charToDec->\"=\") \"61\";\r\
    \n:set (\$charToDec->\">\") \"62\";\r\
    \n:set (\$charToDec->\"\?\") \"63\";\r\
    \n:set (\$charToDec->\"@\") \"64\";\r\
    \n:set (\$charToDec->\"A\") \"65\";\r\
    \n:set (\$charToDec->\"B\") \"66\";\r\
    \n:set (\$charToDec->\"C\") \"67\";\r\
    \n:set (\$charToDec->\"D\") \"68\";\r\
    \n:set (\$charToDec->\"E\") \"69\";\r\
    \n:set (\$charToDec->\"F\") \"70\";\r\
    \n:set (\$charToDec->\"G\") \"71\";\r\
    \n:set (\$charToDec->\"H\") \"72\";\r\
    \n:set (\$charToDec->\"I\") \"73\";\r\
    \n:set (\$charToDec->\"J\") \"74\";\r\
    \n:set (\$charToDec->\"K\") \"75\";\r\
    \n:set (\$charToDec->\"L\") \"76\";\r\
    \n:set (\$charToDec->\"M\") \"77\";\r\
    \n:set (\$charToDec->\"N\") \"78\";\r\
    \n:set (\$charToDec->\"O\") \"79\";\r\
    \n:set (\$charToDec->\"P\") \"80\";\r\
    \n:set (\$charToDec->\"Q\") \"81\";\r\
    \n:set (\$charToDec->\"R\") \"82\";\r\
    \n:set (\$charToDec->\"S\") \"83\";\r\
    \n:set (\$charToDec->\"T\") \"84\";\r\
    \n:set (\$charToDec->\"U\") \"85\";\r\
    \n:set (\$charToDec->\"V\") \"86\";\r\
    \n:set (\$charToDec->\"W\") \"87\";\r\
    \n:set (\$charToDec->\"X\") \"88\";\r\
    \n:set (\$charToDec->\"Y\") \"89\";\r\
    \n:set (\$charToDec->\"Z\") \"90\";\r\
    \n:set (\$charToDec->\"[\") \"91\";\r\
    \n:set (\$charToDec->\"]\") \"93\";\r\
    \n:set (\$charToDec->\"^\") \"94\";\r\
    \n:set (\$charToDec->\"_\") \"95\";\r\
    \n:set (\$charToDec->\"`\") \"96\";\r\
    \n:set (\$charToDec->\"a\") \"97\";\r\
    \n:set (\$charToDec->\"b\") \"98\";\r\
    \n:set (\$charToDec->\"c\") \"99\";\r\
    \n:set (\$charToDec->\"d\") \"100\";\r\
    \n:set (\$charToDec->\"e\") \"101\";\r\
    \n:set (\$charToDec->\"f\") \"102\";\r\
    \n:set (\$charToDec->\"g\") \"103\";\r\
    \n:set (\$charToDec->\"h\") \"104\";\r\
    \n:set (\$charToDec->\"i\") \"105\";\r\
    \n:set (\$charToDec->\"j\") \"106\";\r\
    \n:set (\$charToDec->\"k\") \"107\";\r\
    \n:set (\$charToDec->\"l\") \"108\";\r\
    \n:set (\$charToDec->\"m\") \"109\";\r\
    \n:set (\$charToDec->\"n\") \"110\";\r\
    \n:set (\$charToDec->\"o\") \"111\";\r\
    \n:set (\$charToDec->\"p\") \"112\";\r\
    \n:set (\$charToDec->\"q\") \"113\";\r\
    \n:set (\$charToDec->\"r\") \"114\";\r\
    \n:set (\$charToDec->\"s\") \"115\";\r\
    \n:set (\$charToDec->\"t\") \"116\";\r\
    \n:set (\$charToDec->\"u\") \"117\";\r\
    \n:set (\$charToDec->\"v\") \"118\";\r\
    \n:set (\$charToDec->\"w\") \"119\";\r\
    \n:set (\$charToDec->\"x\") \"120\";\r\
    \n:set (\$charToDec->\"y\") \"121\";\r\
    \n:set (\$charToDec->\"z\") \"122\";\r\
    \n:set (\$charToDec->\"{\") \"123\";\r\
    \n:set (\$charToDec->\"|\") \"124\";\r\
    \n:set (\$charToDec->\"}\") \"125\";\r\
    \n:set (\$charToDec->\"~\") \"126\";\r\
    \n\r\
    \n  :local base64Chars [:toarray \"\"];\r\
    \n:set (\$base64Chars->\"0\") \"A\";\r\
    \n:set (\$base64Chars->\"1\") \"B\";\r\
    \n:set (\$base64Chars->\"2\") \"C\";\r\
    \n:set (\$base64Chars->\"3\") \"D\";\r\
    \n:set (\$base64Chars->\"4\") \"E\";\r\
    \n:set (\$base64Chars->\"5\") \"F\";\r\
    \n:set (\$base64Chars->\"6\") \"G\";\r\
    \n:set (\$base64Chars->\"7\") \"H\";\r\
    \n:set (\$base64Chars->\"8\") \"I\";\r\
    \n:set (\$base64Chars->\"9\") \"J\";\r\
    \n:set (\$base64Chars->\"10\") \"K\";\r\
    \n:set (\$base64Chars->\"11\") \"L\";\r\
    \n:set (\$base64Chars->\"12\") \"M\";\r\
    \n:set (\$base64Chars->\"13\") \"N\";\r\
    \n:set (\$base64Chars->\"14\") \"O\";\r\
    \n:set (\$base64Chars->\"15\") \"P\";\r\
    \n:set (\$base64Chars->\"16\") \"Q\";\r\
    \n:set (\$base64Chars->\"17\") \"R\";\r\
    \n:set (\$base64Chars->\"18\") \"S\";\r\
    \n:set (\$base64Chars->\"19\") \"T\";\r\
    \n:set (\$base64Chars->\"20\") \"U\";\r\
    \n:set (\$base64Chars->\"21\") \"V\";\r\
    \n:set (\$base64Chars->\"22\") \"W\";\r\
    \n:set (\$base64Chars->\"23\") \"X\";\r\
    \n:set (\$base64Chars->\"24\") \"Y\";\r\
    \n:set (\$base64Chars->\"25\") \"Z\";\r\
    \n:set (\$base64Chars->\"26\") \"a\";\r\
    \n:set (\$base64Chars->\"27\") \"b\";\r\
    \n:set (\$base64Chars->\"28\") \"c\";\r\
    \n:set (\$base64Chars->\"29\") \"d\";\r\
    \n:set (\$base64Chars->\"30\") \"e\";\r\
    \n:set (\$base64Chars->\"31\") \"f\";\r\
    \n:set (\$base64Chars->\"32\") \"g\";\r\
    \n:set (\$base64Chars->\"33\") \"h\";\r\
    \n:set (\$base64Chars->\"34\") \"i\";\r\
    \n:set (\$base64Chars->\"35\") \"j\";\r\
    \n:set (\$base64Chars->\"36\") \"k\";\r\
    \n:set (\$base64Chars->\"37\") \"l\";\r\
    \n:set (\$base64Chars->\"38\") \"m\";\r\
    \n:set (\$base64Chars->\"39\") \"n\";\r\
    \n:set (\$base64Chars->\"40\") \"o\";\r\
    \n:set (\$base64Chars->\"41\") \"p\";\r\
    \n:set (\$base64Chars->\"42\") \"q\";\r\
    \n:set (\$base64Chars->\"43\") \"r\";\r\
    \n:set (\$base64Chars->\"44\") \"s\";\r\
    \n:set (\$base64Chars->\"45\") \"t\";\r\
    \n:set (\$base64Chars->\"46\") \"u\";\r\
    \n:set (\$base64Chars->\"47\") \"v\";\r\
    \n:set (\$base64Chars->\"48\") \"w\";\r\
    \n:set (\$base64Chars->\"49\") \"x\";\r\
    \n:set (\$base64Chars->\"50\") \"y\";\r\
    \n:set (\$base64Chars->\"51\") \"z\";\r\
    \n:set (\$base64Chars->\"52\") \"0\";\r\
    \n:set (\$base64Chars->\"53\") \"1\";\r\
    \n:set (\$base64Chars->\"54\") \"2\";\r\
    \n:set (\$base64Chars->\"55\") \"3\";\r\
    \n:set (\$base64Chars->\"56\") \"4\";\r\
    \n:set (\$base64Chars->\"57\") \"5\";\r\
    \n:set (\$base64Chars->\"58\") \"6\";\r\
    \n:set (\$base64Chars->\"59\") \"7\";\r\
    \n:set (\$base64Chars->\"60\") \"8\";\r\
    \n:set (\$base64Chars->\"61\") \"9\";\r\
    \n:set (\$base64Chars->\"62\") \"+\";\r\
    \n:set (\$base64Chars->\"63\") \"/\";\r\
    \n\r\
    \n#:put \$charToDec;\r\
    \n#:put \$base64Chars;\r\
    \n\r\
    \n  :local rr \"\"; \r\
    \n  :local p \"\";\r\
    \n  :local s \"\";\r\
    \n  :local cLenForString ([:len \$stringVal]);\r\
    \n  :local cModVal ( \$cLenForString % 3);\r\
    \n  :local stringLen ([:len \$stringVal]);\r\
    \n  :local returnVal;\r\
    \n\r\
    \n  if (\$cLenForString > 0) do={\r\
    \n    :local startEncode 0;\r\
    \n\r\
    \n    :if (\$cModVal > 0) do={\r\
    \n       for val from=(\$cModVal+1) to=3 do={\r\
    \n          :set p (\$p.\"=\"); \r\
    \n          :set s (\$s.\"0\"); \r\
    \n          :set cModVal (\$cModVal + 1);\r\
    \n        }\r\
    \n    }\r\
    \n\r\
    \n    :local firstIndex 0;\r\
    \n    :while ( \$firstIndex < \$stringLen ) do={\r\
    \n\r\
    \n        if ((\$cModVal > 0) && ((((\$cModVal / 3) *4) % 76) = 0) ) do={\r\
    \n          :set rr (\$rr . \"\\ r \\ n\");\r\
    \n        }\r\
    \n\r\
    \n        :local charVal1 ([:pick \"\$stringVal\" \$firstIndex (\$firstIndex + 1)]);\r\
    \n        :local charVal2 ([:pick \$stringVal (\$firstIndex + 1) (\$firstIndex + 2)]);\r\
    \n        :local charVal3 ([:pick \$stringVal (\$firstIndex+2) (\$firstIndex + 3)]);\r\
    \n\r\
    \n        :local n1Shift ([:tonum (\$charToDec->\$charVal1)] << 16);\r\
    \n        :local n2Shift ([:tonum (\$charToDec->\$charVal2)] << 8);\r\
    \n        :local n3Shift [:tonum (\$charToDec->\$charVal3)];\r\
    \n\r\
    \n        :local mergeShift ((\$n1Shift +\$n2Shift) + \$n3Shift);\r\
    \n\r\
    \n        :local n \$mergeShift;\r\
    \n        :set n ([:tonum \$n]);\r\
    \n\r\
    \n        :local n1 (n >>> 18);\r\
    \n\r\
    \n        :local n2 (n >>> 12);\r\
    \n\r\
    \n        :local n3 (n >>> 6);\r\
    \n          \r\
    \n        :local arrayN [:toarray \"\" ];\r\
    \n        :set arrayN ( \$arrayN, (n1 & 63));\r\
    \n        :set arrayN ( \$arrayN, (n2 & 63));\r\
    \n        :set arrayN ( \$arrayN, (n3 & 63));\r\
    \n        :set arrayN ( \$arrayN, (n & 63));\r\
    \n\r\
    \n        :set n (\$arrayN);\r\
    \n\r\
    \n        :local n1Val ([:pick \$n 0]);\r\
    \n        :set n1Val ([:tostr \$n1Val]);\r\
    \n\r\
    \n        :local n2Val ([:pick \$n 1]);\r\
    \n        :set n2Val ([:tostr \$n2Val]);\r\
    \n\r\
    \n        :local n3Val ([:pick \$n 2]);\r\
    \n        :set n3Val ([:tostr \$n3Val]);\r\
    \n\r\
    \n        :local n4Val ([:pick \$n 3]);\r\
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
    \n      :local rLen ([:len \$rr]);\r\
    \n      :local pLen ([:len \$p]);\r\
    \n\r\
    \n      :set returnVal ([:pick \"\$rr\" 0 (\$rLen - \$pLen)]);\r\
    \n      :set returnVal (\$returnVal . \$p);\r\
    \n      :set startEncode 1;\r\
    \n      :return \$returnVal;\r\
    \n     \r\
    \n    } on-error={\r\
    \n      :set returnVal (\"Error: Base64 encode error.\");\r\
    \n      :return \$returnVal;\r\
    \n    }\r\
    \n\r\
    \n  } else={\r\
    \n    :set returnVal (\"Error: Base64 encode error, likely an empty value.\");\r\
    \n    :return \$returnVal;\r\
    \n  }\r\
    \n  \r\
    \n}\r\
    \n\r\
    \n:global urlEncodeFunct do={\r\
    \n  #:put \"\$currentUrlVal\"; \r\
    \n  #:put \"\$urlVal\"\r\
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
    \n:global Split do={\r\
    \n\r\
    \n  :local input \$1;\r\
    \n  :local delim \$2;\r\
    \n\r\
    \n  #:put \"Split()\";\r\
    \n  #:put \"INPUT: \$input\";\r\
    \n  #:put \"DELIMETER: \$delim\";\r\
    \n\r\
    \n  :local strElem;\r\
    \n  :local arr [:toarray \"\"];\r\
    \n  :local arrIndex 0;\r\
    \n\r\
    \n  :for c from=0 to=[:len \$input] do={\r\
    \n\r\
    \n    :local ch [:pick \$input \$c (\$c+1)];\r\
    \n    #:put \"ch \$c: \$ch\";\r\
    \n\r\
    \n    if (\$ch = \$delim) do={\r\
    \n\r\
    \n      if ([:len \$strElem] > 0) do={\r\
    \n        #:put \"found strElem: \$strElem\";\r\
    \n        :set (\$arr->\$arrIndex) \$strElem;\r\
    \n        :set arrIndex (\$arrIndex+1);\r\
    \n        :set strElem \"\";\r\
    \n      }\r\
    \n\r\
    \n    } else={\r\
    \n      :set strElem (\$strElem . \$ch);\r\
    \n    }\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n  #:put \"last strElem: \$strElem\";\r\
    \n  :set (\$arr->\$arrIndex) \$strElem;\r\
    \n\r\
    \n  :return \$arr;\r\
    \n\r\
    \n}\r\
    \n\r\
    \n# routeros 0w0d0m0s to seconds\r\
    \n:global rosTsSec do={\r\
    \n\r\
    \n  :local input \$1;\r\
    \n\r\
    \n  #:put \"rosTsSec \$input\";\r\
    \n\r\
    \n  :local upSeconds 0;\r\
    \n\r\
    \n  :local weeks 0;\r\
    \n  if (([:find \$input \"w\"]) > 0 ) do={\r\
    \n    :set weeks ([:pick \$input 0 ([:find \$input \"w\"])]);\r\
    \n    :set input [:pick \$input ([:find \$input \"w\"]+1) [:len \$input]];\r\
    \n  }\r\
    \n  :local days 0;\r\
    \n  if (([:find \$input \"d\"]) > 0 ) do={\r\
    \n    :set days ([:pick \$input 0 [:find \$input \"d\"]]);\r\
    \n    :set input [:pick \$input ([:find \$input \"d\"]+1) [:len \$input]];\r\
    \n  }\r\
    \n\r\
    \n  :local hours [:pick \$input 0 [:find \$input \":\"]];\r\
    \n  :set input [:pick \$input ([:find \$input \":\"]+1) [:len \$input]];\r\
    \n\r\
    \n  :local minutes [:pick \$input 0 [:find \$input \":\"]];\r\
    \n  :set input [:pick \$input ([:find \$input \":\"]+1) [:len \$input]];\r\
    \n\r\
    \n  :local upSecondVal 0;\r\
    \n  :set upSecondVal \$input;\r\
    \n\r\
    \n  :set upSeconds value=[:tostr ((\$weeks*604800)+(\$days*86400)+(\$hours*3600)+(\$minutes*60)+\$upSecondVal)];\r\
    \n\r\
    \n  return \$upSeconds;\r\
    \n\r\
    \n}\r\
    \n\r\
    \n# routeros timestamp string to seconds\r\
    \n:global rosTimestringSec do={\r\
    \n\r\
    \n  :global Split;\r\
    \n\r\
    \n  :local input \$1;\r\
    \n\r\
    \n  # split the date and the time from \$input\r\
    \n  :local dateTimeSplit [\$Split \$input \" \"];\r\
    \n\r\
    \n  # date Dec/21/2021 or dec/21/2021\r\
    \n  :local buildDate (\$dateTimeSplit->0);\r\
    \n  # time 11:53:05\r\
    \n  :local buildTimeValue (\$dateTimeSplit->1);\r\
    \n\r\
    \n  # parse the date\r\
    \n  # this needs to conver tto UTC\r\
    \n  :local month [:pick \$buildDate 0 3];\r\
    \n  :local day [:pick \$buildDate 4 6];\r\
    \n  :local year [:pick \$buildDate 7 11];\r\
    \n\r\
    \n  :local Months [:toarray \"Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec\"];\r\
    \n  :local months [:toarray \"jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec\"];\r\
    \n\r\
    \n  :local monthInt 0;\r\
    \n\r\
    \n  # routeros uses lowercase and starting with uppercase strings for the 3 character month prefix\r\
    \n  for i from=0 to=([:len \$months] - 1) do={\r\
    \n    :local m (\$months->\$i);\r\
    \n\r\
    \n    if (\$m = \$month) do={\r\
    \n      :set monthInt \$i;\r\
    \n    }\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n  # routeros uses lowercase and starting with uppercase strings for the 3 character month prefix\r\
    \n  for i from=0 to=([:len \$Months] - 1) do={\r\
    \n    :local m (\$Months->\$i);\r\
    \n\r\
    \n    if (\$m = \$month) do={\r\
    \n      :set monthInt \$i;\r\
    \n    }\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n  # increment the monthInt by one because the index starts at 0\r\
    \n  :set monthInt (\$monthInt + 1);\r\
    \n\r\
    \n  # convert the day and year to numbers\r\
    \n  :local dayInt [:tonum \$day];\r\
    \n  :local yearInt [:tonum \$year];\r\
    \n\r\
    \n  # number of seconds since epoch\r\
    \n  # jan 1st 1970 UTC\r\
    \n  :local epochMonthInt 1;\r\
    \n  :local epochDayInt 1;\r\
    \n  :local epochYearInt 1970;\r\
    \n\r\
    \n  # get the difference between now and then for the date parts\r\
    \n  :local monthDiff (\$monthInt - \$epochMonthInt);\r\
    \n  :local dayDiff (\$dayInt - \$epochDayInt);\r\
    \n  :local yearDiff (\$yearInt - \$epochYearInt);\r\
    \n\r\
    \n  # for every 4 years add 1 day for leap years\r\
    \n  # routeros has no float support\r\
    \n  :local leapSecondsInDatePart 0;\r\
    \n  :local isFour 0;\r\
    \n  for i from=0 to=\$yearDiff do={\r\
    \n\r\
    \n    :set isFour (\$isFour + 1);\r\
    \n\r\
    \n    if (\$isFour = 4) do={\r\
    \n      # add one day of seconds\r\
    \n      :set leapSecondsInDatePart (\$leapSecondsInDatePart + (24 * 60 * 60));\r\
    \n      :set isFour 0;\r\
    \n    }\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n  # convert to seconds\r\
    \n  # the months need to have their days calculated correctly\r\
    \n  # all have 31 except\r\
    \n  # feb has 28, and 29 in leap years\r\
    \n  # apr, jun, sep and nov have 30\r\
    \n  # in october this is ~3 days off\r\
    \n  :local monthDiffSec (\$monthDiff * 30 * 24 * 60 * 60);\r\
    \n  :local dayDiffSec (\$dayDiff * 24 * 60 * 60);\r\
    \n  :local yearDiffSec (\$yearDiff * 365 * 24 * 60 * 60);\r\
    \n\r\
    \n  # get the date part difference in seconds since the unix epoch per field\r\
    \n  :local datePartDiffSec (\$monthDiffSec + \$dayDiffSec + \$yearDiffSec);\r\
    \n\r\
    \n  # get the time parts\r\
    \n  :local hour [:tonum [:pick \$buildTimeValue 0 2]];\r\
    \n  :local minute [:tonum [:pick \$buildTimeValue 3 5]];\r\
    \n  :local second [:tonum [:pick \$buildTimeValue 6 8]];\r\
    \n\r\
    \n  # convert the time parts to seconds\r\
    \n  :set hour (\$hour * 60 * 60);\r\
    \n  :set minute (\$minute * 60);\r\
    \n\r\
    \n  # get the time part difference in seconds since the unix epoch per field\r\
    \n  :local timePartDiffSec (\$hour + \$minute + \$second);\r\
    \n\r\
    \n  # return the sum of the seconds since epoch of the date and seconds in the time\r\
    \n  # with leap year days added\r\
    \n  :return (\$datePartDiffSec + \$timePartDiffSec + \$leapSecondsInDatePart);\r\
    \n\r\
    \n}\r\
    \n\r\
    \n"