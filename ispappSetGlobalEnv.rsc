/system script add dont-require-permissions=no name=ispappSetGlobalEnv owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":global startEncode 1;\r\
    \n:global isSend 1;\r\
    \n\r\
    \n:global topKey (\$topKey);\r\
    \n:global topDomain (\$topDomain);\r\
    \n:global topClientInfo (\$topClientInfo);\r\
    \n:global topListenerPort (\$topListenerPort);\r\
    \n:global topServerPort (\$topServerPort);\r\
    \n:global topSmtpPort (\$topSmtpPort);\r\
    \n\r\
    \n# setup email server\r\
    \n/tool e-mail set address=(\$topDomain);\r\
    \n/tool e-mail set port=(\$topSmtpPort);\r\
    \n\r\
    \n:local ROSver value=[:tostr [/system resource get value-name=version]];\r\
    \n:local ROSverH value=[:pick \$ROSver 0 ([:find \$ROSver \".\" -1]) ];\r\
    \n:global rosMajorVersion value=[:tonum \$ROSverH];\r\
    \n\r\
    \n:if (\$rosMajorVersion = 7) do={\r\
    \n  #:put \">= 7\";\r\
    \n  :execute script=\"/tool e-mail set tls=yes\";\r\
    \n}\r\
    \n\r\
    \n:if (\$rosMajorVersion = 6) do={\r\
    \n  #:put \"not >= 7\";\r\
    \n  :execute script=\"/tool e-mail set start-tls=tls-only\";\r\
    \n}\r\
    \n\r\
    \n:global currentUrlVal;\r\
    \n\r\
    \n# Get login from MAC address of an interface\r\
    \n:local l \"\";\r\
    \n\r\
    \n:do {\r\
    \n  :set l ([/interface get [find default-name=wlan1] mac-address]);\r\
    \n} on-error={\r\
    \n  :do {\r\
    \n    :set l ([/interface get [find default-name=ether1] mac-address]);\r\
    \n  } on-error={\r\
    \n    :do {\r\
    \n      :set l ([/interface get [find default-name=sfp-sfpplus1] mac-address]);\r\
    \n    } on-error={\r\
    \n      :do {\r\
    \n        :set l ([/interface get [find default-name=lte1] mac-address]);\r\
    \n      } on-error={\r\
    \n        :log info (\"No Interface MAC Address found to use as ISPApp login, default-name=wlan1, ether1, sfp-sfpplus1 or lte1 must exist.\");\r\
    \n      }\r\
    \n    }\r\
    \n  }\r\
    \n}\r\
    \n\r\
    \n:local new \"\";\r\
    \n# Convert to lowercase\r\
    \n:local low (\"a\",\"b\",\"c\",\"d\",\"e\",\"f\",\"g\",\"h\",\"i\",\"j\",\"k\",\"l\",\"m\",\"n\",\"o\",\"p\",\"q\",\"r\",\"s\",\"t\",\"u\",\"v\",\"w\",\"x\",\"y\",\"z\");\r\
    \n:local upp (\"A\",\"B\",\"C\",\"D\",\"E\",\"F\",\"G\",\"H\",\"I\",\"J\",\"K\",\"L\",\"M\",\"N\",\"O\",\"P\",\"Q\",\"R\",\"S\",\"T\",\"U\",\"V\",\"W\",\"X\",\"Y\",\"Z\");\r\
    \n\r\
    \n:for i from=0 to=([:len \$l] - 1) do={\r\
    \n  :local char [:pick \$l \$i];\r\
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
    \n:global login \"00:00:00:00:00:00\";\r\
    \n:if ([:len \$new] > 0) do={\r\
    \n:set login \$new;\r\
    \n}\r\
    \n\r\
    \n#:put (\"ispappSetGlobalEnv executed, login: \$login\");"