//
//  Sticker.m
//  StickerPhoto
//
//  Created by KyivMobileDev on 8/10/15.
//  Copyright © 2015 KyivMobileDev. All rights reserved.
//

#import "Sticker.h"

@implementation Sticker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.moving = false;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.vc.dragAllowed && !self.moving) {
        self.moving = true;
        self.exclusiveTouch = YES;
        
        self.supView = self.superview;
        self.originalFrame = self.frame;
        
        [self setTranslatesAutoresizingMaskIntoConstraints:YES];
        
        [self removeFromSuperview];
        [self.topView addSubview:self];
        [self.topView bringSubviewToFront:self];
        self.frame = self.originalFrame;
        
        UITouch *touch = [touches anyObject];
        
        CGPoint position = [touch locationInView: self.superview];
        self.center = CGPointMake(position.x, position.y);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.moving)
    {
        UITouch *touch = [touches anyObject];
        
        CGPoint position = [touch locationInView: self.superview];
        
        self.center = CGPointMake(position.x, position.y);
        [self.topView bringSubviewToFront:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.moving)
    {
        if (CGRectIntersectsRect(self.frame, self.vc.canvas.frame))
        {
            UITouch *touch = [touches anyObject];
            
            UIImageView *sticker = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.filename]];
            sticker.contentMode = UIViewContentModeScaleAspectFit;
            sticker.userInteractionEnabled = YES;
            [self.vc.canvas addSubview:sticker];
            CGPoint position = [touch locationInView: sticker.superview];
            sticker.center = position;
            [self resizeImage:sticker];
            
            [[self.topView viewWithTag:1] bringSubviewToFront:sticker];
            
            if (self.vc != nil) {
                UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self.vc action:@selector(pinchPicture:)];
                [sticker addGestureRecognizer:pinch];
                
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.vc action:@selector(panPicture:)];
                [sticker addGestureRecognizer:pan];
                
                UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self.vc action:@selector(rotatePicture:)];
                [sticker addGestureRecognizer:rotate];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.vc action:@selector(handleTapGesture:)];
                [sticker addGestureRecognizer:tap];
            }
            
            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                        style:UIBarButtonItemStyleDone target:self.vc action:@selector(Done:)];
            
            UIBarButtonItem *undoBtn = [[UIBarButtonItem alloc] initWithTitle:@"Undo"
                                                                        style:UIBarButtonItemStyleDone target:self.vc action:@selector(Undo:)];
            
            self.vc.navItem.rightBarButtonItems = [NSArray arrayWithObjects:doneBtn, undoBtn, nil];
        }
        
        [self getBackToOriginalSuperview];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.moving)
    {
        [self getBackToOriginalSuperview];
    }
}

- (void)getBackToOriginalSuperview
{
    self.moving = false;
    [self removeFromSuperview];
    [self.supView addSubview:self];
    self.frame = self.originalFrame;
    
    NSLayoutConstraint *topQuote = [NSLayoutConstraint
                                    constraintWithItem:self
                                    attribute:NSLayoutAttributeTop
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.superview
                                    attribute:NSLayoutAttributeTop
                                    multiplier:1.0f
                                    constant: 0.0f];
    
    NSLayoutConstraint *bottomQuote = [NSLayoutConstraint
                                       constraintWithItem:self
                                       attribute:NSLayoutAttributeBottom
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self.superview
                                       attribute:NSLayoutAttributeBottom
                                       multiplier:1.0f
                                       constant: 0];
    
    NSLayoutConstraint *leadingQuote = [NSLayoutConstraint
                                        constraintWithItem:self
                                        attribute:NSLayoutAttributeLeading
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self.superview
                                        attribute:NSLayoutAttributeLeading
                                        multiplier:1.0f
                                        constant:0.0f];
    
    NSLayoutConstraint *trailingQuote = [NSLayoutConstraint
                                         constraintWithItem:self
                                         attribute:NSLayoutAttributeTrailing
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.superview
                                         attribute:NSLayoutAttributeTrailing
                                         multiplier:1.0f
                                         constant:0.0f];
    
    [self.superview addConstraint:bottomQuote];
    [self.superview addConstraint:trailingQuote];
    [self.superview addConstraint:topQuote];
    [self.superview addConstraint:leadingQuote];
}

- (void)resizeImage:(UIImageView*)img {
    float newWidth = img.bounds.size.width;
    float newHeight = img.bounds.size.height;
    
    if (img.bounds.size.width > (self.vc.canvas.bounds.size.width * 0.5)) {
        
    }
    if (img.bounds.size.height > (self.vc.canvas.bounds.size.height * 0.5)) {
        
    }
    
    float factor = MIN((self.vc.canvas.bounds.size.width * 0.5), (self.vc.canvas.bounds.size.height * 0.5));
    float dimension = MAX(newWidth, newHeight);
    
    if (dimension > factor) {
        img.bounds = CGRectMake(0, 0, newWidth * (factor / dimension), newHeight * (factor / dimension));
    }
}

- (void)touchesFinishedWithoutCallback {
    [self touchesCancelled:nil withEvent:nil];
}

@end
