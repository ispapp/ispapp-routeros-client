/system script add dont-require-permissions=no name=ispappRemoveConfiguration owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="# remove existing ispapp configuration\r\
    \n:local hasWirelessConfigurationMenu 0;\r\
    \n:local hasWifiwave2ConfigurationMenu 0;\r\
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
    \nif (\$hasWirelessConfigurationMenu = 1) do={\r\
    \n\r\
    \n  # remove existing ispapp security profiles\r\
    \n  :foreach wSpId in=[/interface wireless security-profiles find] do={\r\
    \n\r\
    \n   :local wSpName ([/interface wireless security-profiles get \$wSpId name]);\r\
    \n   :local isIspappSp ([:find \$wSpName \"ispapp-\"]);\r\
    \n\r\
    \n   if (\$isIspappSp = 0) do={\r\
    \n     # remove existing ispapp security profile\r\
    \n     /interface wireless security-profiles remove \$wSpName;\r\
    \n   }\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n  # remove existing ispapp vaps and bridge ports\r\
    \n  :foreach wIfaceId in=[/interface wireless find] do={\r\
    \n\r\
    \n   :local wIfName ([/interface wireless get \$wIfaceId name]);\r\
    \n   :local wIfSsid ([/interface wireless get \$wIfaceId ssid]);\r\
    \n   :local isIspappIf ([:find \$wIfName \"ispapp-\"]);\r\
    \n   :local wIfType ([/interface wireless get \$wIfaceId interface-type]);\r\
    \n   :local wComment ([/interface wireless get \$wIfaceId comment]);\r\
    \n\r\
    \n   if (\$wIfType != \"virtual\" && \$wComment = \"ispapp\") do={\r\
    \n     :do {\r\
    \n       # set the comment to \"\" on the physical interface to know it was not configured by ispapp\r\
    \n       /interface wireless set comment=\"\" \$wIfaceId;\r\
    \n     } on-error={\r\
    \n     }\r\
    \n   }\r\
    \n\r\
    \n   if (\$isIspappIf = 0) do={\r\
    \n     #:put \"deleting virtual ispapp interface: \$wIfName\";\r\
    \n     /interface wireless remove \$wIfName;\r\
    \n   }\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n}\r\
    \n\r\
    \nif (\$hasWifiwave2ConfigurationMenu = 1) do={\r\
    \n  :foreach wIfaceId in=[/interface wifiwave2 find] do={\r\
    \n\r\
    \n    :local wIfName ([/interface wifiwave2 get \$wIfaceId name]);\r\
    \n    :local wIfMasterIf ([/interface wifiwave2 get \$wIfaceId master-interface]);\r\
    \n    :local wIfComment ([/interface wifiwave2 get \$wIfaceId comment]);\r\
    \n\r\
    \n    if ([:len \$wIfMasterIf] = 0) do={\r\
    \n      # this is a physical interface\r\
    \n      :do {\r\
    \n       # set the comment to \"\" on the physical interface to know it was not configured by ispapp\r\
    \n       /interface wifiwave2 set comment=\"\" \$wIfaceId;\r\
    \n     } on-error={\r\
    \n     }\r\
    \n      \r\
    \n    } else={\r\
    \n      # this is not a physical interface\r\
    \n      if (\$wIfComment = \"ispapp\") do={\r\
    \n        # remove this virtual ispapp wifiwave2 interface\r\
    \n        /interface wifiwave2 remove \$wIfaceId;\r\
    \n      }\r\
    \n    }\r\
    \n\r\
    \n  }\r\
    \n  }"