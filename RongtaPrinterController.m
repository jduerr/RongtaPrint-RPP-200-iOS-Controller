//
//  RongtaPrinterController.m
//  FCT Gauge
//
//  Created by Johannes on 30.08.17.
//  Copyright © 2017 Johannes Dürr. All rights reserved.
//

#import "RongtaPrinterController.h"

@implementation RongtaPrinterController

@synthesize delegate;



- (instancetype)initWithDelegate:(id)aDelegate{
    self = [self init];
    self.delegate = aDelegate;
    
    return self;
}

- (instancetype)init
{
    if (!self) {
        self = [super init];
    }
    
    printerServiceUUID = [CBUUID UUIDWithString:@"E7810A71-73AE-499D-8C15-FAA9AEF0C3F2"];
    manager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    
    return self;
}

#pragma mark - CBCentralManager

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBManagerStatePoweredOn) {
        NSLog(@"Powered on");
        [self startScan];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"found peripheral with name: %@", peripheral.name);
    
    if (self.delegate) {
        if ([delegate respondsToSelector:@selector(rp_didDiscoverPrinter:withName:)]) {
            [delegate rp_didDiscoverPrinter:peripheral withName:peripheral.name];
        }
    }
}

- (void)connectPeripheral:(CBPeripheral*)peripheral{
    foundPeripheral = peripheral;
    [manager connectPeripheral:peripheral options:nil];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if (self.delegate) {
        if ([delegate respondsToSelector:@selector(rp_didConnectPrinterWithName:)]) {
            [delegate rp_didConnectPrinterWithName:peripheral.name];
        }
    }
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    [manager stopScan];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if ([peripheral.identifier.UUIDString isEqualToString:foundPeripheral.identifier.UUIDString]) {
        foundPeripheral = nil;
        if (delegate != nil && [delegate respondsToSelector:@selector(rp_didDisConnectPrinterWithName:)]) {
            [delegate rp_didDisConnectPrinterWithName:peripheral.name];
        }
    }
    [self startScan];
}

- (void)startScan
{
    NSArray* serviceArray = [NSArray arrayWithObject:printerServiceUUID];
    [manager scanForPeripheralsWithServices:serviceArray options:nil];
}

#pragma mark - CBPeripheral

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    for (CBService* s  in peripheral.services) {
        NSLog(@"%@", [NSString stringWithFormat:@"Did discover Service: %@", s.UUID.UUIDString ]);
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if ([service.UUID.UUIDString isEqualToString:printerServiceUUID.UUIDString]) {
        for (CBCharacteristic* charact in service.characteristics) {
            if ([charact.UUID.UUIDString isEqualToString:@"BEF8D6C9-9C21-4C9E-B632-BD58C1009F9F"]) {
                NSLog(@"Found Printer Characteristic. Trying to print now.");
                
                
                printCharacteristic = charact;
            }
        }
    }
}

- (void)printString:(NSString*)string
{
    if (printCharacteristic) {
        
        NSData* rawData = [string dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:YES];
        NSMutableData* dat = [[NSMutableData alloc]initWithData:rawData];
        
        uint8_t endDat = 0x0A;
        NSData* endData = [NSData dataWithBytes:&endDat length:1];
        [dat appendData:endData];
        [dat appendData:endData];
        [dat appendData:endData];
        
        [foundPeripheral writeValue:dat forCharacteristic:printCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"%@", string);
    }else{
        NSLog(@"Printer not available");
    }
}

@end
