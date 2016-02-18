//
//  ViewController.m
//  ApplePayDemo
//
//  Created by shihaijie on 2/18/16.
//  Copyright © 2016 Saick. All rights reserved.
//

#import "ViewController.h"
@import PassKit;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 是否支持ApplePay，系统版本、硬件、ParentControl
    BOOL isSupportPay = [PKPaymentAuthorizationViewController canMakePayments];
    NSLog(@"isSupportPay: %d", isSupportPay);
    if (!isSupportPay) {
        return;
    } else {
        // continue
    }
    
    // 是否支持这些支持方式（可能没有绑卡）
    NSArray *networks = @[PKPaymentNetworkPrivateLabel, PKPaymentNetworkVisa, PKPaymentNetworkMasterCard];
    BOOL canPay = [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:networks];
    NSLog(@"canPay: %d", canPay);
    
    if (!canPay) {
        // setup
        PKPaymentButton *setupButton = [PKPaymentButton buttonWithType:PKPaymentButtonTypeSetUp style:PKPaymentButtonStyleBlack];
        [setupButton addTarget:self action:@selector(applePaySetupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:setupButton];
        
        setupButton.center = CGPointMake(self.view.frame.size.width/2, 100.0f);
    } else {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)applePaySetupButtonPressed:(PKPaymentButton *)button
{
    // openPaymentSetup
    [[PKPassLibrary new] openPaymentSetup];
}

@end
