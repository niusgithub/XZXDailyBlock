//
//  XZXTransitionAnimator.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/12.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXTransitionAnimator.h"

@interface XZXTransitionAnimator()

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) CGFloat splitLineY;

@end


@implementation XZXTransitionAnimator

- (instancetype)initWithDuration:(NSTimeInterval)duration splitLineY:(CGFloat)splitLineY {
    if (self = [super init]) {
        self.duration = duration;
        self.splitLineY = splitLineY;
    }
    return self;
}


//| ----------------------------------------------------------------------------
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return _duration;
}


//| ----------------------------------------------------------------------------
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    // For a Presentation:
    //      fromView = The presenting view.
    //      toView   = The presented view.
    // For a Dismissal:
    //      fromView = The presented view.
    //      toView   = The presenting view.
    UIView *fromView;
    UIView *toView;
    
    // In iOS 8, the viewForKey: method was introduced to get views that the
    // animator manipulates.  This method should be preferred over accessing
    // the view of the fromViewController/toViewController directly.
    // It may return nil whenever the animator should not touch the view
    // (based on the presentation style of the incoming view controller).
    // It may also return a different view for the animator to animate.
    //
    // Imagine that you are implementing a presentation similar to form sheet.
    // In this case you would want to add some shadow or decoration around the
    // presented view controller's view. The animator will animate the
    // decoration view instead and the presented view controller's view will
    // be a child of the decoration view.
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    
    fromView.frame = [transitionContext initialFrameForViewController:fromViewController];
    toView.frame = [transitionContext finalFrameForViewController:toViewController];
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    // Add a reduced snapshot of the toView to the container
//    UIView *toViewSnapshot = [toView resizableSnapshotViewFromRect:toView.frame afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
//    CATransform3D scale = CATransform3DIdentity;
//    toViewSnapshot.layer.transform = CATransform3DScale(scale, 0.8, 0.8, 1);
//    [containerView addSubview:toViewSnapshot];
//    [containerView sendSubviewToBack:toViewSnapshot];
    //toView.frame = CGRectOffset(toView.frame, 0, _splitLineY - 64);
    [containerView addSubview:toView];
    
    
    // Create two-part snapshots of the from- view
    
    // snapshot the upper-hand side of the from- view
    CGRect upperSnapshotRegion = CGRectMake(0, 0, fromView.frame.size.width, _splitLineY);
    UIView *upperHandView = [fromView resizableSnapshotViewFromRect:upperSnapshotRegion  afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    upperHandView.frame = CGRectOffset(upperSnapshotRegion, 0, 64);
    [containerView addSubview:upperHandView];
    
    // snapshot the bottom-hand side of the from- view
    CGRect bottomSnapshotRegion = CGRectMake(0, _splitLineY, fromView.frame.size.width, fromView.frame.size.height - _splitLineY);
    UIView *bottomHandView = [fromView resizableSnapshotViewFromRect:bottomSnapshotRegion  afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    bottomHandView.frame = CGRectOffset(bottomSnapshotRegion, 0, 64);
    [containerView addSubview:bottomHandView];
    
    // remove the view that was snapshotted
    [fromView removeFromSuperview];
    
    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // Open the portal doors of the from-view
#warning 50是暂定高度
                         upperHandView.frame = CGRectOffset(upperHandView.frame, 0, - upperHandView.frame.size.height + 50);
                         bottomHandView.frame = CGRectOffset(bottomHandView.frame, 0, bottomHandView.frame.size.height);
                         
                         // zoom in the to-view
//                         toViewSnapshot.center = toView.center;
//                         toViewSnapshot.frame = toView.frame;
                         // toView跟随upperHandView上升
                         //toView.frame = CGRectOffset(toView.frame, 0, - self->_splitLineY + 64);
                         
                     } completion:^(BOOL finished) {
                         
                         // remove all the temporary views
                         if ([transitionContext transitionWasCancelled]) {
                             [containerView addSubview:fromView];
                             [self removeOtherViews:fromView];
                         } else {
                             // add the real to- view and remove the snapshots
                             [containerView addSubview:toView];
                             [self removeOtherViews:toView];
                         }
                         
                         // inform the context of completion
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];

}

- (void)removeOtherViews:(UIView*)viewToKeep {
    UIView *containerView = viewToKeep.superview;
    for (UIView *view in containerView.subviews) {
        if (view != viewToKeep) {
            [view removeFromSuperview];
        }
    }
}

@end
