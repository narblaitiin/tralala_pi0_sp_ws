#! /usr/bin/python
# test for waveshare environment sensor hat (temperature & humidity, air pressure, ambient light intensity, VOC, IR ray, UV ray)
# version 1.0 - 23/01/25

import ICM20948     # 3-axis accelerometer, 3-axis gyroscrope, 3-axis magnetometer
import BME280       # measuring temperature, humidity, and air pressure sensor
import LTR390       # UV sensor
import TSL2591      # digital ambient light sensor, for measuring IR and visible light
import SGP40        # VOC sensor
import smbus

ICM_VAL_WIA = 0xEA
ICM_ADD_WIA = 0x00
ICM_SLAVE_ADDRESS = 0x68
bus = smbus.SMBus(1)

bme280 = BME280.BME280()
bme280.get_calib_param()

light = TSL2591.TSL2591()
uv = LTR390.LTR390()

sgp = SGP40.SGP40()

device_id = bus.read_byte_data(int(ICM_SLAVE_ADDRESS), int(ICM_ADD_WIA))
icm = ICM20948.ICM20948()

print("ICM20948 9-DOF I2C address:0X68")
print("TSL2591 Light I2C address:0X29")
print("LTR390 UV I2C address:0X53")
print("SGP40 VOC I2C address:0X59")
print("bme280 T&H I2C address:0X76")

try:
    while True:
        #time.sleep(1)
        bme = []
        bme = bme280.readData()
        pressure = round(bme[0], 2) 
        temp = round(bme[1], 2) 
        hum = round(bme[2], 2)
        
        lux = round(light.Lux(), 2)
        
        UVS = uv.UVS()
        
        gas = round(sgp.raw(), 2)
        
        icm = []
        icm = icm.getdata()
        
        print("==================================================")
        print("pressure: %7.2f hPa" %pressure)
        print("temp: %-6.2f ℃" %temp)
        print("hum: %6.2f ％" %hum)
        print("lux: %d " %lux)
        print("uv: %d " %UVS)
        print("gas: %6.2f " %gas)
        print("roll = %.2f , pitch = %.2f , Yaw = %.2f" %(icm[0],icm[1],icm[2]))
        print("acceleration: X = %d, Y = %d, Z = %d" %(icm[3],icm[4],icm[5]))
        print("gyroscope: X = %d , Y = %d , Z = %d" %(icm[6],icm[7],icm[8]))
        print("magnetic: X = %d , Y = %d , Z = %d" %(icm[9],icm[10],icm[11]))


except KeyboardInterrupt:
    exit()



