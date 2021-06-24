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
2. Modify the `topUrl` and `topKey` declarations at the top of the script for your ISPApp instance
3. Copy the contents of the file and paste it into the RouterOS command line or upload the file to the RouterOS device and run
	`/import ispapp.rsc`

That's all, you will now see the host in ISPApp.

# license

The project ispapp-routeros-client is licensed per the GNU General Public License, version 2

A copy is in the project directory, as a file named LICENSE
