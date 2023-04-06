![ISPApp Logo](/img/logo.png)

Learn more at https://ispapp.co

Watch a YouTube Video about how ISPApp can help you - https://www.youtube.com/watch?v=BQN8FdMqApo

# about

This is an ISPApp client which is designed to monitor Mikrotik hosts running RouterOS.

ISPApp allows you to monitor thousands of hosts or IoT devices quickly and easily with high resolution charts and realtime data.

It will automatically monitor a host when this script is ran on that host and send ISPApp data to generate realtime, daily, weekly, monthly and annual charts for:

* All Network Interfaces - Traffic and Packet Rate
![Traffic](/img/if-traffic.png)
* All Wireless Interfaces - RSSI and Traffic per Connected Station, # of Stations per Interface
![RSSI](/img/rssi.png)
* All System Disks - Total, Used and Available Disk Space
![Disk](/img/disk.png)
* System Load
![Load](/img/load.png)
* System Memory
![Memory](/img/memory.png)
* Ping to a Host - Average, Maximum and Minimum RTT + Total Loss
![Ping](/img/ping.png)
* Environment - Temperature, Humidity, Precipitation, Barometric Pressure and others
* Industrial Sensors - Gas Levels, Pressure, Fill Levels, Rotation and Positioning Data
* Vehicle Data - Torque, Fuel Rate and others
* Electronic Data - Voltage, Power and Current
* Request Data - HTTP Request Rate, DNS Request Rate, Rate of Incoming Emails etc (easily added to software with our REST API)

ISPApp also provides outage notifications and maintenance/degradation analysis for each of the monitored data types.

We have ISPApp Instances running with tens of thousands of charts and are ready for you to be a customer.

ISPApp Instances are private, once we are out of Beta we will not have access to your Data like Google and Facebook do.

# installation

1. Download the ispapp.rsc file
2. Modify the `topDomain` and `topKey` declarations at the top of the script for your ISPApp instance
3. Copy the contents of the file and paste it into the RouterOS command line or upload the file to the RouterOS device and run
	`/import ispapp.rsc`

That's all, you will now see the host in ISPApp.

# Setting changes on the routers

The ISPApp RouterOS client script modifies the following settings on the routers:

* Sets the **system identity** to the hostname on the server.
* If there is not an admin password then the script sets an **admin password** to the key value on the server.
* If you set the Wi-Fi network name and password on the server then the script sets the Wi-Fi **SSID** and **wireless security profile** on the router.
* The script configures an **email server** to get around the [4096 byte limit](https://forum.mikrotik.com/viewtopic.php?t=127093) for RouterOS variables.
* Creates **system scripts** and **system schedules** to gather the performance info of the router and send it to the server on regular intervals, backup the configuration to the server, and provide web shell functionality.

# modification

Modify the script in winbox, and once you have made the changes you need to ssh to the device and run:

```
/system script export terse
```

Copy the exported data and paste it to a text editor between where `/system script` and `/system schedule` exists in the current version of the script.

You will need to modify part of the `globalScript` before commiting new changes because that is where the topN global variables are persistently stored.

RouterOS does not store environment variables or files with reboot or upgrade persistence.

Change the section that looks like this:

```
    \n:set \$topKey (\"ghsfhfgsjhnadfgasdjflashgjkladfhjkgasdgsdfgsdfgsdfgsdfg\");\r\
    \n:set \$topDomain (\"dev.ispapp.co\");\r\
    \n:set \$topClientInfo (\"RouterOS-v0.23\");\r\
    \n:set \$topListenerPort (\"8550\");\r\
    \n:set \$topServerPort (\"443\");\r\
    \n:set \$topSmtpPort (\"465\");\r\
```

To:

```
    \n:set \$topKey (\"$topKey\");\r\
    \n:set \$topDomain (\"$topDomain\");\r\
    \n:set \$topClientInfo (\"$topClientInfo\");\r\
    \n:set \$topListenerPort (\"$topListenerPort\");\r\
    \n:set \$topServerPort (\"$topServerPort\");\r\
    \n:set \$topSmtpPort (\"$topSmtpPort\");\r\
```

This will allow the script to again be copied and pasted without trouble.  Also make sure to remove any scripts from the `/system script export` that aren't part of ispapp-routeros-client.

# license

The project ispapp-routeros-client is licensed per the MIT License

A copy is in the project directory, as a file named LICENSE

# create v2 of mikrotik script Separating code
