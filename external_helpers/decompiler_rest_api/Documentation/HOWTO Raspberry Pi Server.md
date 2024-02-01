# **HOWTO Raspberry Pi Server**

<img src="C:\Users\thoma\OneDrive - EDV-Beratung und Softwareentwicklung\HOWTO raspi-Dateien\raspi-final.jpg" style="zoom:80%;" />



# Inhaltsverzeichnis

[TOC]



# Raspberry Pi 4



## Hardware

Das Raspberry Pi 4 Model B ist mit einem Broadcom 2711, Quad-core CortexA72 64-bit SoC @ 1.5GHz sowie 8 GB SDRAM ausgestattet.

<img src="C:\Users\thoma\OneDrive - EDV-Beratung und Softwareentwicklung\HOWTO raspi-Dateien\image003.png" style="zoom:75%;" />

Weitere Details sind:

- 2.4GHz / 5.0GHz IEEE 802.11.b/g/n/ac Wireless LAN integriert

- Bluetooth 5.0, BLE

- 2 x USB 2.0 / 2 x USB 3.0 Ports 

- ein "echter" Gigabit Ethernet RJ45 Port
- HAT kompatibler 40-pin GPIO Header
- 2 x Micro HDMI
- 4K Video 1 X MIPI
- DSI Display Port
- 1 X MIPI CSI Camera Port
- 4 poliger Stereo Audio und Composite Video
- H.265 decode (4kp60)
- H.264 decode (1080p60)
- H.264 encode (1080p30)
- OpenGL ES 1.1, 2.0, 3.0 graphics
- Micro SD für OS & Datenspeicherung
- 5V/3A DC via USB type C Connector
- 5V DC via GPIO
- PoE fähig über optionale HAT Erweiterung



## Gehäuse

The Argon ONE M.2 Case ups the ante by providing the following:

- Two full-sized HDMI ports 

- Power Management Modes

- Built-in IR support 

- Integrated M.2 SATA SSD support

  ![](C:\Users\thoma\OneDrive - EDV-Beratung und Softwareentwicklung\HOWTO raspi-Dateien\image006.jpg)

  Argon ONE M.2 Case extended support for M.2 SATA SSDs allows you to maximize the true potential speeds of your Raspberry Pi 4. You will now be able to boot via an M.2 SATA SSD for faster boot times and larger storage capacity compared to the traditional microSD Card.

  Argon ONE M.2 is UASP Supported for the Raspberry Pi 4 which means you can maximize the transfer speeds of your M.2 SATA Drive.

  It is compatible with any M.2 SATA SSD with Key-B and Key B&M.



# Booten von der SSD



## Quellen

- [How to Boot a Raspberry Pi From SSD and Use It for Permanent Storage (makeuseof.com)](https://www.makeuseof.com/how-to-boot-raspberry-pi-ssd-permanent-storage/)
- [Raspberry Pi OS – Raspberry Pi](https://www.raspberrypi.com/software/)



## Things You Will Need

You will need the following items to enable SSD boot on Raspberry Pi.

- Raspberry Pi (4, 400, 3, Zero W, or Zero 2W model)
- microSD card (1GB minimum, 64GB maximum)
- microSD card reader
- Keyboard and mouse (both wireless or wired will work)—not required     if you want to enable SSD boot on a Raspberry Pi 4 or Pi 400
- Any type of external SSD (such as M.2, SATA, or NVMe/PCIe)



## Boot Raspberry Pi 4 from SSD

To boot Raspberry Pi 4 or Raspberry Pi 400 from SSD, you must enable USB boot:

1. Connect the microSD card to another computer using a card reader.
2. Download, install, and launch the [Raspberry Pi Imager](https://www.raspberrypi.com/software/) tool on your Windows, Linux, or Mac system.
3. Click the Choose OS button and then click Misc Utility Images > Bootloader > USB Boot.
4. Click the Choose Storage button and select the microSD card connected to your system.
5. Click Write and wait for the flash process to complete. It will take a few seconds only.
6. After the flash process, the microSD card is auto-ejected. Disconnect the microSD card from the system and insert it into the microSD slot of your Raspberry Pi 4 or 400.
7. Connect the power supply to the Raspberry Pi to turn it on. The Pi will automatically read and flash the USB bootloader from the connected     microSD card. This takes a few seconds.
8. When the flash is successful, the green LED light on the Raspberry Pi starts blinking steadily. To confirm further, connect the HDMI port to a display. If the display shows a green screen, it indicates that the flash process is complete.
9. Turn off the Raspberry Pi and disconnect or remove the microSD     card.



## Prepare Bootable Raspberry Pi SSD

To boot the Raspberry Pi via SSD, you must install an operating system, such as Raspberry Pi OS on the SSD by using Raspberry Pi Imager. After writing the OS, you can connect the SSD to the Raspberry Pi via a USB port and boot the OS from the SSD. To prepare the SSD for boot, follow these steps:

1. Launch the Raspberry Pi Imager tool and connect your external SSD     to the system via a USB port.
2. Click Choose OS to select the desired OS from the list. If you want to flash a downloaded OS image, you can use the file by     clicking on the Custom option and then selecting the OS file from your system.
3. Click Choose Storage to select the connected SSD storage media.
4. Click the Write button.
5. After the OS is flashed on the SSD, dismount the drive and then connect the USB drive to one of the USB 3.0 or 2.0 ports on your Raspberry     Pi 4/400, Raspberry Pi 3 (or to Zero W/2W’s micro-USB port via an     adapter).
6. Connect the power supply to turn on the Raspberry Pi.
7. The Raspberry Pi will check for a bootable SSD connected to the USB     port and boot the operating system.



## Raspberry PI Imager

<img src="C:\Users\thoma\OneDrive - EDV-Beratung und Softwareentwicklung\HOWTO raspi-Dateien\image007.png" style="zoom:50%;" />

| Auswahlmöglichkeit |                                                              |
| ------------------ | ------------------------------------------------------------ |
| Betriebssystem     | RASPBERRY PI OS LITE (64-BIT)                                |
| SD-Karte           | SSD-Karte                                                    |
| Einstellungen      | WLAN aktivieren<br />SSH aktivieren<br />Passwort setzen<br />Tastaturlayout DE |



# Installation SSH



## Quellen

- [How to Enable SSH on Raspberry Pi- Definitive Guide (phoenixnap.com)](https://phoenixnap.com/kb/enable-ssh-raspberry-pi#:~:text=To enable SSH using the raspi-config tool%3A 1,SSH server is enabled” confirmation box. Weitere Elemente)



## Installation

```
sudo raspi-config
```

<img src="C:\Users\thoma\OneDrive - EDV-Beratung und Softwareentwicklung\HOWTO raspi-Dateien\image009.png" style="zoom:50%;" />

Alternativ

```
sudo systemctl enable ssh
sudo systemctl start ssh
```



# Update Raspberry PiOS

```
sudo apt update
sudo apt full-upgrade
```



# Installation Midnight Commander

```
sudo apt-get install mc
```

Hinweis: immer als root ausführen

```
sudo mc
```

<img src="C:\Users\thoma\OneDrive - EDV-Beratung und Softwareentwicklung\HOWTO raspi-Dateien\image011.png" style="zoom:50%;" />



# Installation Apache2



## Quellen

- [How to Setup a Raspberry Pi Apache Web Server - Pi My Life Up](https://pimylifeup.com/raspberry-pi-apache/)



## Installation

```
sudo apt-get install apache2
```



## Konfiguration

Nach der Installation lauscht der Webserver Apache 2 auf dem Port 80.  Eine Änderung erolgt in der Datei $/etc/apache2/ports.conf$ mit dem Befehl `listen  to`

```
sudo nano /etc/apache2/ports.conf
```

Anschließend ist die Änderung der Konfiguration zu laden und der Webserver neu zu starten.

```
sudo systemctl reload apache2
```



# Installation nagios



## Quellen

- [Installing Nagios on the Raspberry Pi - Pi My Life Up](https://pimylifeup.com/raspberry-pi-nagios/)
- [Nagios Core - Installing Nagios Core From Source](https://support.nagios.com/kb/article/nagios-core-installing-nagios-core-from-source-96.html#Raspbian)
- [Nagios - Ports and Protocols (tutorialspoint.com)](https://www.tutorialspoint.com/nagios/nagios_ports_and_protocols.htm)
- [Nagios - The Industry Standard In IT Infrastructure Monitoring](https://www.nagios.org/)



## Installation

This guide is based on SELinux being disabled or in permissive mode. SELinux is not enabled by default on Debian. If you would like to see if it is installed run the following command:

```
sudo dpkg -l selinux*
```

### **Prerequisites**

Perform these steps to install the pre-requisite packages.

```
sudo apt-get update
sudo apt-get install -y autoconf gcc libc6 make wget unzip apache2 apache2-utils php libgd-dev
sudo apt-get install openssl libssl-dev
```

 

### **Downloading the Source**

```
cd /tmp
wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.6.tar.gz
tar xzf nagioscore.tar.gz
```

 

### **Compile**

```
cd /tmp/nagioscore-nagios-4.4.6/
sudo ./configure --with-httpd-conf=/etc/apache2/sites-enabled
sudo make all
```

 

### **Create User And Group**

This creates the nagios user and group. The www-data user is also added to the nagios group.

```
sudo make install-groups-users
sudo usermod -a -G nagios www-data
```

 add password for user

```
sudo passwd nagios
```



### **Install Binaries**

This step installs the binary files, CGIs, and HTML files.

```
sudo make install
```

 

### **Install Service/Daemon**

This installs the service or daemon files and also configures them to start on boot.

```
sudo make install-daemoninit
```

 

Information on starting and stopping services will be explained further on.

 

### **Install Command Mode**

This installs and configures the external command file.

```
sudo make install-commandmode
```



### **Install Configuration Files**

This installs the *SAMPLE* configuration files. These are required as Nagios needs some configuration files to allow it to start.

```
sudo make install-config
```

 

### **Install Apache Config Files**

This installs the Apache web server configuration files and configures the Apache settings.

```
sudo make install-webconf
sudo a2enmod rewrite
sudo a2enmod cgi
```

 

### **Configure Firewall**

You need to allow port 80 inbound traffic on the local firewall so you can reach the Nagios Core web interface.

```
sudo iptables -I INPUT -p tcp --destination-port 80 -j ACCEPT
sudo apt-get install -y iptables-persistent
```

Answer yes to saving existing rules

 

### **Create nagiosadmin User Account**

You'll need to create an Apache user account to be able to log into Nagios.

The following command will create a user account called nagiosadmin and you will be prompted to provide a password for the account.

```
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
```

 

When adding additional users in the future, you need to remove **-c** from the above command otherwise it will replace the existing nagiosadmin user *(and any other users you may have added)*.

 

### **Start Apache Web Server**

Need to restart it because it is already running.

```
sudo systemctl restart apache2.service
```

 

### **Start Service/Daemon**

This command starts Nagios Core.

```
sudo systemctl start nagios.service
```

 

### **Test Nagios**

Nagios is now running, to confirm this you need to log into the Nagios Web Interface.

Point your web browser to the ip address or FQDN of your Nagios Core server, for example *`http://192.168.xxx.yyy/nagios`* 

You will be prompted for a username and password. The username is nagiosadmin (you created it in a previous step) and the password is what you provided earlier.

Once you have logged in you are presented with the Nagios interface. Congratulations you have installed Nagios Core.

**BUT WAIT ...**

Currently you have only installed the Nagios Core engine. You'll notice some errors under the hosts and services along the lines of:

```
(No output on stdout) stderr: execvp(/usr/local/nagios/libexec/check_load, ...) failed. errno is 2: No such file or directory 
```

These errors will be resolved once you install the Nagios Plugins, which is covered in the next step.

 

### **Installing The Nagios Plugins**

Nagios Core needs plugins to operate properly. The following steps will walk you through installing Nagios Plugins.

These steps install nagios-plugins 2.3.3. Newer versions will become available in the future and you can use those in the following installation steps. Please see the [releases page on GitHub](https://github.com/nagios-plugins/nagios-plugins/releases) for all available versions.

Please note that the following steps install most of the plugins that come in the Nagios Plugins package. However there are some plugins that require other libraries which are not included in those instructions. Please refer to the following KB article for detailed installation instructions:

[Documentation - Installing Nagios Plugins From Source](https://support.nagios.com/kb/article.php?id=569)

 

#### **Prerequisites**

Make sure that you have the following packages installed.

```
sudo apt-get install -y autoconf gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext
```

 

#### **Downloading The Source**

```
cd /tmp
wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.3.3.tar.gz
tar zxf nagios-plugins.tar.gz
```

 

#### **Compile + Install**

```
cd /tmp/nagios-plugins-release-2.3.3/
sudo ./tools/setup
sudo ./configure
sudo make
sudo make install
```

 

#### **Test Plugins**

Point your web browser to the ip address or FQDN of your Nagios Core server, for example: *`http://192.168.xxx.yyy/nagios`* or *`http://core-013.domain.local/nagios`*. 

Go to a host or service object and "Re-schedule the next check" under the Commands menu. The error you previously saw should now disappear and the correct output will be shown on the screen.

 

#### **Service/Daemon Commands**

Different Linux distributions have different methods of starting / stopping / restarting / status Nagios.

```
sudo systemctl start nagios.service
sudo systemctl stop nagios.service
sudo systemctl restart nagios.service
sudo systemctl status nagios.service
```



## Konfiguration 

Die Konfigurationsdateien sind zu finden unter `/usr/local/nagios/etc` sowie  `/usr/local/nagios/etc/objects` .

| Datei                                         | Bedeutung                                                    |
| --------------------------------------------- | ------------------------------------------------------------ |
| /usr/local/nagios/etc/nagios.cfg              | Haupt-Konfigurationsdatei. Hier wird definiert<br />- Konfiguration der LOG-Datei<br />- alle weiteren zu nutzenden Konfigurationsdateien |
| /usr/local/nagios/etc/objects/commands.cfg    | Definition der Befehle                                       |
| /usr/local/nagios/etc/objects/contacts.cfg    | Definition der Kontaktdaten                                  |
| /usr/local/nagios/etc/objects/localhost.cfg   | Definition des hosts und der durchzuführenden Prüfungen      |
| /usr/local/nagios/etc/objects/printer.cfg     | Vorlage für das Monitoring eines Druckers                    |
| /usr/local/nagios/etc/objects/switch.cfg      | Vorlage für das Monitoring eines Switches                    |
| /usr/local/nagios/etc/objects/templates.cfg   | Vorlagen für Definitionen von Befehlen, hosts, Gruppen, Kontakten, … |
| /usr/local/nagios/etc/objects/timeperiods.cfg | Vorlagen für Zeiten, Zeitintervalle, …                       |
| /usr/local/nagios/etc/objects/windows.cfg     | Vorlage für das Monitoring eines Windows-Rechners (Server, Client) |

### Anpassungen in der Datei localhost.cfg

Ergänzen der Port-Nummer des Apache-Webservers

```
define service{
    use                    local-service
    host_name              localhost
    service_description    HTTP
    check_command          check_http!-p 1417
    notification_enabled   1
}
```



### Anpassungen für Tomcat

#### Quellen

- [Configure Tomcat's Plugin in Nagios (Ubuntu) – The geeky Argonaut – Experiences on software craftmanship (zouzias.org)](https://www.zouzias.org/2015/02/26/Tomcat-Plugin-in-Nagios/)
- [check_tomcat.pl - Nagios Exchange](https://exchange.nagios.org/directory/Plugins/Java-Applications-and-Servers/Apache-Tomcat/check_tomcat-2Epl/details)



#### Installation

1. Download the [Tomcat plugin](http://exchange.nagios.org/directory/Plugins/Java-Applications-and-Servers/Apache-Tomcat/check_tomcat-2Epl/details) into `/usr/local/nagios/libexec/` directory (into your nagios server). 

2. ```
   cd /usr/local/nagios/libexec/
   sudo nano ./check_tomcat.pl
   ```

   

3. Rename the plugin from `check_tomcat.pl` to `check_tomcat`and make it executable.

4. Just to be on the safe side, install a XML dependency that is used by the tomcat plugin using

   ```
   sudo apt-get install libxml-xpath-perl
   ```

   

5. Append the following lines in the file `/usr/local/nagios/etc/objects/commands.cfg`

   ```
   # check_tomcat command definition
   define command{
          command_name check_tomcat
          command_line /usr/bin/perl /usr/local/nagios/libexec/check_tomcat -H $HOSTADDRESS$ -p $ARG1$ -l $ARG2$ -a $ARG3$ -w $ARG4$ -c $ARG5$
   }
   ```

   

6. Add the following service definition in the host that you want to check if Tomcat is running. In our case we will use localhost. 

   ```
   sudo nano /usr/local/nagios/etc/objects/localhost.cfg
   ```

   

   ```
   # Define a service to check the state of a Tomcat service
   define service{
          use                  local-service
          host_name            localhost
          service_description  Tomcat
          check_command        check_tomcat!7323!tomcat_username!tomcat_password!25%,25%!10%,10%
   }
   ```

   

7. Finally, restart nagios using

   ```
   sudo systemctl restart nagios.service
   ```

   

## E-Mail notification

### Quellen

[How to configure email notification from nagios. - Nagios Support Forum](https://support.nagios.com/forum/viewtopic.php?t=40122)

[Monitor and Configure Nagios Alerts on Debian 10 and Ubuntu 20.04 | Linode Docs](https://www.linode.com/docs/guides/monitor-and-configure-nagios-alerts-on-debian-10-ubuntu-2004/)

### Kontaktinformationen aktualisieren

```
sudo nano /usr/local/nagios/etc/objects/contacts.cfg
```

```
define contact{
    contact_name  nagiosadmin ;Short name of user
    use           generic-contact ;Inherit default values from generic-contact template (defined above)
    alias         Nagios Admin ;Full name of user
    pager         0045xxxxxxxx
    email         <your email goes here>
    host_notification_period    24x7
    host_notification_options   d,u,r
    host_notification_commands host-notify-by-email
}
```



### Befehl für E-Mail-Kommunikation definieren

```
sudo nano /usr/local/nagios/etc/objects/commands.cfg
```

```
# 'notify-host-by-email' command definition
define command{
        command_name    notify-host-by-email
        command_line    /usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: $NOTIFICATIONTYPE$\nHost: $HOSTNAME$\nState: $HOSTSTATE$\nAddress: $HOSTADDRESS$\nInfo: $HOSTOUTPUT$\n\nDate/Time: $LONGDATETIME$\n" | /bin/mail -s "** $NOTIFICATIONTYPE$ Host Alert: $HOSTNAME$ is $HOSTSTATE$ **" $CONTACTEMAIL$
        }
```

```
# 'notify-service-by-email' command definition
define command{
        command_name    notify-service-by-email
        command_line    /usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: $NOTIFICATIONTYPE$\nServices: $SERVICEDESC$\nState: $HOSTSTATE$\nAddress: $HOSTADDRESS$\nInfo: $HOSTOUTPUT$\n\nDate/Time: $LONGDATETIME$\n" | /bin/mail -s "** $NOTIFICATIONTYPE$ Host Alert: $HOSTNAME$ is $HOSTSTATE$ **" $CONTACTEMAIL$
        }
```



## Mail-Server installieren - postfix

### Quellen

[Monitor and Configure Nagios Alerts on Debian 10 and Ubuntu 20.04 | Linode Docs](https://www.linode.com/docs/guides/monitor-and-configure-nagios-alerts-on-debian-10-ubuntu-2004/)

https://www.howtoforge.com/postfix_relaying_through_another_mailserver



```
sudo apt install mailutils postfix
```

To configure our Postfix server for relaying emails through *smtp.example.de*, we run

```
sudo postconf -e 'relayhost = smtp.example.de'
sudo postconf -e 'smtp_sasl_auth_enable = yes'
sudo postconf -e 'smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd'
sudo postconf -e 'smtp_sasl_security_options ='
```

Our username (*USER*) and password (*PASSWORD*) for *smtp.example.com* must be stored in */etc/postfix/sasl_passwd*, therefore we do this:

```
echo "smtp.example.de   USER:PASSWORD" > /etc/postfix/sasl_passwd 
```

Alternativ:

```
sudo nano /etc/postfix/sasl_passwd
```

und manuell ergänzen

```
smtp.example.de   USER:PASSWORD
```

*/etc/postfix/sasl_passwd* must be owned by root, and noone else should have read access to that file, so we do this:

```
sudo chown root:root /etc/postfix/sasl_passwd
sudo chmod 600 /etc/postfix/sasl_passwd
```

Now we must convert */etc/postfix/sasl_passwd* into a format that Postfix can read:

```
sudo postmap /etc/postfix/sasl_passwd
```

This will create the file */etc/postfix/sasl_passwd.db*.

All that is left to do is restart Postfix:

```
/etc/init.d/postfix restart 
```





## Konfiguration überprüfen

```
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
```







# Installation java



## Quellen

- http://java.xrheingauerx.de/raspberry_java_installieren.html



## Installation

Das OpenJDK wird in das *`/usr/lib/jvm/`* Verzeichnis installiert. Dort legen wir später einen symbolischen Link an, damit wir Java einfach aktualisieren können, ohne die Grundkonfiguration jedesmal dafür ändern zu müssen. Zudem können wir den Link einfach auf eine andere Java-Version zeigen lassen und z. B. der Tomcat würde diese Version dann nutzen.

Wir installieren auch nur die Runtime (JRE), da wir auf diesem Pi nichts entwickeln, sondern nur laufen lassen.



## Installation

Zunächst einmal aktualisieren wir die Paketlisten mit folgendem Befehl

```
sudo apt-get update
```

Danach installieren wir das OpenJDK mit

```
sudo apt-get install openjdk-11-jre
```

Nun legen wir einen symbolischen Link *`/usr/lib/jvm/java`* an, der auf dieses Verzeichnis zeigt und den wir später in anderen Programmen oder Diensten, z. B. im Tomcat, nutzen können.

```
sudo ln -s /usr/lib/jvm/java-11-openjdk-arm64 /usr/lib/jvm/java
```

Nun müssen wir die Umgebungsvariable  *`JAVA_HOME`*  so konfigurieren, dass Java-Anwendungen das Java-Installationsverzeichnis finden können. Tomcat benötigt eine JAVA_HOME-Umgebung, um korrekt eingerichtet zu werden. Hierzu ist in der Umgebungsdatei /etc/environments die JAVA_HOME-Umgebung zu ergänzen.

```
sudo nano /etc/environment
```

 

```
JAVA_HOME="/usr/lib/jvm/java"
```

Bearbeiten Sie anschließend die .bashrc-Datei und fügen Sie Zeilen hinzu, um die JAVA_HOME-Umgebungsvariablen zu exportieren:

```
sudo nano ~/.bashrc
```

Fügen Sie am Ende der Datei die untenstehende Konfiguration ein:

```
export JAVA_HOME=/usr/lib/jvm/java-8-oracle/jre
export PATH=$JAVA_HOME/bin:$PATH
```

Speichern und beenden Sie die Datei und laden Sie dann die.bashrc-Datei neu.

```
source ~/.bashrc
```







# Installation Tomcat



## Quellen

- http://java.xrheingauerx.de/raspberry_tomcat_installieren.html
- https://linuxhint.com/change-default-port-of-tomcat-server/#:~:text=Changing%20Default%20Port%201%201.%20Locating%20the%20Server.xml,Port%20Number%20...%204%204.%20Restarting%20Tomcat%20
- https://www.howtoforge.de/anleitung/so-installieren-und-konfigurieren-sie-apache-tomcat-85-unter-ubuntu-1604/
- https://tomcat.apache.org/
- [A Step By Step Guide to Tomcat Performance Monitoring (stackify.com)](https://stackify.com/tomcat-performance-monitoring/)
- [Home · javamelody/javamelody Wiki (github.com)](https://github.com/javamelody/javamelody)



Wir richten einen separaten User "tomcat" ein und lassen den Tomcat im Anschluss als Dienst auf dem Raspberry unter diesem Benutzer laufen.



## Benutzer tomcat anlegen

```
sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat
```



## Installation

Wir wechseln in das Temp-Verzeichnis und laden uns die Zip-Datei des aktuellen Tomcat (Core) herunter. Danach entpacken wir die ZIP-Datei. Wir stellen sicher, dass innerhalb dem "/opt" das Verzeichnis " tomcat " existiert und verschieben den entpackten Tomcat in das neu erstellte Verzeichnis. Im Anschluss löschen wir das Zip-File im /tmp-Ordner. Nun legen wir noch einen symbolischen Link "/opt/tomcat/home" an und legen tomcat als Besitzer des Verzeichnisses "/opt/tomcat" fest. Abschließend werden die Skripte innerhalb dem "bin"-Verzeichnis ausführbar gemacht.

```
cd /tmp
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.10/bin/apache-tomcat-10.1.10.zip

unzip apache-tomcat-*.zip
sudo mkdir -p /opt/tomcat
sudo mv apache-tomcat-10.1.10 /opt/tomcat/
sudo rm apache-tomcat-10.1.10.zip
sudo ln -s /opt/tomcat/apache-tomcat-10.1.10 /opt/tomcat/home
sudo chown -R tomcat: /opt/tomcat
sudo sh -c 'chmod +x /opt/tomcat/home/bin/*.sh'
```

Um den Tomcat auf dem Raspberry als Dienst laufen zu lassen, legen wir innerhalb "systemd" eine Unit-Datei mit dem Namen "tomcat.service" an.

```
sudo nano /etc/systemd/system/tomcat.service
```

Inhalt der Datei:

```
[Unit]
Description=Apache Tomcat Webserver
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat
Environment="JAVA_HOME=/usr/lib/jvm/java"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"

Environment="CATALINA_HOME=/opt/tomcat/home"
Environment="CATALINA_BASE=/opt/tomcat/home"
Environment="CATALINA_PID=/opt/tomcat/home/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/home/bin/startup.sh
ExecStop=/opt/tomcat/home/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
```

 

Wir prüfen jetzt, ob der Tomcat auch sauber startet und geben der Reihenfolge nach folgende Befehle ein

```
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl status tomcat
```

 

Im Ok-Fall wollen wir, dass der Dienst bei jedem Start des Raspberry automatisch startet. Das erledigen wir mit folgendem Befehl

```
sudo systemctl enable tomcat
```

 

## Umgebungsvariable "Produktion" setzen

Da der Webserver als (private) Produktionsumgebung dient, auf der unsere Programme nach Fertigstellung laufen, erhält dieser eine entsprechende Umgebungsvariable. Wer diese in seinem Programm ausgibt, sieht in welcher Umgebung er sich gerade befindet.

 

Dazu bearbeiten wir die "server.xml" des Tomcats mit diesem Befehl 

```
sudo nano /opt/tomcat/home/conf/server.xml
```

und fügen das folgende unter den "GlobalNamingResources" ein:

```
<Environment description="Umgebung" name="UMGEBUNG" type="java.lang.String" value="Produktion"/>
```

![](C:\Users\thoma\OneDrive - EDV-Beratung und Softwareentwicklung\HOWTO raspi-Dateien\image014.jpg)

 

## Tomcat Manager App von außen zugänglich machen

Aus Sicherheitsgründen ist die Tomcat-Manager-App sowie die Tomcat-Hostmanager-App nur vom lokalen Raspberry aus nutzbar. Wir befinden uns aber im Heimnetz und möchten zumindest Zugriff auf die Manager-App von einem anderen Rechner aus, auf dem auch unser PuTTY (SSH-Client) läuft. Dazu müssen wir lediglich die jeweilige context.xml der App umkonfigurieren.

 

#### Editieren der Datei "tomcat-users.xml" 

```
sudo nano /opt/tomcat/home/conf/tomcat-users.xml
```

Anzupassender Inhalt: Anfügen ans Ende (aber vor "</tomcat-users>") :

```
<role rolename="admin"/>
<role rolename="admin-gui"/>
<role rolename="manager-gui"/>

<user username="USER" password="PASSWORD" roles="admin,admin-gui,manager-gui"/>
```

Achtung:  

- USER und PASSWORD ersetzen! 
-  Benutzer ist beliebig wählbar und das Passwort sowieso.

 

#### Editieren der Datei "context.xml" der Tomcat-Manager-App. 

```
sudo nano /opt/tomcat/home/webapps/manager/META-INF/context.xml
```

Dort tragen wir getrennt durch "|" die IP-Adressen der Rechner ein, die auch Zugriff auf die Manager-App haben sollen. 

![](C:\Users\thoma\OneDrive - EDV-Beratung und Softwareentwicklung\HOWTO raspi-Dateien\image018.jpg)



#### Wir starten nun den Tomcat neu, damit die Änderungen wirksam werden

```
sudo systemctl restart tomcat
```

 

## Changing Default Port

By default, the Tomcat server runs on the 8080 Port number. However, if there comes a need to change this, then it can be done easily by changing the port in the server.xml-File.

#### Edititieren der Datei /opt/tomcat/home/conf/server.xml

```
sudo nano /opt/tomcat/home/conf/server.xml
```

Anzupassender Inhalt

```
<Connector port="xxxx" protocol=“http/1.1“ …/>
```



## Enable Performance Management

Tomcat performance monitoring can be done with JMX beans or a monitoring tool.

One way of obtaining the values of the MBeans is through the Manager App that comes with Tomcat. This app is protected, so to access it, you need to first define a user and password by adding the following in the `conf/tomcat-users.xml` file:

```
sudo nano /opt/tomcat/home/conf/tomcat-users.xml
```



```
<role rolename="manager-gui"/>
<role rolename="manager-jmx"/>
<user username=... password=... roles="manager-gui, manager-jmx"/>
```

The Manager App interface contains some minimal information on the server status.

Information on the JMX beans can be found at http://localhost:7323/manager/jmxproxy.   The information is in text format, as it is intended for tool processing.

To retrieve data about a specific bean, you can add parameters to the URL that represent the name of the bean and attribute you want:

```
http://localhost:7323/manager/jmxproxy/?get=java.lang:type=Memory&att=HeapMemoryUsage
```

Overall, this tool can be useful for a quick check, but it’s limited and unreliable, so not recommended for production instances.



### Enabling Tomcat Performance Monitoring with JavaMelody

http://192.168.178.86:7323/GCW_Unluac/monitoring

If you’re using Maven, simply add the [javamelody-core](https://search.maven.org/#search|ga|1|a%3A"javamelody-core") dependency to the pom.xml:

```
<dependency>
    <groupId>net.bull.javamelody</groupId>
    <artifactId>javamelody-core</artifactId>
    <version>1.69.0</version>
</dependency>
```

In this way, you can enable monitoring of your web application.

After deploying the application on Tomcat, you can access the monitoring screens at the /monitoring URL.

JavaMelody contains useful graphs for displaying information related to various performance measures, as well as a way to find the values of the Tomcat JMX beans.



#### Unterstützen von JavaMelody unter Tomcat 10.x

##### Problem

Tomcat 10.x throws java.lang.NoClassDefFoundError on javax.servlet.*

##### Lösung

Since Tomcat 10.0.4 there is a workaround that allows deployment of Servlet 4.0 applications on Tomcat 10.

You just need to modify your context description in `/opt/tomcat/home/conf/Catalina/localhost/VirtualStore.xml` 

```
sudo nano /opt/tomcat/home/conf/Catalina/localhost/VirtualStore.xml
```

and add:

```xml
<Context>
    ...
    <Loader jakartaConverter="TOMCAT" />
</Context>
```

Alternativ

- - As my installation has no "VirtualStore.xml", I just added the Loader line to the context.xml of the Tomcat installation, restarted and now works. 
  - I am using tomcat 10.0.27 with spring 5.3.23. I added it in conf/context.xml. It is working fine. 
  - sudo mc

##### Quelle 

https://stackoverflow.com/questions/66711660/tomcat-10-x-throws-java-lang-noclassdeffounderror-on-javax-servlet#comment121450945_66805452

`<Loader jakartaConverter="TOMCAT" />` in "tomcat/conf/context.xml"



# GCWizardDecompiler Servlet

The GCWizardDecompiler Servlet is a Java Servlet that runs Hans Wessels [LUA 5.x decompiler](https://github.com/HansWessels/unluac).

Therefor the servlet 

- receives a HTTP Multipart request containing a file with LUA bytecode.

- returns the decompiled code as plain text.



## Quellcode

GitHub [GCWizard/external_helpers/decompiler_rest_api at 2.3.0 · S-Man42/GCWizard (github.com)](https://github.com/S-Man42/GCWizard/tree/2.3.0/external_helpers/decompiler_rest_api)



## Test

```
curl -F file=@<path_to_luac_file> <server_url>
```



## Installation 

- Öffne das Servlet Projekt in Eclipse
- Wähle File > Export > Web: WAR File
- Setze einen Dateinamen und Speicherort
- [Optional: Optimieren für spezifische Server Version]
- Öffne den Tomcat Manager
- Im Abschnitt "Lokale WAR Datei zur Installation hochladen"
  - Wähle WAR vom Speicherort
  - Klicke "Installieren"
- Teste Servlet mit `curl -F file=@<path_to_luac_file> <server_url>`



# Installation python3



## Quellen

- [Welcome to Python.org](https://www.python.org/)
- [How To Install the Latest Python Version on Raspberry Pi? – RaspberryTips](https://raspberrytips.com/install-latest-python-raspberry-pi/)



Two versions of Python come preinstalled on Raspberry Pi OS: Python 2 and Python 3. To find the exact version number, use the command line `python –version` and `python3 –version`.

The easiest way to find the latest Python release available is to go to the official Python website. On the download page, the latest versions are listed with their release date and maintenance status.



## Installation

Go to the tmp-Directory

```
cd /tmp
```

Download the latest Python file with

```
wget https://www.python.org/ftp/python/3.9.15/Python-3.9.15.tgz
```

Extract the files with

```
tar -zxvf Python-3.9.15.tgz
```

Move to the folder containing the extracted files

```
cd Python-3.9.15
```

Run the configuration command

```
./configure --enable-optimizations
```

Once done, run this command to install it

```
sudo make altinstall
```

Make Python the default version on Raspberry Pi OS

```
cd /usr/bin
sudo rm python
sudo ln -s /usr/local/bin/python3.9 python
python --version
```



## Installation des Paketmanagers PIP

```
sudo apt-get install python3-pip
```



## Installation des Paketes smbus

```
sudo pip install smbus2 --system
```



## Installation des Paketes gpiozero

```
sudo pip install gpiozero --system
```







# Install git

```
sudo apt install git
```



# Installation flutter-pi

## Quellen

[ardera/flutter-pi: A light-weight Flutter Engine Embedder for Raspberry Pi that runs without X. (github.com)](https://github.com/ardera/flutter-pi)



## Installieren

### Install

```
sudo apt install cmake libgl1-mesa-dev libgles2-mesa-dev libegl1-mesa-dev libdrm-dev libgbm-dev ttf-mscorefonts-installer fontconfig libsystemd-dev libinput-dev libudev-dev  libxkbcommon-dev
```



### Update system fonts

```
sudo fc-cache
```



### Clone flutter-pi

```
git clone https://github.com/ardera/flutter-pi
cd flutter-pi
```



### Compile

```
mkdir build && cd build
cmake ..
make -j`nproc`
```

Install

```
sudo make install
```



## Raspberry konfigurieren

Open raspi-config:

```
sudo raspi-config
```

Switch to 1 System Options -> Boot / Auto Login and select Console or Console (Autologin).

Switch to 4 Performance Options and configure the GPU memory Performance Options -> GPU Memory and enter 64.

Leave raspi-config.

Finish and reboot.



## App erzeugen

### LINUX

#### One-time setup

1. Make sure you've installed the flutter SDK. Only flutter SDK >= 3.10.5 is supported for the new method at the moment.

2. Install the flutterpi_tool: Run flutter pub global activate flutterpi_tool (One time only)

3. If running flutterpi_tool directly doesn't work, follow https://dart.dev/tools/pub/cmd/pub-global#running-a-script-from-your-path to add the dart global bin directory to your path.

   Alternatively, you can launch the tool via: flutter pub global run flutterpi_tool ...

#### Building the app bundle

1. Open terminal or commandline and cd into your app directory.

2. Run `flutterpi_tool build` to build the app.

   - This will build the app for ARM 32-bit debug mode.

   - `flutterpi_tool build --help` gives more usage information.

   - For example, to build for 64-bit ARM, release mode, with a Raspberry Pi 4 tuned engine, use:

     ```
     flutterpi_tool build --arch=arm64 --cpu=pi4 --release
     ```

     

3. Deploy the bundle to the Raspberry Pi using rsync or scp:

   - Using rsync (available on linux and macOS or on Windows when using WSL)

     ```
     rsync -a --info=progress2 ./build/flutter_assets/ pi@raspberrypi:/home/pi/my_apps_flutter_assets
     ```

     

   - Using scp (available on linux, macOS and Windows) 

     ```
     scp -r ./build/flutter_assets/ pi@raspberrypi:/home/pi/my_apps_flutter_assets
     ```




### Windows

Build the asset bundle

```
flutter build bundle`
```

Build the kernel snapshot. (Replace `my_app_name` with the name of your app)

```
C:\flutter\bin\cache\dart-sdk\bin\dart.exe ^
  C:\flutter\bin\cache\dart-sdk\bin\snapshots\frontend_server.dart.snapshot ^
  --sdk-root C:\flutter\bin\cache\artifacts\engine\common\flutter_patched_sdk_product ^
  --target=flutter ^
  --aot ^
  --tfa ^
  -Ddart.vm.product=true ^
  --packages .dart_tool\package_config.json ^
  --output-dill build\kernel_snapshot.dill ^
  --verbose ^
  --depfile build\kernel_snapshot.d ^
  package:my_app_name/main.dart
```

**Hint**

- In versions prior to Flutter 3.3.0 the `--packages` argument should be set to `.packages`. In versions greater than or equal to 3.3.0 the `--packages` argument should be set to `.dart_tool\package_config.json`.

Fetch the latest `gen_snapshot_linux_x64_release` I provide in the [engine binaries repo](https://github.com/ardera/flutter-engine-binaries-for-arm).

The following steps must be executed on a linux x64 machine. If you're on windows, you can use [WSL](https://docs.microsoft.com/de-de/windows/wsl/install-win10). If you're on macOS, you can use a linux VM.

Build the `app.so`. If you're building for *arm64*, you need to omit the `--sim-use-hardfp` flag.

```
gen_snapshot_linux_x64_release \
  --deterministic \
  --snapshot_kind=app-aot-elf \
  --elf=build/flutter_assets/app.so \
  --strip \
  --sim-use-hardfp \
  build/kernel_snapshot.dill
```

Now you can switch to your normal OS again.

Deploy the bundle to the Raspberry Pi using rsync or scp:

- Using rsync (available on linux and macOS or on Windows when using WSL)

  ```
  rsync -a --info=progress2 ./build/flutter_assets/ pi@raspberrypi:/home/pi/my_apps_flutter_assets
  ```

  

- Using scp (available on linux, macOS and Windows) 

  ```
  scp -r ./build/flutter_assets/ pi@raspberrypi:/home/pi/my_apps_flutter_assets
  ```



Done. You can now launch the app in release mode using 

```
flutter-pi --release /home/pi/my_app
```

`



## Hilfeseiten flutter-pi

```
USAGE:
  flutter-pi [options] <bundle path> [flutter engine options]

OPTIONS:
  --release                  Run the app in release mode. The AOT snapshot
                             of the app must be located inside the bundle directory.
                             This also requires a libflutter_engine.so that was
                             built with --runtime-mode=release.

  --profile                  Run the app in profile mode. The AOT snapshot
                             of the app must be located inside the bundle directory.
                             This also requires a libflutter_engine.so that was
                             built with --runtime-mode=profile.

  --vulkan                   Use vulkan for rendering.

  -o, --orientation <orientation>  Start the app in this orientation. Valid
                             for <orientation> are: portrait_up, landscape_left,
                             portrait_down, landscape_right.
                             For more information about this orientation, see
                             the flutter docs for the "DeviceOrientation"
                             enum.
                             Only one of the --orientation and --rotation
                             options can be specified.

  -r, --rotation <degrees>   Start the app with this rotation. This is just an
                             alternative, more intuitive way to specify the
                             startup orientation. The angle is in degrees and
                             clock-wise.
                             Valid values are 0, 90, 180 and 270.

  -d, --dimensions "width_mm,height_mm" The width & height of your display in
                             millimeters. Useful if your GPU doesn't provide
                             valid physical dimensions for your display.
                             The physical dimensions of your display are used
                             to calculate the flutter device-pixel-ratio, which
                             in turn basically "scales" the UI.

  --pixelformat <format>     Selects the pixel format to use for the framebuffers.
                             If this is not specified, a good pixel format will
                             be selected automatically.
                             Available pixel formats: RGB565, ARGB4444, XRGB4444, ARGB1555, XRGB1555, ARGB8888, XRGB8888, BGRA8888, BGRX8888, RGBA8888, RGBX8888, 
  --videomode widthxheight
  --videomode widthxheight@hz  Uses an output videomode that satisfies the argument.
                             If no hz value is given, the highest possible refreshrate
                             will be used.

  -h, --help                 Show this help and exit.

EXAMPLES:
  flutter-pi ~/hello_world_app
  flutter-pi --release ~/hello_world_app
  flutter-pi -o portrait_up ./my_app
  flutter-pi -r 90 ./my_app
  flutter-pi -d "155, 86" ./my_app
  flutter-pi --videomode 1920x1080 ./my_app
  flutter-pi --videomode 1280x720@60 ./my_app

SEE ALSO:
  Author:  Hannes Winkler, a.k.a ardera
  Source:  https://github.com/ardera/flutter-pi
  License: MIT

  For instructions on how to build an asset bundle or an AOT snapshot
    of your app, please see the linked github repository.
  For a list of options you can pass to the flutter engine, look here:
    https://github.com/flutter/engine/blob/main/shell/common/switches.h
```



## discord

There a `#custom-embedders` channel on the [flutter discord](https://github.com/flutter/flutter/wiki/Chat) which you can use if you have any questions regarding flutter-pi or generally, anything related to embedding the engine for which you don't want to open issue about or write an email.



# Uninterruptable Power Supply



## Quellen

- [UPS HAT - Waveshare Wiki](https://www.waveshare.com/wiki/UPS_HAT)



## Features

- Standard Raspberry Pi 40PIN GPIO extension header, supports Raspberry Pi series boards.
- I2C bus communication, monitoring the batteries voltage, current, power, and remaining capacity in real-time.
- Multi battery protection circuits: overcharge/discharge protection, over current protection, short circuit protection, and reverse protection, along with the equalizing charge feature, more safe and stable.
- Onboard 5V regulator, up to 2.5A continuous output current.
- 5V USB output, convenient for powering other boards.
- Batteries warning indicators, easy to check if the battery is connected correctly.



## Specifications

- Output voltage：       5V
- Charger：                    8.4V 2A
- Control bus：              I2C
- Battery supported：  18650 Li battery (NOT included)
- Dimensions：              56mm × 85mm
- Mounting hole：         3.0mm



## Hardware

| Bild                                                         | Beschreibung                                                 |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![](C:\Users\thoma\OneDrive - EDV-Beratung und Softwareentwicklung\HOWTO raspi-Dateien\image020.jpg) | Note that the 8.4V interface is the charging port. You can plug the 8.4V/2A charger provided for charging the batteries.<br/> The switch is the power switch, you can turn it into ON/OFF to turn on/off Jetson Nano Developer Kit.<br/> WARNING LED are the indicators of batteries, they turn on if you reverse batteries.<br/> Note 1: Please check the WARNING LED when you install batteries, make sure that you set all the batteries in the correct way. Don't charge batteries if you reverse them.<br/> Note 2: The board may not work when you install the batteries for the first time, you need to charge the batteries for a while to activate them.<br/> Note 3: Please use the charger provided, the module may be destroyed by other unsuitable power adapters/chargers. |



## Enable I2C Interface

Open the terminal of Raspberry Pi, and enter the following commands for the configuration interface:

```
sudo raspi-config
```

Select Interfacing Options -> I2C ->yes to start the i2C kernel driver.

```
sudo reboot
```

You can just attach the UPS HAT on the 40PIN GPIO of Raspberry Pi or connect the i2c interface and to Raspberry Pi by wires. VCC should be connected to 3.3V

Open a terminal and run the following commands:

```
sudo apt-get install p7zip
wget https://www.waveshare.com/w/upload/d/d9/UPS_HAT.7z
7zr x UPS_HAT.7z -r -o./UPS_HAT
cd UPS_HAT
python3 INA219.py
```

Obviously two errors could occur:

- python3 is not installed
- the smbus module is not installed

Hence you have to install python3 and the smbus module.



## Gehäuse

Copyright 13.11.2022 Matthias Meyer, 14089 Berlin

Druckplan liegt als TMZ.stl vor.



## Anpassungen für Waveshare UPS Hat

### python-script für die Abfrage erstellen

```
sudo nano /usr/local/nagios/libexec/check_ups_hat
```



### Die Datei ausführbar machen

```
sudo chmod 755 /usr/local/nagios/libexec/check_ups_hat
```



### nagios für die Ausführung dieser Datei in der Datei `sudoers` befähigen.

```
sudo visudo
```

```
nagios ALL=NOPASSWD: /sur/bin/python
nagios ALL=NOPASSWD: /sur/bin/python3
nagios ALL=NOPASSWD: /usr/local/nagios/libexec/check_ups_hat
```

alternativ

```
sudo nano /etc/sudoers.d/020_nagios
```

die Befehlszeile hinzufügen und den Datei-Modus ändern

```
sudo chmod 0440 /etc/sudoers.d/020_nagios
```



### Befehl in der Datei `commands.cfg` erstellen

```
sudo nano /usr/local/nagios/etc/objects/commands.cfg
```

```
define command{
       command_name          check_ups_hat
       command_line          sudo /usr/bin/python3 /usr/local/nagios/libexec/check_ups_hat
}
```



### Service in der Datei `localhost.cfg` erstellen

```
sudo nano /usr/local/nagios/etc/objects/localhost.cfg
```

```
define service{
       use                   local-service
       host_name             localhost
       service_description   UPS_HAT
       check_command         check_ups_hat
}
```



nagios erneut starten

```
sudo systemctl restart nagios.service
```



## Anpassungen für die Temperaturüberwachung

### python-script für die Abfrage erstellen

```
sudo nano /usr/local/nagios/libexec/check_temp
```

Inhalt siehe Quelldateien check_temp



### Die Datei ausführbar machen

```
sudo chmod 755 /usr/local/nagios/libexec/check_temp
```



### nagios für die Ausführung dieser Datei in der Datei `sudoers` befähigen.

```
sudo visudo
```

```
nagios ALL=NOPASSWD: /usr/local/nagios/libexec/check_temp
```



### Befehl in der Datei `commands.cfg` erstellen

```
sudo nano /usr/local/nagios/etc/objects/commands.cfg
```

```
define command{
       command_name          check_temp
       command_line          echo PASSWORD | sudo -S /usr/bin/python /usr/local/nagios/libexec/check_temp
}
```



### Service in der Datei `localhost.cfg` erstellen

```
sudo nano /usr/local/nagios/etc/objects/localhost.cfg
```

```
define service{
       use                   local-service
       host_name             localhost
       service_description   Temperatur
       check_command         check_temp
}
```



nagios erneut starten

```
sudo systemctl restart nagios.service
```





# Konfigurationsdaten

## Raspberry

| Schlüssel         | Wert |
| ----------------- | ---- |
| Benutzer Name     | pi   |
| Benutzer Kennwort |      |



## Tomcat

| Schlüssel                                      | Wert                                                    |
| ---------------------------------------------- | ------------------------------------------------------- |
| Port                                           | 7323                                                    |
| Benutzer Name                                  | GCWizardDecompiler                                      |
| Benutzer Kennwort                              |                                                         |
| IP-Adresse für den Zugriff auf die manager-GUI | 192.168.178.45<br />192.168.178.93<br />192.168.178.194 |
| Servlet-Verzeichnis                            | /GCW_Unluac                                             |

## nagios

| Schlüssel         | Wert        |
| ----------------- | ----------- |
| Benutzer Name     | nagios      |
| Benutzer Kennwort |             |
| Admin Name        | nagiosadmin |
| Admin Kennwort    |             |
| Port              | 1417        |



### check Tomcat

| /usr/local/nagios/libexec                         | check_tomcat.pl generieren                                   |
| ------------------------------------------------- | ------------------------------------------------------------ |
| /usr/local/nagios/etc/objects/<br />commands.cfg  | define command{<br/>       command_name      check_tomcat<br/>       command_line          /usr/bin/perl /usr/lib/nagios/plugins/check_tomcat -H\$HOSTADDRESS\$ -p\$ARG1\$ -l\$ARG2\$ -a\$ARG3\$ -w\$ARG4\$ -c\$ARG5\$<br/>} |
| /usr/local/nagios/etc/objects/<br />localhost.cfg | define service{<br />        use                              local-service<br />        host_name                 localhost<br />        service_description  Tomcat <br />       check_command        check_tomcat!7323!tomcat_username!tomcat_password!25%,25%!10%,10%<br /> } |



### check_ups_hat

| /usr/local/nagios/libexec                         | check_ups_hat.pl generieren                                  |
| ------------------------------------------------- | ------------------------------------------------------------ |
| /usr/local/nagios/etc/objects/<br />commands.cfg  | define command{<br/>       command_name  check_ups_hat<br/>       command_line      echo <PASSWORD> \| sudo -S /usr/bin/python3 /usr/local/nagios/libexec/check_ups_hat<br/>} |
| /usr/local/nagios/etc/objects/<br />localhost.cfg | define service{<br />        use                              local-service<br />        host_name                 localhost<br />        service_description  UPS_HAT <br />       check_command        check_ups_hat<br /> } |



### check_temp

| /usr/local/nagios/libexec                         | check_temp generieren                                        |
| ------------------------------------------------- | ------------------------------------------------------------ |
| /usr/local/nagios/etc/objects/<br />commands.cfg  | define command{<br/>       command_name  check_ups_hat<br/>       command_line /usr/local/nagios/libexec/check_ups_hat<br/>} |
| /usr/local/nagios/etc/objects/<br />localhost.cfg | define service{<br />        use                              local-service<br />        host_name                 localhost<br />        service_description  Temperatur <br />       check_command        check_temp<br /> } |



## Apache 2

| Schlüssel | Wert |
| --------- | ---- |
| Port      | 1417 |



## myFritz-Zugriff

| Schlüssel | Wert                                |
| --------- | ----------------------------------- |
| Adresse   | http://sdklmfoqdd5qrtha.myfritz.net |



## Servlet

| Schlüssel    | Wert                                                 |
| ------------ | ---------------------------------------------------- |
| Zugriffsart  | MultipartRequest                                     |
| Methode      | POST                                                 |
| Adresse      | http://sdklmfoqdd5qrtha.myfritz.net:7323/GCW_Unluac/ |
| Datentyp     | MultipartFile                                        |
| Content-Type | application, octet-stream                            |



# Quell-Dateien

## check_tomcat

**Hinweis**:

Default-Werte für `port`, `user` , `password`… anpassen

```
#!/usr/bin/perl 

#############################################################################
#                                                                           #
# This script was initially developed by Lonely Planet for internal use     #
# and has kindly been made available to the Open Source community for       #
# redistribution and further development under the terms of the             #
# GNU General Public License v3: http://www.gnu.org/licenses/gpl.html       #
#                                                                           #
#############################################################################
#                                                                           #
# This script is supplied 'as-is', in the hope that it will be useful, but  #
# neither Lonely Planet nor the authors make any warranties or guarantees   #
# as to its correct operation, including its intended function.             #
#                                                                           #
# Or in other words:                                                        #
#       Test it yourself, and make sure it works for YOU.                   #
#                                                                           #
#############################################################################
# Author: George Hansper                     e-mail:  george@hansper.id.au  #
#############################################################################

use strict;
use LWP;
use LWP::UserAgent;
use Getopt::Std;
use XML::XPath;

my %optarg;
my $getopt_result;

my $lwp_user_agent;
my $http_request;
my $http_response;
my $url;
my $body;

my @message;
my @message_perf;
my $exit = 0;
my @exit = qw/OK: WARNING: CRITICAL:/;

my $rcs_id = '$Id: check_tomcat.pl,v 1.4 2013/03/15 10:45:41 george Exp $';
my $rcslog = '
	$Log: check_tomcat.pl,v $
	Revision 1.4  2013/03/15 10:45:41  george
	Fixed bug in % threads thresholds, which appear if multiple connectors are in use (thanks to Andreas Lamprecht for reporting this).
	Changed MB to MiB in output text.

	Revision 1.3  2011/12/11 04:56:27  george
	Added currentThreadCount to performance data.

	Revision 1.2  2011/11/18 11:30:57  george
	Added capability to extract the connector names, and check any or all tomcat connectors for sufficient free threads.
	Stripped quotes from connector names to work around tomcat7 quirkiness.

	Revision 1.1  2011/04/16 12:05:26  george
	Initial revision

	';

# Defaults...
my $timeout = 10;			# Default timeout
my $host = 'localhost';		# default host header
my $host_ip = 'localhost';		# default IP
my $port = 80; 			# default port
my $user = 'nagios';		# default user
my $password = 'nagios';	# default password
my $uri = '/manager/status?XML=true';			#default URI
my $http = 'http';
my $connector_arg = undef;
my $opt_warn_threads = "25%";
my $opt_crit_threads = "10%";
my $warn_threads;
my $crit_threads;
# Memory thresholds are tight, because garbage collection kicks in only when memory is low anyway
my $opt_warn_memory = "5%";
my $opt_crit_memory = "2%";
my $warn_memory;
my $crit_memory;

my $xpath;
my %xpath_checks = (
	maxThreads => '/status/connector/threadInfo/@maxThreads',
	currentThreadCount => '/status/connector/threadInfo/@currentThreadCount',
	currentThreadsBusy => '/status/connector/threadInfo/@currentThreadsBusy',
	memMax => '/status/jvm/memory/@max',
	memFree => '/status/jvm/memory/@free',
	memTotal => '/status/jvm/memory/@total',
);
# XPath examples...
# /status/jvm/memory/@free
# /status/connector[attribute::name="http-8080"]/threadInfo/@maxThreads
# /status/connector/threadInfo/@*	<- returns multiple nodes

my %xpath_check_results;

sub VERSION_MESSAGE() {
	print "$^X\n$rcs_id\n";
}

sub HELP_MESSAGE() {
	print <<EOF;
Usage:
	$0 [-v] [-H hostname] [-I ip_address] [-p port] [-S] [-t time_out] [-l user] [-a password] [-w /xpath[=value]...] [-c /xpath[=value]...]

	-H  ... Hostname and Host: header (default: $host)
	-I  ... IP address (default: none)
	-p  ... Port number (default: ${port})
	-S  ... Use SSL connection
	-v  ... verbose messages
	-t  ... Seconds before connection times out. (default: $timeout)
	-l  ... username for authentication (default: $user)
	-a  ... password for authentication (default: embedded in script)
	-u  ... uri path, (default: $uri)
	-n  ... connector name, regular expression
		eg 'ajp-bio-8009' or 'http-8080' or '^http-'.
		default is to check: .*-port_number\$
		Note: leading/trailing quotes and spaces are trimmed from the connector name for matching.
	-w  ... warning thresholds for threads,memory (memory in MiB)
		eg 20,50 or 10%,25% default is $opt_warn_threads,$opt_warn_memory
	-c  ... critical thresholds for threads,memory (memory in MiB)
		eg 10,20 or 5%,10%, default is $opt_crit_threads,$opt_crit_memory
Example:
	$0 -H app01.signon.devint.lpo -p 8080 -t 5 -l nagios -a apples -u '/manager/status?XML=true'
	$0 -H app01.signon.devint.lpo -p 8080 -w 10%,50 -c 5%,10
	$0 -H app01.signon.devint.lpo -p 8080 -w 10%,50 -c 5%,10 -l admin -a admin -n .

Notes:
	The -I parameters connects to a alternate hostname/IP, using the Host header from the -H parameter
	
	To check ALL connectors mentioned in the status XML file, use '-n .'
	'.' is a regular expression matching all connector names.

	MiB = mebibyte = 1024 * 1024 bytes
	
EOF
}

$getopt_result = getopts('hvSH:I:p:w:c:t:l:a:u:n:', \%optarg) ;

# Any invalid options?
if ( $getopt_result == 0 ) {
	HELP_MESSAGE();
	exit 1;
}
if ( $optarg{h} ) {
	HELP_MESSAGE();
	exit 0;
}

sub printv($) {
	if ( $optarg{v} ) {
		chomp( $_[-1] );
		print STDERR @_;
		print STDERR "\n";
	}
}

if ( defined($optarg{t}) ) {
	$timeout = $optarg{t};
}

# Is port number numeric?
if ( defined($optarg{p}) ) {
	$port = $optarg{p};
	if ( $port !~ /^[0-9][0-9]*$/ ) {
		print STDERR <<EOF;
		Port must be a decimal number, eg "-p 8080"
EOF
	exit 1;
	}
}

if ( defined($optarg{H}) ) {
	$host = $optarg{H};
	$host_ip = $host;
}

if ( defined($optarg{I}) ) {
	$host_ip = $optarg{I};
	if ( ! defined($optarg{H}) ) {
		$host = $host_ip;
	}
}

if ( defined($optarg{l}) ) {
	$user = $optarg{l};
}

if ( defined($optarg{a}) ) {
	$password = $optarg{a};
}

if ( defined($optarg{u}) ) {
	$uri = $optarg{u};
}

if ( defined($optarg{S}) ) {
	$http = 'https';
}

if ( defined($optarg{c}) ) {
	my @threshold = split(/,/,$optarg{c});
	if ( $threshold[0] ne "" ) {
		$opt_crit_threads = $threshold[0];
	}
	if ( $threshold[1] ne "" ) {
		$opt_crit_memory = $threshold[1];
	}
}

if ( defined($optarg{n}) ) {
	$connector_arg = $optarg{n};
} else {
	$connector_arg = "-$port\$";
}

if ( defined($optarg{w}) ) {
	my @threshold = split(/,/,$optarg{w});
	if ( $threshold[0] ne "" ) {
		$opt_warn_threads = $threshold[0];
	}
	if ( $threshold[1] ne "" ) {
		$opt_warn_memory = $threshold[1];
	}
}

*LWP::UserAgent::get_basic_credentials = sub {
        return ( $user, $password );
};

# print $xpath_checks[0], "\n";

printv "Connecting to $host:${port}\n";

$lwp_user_agent = LWP::UserAgent->new;
$lwp_user_agent->timeout($timeout);
if ( $port == 80 || $port == 443 || $port eq "" ) {
	$lwp_user_agent->default_header('Host' => $host);
} else {
	$lwp_user_agent->default_header('Host' => "$host:$port");
}

$url = "$http://${host_ip}:${port}$uri";
$http_request = HTTP::Request->new(GET => $url);

printv "--------------- GET $url";
printv $lwp_user_agent->default_headers->as_string . $http_request->headers_as_string;

$http_response = $lwp_user_agent->request($http_request);
printv "---------------\n" . $http_response->protocol . " " . $http_response->status_line;
printv $http_response->headers_as_string;
printv "Content has " . length($http_response->content) . " bytes \n";

if ($http_response->is_success) {
	$body = $http_response->content;
	my $xpath = XML::XPath->new( xml => $body );
	my $xpath_check;
	# Parse the data out of the XML...
	foreach $xpath_check ( keys %xpath_checks ) {
		#print keys(%{$xpath_check}) , "\n";
		my $path = $xpath_checks{$xpath_check};
		$path =~ s{\$port}{$port};
		#print $xpath_check->{xpath} , "\n";
		my $nodeset = $xpath->find($path);
		if ( $nodeset->get_nodelist == 0 ) {
			push @message, "$path not found";
			$exit |= 2;
			push @message_perf, "$path=not_found";
			next;
		}
		foreach my $node ($nodeset->get_nodelist) {
			my $connector_name = $node->getParentNode()->getParentNode()->getAttribute("name");
			$connector_name =~ s/^["'\s]+//;
			$connector_name =~ s/["'\s]+$//;
			my $value = $node->string_value();
			if ( $value =~ /^"?([0-9.]+)"?$/ ) {
				$value = $1;
			} else {
				push @message, "$path is not numeric";
				$exit |= 2;
				push @message_perf, "$path=not_numeric";
				next;
			}
			if ( $xpath_check =~ /^mem/ ) {
				# This is the .../memory/.. xpath, just store the value in the hash
				$xpath_check_results{$xpath_check} = $value;
			} elsif ( $connector_name =~ /${connector_arg}/ && $connector_name ne "" ) {
				# This is a .../threadInfo/... xpath, put the result into a hash (key is connector_name)
				$xpath_check_results{$xpath_check}{$connector_name} = $value;
			}
		}
	}
	# Now apply the logic and check the results
	#----------------------------------------------
	# Check memory
	#----------------------------------------------
	my $jvm_mem_available = $xpath_check_results{memFree} + $xpath_check_results{memMax} - $xpath_check_results{memTotal};
	printv(sprintf("free=%d max=%d total=%d",$xpath_check_results{memFree}/1024, $xpath_check_results{memMax}/1024, $xpath_check_results{memTotal}/1024));
	if ( $opt_warn_memory =~ /(.*)%$/ ) {
		$warn_memory = int($1 * $xpath_check_results{memMax} / 100);
	} else {
		# Convert to bytes
		$warn_memory =int($opt_warn_memory * 1024 * 1024);
	}
	printv("warning at $warn_memory bytes (". ( $warn_memory / 1024 /1024 )."MiB) free, max=$xpath_check_results{memMax}");
	
	if ( $opt_crit_memory =~ /(.*)%$/ ) {
		$crit_memory = int($1 * $xpath_check_results{memMax} / 100);
	} else {
		# Convert to bytes
		$crit_memory = int($opt_crit_memory * 1024 * 1024);
	}
	printv("critical at $crit_memory bytes (". ( $crit_memory / 1024 /1024 )."MiB) free, max=$xpath_check_results{memMax}");
	
	if ( $jvm_mem_available <= $crit_memory ) {
		$exit |= 2;
		push @message, sprintf("Memory critical <%d MiB,",$crit_memory/1024/1024);
	} elsif ( $jvm_mem_available <= $warn_memory ) {
		$exit |= 1;
		push @message, sprintf("Memory low <%d MiB,",$warn_memory/1024/1024);
	}
	push @message, sprintf("memory in use %d MiB (%d MiB);",
		( $xpath_check_results{memMax} - $jvm_mem_available ) / ( 1024 * 1024),
		$xpath_check_results{memMax} / ( 1024 * 1024) 
		);
	push @message_perf, "used=".( $xpath_check_results{memMax} - $jvm_mem_available ) . " free=$jvm_mem_available max=$xpath_check_results{memMax}";

	#----------------------------------------------
	# Check threads
	#----------------------------------------------
	my $name;
	foreach $name ( keys( %{$xpath_check_results{currentThreadsBusy}} ) ) {

		if ( $opt_warn_threads =~ /(.*)%$/ ) {
			$warn_threads = int($1 * $xpath_check_results{maxThreads}{$name} / 100);
		} else {
			$warn_threads = $opt_warn_threads;
		}
		printv("warning at $warn_threads threads free, max=$xpath_check_results{maxThreads}{$name}");

		if ( $opt_crit_threads =~ /(.*)%$/ ) {
			$crit_threads = int($1 * $xpath_check_results{maxThreads}{$name} / 100);
		} else {
			$crit_threads = $opt_crit_threads;
		}
		printv("critical at $crit_threads threads free, max=$xpath_check_results{maxThreads}{$name}");

		my $threads_available = $xpath_check_results{maxThreads}{$name} - $xpath_check_results{currentThreadsBusy}{$name};
		if ( $threads_available <= $crit_threads ) {
			$exit |= 2;
			push @message, sprintf("Critical: free_threads<%d",$crit_threads);
		} elsif ( $threads_available <= $warn_threads ) {
			$exit |= 1;
			push @message, sprintf("Warning: free_threads<%d",$warn_threads);
		}
		push @message, sprintf("threads[$name]=%d(%d);",
			$xpath_check_results{currentThreadsBusy}{$name},
			$xpath_check_results{maxThreads}{$name}
			);
		if ( defined($optarg{n}) ) {
			push @message_perf, "currentThreadsBusy[$name]=$xpath_check_results{currentThreadsBusy}{$name} currentThreadCount[$name]=$xpath_check_results{currentThreadCount}{$name} maxThreads[$name]=$xpath_check_results{maxThreads}{$name}";
		} else {
			# For the sake of backwards-compatability of graphs etc...
			push @message_perf, "currentThreadsBusy=$xpath_check_results{currentThreadsBusy}{$name} currentThreadCount=$xpath_check_results{currentThreadCount}{$name} maxThreads=$xpath_check_results{maxThreads}{$name}";
		}
	}
	if ( keys(%{$xpath_check_results{currentThreadsBusy}}) == 0 ) {
		# no matching connectors found - this is not OK.
		$exit |= 1;
		push @message, "Warning: No tomcat connectors matched name =~ /$connector_arg/";
	}
} elsif ( $http_response->code == 401 ) {
	print "WARNING: $url " . $http_response->protocol . " " . $http_response->status_line ."\n";
	exit 1;
} else {
	print "CRITICAL: $url " . $http_response->protocol . " " . $http_response->status_line ."\n";
	exit 2;
}

if ( $exit == 3 ) {
	$exit = 2;
}

print "$exit[$exit] ". join(" ",@message) . "|". join(" ",@message_perf) . "\n";
exit $exit;

```



## check_upshat

```
#!/usr/bin/python3
import smbus2
import smbus
import time
import os
import sys

OK = 0
WARNING = 1
CRITICAL = 2
UNKNOWN = 3

_REG_CONFIG                 = 0x00
_REG_SHUNTVOLTAGE           = 0x01
_REG_BUSVOLTAGE             = 0x02
_REG_POWER                  = 0x03
_REG_CURRENT                = 0x04
_REG_CALIBRATION            = 0x05

class BusVoltageRange:
    RANGE_16V               = 0x00      # set bus voltage range to 16V
    RANGE_32V               = 0x01      # set bus voltage range to 32V (default)

class Gain:
    DIV_1_40MV              = 0x00      # shunt prog. gain set to  1, 40 mV range
    DIV_2_80MV              = 0x01      # shunt prog. gain set to /2, 80 mV range
    DIV_4_160MV             = 0x02      # shunt prog. gain set to /4, 160 mV range
    DIV_8_320MV             = 0x03      # shunt prog. gain set to /8, 320 mV range

class ADCResolution:
    ADCRES_9BIT_1S          = 0x00      #  9bit,   1 sample,     84us
    ADCRES_10BIT_1S         = 0x01      # 10bit,   1 sample,    148us
    ADCRES_11BIT_1S         = 0x02      # 11 bit,  1 sample,    276us
    ADCRES_12BIT_1S         = 0x03      # 12 bit,  1 sample,    532us
    ADCRES_12BIT_2S         = 0x09      # 12 bit,  2 samples,  1.06ms
    ADCRES_12BIT_4S         = 0x0A      # 12 bit,  4 samples,  2.13ms
    ADCRES_12BIT_8S         = 0x0B      # 12bit,   8 samples,  4.26ms
    ADCRES_12BIT_16S        = 0x0C      # 12bit,  16 samples,  8.51ms
    ADCRES_12BIT_32S        = 0x0D      # 12bit,  32 samples, 17.02ms
    ADCRES_12BIT_64S        = 0x0E      # 12bit,  64 samples, 34.05ms
    ADCRES_12BIT_128S       = 0x0F      # 12bit, 128 samples, 68.10ms

class Mode:
    POWERDOW                = 0x00      # power down
    SVOLT_TRIGGERED         = 0x01      # shunt voltage triggered
    BVOLT_TRIGGERED         = 0x02      # bus voltage triggered
    SANDBVOLT_TRIGGERED     = 0x03      # shunt and bus voltage triggered
    ADCOFF                  = 0x04      # ADC off
    SVOLT_CONTINUOUS        = 0x05      # shunt voltage continuous
    BVOLT_CONTINUOUS        = 0x06      # bus voltage continuous
    SANDBVOLT_CONTINUOUS    = 0x07      # shunt and bus voltage continuous


class INA219:
    def __init__(self, i2c_bus=1, addr=0x40):
        self.bus = smbus.SMBus(i2c_bus);
        self.addr = addr

        self._cal_value = 0
        self._current_lsb = 0
        self._power_lsb = 0
        self.set_calibration_32V_2A()

    def read(self,address):
        data = self.bus.read_i2c_block_data(self.addr, address, 2)
        return ((data[0] * 256 ) + data[1])

    def write(self,address,data):
        temp = [0,0]
        temp[1] = data & 0xFF
        temp[0] =(data & 0xFF00) >> 8
        self.bus.write_i2c_block_data(self.addr,address,temp)

    def set_calibration_32V_2A(self):
        self._current_lsb = .1  # Current LSB = 100uA per bit
        self._cal_value = 4096
        self._power_lsb = .002  # Power LSB = 2mW per bit
        self.write(_REG_CALIBRATION,self._cal_value)
        self.bus_voltage_range = BusVoltageRange.RANGE_32V
        self.gain = Gain.DIV_8_320MV
        self.bus_adc_resolution = ADCResolution.ADCRES_12BIT_32S
        self.shunt_adc_resolution = ADCResolution.ADCRES_12BIT_32S
        self.mode = Mode.SANDBVOLT_CONTINUOUS
        self.config = self.bus_voltage_range << 13 | \
                      self.gain << 11 | \
                      self.bus_adc_resolution << 7 | \
                      self.shunt_adc_resolution << 3 | \
                      self.mode
        self.write(_REG_CONFIG,self.config)

    def getShuntVoltage_mV(self):
        self.write(_REG_CALIBRATION,self._cal_value)
        value = self.read(_REG_SHUNTVOLTAGE)
        if value > 32767:
            value -= 65535
        return value * 0.01

    def getBusVoltage_V(self):
        self.write(_REG_CALIBRATION,self._cal_value)
        self.read(_REG_BUSVOLTAGE)
        return (self.read(_REG_BUSVOLTAGE) >> 3) * 0.004

    def getCurrent_mA(self):
        value = self.read(_REG_CURRENT)
        if value > 32767:
            value -= 65535
        return value * self._current_lsb

    def getPower_W(self):
        self.write(_REG_CALIBRATION,self._cal_value)
        value = self.read(_REG_POWER)
        if value > 32767:
            value -= 65535
        return value * self._power_lsb
        
if __name__=='__main__':

    ina219 = INA219(addr=0x42)
    bus_voltage = ina219.getBusVoltage_V()             # voltage on V- (load side)
    shunt_voltage = ina219.getShuntVoltage_mV() / 1000 # voltage between V+ and V- across the shunt
    current = ina219.getCurrent_mA()                   # current in mA
    power = ina219.getPower_W()                        # power in W
    p = (bus_voltage - 6)/2.4*100
    if(p > 100):p = 100
    if(p < 0):p = 0

    print("{:3.1f}%, {:6.3f}V,{:9.6f}A, {:6.3f}W".format(p, bus_voltage, current/1000, power))
    
    if (p > 25): sys.exit(OK)
    if (p > 10): sys.exit(WARNING)
    if (p > 2): sys.exit(CRITICAL)
    
    os.system("shutdown /s /t 1")
```



## check_temp

```
#!/usr/bin/python3
from gpiozero import CPUTemperature
import os
import sys

OK = 0
WARNING = 1
CRITICAL = 2
UNKNOWN = 3

cpu = CPUTemperature()
print(str(cpu.temperature)+"°C")

if (cpu.temperature > 80.0): sys.exit(CRITICAL)
if (cpu.temperature > 80.0): sys.exit(WARNING)
```

