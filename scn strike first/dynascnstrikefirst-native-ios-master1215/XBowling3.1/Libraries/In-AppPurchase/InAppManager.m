//
//  InAppManager.m
//  Inapp1
//
//  Created by Samar Singla on 18/08/12.
//  Copyright (c) 2012 samarsingla@me.com. All rights reserved.
//

#import "InAppManager.h"
#import "NSData+Base64.h"

@implementation InAppManager
static InAppManager * _sharedHelper;

@synthesize Products;
@synthesize Delegate=_Delegate;
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}


- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    // Your application should implement these two methods.
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [[NSUserDefaults standardUserDefaults]setObject:transaction.transactionIdentifier forKey:@"transactionId"];
     NSLog(@"complete on server=%@",transaction.payment.productIdentifier);
    // Remove the transaction from the payment queue.
    
    NSString *productId=[NSString stringWithFormat:@"%@",transaction.payment.productIdentifier];
    [[NSUserDefaults standardUserDefaults]setValue:productId forKeyPath:@"productId"];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//    NSDictionary *dictionaryParsed = [NSPropertyListSerialization propertyListWithData:transaction.transactionReceipt
//                                                                               options:NSPropertyListImmutable
//                                                                                format:nil
//                                                                                 error:nil];
//    NSLog(@"dictionaryParsed=%@",dictionaryParsed);
//    NSData* data = [NSJSONSerialization dataWithJSONObject:dictionaryParsed
//                    
//                                                   options:NSJSONWritingPrettyPrinted error:nil];
//    NSString* dataString = [[NSString alloc] initWithData:data
//                                                 encoding:NSUTF8StringEncoding];
//    NSLog(@"dataString=%@",dataString);
//    NSString *baseString=[data base64EncodedString];
    
//    [[NSUserDefaults standardUserDefaults]setObject:dataString forKey:@"TransactionDict"];
//    NSString *receipt=[NSString stringWithFormat:@"%@",[dictionaryParsed objectForKey:@"signature"]];
//    NSData *receiptData = [receipt dataUsingEncoding: NSUnicodeStringEncoding];
//    NSString *base64String = [receiptData base64EncodedString];
//    NSLog(@"base64String=%@",baseString);
//    [[NSUserDefaults standardUserDefaults]setValue:baseString forKey:@"TransactionReceipt"];
    NSLog(@"transactionReceipt=%@",[transaction transactionReceipt]);
    NSString *base64String =[[transaction transactionReceipt] base64EncodedString];
    [[NSUserDefaults standardUserDefaults]setValue:base64String forKey:@"TransactionReceipt"];
    NSLog(@"base64String=%@",base64String);
    [_Delegate transactionCompleted];
    
   

}


- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        // Optionally, display an error here.
    }
   // [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    [_Delegate InAppPurchaseFailed:transaction];
   //  NSLog(@"fail on server=%@",transaction.payment.productIdentifier);
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];

}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    [self recordTransaction: transaction];
     NSLog(@"restore on server=%@",transaction.payment.productIdentifier);
    [[NSUserDefaults standardUserDefaults]setObject:transaction.payment.productIdentifier forKey:@"transactionId"];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)recordTransaction:(SKPaymentTransaction *)transaction {   
   NSLog(@"record on server=%@",transaction.payment.productIdentifier);
    [[NSUserDefaults standardUserDefaults] setObject:transaction.payment.productIdentifier forKey:@"Product.productIdentifier"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Record the transaction on the server side...    
}

- (void)provideContent:(NSString *)productIdentifier {
    
    [_Delegate InAppPurchaseSuccessFull:productIdentifier];
 //   [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:productIdentifier];    
}

+ (InAppManager *) sharedHelper {
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[InAppManager alloc] init];
    return _sharedHelper;
    
}

- (void) RequestProductWithIdentifier:(NSSet *)AllProductIdentifires
{
    SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:
                                 AllProductIdentifires];
    request.delegate = self;
    [request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    Products =response.products;
    NSLog(@"product response=%@",Products);
      NSLog(@"invalid response=%@",response.invalidProductIdentifiers);
    [_Delegate InAppPurchaseProductLoaded:Products];
   // [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:Products];    
    
}
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    
    // NSLog(@"product response=%@",queue);
}
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads{
    
   //  NSLog(@"product response=%@",queue);
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    
     NSLog(@"product response=%@",queue);
}


- (void)restorePreviousTransaction:(id)sender {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


-(void)BuyProductAtIndex:(NSInteger)Index{
     [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    SKProduct *Product=[[InAppManager sharedHelper].Products objectAtIndex:Index];
    NSLog(@"buying.. %@",Product.productIdentifier);
    [[NSUserDefaults standardUserDefaults] setObject:Product.productIdentifier forKey:@"Product.productIdentifier"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SKPayment *payment = [SKPayment paymentWithProduct:Product ];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
#pragma mark - Inapp transaction data
- (NSData *)appStoreReceiptForPaymentTransaction:(SKPaymentTransaction *)transaction {
    NSData *receiptData = nil;
    
    // This is just a quick/dummy implementation!
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        NSURL *receiptFileURL = [[NSBundle mainBundle] appStoreReceiptURL];
        receiptData = [NSData dataWithContentsOfURL:receiptFileURL]; // Returns valid NSData object
        
    } else {
        receiptData = transaction.transactionReceipt; // Returns valid NSData object
    }
    
    return receiptData;
}
- (NSDictionary *)dictionaryFromPlistData:(NSError **)outError data:(NSData *)data
{
    NSError *error;
    NSDictionary *dictionaryParsed = [NSPropertyListSerialization propertyListWithData:data
                                                                               options:NSPropertyListImmutable
                                                                                format:nil
                                                                                 error:&error];
    
    if (!dictionaryParsed) {
        
        if (error) {
            *outError = error;
        }
        
        return nil;
    }
    
    return dictionaryParsed;
}

@end
