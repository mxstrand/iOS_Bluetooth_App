//
//  BTViewController.m
//  bluetooth-demo
//
//  Created by John Bender on 9/26/13.
//  
//

#import "BTViewController.h"
#import "BTBubbleView.h"
#import "BTBluetoothManager.h"

static const NSInteger nBubbles = 3;
static const CGFloat bubbleSize = 50.;

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
    
    [BTBluetoothManager instance]; // 

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bluetoothDataReceived:)
                                                 name:@"bluetoothDataReceived"
                                               object:nil];
}

-(void) makeBubbles
{
    NSMutableArray *b = [NSMutableArray new];

    for( NSInteger i = 0; i < nBubbles; i++ ) {
        BTBubbleView *bubble = [[BTBubbleView alloc] initWithFrame:CGRectMake( bubbleSize+1, bubbleSize*(i+1),
                                                                              bubbleSize*(i+1), bubbleSize*(i+1))];
        
        bubble.originalIndex = i;
        NSLog (@"Bubble was given index# %ld", (long)bubble.originalIndex);
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
                NSLog (@"PICKED UP with ARRAY-based viewNumber %ld", (long)viewNumber);
                
                for( BTBubbleView *bubble in bubbles )
                    if( bubble.originalIndex == viewNumber ) {
                        [bubble pickUp];
                        break;
                    }
                break;
            }
            case BluetoothCommandDrop:
            {
                NSInteger viewNumber = [dict[@"viewNumber"] intValue];
                NSLog (@"DROPPED with ARRAY-based viewNumber %ld", (long)viewNumber);

                for( BTBubbleView *bubble in bubbles )
                    if( bubble.originalIndex == viewNumber ) {
                        [bubble drop];
                        break;
                    }
                break;
            }
            case BluetoothCommandMove:
            {
                NSInteger viewNumber = [dict[@"viewNumber"] intValue];
                for( BTBubbleView *bubble in bubbles )
                    if( bubble.originalIndex == viewNumber ) {
                        bubble.center = [dict[@"newCenter"] CGPointValue];
                        break;
                    }
                break;
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    bubbles = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Dispose of any resources that can be recreated.
}


@end
