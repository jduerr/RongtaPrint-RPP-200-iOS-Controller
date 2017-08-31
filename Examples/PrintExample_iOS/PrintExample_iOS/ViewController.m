//
//  ViewController.m
//  PrintExample_iOS
//
//  Created by Johannes on 31.08.17.
//  Copyright © 2017 whileCoffee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    printController = [[RongtaPrinterController alloc]initWithDelegate:self];
    
    [_printerStatusLabel setText:@"Searching printer"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)printHelloWorldButtonPushed:(id)sender {
    if (printController) {
        [printController printString:@"Hello World"];
    }
}

#pragma mark - RongtaPrinterController Delegate

- (void)rp_didDiscoverPrinter:(CBPeripheral *)printer withName:(NSString *)name
{
    [_printerStatusLabel setText:[NSString stringWithFormat:@"Found %@", name]];
    
    // printer was discovered --> connect to it
    [printController connectPeripheral:printer];
    
    // in production you would keep a list of printers and give the user a chance to select one.
    
}

- (void)rp_didConnectPrinterWithName:(NSString *)name{
    [_printerStatusLabel setText:[NSString stringWithFormat:@"Connected to %@", name]];
    [_printButton setEnabled:YES];
}

- (void)rp_didDisConnectPrinterWithName:(NSString *)name
{
    [_printerStatusLabel setText:[NSString stringWithFormat:@"Disconnected %@", name]];
    [_printButton setEnabled:NO];
}

@end
