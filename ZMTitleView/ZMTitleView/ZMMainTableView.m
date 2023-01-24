//
//  ZMMainTableView.m
//  ZMTitleView
//
//  Created by ming zhou on 2023/1/23.
//

#import "ZMMainTableView.h"

@interface ZMMainTableView ()<UIGestureRecognizerDelegate>

@end

@implementation ZMMainTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if(otherGestureRecognizer.view == self.noSimultaneouslyView) {
        return NO;
    }
    return YES;
}

@end
