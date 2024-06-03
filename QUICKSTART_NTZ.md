# QuickStart STM32H5 on IoTConnect

## Introduction

This document provides a step-by-step-guide to program and evaluate the 
[STM32H573IIK3Q Discovery kit](https://www.st.com/en/evaluation-tools/stm32h573i-dk.html) board 
on IoTConnect.


## Required Software

* Download the pre-built firmware image from: TBD
* Download and install the [STM32CubeProgrammer](https://www.st.com/en/development-tools/stm32cubeprog.html) for STM32.
* A serial console application such as [Tera Term](https://sourceforge.net/projects/tera-term/). 
 

## Configure Your Board

Open the target board's serial port with your serial console application.

Determine the serial port that the board is connected to and ensure the following settings
are configured as seen in the screenshot below:

![Tera Term Serial Settings](media/teraterm_settings.png "Tera Term Serial Settings")

You will now have access to the command line interface to the device,
enter the command "help" to check that the serial port is functioning.


## Cloud Account Setup
This guide requires an IoTConnect account on AWS.

>**NOTE:**  
> If you have already created an IoTConnect account on AWS you may skip this section.

If you need to create an account, a free trial subscription is available.
Please follow the 
[Creating a New IoTConnect Account](https://github.com/avnet-iotconnect/avnet-iotconnect.github.io/blob/main/documentation/iotconnect/subscription/subscription.md)
guide and ensure to select the [AWS version](https://subscription.iotconnect.io/subscribe?cloud=aws) during registration:

![IoTConnect on AWS](https://github.com/avnet-iotconnect/avnet-iotconnect.github.io/blob/main/documentation/iotconnect/subscription/media/iotc-aws.png)

## Device Setup

### Flash firmware image onto dev kit board.

* Connect an Ethernet cable to the board and to your network.
* Open the STM32CubeProgrammer and connect board to a PC with a USB cable. Ensure you use the USB port labled "USB_STLINK" which is on the opposite side of the board as the Ethernet port.

In STM32CubeProgrammer click the Open File tab or "+" tab at the top of the
window.

Towards the top-right of the STM32CubeProgrammer window is a blue "Download" button, click on this to download the image to the developer kit board. The red LED next to the USB socket will flash during the download.

Once the download is reported as complete, click the green "Disconnect" button in the top-right corner of STM32CubeProgrammer.

Press the black reset button next to the blue button to reset the board.


#### Configure Device Name

Copy the following command, paste it in the terminal, replace "[device name]" with a name of your choice and hit `Enter`.

```
conf set thing_name [device name]
```

#### Configure IoTConnect CPID and Env



Replace "cpid_string" with the actual CPID in the following command and enter into the terminal.  
```
conf set cpid cpid_string
```

Replace "env_string" with the actual CPID in the following command and enter into the terminal. 
```
conf set env env_string
```

### Commit Configuration Changes
Commit the staged configuration changes to non-volatile memory.

```
conf commit
```


### Import the AWS Root CA Certificate

Issue the following command to import the AWS Root CA:  
```
pki import cert root_ca_cert
```

Next, Copy/Paste the contents of ["Starfield Services Root Certificate Authority - G2](https://www.amazontrust.com/repository/SFSRootCAG2.pem) with the "BEGIN" and "END" lines into the terminal and press `Enter`.
Note:  This Root CA Certificate which has signed all four available Amazon Trust Services Root CA certificates.

### Generate a Private Key

Use the following command to generate a local Private Key:  
```
pki generate key
```

### Generate a Self-Signed Certificate
Use the following command to generate a Self-Signed Certificate:  
```
pki generate cert
```

* Save the resulting certificate to a file, including the "BEGIN" and "END" lines, named *devicecert.pem*.

### Register the device with IoTConnect

1. Upload the certificate that you saved from the terminal, devicecert.pem at https://awspoc.iotconnect.io/certificate (CA Certificate Individual)
2. Create a template using **CA certificate Individual** as "Auth Type".
3. Create a device and select the certicate that you uploaded in "Certificate Authority" and upload the same certificate again in "Device Certificate".


In the template add attributes for the following, setting their types as integers:

| Name              | Type      |
|-------------------|-----------|
| accelerometer_x   | Integer   |
| accelerometer_y   | Integer   |
| accelerometer_z   | Integer   |
| gyro_x            | Integer   |
| gyro_y            | Integer   |
| gyro_z            | Integer   |


In the template add the following commands that the device supports:

| Command           | Command-Name | Parameter Required | Receipt Required | OTA   |
--------------------|--------------|--------------------|------------------|-------|
| led-green         | led-green    | No                 | No               | No    |
| led-red           | led-red      | No                 | No               | No    |



### Reset the target device

Reset the device and it shall automatically connect to the WiFi router and AWS MQTT broker based
on the configuration set earlier. 

```
> reset
Resetting device.
```

This will take several seconds to connect, There is usually a wait after the filesystem is mounted.
When connected the following lines should appear on the CLI.

```
<INF>     9574 [MQTTAgent ] Network connection 0x20025538: TLS handshake successful. (mbedtls_transport.c:1367)
<INF>     9574 [MQTTAgent ] Network connection 0x20025538: Connection to xxxxxxxx-ats.iot.us-east-1.amazonaws.com:8883 established. (mbedtls_transport.c:1374)
<INF>     9864 [MQTTAgent ] Starting a clean MQTT Session. (mqtt_agent_task.c:1169)
<INF>    10732 [lwIP      ] Time set to: 2023-10-09T11:56:59.000Z! (time.c:68)
<INF>    10839 [sntp      ] Time received from NTP. Time now: 2023-10-09T11:56:59.000Z! (time.c:100)
```

## Verification

At this point the board should be sending telemetry to the IoTConnect portal. We can verify by checking the "Live Data" feed.
* Return to the *Devices* page and click on the newly created Device ID.
* On the left sub-menu, click "Live Data" and after a few seconds, MQTT data should be shown. 


## Sending Commands

This demo supports commands to turn the red and green LEDs on the development kit board on and off.

Send a command "led-green en"  to enable the green LED, set "led-green" to turn green LED off. The same
applies to "led-red en" for the red LED.


## Erasing settings (factory reset)

The settings can be erased with the following command:

```
> erase
Erasing QSPI NVM, will reset afterwards.
```
