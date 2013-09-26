//
//  BTViewController.m
//  bluetooth-demo
//
//  Created by John Bender on 9/26/13.
//  Copyright (c) 2013 General UI, LLC. All rights reserved.
//

#import "BTViewController.h"
#import "BTBubbleView.h"
#import "BTBluetoothManager.h"

static const NSInteger nBubbles = 5;
static const CGFloat bubbleSize = 60.;

@interface BTViewController ()
{
    NSArray *bubbles;
}
@end

@implementation BTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self makeBubbles];

    [BTBluetoothManager instance];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bluetoothDataReceived:)
                                                 name:@"bluetoothDataReceived"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) makeBubbles
{
    NSMutableArray *b = [NSMutableArray new];

    for( NSInteger i = 0; i < nBubbles; i++ ) {
        BTBubbleView *bubble = [[BTBubbleView alloc] initWithFrame:CGRectMake( bubbleSize*i, bubbleSize*i,
                                                                              bubbleSize, bubbleSize )];
        bubble.originalIndex = i;
        [self.view addSubview:bubble];
        [b addObject:bubble];
    }

    bubbles = [NSArray arrayWithArray:b];
}


-(void) bluetoothDataReceived:(NSNotification*)note
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSDictionary *dict = [note object];
        NSInteger command = [dict[@"command"] intValue];
        switch( command ) {
            case BluetoothCommandPickUp:
            {
                NSInteger viewNumber = [dict[@"viewNumber"] intValue];
                BTBubbleView *bubble = self.view.subviews[viewNumber];
                if( [bubble isKindOfClass:[BTBubbleView class]] )
                    [bubble pickUp];
                break;
            }
            case BluetoothCommandDrop:
            {
                NSInteger viewNumber = [dict[@"viewNumber"] intValue];
                BTBubbleView *bubble = self.view.subviews[viewNumber];
                if( [bubble isKindOfClass:[BTBubbleView class]] )
                    [bubble drop];
                break;
            }
            case BluetoothCommandMove:
            {
                NSInteger viewNumber = [dict[@"viewNumber"] intValue];
                BTBubbleView *bubble = self.view.subviews[viewNumber];
                if( [bubble isKindOfClass:[BTBubbleView class]] )
                    bubble.center = [dict[@"newCenter"] CGPointValue];
            }
        }
    }];
}

@end
