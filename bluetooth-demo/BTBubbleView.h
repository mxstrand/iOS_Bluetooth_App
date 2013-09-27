//
//  BTBubbleView.h
//  bluetooth-demo
//
//  Created by John Bender on 9/26/13.
//  
//

#import <UIKit/UIKit.h>

@interface BTBubbleView : UIView

@property (nonatomic, assign) NSInteger originalIndex;

-(void) pickUp;
-(void) drop;

@end
