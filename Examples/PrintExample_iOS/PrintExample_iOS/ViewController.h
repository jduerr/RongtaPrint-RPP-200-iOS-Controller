//
//  ViewController.h
//  PrintExample_iOS
//
//  Created by Johannes on 31.08.17.
//  Copyright © 2017 whileCoffee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RongtaPrinterController.h"

@interface ViewController : UIViewController <RongtaPrinterDelegate>
{
    RongtaPrinterController* printController;
}

@property (weak, nonatomic) IBOutlet UIButton *printButton;
@property (weak, nonatomic) IBOutlet UILabel *printerStatusLabel;

- (IBAction)printHelloWorldButtonPushed:(id)sender;

@end

