//
//  RongtaPrinterController.h
//  FCT Gauge
//
//  Created by Johannes on 30.08.17.
//  Copyright © 2017 Johannes Dürr. All rights reserved.
//
@import CoreBluetooth;
#import <Foundation/Foundation.h>


@interface RongtaPrinterController : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
{
    CBUUID* printerServiceUUID; //= [CBUUID UUIDWithString:@"E7810A71-73AE-499D-8C15-FAA9AEF0C3F2"];
    CBCharacteristic* printCharacteristic;
    CBCentralManager* manager;
    CBPeripheral* foundPeripheral;
}

@property (nonatomic) id delegate;

- (instancetype)initWithDelegate:(id)aDelegate;

- (void)connectPeripheral:(CBPeripheral*)peripheral;
- (void)printString:(NSString*)string;

@end



@protocol RongtaPrinterDelegate <NSObject>

@optional

@required

- (void)rp_didDiscoverPrinter:(CBPeripheral*)printer withName:(NSString*)name;
- (void)rp_didConnectPrinterWithName:(NSString*)name;
- (void)rp_didDisConnectPrinterWithName:(NSString*)name;
@end
