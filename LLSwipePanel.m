//
//  LLSwipePanel.m
//  Carma
//
//  Created by Jeremy Lubin on 5/24/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "LLSwipePanel.h"

@implementation LLSwipePanel

@synthesize mapView;
@synthesize panel;
@synthesize isPanelVisible;
@synthesize panelGripSpace;
@synthesize direction;
@synthesize isSliding;
@synthesize isModalViewPresent;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modalViewControllerPresented:) name:@"ModalViewControllerPresented" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modalViewControllerDismissed:) name:@"ModalViewControllerDismissed" object:nil];
        isModalViewPresent = NO;
    }
    return self;
}

- (void)modalViewControllerPresented:(NSNotification *)notification
{
    isModalViewPresent = YES;
}

- (void)modalViewControllerDismissed:(NSNotification *)notification
{
    isModalViewPresent = NO;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside;
    
    if (isModalViewPresent)
    {
        inside = [super pointInside:point withEvent:event];
    }
    
    else
    {
        inside = [panel pointInside:[self convertPoint:point toView:panel] withEvent:event];
        
        //UIViewController *controller = (UIViewController *)[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController];
        
//        for (id subview in [[[[UIApplication sharedApplication] windows] objectAtIndex:0] subviews])
//        {
//            if ([[subview nextResponder] respondsToSelector:@selector(presentingViewController)]) {
//                NSLog(@"%@", [[subview nextResponder] presentingViewController]);
//            }
//        }
    }
    
    return inside;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
        
    switch (direction) {
        case LLScrollViewScrollDirectionHorizontal:
            
            if (self.contentOffset.x == 0) {
                UITouch *myTouch = [[event allTouches] anyObject];
                if ([myTouch locationInView:self].x > self.frame.size.width - panelGripSpace) {
                    [self setContentOffset:CGPointMake(self.frame.size.width - panelGripSpace, 0) animated:YES];
                }
                
            }
            
            break;
            
        case LLScrollViewScrollDirectionVertical:
            
            if (self.contentOffset.y == 0) {
                UITouch *myTouch = [[event allTouches] anyObject];
                if ([myTouch locationInView:self].y > self.frame.size.height - panelGripSpace) {
                    [self setContentOffset:CGPointMake(self.frame.size.height - panelGripSpace, 0) animated:YES];
                }
                
            }
            
            break;
            
        default:
            break;
    }
    
}

@end
