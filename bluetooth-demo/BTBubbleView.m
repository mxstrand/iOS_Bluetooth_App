//
//  BTBubbleView.m
//  bluetooth-demo
//
//  Created by John Bender on 9/26/13.
//  Copyright (c) 2013 General UI, LLC. All rights reserved.
//

#import "BTBubbleView.h"
#import "UIColor+RandomColor.h"
#import <QuartzCore/QuartzCore.h>
#import "BTBluetoothManager.h"

static NSString* const animationKey = @"myCornerRadiusAnimation";

@interface BTBubbleView ()
{
    BOOL isMoving;
    UITouch *movingTouch;
    CGSize touchOffset;
    CGPoint originalPosition;
}
@end

@implementation BTBubbleView

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self ) {
        self.backgroundColor = [UIColor randomColor];
    }
    return self;
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event //touchesBegan is a canned function.
{
    if( isMoving ) return; //if an object is already moving, end function.

    movingTouch = [touches anyObject];

    CGPoint touchPoint = [movingTouch locationInView:self.superview];
    touchOffset = CGSizeMake( self.center.x - touchPoint.x, self.center.y - touchPoint.y );
    originalPosition = self.center;
    [self pickUp];

    // Create a dictionary containing key, value pairs for an indicator of the current command and the acting object. Send that dictionary to your peers via the BluetoothManager.
    NSDictionary *dict = @{@"command": @(BluetoothCommandPickUp),
                           @"viewNumber": @(_originalIndex)};
    [[BTBluetoothManager instance] sendDictionaryToPeers:dict];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event // touchesMoved is a canned function.
{
    if( [touches containsObject:movingTouch] ) {
        CGPoint touchPoint = [movingTouch locationInView:self.superview];
        self.center = CGPointMake( touchPoint.x + touchOffset.width, touchPoint.y + touchOffset.height );

        // Create a dictionary containing key, value pairs for an indicator of the current command and the acting object.
        NSDictionary *dict = @{@"command": @(BluetoothCommandMove),
                               @"viewNumber": @(_originalIndex),
                               @"newCenter": [NSValue valueWithCGPoint:self.center]};
        [[BTBluetoothManager instance] sendDictionaryToPeers:dict];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event // touchesEnded is a canned function.
{
    if( [touches containsObject:movingTouch] ) {
        [self drop];
        movingTouch = nil;

        // Create a dictionary containing key, value pairs for an indicator of the current command and the acting object. Send that dictionary to your peers via the BluetoothManager.
        NSDictionary *dict = @{@"command": @(BluetoothCommandDrop),
                               @"viewNumber": @(_originalIndex)};
        [[BTBluetoothManager instance] sendDictionaryToPeers:dict];
    }
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event // touchesCancelled is a canned function.
{
    if( [touches containsObject:movingTouch] ) {
        [UIView animateWithDuration:0.3 animations:^{
            self.center = originalPosition;
        } completion:^(BOOL finished) {
            [self touchesEnded:touches withEvent:event];
        }];
    }
}


-(void) pickUp
{
    isMoving = TRUE;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.85;
        CGAffineTransform t = CGAffineTransformMakeScale( 1.11, 1.11 );
        t = CGAffineTransformRotate( t, M_PI );
        self.transform = t;
        //        self.transform = CGAffineTransformMakeScale(2.f, 1.5);
        self.layer.cornerRadius = 50.;
    } completion:^(BOOL finished) {
        //        self.layer.cornerRadius = [a.toValue floatValue];
    }];
}


-(void) drop
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.;
        self.transform = CGAffineTransformIdentity;
        self.layer.cornerRadius = 0.1;
    } completion:^(BOOL finished) {
        self.layer.cornerRadius = 0.;
    }];
    
    isMoving = FALSE; // by setting back to false, the touchesBegan function will run fully when triggered.
}

#pragma mark - Animation delegate

-(void) animationDidStart:(CAAnimation *)anim
{
}

-(void) animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
{
    [self.layer removeAnimationForKey:animationKey];
}


@end
