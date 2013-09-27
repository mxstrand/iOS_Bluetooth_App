//
//  BTBluetoothManager.h
//  bluetooth-demo
//
//  Created by John Bender on 9/26/13.
//  Copyright (c) 2013 General UI, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

typedef enum {
    BluetoothCommandHandshake=1,
    BluetoothCommandNegotiate,
    BluetoothCommandNegotiateConfirm,
    BluetoothCommandLayout,
    BluetoothCommandPickUp,
    BluetoothCommandMove,
    BluetoothCommandDrop
} BluetoothCommand;


@interface BTBluetoothManager : NSObject <MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>
{
    MCNearbyServiceBrowser *nearbyBrowser;
    MCNearbyServiceAdvertiser *nearbyAdvertiser;

    MCSession *session;
    NSString *peerId;

    NSDate *playerIndexTimestamp;
}

@property (nonatomic, readonly) NSString *peerName;
@property (nonatomic, readonly) NSInteger playerIndex;

+(BTBluetoothManager*) instance;
+(BOOL) hasConnection;

-(void) sendDictionaryToPeers:(NSDictionary*)dict;

@end
