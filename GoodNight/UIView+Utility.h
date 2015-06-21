//
//  UIView+Utility.h
//  OneAppEveryDay
//
//  Created by ShotaTakai on 2015/05/27.
//  Copyright (c) 2015年 ShotaTakai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Utility)
/** @brief self.frame.origin.xへのショートカット */
@property (nonatomic) CGFloat x;

/** @brief self.frame.origin.yへのショートカット */
@property (nonatomic) CGFloat y;

/** @brief self.frame.size.widthへのショートカット */
@property (nonatomic) CGFloat width;

/** @brief self.frame.size.heightへのショートカット */
@property (nonatomic) CGFloat height;

@end
