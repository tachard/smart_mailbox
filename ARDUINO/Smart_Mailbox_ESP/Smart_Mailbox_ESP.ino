/*
 * Program for a smart mailbox :
 * Read the value of a HX711 input (load cell sensor)
 * And generating a BLE Server for displaying these
 * Use of deep sleep
 */
 
/* Packages to be included */
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <BLE2902.h>
#include <ESP32Time.h>
#include <Arduino.h>
#include "HX711.h"
#include "soc/rtc.h"

/* BLE related constants variables and classes */
#define BLE_DEVICE_NAME                   "SmartMailboxAchard"
#define BATTERY_SERVICE_UUID              "0000180F-0000-1000-8000-00805f9b34fb" /*Service to get access to battery level */
#define BATTERY_LEVEL_CHARACTERISTIC_UUID "00002a19-0000-1000-8000-00805f9b34fb" /*Characteristic for battery level */

#define LOAD_CELL_SERVICE_UUID            "c961649c-2b90-4add-ad60-21a9f26c048a" /*Service to get load cell weight */
#define LOAD_CELL_CHARACTERISTIC_UUID     "99e8a6f3-85c2-4fb8-98d8-7e748c61b9c7" /*Characteristic to get load cell weight */

#define TIME_SERVICE_UUID                 "bf7d4718-6dcf-4e67-95a1-d5e18bd094a2" /*Service to get ms since Epoch */
#define TIME_CHARACTERISTIC_UUID          "a49c2c03-e157-4565-81a9-3a324c25c23e" /* Characteristic to get ms since Epoch */

BLEServer* pServer = NULL;
BLECharacteristic* pBatteryLevelCharacteristic = NULL;
BLECharacteristic* pLoadCellCharacteristic = NULL;
BLECharacteristic* pTimeCharacteristic = NULL;
bool deviceConnected = false;

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
      pServer->startAdvertising();
    }
};

/* Deep Sleep related constants variables and classes */
#define uS_TO_S_FACTOR 1000000ULL  /* Conversion factor for micro seconds to seconds */
#define TIME_TO_SLEEP  12          /* Time ESP32 will go to sleep (in seconds) */
ESP32Time rtc(3600);                     /* Time object with 1 hour offset (winter french time)*/
HX711 scale;


class MyCharacteristicCallbacks: public BLECharacteristicCallbacks {

    void onWrite(BLECharacteristic *pCharacteristic)
    {
      /* Number of milliseconds since Epoch received */
      int received_data = std::stoi(pCharacteristic->getValue());
      Serial.println(received_data);
      rtc.setTime(received_data);
    }

};

/* Measures related constants variables and classes */
/* HX711 circuit wiring */
const int LOADCELL_DOUT_PIN = 16;
const int LOADCELL_SCK_PIN = 4;
/* Calibration factor, set with another program */
const double CALIBRATION_FACTOR = 0;

/* Main code */
/* Code run when starting (deep sleep included) */
void setup() {

  Serial.begin(115200);

  /* Set deep sleep time */
  rtc.setTime(0, 0, 7, 1, 1, 1970);  /* Set time after booting */
  esp_sleep_enable_timer_wakeup(uS_TO_S_FACTOR * 3600 * TIME_TO_SLEEP);

   /*Create a BLE Device called "SmartMailbox Achard" */
  BLEDevice::init(BLE_DEVICE_NAME);

  /* Set the device as a server */
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks ());

  /* Set the battery service and battery level characteristic */
  BLEService *pBatteryService = pServer->createService(BATTERY_SERVICE_UUID);
  pBatteryLevelCharacteristic = pBatteryService->createCharacteristic(
                                                                       BATTERY_LEVEL_CHARACTERISTIC_UUID,
                                                                       BLECharacteristic::PROPERTY_NOTIFY
                                                                     );
  pBatteryLevelCharacteristic->setValue("0");

  /* Set the battery service and battery level characteristic */
  BLEService *pLoadCellService = pServer->createService(LOAD_CELL_SERVICE_UUID);
  pLoadCellCharacteristic = pLoadCellService->createCharacteristic(
                                                                       LOAD_CELL_CHARACTERISTIC_UUID,
                                                                       BLECharacteristic::PROPERTY_NOTIFY
                                                                     );
  pLoadCellCharacteristic->setValue("0");
  
  /* Set the battery service and battery level characteristic */
  BLEService *pTimeService = pServer->createService(TIME_SERVICE_UUID);
  pTimeCharacteristic = pTimeService->createCharacteristic(
                                                                       TIME_CHARACTERISTIC_UUID,
                                                                       BLECharacteristic::PROPERTY_WRITE
                                                                     );
                                                                     
  pTimeCharacteristic->setCallbacks(new MyCharacteristicCallbacks());
  
  /* Start services */
  pBatteryService->start();
  pLoadCellService->start();
  pTimeService->start();

  /* Add advertising : Say that it's available */
  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->addServiceUUID(BATTERY_SERVICE_UUID);
  pAdvertising->addServiceUUID(LOAD_CELL_SERVICE_UUID);
  pAdvertising->addServiceUUID(TIME_SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06); 
  pAdvertising->start();

  /* Set measures */
  setCpuFrequencyMhz(80);
  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);
  scale.set_scale(CALIBRATION_FACTOR);
  scale.tare();
}

void loop() {
  /* put your main code here, to run repeatedly */

  /* Notify to client if value has changed */
    if (deviceConnected) {
      /* Make measures */
      long weight = scale.get_units(10);
      delay(100);
      /* Map voltage read with GPIO33 to percentage proportionnally (huge hypothesis) (0V = 0% and 3,3V = 100%)*/
      float battery = map(analogRead(33), 0.0f, 4095.0f, 0, 100);
      delay(100);
      
      pBatteryLevelCharacteristic->setValue(std::to_string((int) battery));
      pLoadCellCharacteristic->setValue(std::to_string((int) weight));
      delay(100);
      pBatteryLevelCharacteristic->notify();
      delay(100);
      pLoadCellCharacteristic->notify();
    }
    
    /* Deep Sleep condition */
    if (rtc.getHour(true) >= 19){
        esp_deep_sleep_start();
    }

    /* Repeat every 10 seconds and shut down scale for energy economy */
    scale.power_down();
    delay(10000);
    scale.power_up();
  
}