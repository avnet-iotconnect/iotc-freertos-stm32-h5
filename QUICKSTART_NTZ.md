# QuickStart STM32H5 on IoTConnect

## 1. Introduction  
This document provides a step-by-step-guide to program and evaluate the 
[STM32H573IIK3Q Discovery kit](https://www.st.com/en/evaluation-tools/stm32h573i-dk.html) on IoTConnect.

## 2. Required Software  
* Download the pre-built firmware image from: TBD
* Download and install the [STM32CubeProgrammer](https://www.st.com/en/development-tools/stm32cubeprog.html) for STM32.
* A serial console application such as [Tera Term](https://sourceforge.net/projects/tera-term/). 

## 3. Setup Hardware  
* Connect an Ethernet cable to the board and to a local network.
* Connect a USB cable from your PC to the USB port labled "USB_STLINK" which is on the opposite side of the board as the Ethernet port.
![H5 STLINK PORT](media/H5_STLINK_PORT.png)  

## 4. Configure the Serial Terminal  
* Open TeraTerm and configure the settings as shown in the screenshot below:  
![Tera Term Serial Settings](media/teraterm_settings.png "Tera Term Serial Settings")  
* Open a new serial connect and select the COM port which contains "STMicroelectronics" in the name.   
* Enter the following command to ensure the serial port is functioning:  
```
help
```

## 5. Setup an IoTConnect Cloud Account
This guide requires an IoTConnect account on AWS.

>**NOTE:**  
> If you have already created an IoTConnect account on AWS you may skip this section.

If you need to create an account, a free trial subscription is available.
Please follow the 
[Creating a New IoTConnect Account](https://github.com/avnet-iotconnect/avnet-iotconnect.github.io/blob/main/documentation/iotconnect/subscription/subscription.md)
guide and ensure to select the [AWS version](https://subscription.iotconnect.io/subscribe?cloud=aws) during registration:

![IoTConnect on AWS](https://github.com/avnet-iotconnect/avnet-iotconnect.github.io/blob/main/documentation/iotconnect/subscription/media/iotc-aws.png)

## 6. Device Setup  
### 6.1 Flash Firmware  

* Extract the firmware downloaded earlier and take note of the location
* Launch the STM32CubeProgrammer  
* In STM32CubeProgrammer ensure "ST-LINK" is selected as the connection method in the top right:  
[pic]  
* Click **Connect** next to this drop-down  
* Click the 2nd icon down on the left side to open the "Erasing & Programming Screen"  
* Click **Browse** and select the firmware file extracted previously  
* Click **Start Programming**  
[pic]  

* Once the flashing is reported as complete, click the  "Disconnect" button in the top-right corner.  
* Press the black reset button next to the blue button to reset the board.  

### 6.2 Configure Device Name  
Copy the following command, paste it in the terminal, replace "[device name]" with a name of your choice and hit `Enter`.  
```
conf set thing_name [device name]
```

### 6.3 Configure IoTConnect CPID and Env  
Replace "cpid_string" with the actual CPID in the following command and enter into the terminal.  
```
conf set cpid cpid_string
```

Replace "env_string" with the actual CPID in the following command and enter into the terminal.  
```
conf set env env_string
```

### 6.4 Commit Configuration Changes  
Commit the staged configuration changes to non-volatile memory.  
```
conf commit
```

### 6.5 Import the AWS Root CA Certificate  
Issue the following command to import the AWS Root CA:  
```
pki import cert root_ca_cert
```

* Copy/Paste the contents of ["Starfield Services Root Certificate Authority - G2](https://www.amazontrust.com/repository/SFSRootCAG2.pem) with the "BEGIN" and "END" lines into the terminal and press `Enter`.
Note:  This Root CA Certificate which has signed all four available Amazon Trust Services Root CA certificates.

### 6.6 Generate a Private Key 
Use the following command to generate a local Private Key:  
```
pki generate key
```

### 6.7 Generate a Self-Signed Certificate  
Use the following command to generate a Self-Signed Certificate:  
```
pki generate cert
```

* Save the resulting certificate to a file, including the "BEGIN" and "END" lines, named *devicecert.pem*.  

## 6. Configure IoTConnect  
1. Upload the certificate that you saved from the terminal, devicecert.pem at https://awspoc.iotconnect.io/certificate (CA Certificate Individual)
2. Create a template using **CA certificate Individual** as "Auth Type".
3. Create a device and select the certicate that you uploaded in "Certificate Authority" and upload the same certificate again in "Device Certificate".


In the template add attributes for the following, setting their types as integers:

## 7. Reset the target device

* Reset the device and it shall automatically connect to the AWS MQTT broker based on the configuration set previously. 

* After several seconds the following lines should appear in the terminal:  

```
<INF>     9574 [MQTTAgent ] Network connection 0x20025538: TLS handshake successful. (mbedtls_transport.c:1367)
<INF>     9574 [MQTTAgent ] Network connection 0x20025538: Connection to xxxxxxxx-ats.iot.us-east-1.amazonaws.com:8883 established. (mbedtls_transport.c:1374)
<INF>     9864 [MQTTAgent ] Starting a clean MQTT Session. (mqtt_agent_task.c:1169)
<INF>    10732 [lwIP      ] Time set to: 2023-10-09T11:56:59.000Z! (time.c:68)
<INF>    10839 [sntp      ] Time received from NTP. Time now: 2023-10-09T11:56:59.000Z! (time.c:100)
```

## 8. Verification

At this point the board should be sending telemetry to the IoTConnect platform.
* To verify, return to the *Devices* page and click on the newly created Device ID.
* On the left sub-menu, click *Live Data* and after a few seconds, MQTT data should be shown. 
