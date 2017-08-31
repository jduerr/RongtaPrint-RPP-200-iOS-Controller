# RongtaPrint-RPP-200-iOS-Controller
A protocoll/delegate controller class to easily connect to Rongta RPP-200 BTLE Bluetooth printer and print text.

# Usage

1. Import RongtaprinterController.h and add protocol to your classes header file.

'''
#import "RongtaPrinterController.h"
...
@interface ViewController : UIViewController <RongtaPrinterDelegate>
...
'''

2. Instantiate printerController Object (i. e. in init or viewDidLoad...)

'''
// in header
RongtaPrinterController* printController;

// in implementation
printController = [[RongtaPrinterController alloc]initWithDelegate:self];
'''

The RongtaPrinterController will start scanning immediately!

3. Make sure you have implemented at least those three delegate methods:

'''
#pragma mark - RongtaPrinterController Delegate

- (void)rp_didDiscoverPrinter:(CBPeripheral *)printer withName:(NSString *)name
{    
    // printer was discovered --> connect to it
    [printController connectPeripheral:printer];
    
    // in production you would keep a list of printers and give the user a chance to select one.
}

- (void)rp_didConnectPrinterWithName:(NSString *)name{
    [_printButton setEnabled:YES];
}

- (void)rp_didDisConnectPrinterWithName:(NSString *)name
{
    [_printButton setEnabled:NO];
}
'''
