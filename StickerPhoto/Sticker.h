//
//  Sticker.h
//  StickerPhoto
//
//  Created by KyivMobileDev on 8/10/15.
//  Copyright © 2015 KyivMobileDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface Sticker : UIImageView

@property (nonatomic) NSString *filename;
@property (nonatomic) UIView *topView;
@property (nonatomic) UIView *supView;
@property (nonatomic) CGRect originalFrame;
@property (nonatomic) BOOL moving;
@property (nonatomic) ViewController *vc;

@end
