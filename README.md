# COVIDSafe Scanner

## About

This app aims to discover nearby devices that are running the Ausralian Government's COVIDSafe app, which is currently available for iOS and Android devices. It does this by looking for a unique identifier that is broadcast by devices running the app.

**Disclaimer:** I am by no means a Bluetooth expert, in fact this is the first time I have ever worked with Bluetooth APIs. So there are bound to be issues in this code, but by and large it seems to do the job it is intended to do, and is really just intended to be a fun tool to help us all learn a bit more about COVIDSafe.

## Setup

1. Clone this repository
1. Open `CovidSafe Scanner.xcodeproj` in XCode
1. Select your developer account from the `Signing & Capabilities` tab of the project
1. Run it!

## General Information

To start scanning for Bluetooth devices running COVIDSafe, tap the `Start Scanning` button. While scanning, the app will look for new devices. To step scanning for new devices, tap `Stop Scanning`. Any previously discovered devices will continue to update their status until you tap `Clear History` to clear all devices discovered since the app was started.

The scan is only looking for devices that advertise the unique COVIDSafe service identifier, so should not affect any other Bluetooth devices in the vicinity.

A device can be in one of 3 states:

* Disconnected – This means it was seen at some point, but is no longer in range / cannot be connected to any longer.
* Connected (No Data) – This means the device can be seen, but, the data advertised by the COVIDSafe app cannot be fetched. This tends to happen if the app has been in the background for a while.
* Connected (Data Available) – This means the device can be seen and the data advertised by the COVIDSafe app can be fetched.

## Known Issues

* Sometimes when starting the scan, an error occurs in the CoreBluetooth framework. This often seems to happen if you start scanning very shortly after opening the app. If this happens, you can just stop and start scanning again and it usually resolves itself.
* Android devices tend to end up duplicated multiple times in the list. It would appear they show up as different peripherals coming from the same device and I haven't yet worked out the best way to uniquely identify them (I haven't got an Android device to test with, so help is welcome!)