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
#include <BLE2902.h>

// Constants
#define BLE_DEVICE_NAME                   "SmartMailboxAchard"
#define BATTERY_SERVICE_UUID              "0000180F-0000-1000-8000-00805f9b34fb" //Service to get access to battery level
#define BATTERY_LEVEL_CHARACTERISTIC_UUID "00002a19-0000-1000-8000-00805f9b34fb" //Characteristic for battery level

#define LOAD_CELL_SERVICE_UUID            "c961649c-2b90-4add-ad60-21a9f26c048a" //Service to get load cell weight
#define LOAD_CELL_CHARACTERISTIC_UUID     "99e8a6f3-85c2-4fb8-98d8-7e748c61b9c7" //Characteristic to get load cell weight

#define KILOGRAM_UUID "0x2702" //Descriptor of kilogram
#define UNITLESS_UUID "0x2700" //Descriptor of unitless

#define uS_TO_H_FACTOR 3600000000 //uS to hours factor (deep sleep)
#define TIME_TO_SLEEP 16 //Number of hours to sleep

// Variables
int loopCount = 0; 
int delai = 0;
BLEServer* pServer = NULL;
BLECharacteristic* pBatteryLevelCharacteristic = NULL;
BLECharacteristic* pLoadCellCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;

// Classes
class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
    }
};

void setup() {
  // Code run when starting (deep sleep included)
  Serial.begin(115200);

  // Set deep sleep time
  esp_sleep_enable_timer_wakeup(uS_TO_H_FACTOR * TIME_TO_SLEEP);

   //Create a BLE Device called "SmartMailbox Achard"
  BLEDevice::init(BLE_DEVICE_NAME);

  // Set the device as a server
  pServer = BLEDevice::createServer();

  // Set the battery service and battery level characteristic
  BLEService *pBatteryService = pServer->createService(BATTERY_SERVICE_UUID);
  pBatteryLevelCharacteristic = pBatteryService->createCharacteristic(
                                                                       BATTERY_LEVEL_CHARACTERISTIC_UUID,
                                                                       BLECharacteristic::PROPERTY_READ
                                                                     );
  pBatteryLevelCharacteristic->setValue("Battery level");

  // Set the battery service and battery level characteristic
  BLEService *pLoadCellService = pServer->createService(LOAD_CELL_SERVICE_UUID);
  pLoadCellCharacteristic = pLoadCellService->createCharacteristic(
                                                                       LOAD_CELL_CHARACTERISTIC_UUID,
                                                                       BLECharacteristic::PROPERTY_READ
                                                                     );
  pLoadCellCharacteristic->setValue("Load cell");

  // Start services
  pBatteryService->start();
  pLoadCellService->start();

  // Add advertising : Say that it's available
  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->addServiceUUID(BATTERY_SERVICE_UUID);
  pAdvertising->addServiceUUID(LOAD_CELL_SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06); 
  pAdvertising->start();
}

void loop() {
  // put your main code here, to run repeatedly:

  // Count how many loops done and delay for each loop. A loop lasts 10 seconds.
  delai = 0;
  loopCount++;

  // Notify if value has changed
    if (deviceConnected) {
        pBatteryLevelCharacteristic->setValue("New battery value");
        pLoadCellCharacteristic->setValue("New load cell value");
        pBatteryLevelCharacteristic->notify();
        pLoadCellCharacteristic->notify();
        delai = 3;
        delay(delai); // bluetooth stack will go into congestion, if too many packets are sent, in 6 hours test i was able to go as low as 3ms
    }
    // Déconnexion
    if (!deviceConnected && oldDeviceConnected) {
        delai = 500;
        delay(500); // give the bluetooth stack the chance to get things ready
        pServer->startAdvertising(); // restart advertising
        Serial.println("start advertising");
        oldDeviceConnected = deviceConnected;
    }
    // Connexion
    if (deviceConnected && !oldDeviceConnected) {
        // do stuff here on connecting
        oldDeviceConnected = deviceConnected;
    }

    //If 24-TIME_TO_SLEEP hours have passed, go into deep sleep for remaining time
    if (loopCount == (24-TIME_TO_SLEEP)*360){
        esp_deep_sleep_start();
    }

    delay(10000-delai);
  
}
