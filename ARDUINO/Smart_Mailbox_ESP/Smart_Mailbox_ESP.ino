/*
 * Program for a smart mailbox :
 * Read the value of a HX711 input (load cell sensor)
 * And generating a BLE Server for displaying these
 * Use of deep sleep probably
 */


// Packages to be included
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>


// Constants
#define BATTERY_SERVICE_UUID              "0x180F" //Service to get access to battery level
#define BATTERY_LEVEL_CHARACTERISTIC_UUID "0x2A19" //Characteristic for battery level

#define DEVICE_TIME_SERVICE_UUID          "0x1847" //Service to get device time
#define DEVICE_TIME_CHARACTERISTIC_UUID   "0x2B90" //Characteristic to get device time

#define LOAD_CELL_SERVICE_UUID            "c961649c-2b90-4add-ad60-21a9f26c048a" //Service to get load cell weight
#define LOAD_CELL_CHARACTERISTIC_UUID     "99e8a6f3-85c2-4fb8-98d8-7e748c61b9c7" //Characteristic to get load cell weight

#define KILOGRAM_UUID "0x2702" //Descriptor of kilogram
#define UNITLESS_UUID "0x2700" //Descriptor of unitless



void setup() {
  // Code run when starting (deep sleep included)
  Serial.begin(115200);

   //Create a BLE Device called "SmartMailbox Achard"
  BLEDevice::init("SmartMailbox Achard");

  // Set the device as a server
  BLEServer *pServer = BLEDevice::createServer();

  // Set the battery service and battery level characteristic
  BLEService *pBatteryService = pServer->createService(BATTERY_SERVICE_UUID);
  BLECharacteristic *pBatteryLevelCharacteristic = pBatteryService->createCharacteristic(
                                                                       BATTERY_LEVEL_CHARACTERISTIC_UUID,
                                                                       BLECharacteristic::PROPERTY_READ
                                                                     );
  pBatteryLevelCharacteristic->setValue("Battery level");

  // Set the device time service and device time characteristic
  BLEService *pDeviceTimeService = pServer->createService(DEVICE_TIME_SERVICE_UUID);
  BLECharacteristic *pDeviceTimeCharacteristic = pDeviceTimeService->createCharacteristic(
                                                                       DEVICE_TIME_CHARACTERISTIC_UUID,
                                                                       BLECharacteristic::PROPERTY_READ
                                                                     );
  pDeviceTimeCharacteristic->setValue("Device Time");

  // Set the battery service and battery level characteristic
  BLEService *pLoadCellService = pServer->createService(LOAD_CELL_SERVICE_UUID);
  BLECharacteristic *pLoadCellCharacteristic = pLoadCellService->createCharacteristic(
                                                                       LOAD_CELL_CHARACTERISTIC_UUID,
                                                                       BLECharacteristic::PROPERTY_READ
                                                                     );
  pLoadCellCharacteristic->setValue("Load cell");

  // Start services
  pBatteryService->start();
  pDeviceTimeService->start();
  pLoadCellService->start();

  // Add advertising : Say that it's available
  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->start();
}

void loop() {
  // put your main code here, to run repeatedly:

  // Do nothing, even when someone connects.
  delay(2000);
}
