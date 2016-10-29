//
//  ViewController.h
//  StickerPhoto
//
//  Created by KyivMobileDev on 8/10/15.
//  Copyright © 2015 KyivMobileDev. All rights reserved.
//

@import GoogleMobileAds;

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UIDocumentInteractionControllerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, UINavigationBarDelegate, ADBannerViewDelegate, GADInterstitialDelegate> {
    NSMutableArray *stickers;
}

@property IBOutlet UICollectionView *collectionView;
@property IBOutlet UIView *canvas;
@property IBOutlet UILabel *pickPhotoInfo;
@property (strong, nonatomic) IBOutlet UIView *adsView;
@property (strong, nonatomic) IBOutlet GADBannerView *bannerView;
@property (strong, nonatomic) GADInterstitial *interstitial;
@property (strong, nonatomic) NSString *bannerAdUnitID;
@property (strong, nonatomic) NSString *interstitialAdUnitID;
@property (strong, nonatomic) UIDocumentInteractionController *controller;
@property (strong, nonatomic) UIImage *screenCapture;
@property (nonatomic) BOOL dragAllowed;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonMarginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *adsHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *adsWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *adsCenterXConstraint;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (assign, nonatomic) BOOL firstTime;
@property (assign, nonatomic) BOOL needToShowAds;

- (void)initStickers;
- (void)showPickPhotoInfo;
- (void)hidePickPhotoInfo;
- (void)handleTapGesture:(UITapGestureRecognizer *)sender;
- (void)pinchPicture:(UIPinchGestureRecognizer*)recognizer;
- (void)panPicture:(UIPanGestureRecognizer *)recognizer;
- (void)rotatePicture:(UIRotationGestureRecognizer *)recognizer;
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
- (IBAction)showResetCanvasAlertView:(id)sender;

@end

