//
//  TestAsync.m
//
//  Created by Bakken, Sveinung on 10/21/13.
//  Copyright (c) 2013 Clear Channel. All rights reserved.
//

#import "XCTAsyncTestCase.h"

@interface TestAsync : XCTAsyncTestCase

@end

@implementation TestAsync

- (void)testBlockSample
{
    [self prepare];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        sleep(1.0);
        [self notify:kXCTUnitWaitStatusSuccess];
    });
    // Will wait for 2 seconds before expecting the test to have status success
    // Potential statuses are:
    //    kXCTUnitWaitStatusUnknown,    initial status
    //    kXCTUnitWaitStatusSuccess,    indicates a successful callback
    //    kXCTUnitWaitStatusFailure,    indicates a failed callback, e.g login operation failed
    //    kXCTUnitWaitStatusCancelled,  indicates the operation was cancelled
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:2.0];
}

- (void)testPerformSelector
{
    [self prepare];
    [self performSelector:@selector(markAsCancelled) withObject:nil afterDelay:2.0];
    [self waitForStatus:kXCTUnitWaitStatusCancelled timeout:3.0];
}

- (void)markAsCancelled
{
    [self notify:kXCTUnitWaitStatusCancelled];
}

@end
