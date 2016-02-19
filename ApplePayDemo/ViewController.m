//
//  ViewController.m
//  ApplePayDemo
//
//  Created by shihaijie on 2/18/16.
//  Copyright © 2016 Saick. All rights reserved.
//

#import "ViewController.h"
@import PassKit;

@interface ViewController () <PKPaymentAuthorizationViewControllerDelegate>

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
    NSArray *networks = @[PKPaymentNetworkChinaUnionPay, PKPaymentNetworkVisa, PKPaymentNetworkMasterCard];
    BOOL canPay = [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:networks];
    NSLog(@"canPay: %d", canPay);
    
    if (!canPay) {
        // setup
        PKPaymentButton *setupButton = [PKPaymentButton buttonWithType:PKPaymentButtonTypeSetUp style:PKPaymentButtonStyleBlack];
        [setupButton addTarget:self action:@selector(applePaySetupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:setupButton];
        
        setupButton.center = CGPointMake(self.view.frame.size.width/2, 100.0f);
    } else {
        // pay button
        PKPaymentButton *payButton = [PKPaymentButton buttonWithType:PKPaymentButtonTypeBuy style:PKPaymentButtonStyleBlack];
        [payButton addTarget:self action:@selector(applePayBuyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:payButton];
        
        payButton.center = CGPointMake(self.view.frame.size.width/2, 100.0f);
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

- (void)applePayBuyButtonPressed:(PKPaymentButton *)button
{
    // 发起支付请求
    // PKPaymentRequest
    PKPaymentRequest *request = [PKPaymentRequest new];
    request.currencyCode = @"CNY";
    request.countryCode = @"CN";
    request.merchantIdentifier = @"merchant.net.saick.app";
    
    // 构造金额
    {
        // 2.01 subtotal
        NSDecimalNumber *subtotalAmount = [NSDecimalNumber decimalNumberWithMantissa:201 exponent:-2 isNegative:NO];
        PKPaymentSummaryItem *subtotal = [PKPaymentSummaryItem summaryItemWithLabel:@"Subtotal" amount:subtotalAmount];
        
        // 2.00 discount
        NSDecimalNumber *discountAmount = [NSDecimalNumber decimalNumberWithMantissa:200 exponent:-2 isNegative:YES];
        PKPaymentSummaryItem *discount = [PKPaymentSummaryItem summaryItemWithLabel:@"Discount" amount:discountAmount];
        
        // 0.01 grand total
        NSDecimalNumber *totalAmount = [NSDecimalNumber zero];
        totalAmount = [totalAmount decimalNumberByAdding:subtotalAmount];
        totalAmount = [totalAmount decimalNumberByAdding:discountAmount];
        PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"Saick Company Name" amount:totalAmount];
        
        NSArray *summaryItems = @[subtotal, discount, total];
        request.paymentSummaryItems = summaryItems;
    }
    
    // Shipping Method (skip now)
    
    // 支付标准
    {
        request.supportedNetworks = @[PKPaymentNetworkChinaUnionPay, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
        // Supports 3DS only
        request.merchantCapabilities = PKMerchantCapability3DS;
    }
    
    // 配送信息以及mail地址
    {
        //            request.requiredBillingAddressFields = PKAddressFieldEmail;
        //            request.requiredBillingAddressFields = PKAddressFieldEmail | PKAddressFieldPostalAddress;
        
        /*
         Address information can come from a wide range of sources in iOS. Always validate the information before you use it.
         */
        //            PKContact *contact = [[PKContact alloc] init];
        //
        //            NSPersonNameComponents *name = [[NSPersonNameComponents alloc] init];
        //            name.givenName = @"John";
        //            name.familyName = @"Appleseed";
        //
        //            contact.name = name;
        //
        //            CNMutablePostalAddress *address = [[CNMutablePostalAddress alloc] init];
        //            address.street = @"1234 Laurel Street";
        //            address.city = @"Atlanta";
        //            address.state = @"GA";
        //            address.postalCode = @"30303";
        //
        //            contact.postalAddress = address;
        //            request.shippingContact = contact;
    }
    
    // Storing Additional Information
    {
        //            request.applicationData =
    }
    
    // Authorizing Payment
    {
        PKPaymentAuthorizationViewController *viewController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        if (!viewController) {
            /* ... Handle error ... */
        } else {
            viewController.delegate = self;
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }
}

#pragma mark - PKPaymentAuthorizationViewControllerDelegate

// It doesn’t take a completion block, and it can be called at any time.
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)paymentAuthorizationViewControllerWillAuthorizePayment:(PKPaymentAuthorizationViewController *)controller
{
    
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
//    NSError *error;
//    ABMultiValueRef addressMultiValue = ABRecordCopyValue(payment.billingAddress, kABPersonAddressProperty);
//    NSDictionary *addressDictionary = (__bridge_transfer NSDictionary *) ABMultiValueCopyValueAtIndex(addressMultiValue, 0);
//    NSData *json = [NSJSONSerialization dataWithJSONObject:addressDictionary options:NSJSONWritingPrettyPrinted error: &error];
    
    // ... Send payment token, shipping and billing address, and order information to your server ...
    
//    PKPaymentAuthorizationStatus status;  // From your server
//    completion(status);
}

@end
