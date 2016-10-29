//
//  ViewController.m
//  StickerPhoto
//
//  Created by KyivMobileDev on 8/10/15.
//  Copyright © 2015 KyivMobileDev. All rights reserved.
//

#import "ViewController.h"
#import "Sticker.h"
#import <sys/utsname.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // change layout if the screen is small
    [self changeLayout];
    
    // init stickers array
    [self initStickers];
    
    // add a tap gesture to attach the choose image action
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getPhoto)];
    [self.pickPhotoInfo addGestureRecognizer:tapGesture];
    
    // init the document interaction controller to share
    self.controller = [[UIDocumentInteractionController alloc]init];
    self.controller.delegate = (id)self;
    
    // init the drag allowed var
    self.dragAllowed = true;
    
    // decide if you want to use Google AdMob, iAD o none of them
    // None of them = 0
    // Google AdMob = 1
    // iAD = 2
    int useAds = 1;
    switch (useAds) {
        case 1:
            // start Google AdMob request
            [self googleAdMobInit];
            break;
        case 2:
            // start Apple iAD request
            [self appleiADInit];
            break;
        default:
            // delete Google AdMob view
            [self deleteGoogleAdMob];
            break;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    // if is set need to show ads, we do it
    if (self.needToShowAds) {
        self.needToShowAds = false;
        
        if ([self.interstitial isReady]) {
            [self.interstitial presentFromRootViewController:self];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Google AdMob init
- (void)googleAdMobInit {
    // Replace this ad unit ID with your own ad unit ID.
    self.bannerAdUnitID = @"ca-app-pub-3940256099942544/4411468910";
    self.bannerView.adUnitID = self.bannerAdUnitID;
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
    request.testDevices = @[
                            @"2077ef9a63d2b398840261c8221a0c9a",  // Eric's iPod Touch
                            kGADSimulatorID // iphone simulator
                            ];
    [self.bannerView loadRequest:request];
    
    // set it to true so the first time we receive a interstitial we show it
    self.firstTime = false;
    
    // Replace this ad unit ID with your own banner ad unit ID.
    self.interstitialAdUnitID = @"ca-app-pub-3940256099942544/4411468910";
    // the interstitial
    self.interstitial = [self createAndLoadInterstitial];
}

// create and load the interstitial
- (GADInterstitial *)createAndLoadInterstitial {
    // the interstitial
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:self.interstitialAdUnitID];
    
    // set the controller as the delegate in order to use som protocol methods
    interstitial.delegate = self;
    
    // load the interstitial
    [interstitial loadRequest:[GADRequest request]];
    
    // return it
    return interstitial;
}

// callback event for when the user has dissmised a interstitial
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    // we use it to load another one
    self.interstitial = [self createAndLoadInterstitial];
}

// callback event for when a new insterstitial is available
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    // only if first time, we show it right away
    if (self.firstTime) {
        self.firstTime = false;
        
        if ([self.interstitial isReady]) {
            [self.interstitial presentFromRootViewController:self];
        }
    }
}

// Delete Google AdMob
- (void)deleteGoogleAdMob {
    self.adsHeightConstraint.constant = 0;
}

// Apple iAD init
- (void)appleiADInit {
    ADBannerView *adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    // if the device is an iPad, change height to 66 and width to 768 as Apple Guidlines recommend
    if ([deviceType isEqualToString:@"iPad"]) {
        self.adsHeightConstraint.constant = 66;
        self.adsWidthConstraint.constant = 768;
        [self.adsView removeConstraint:self.adsCenterXConstraint];
        [self createCenterXConstraint];
        
        adView.frame = CGRectMake(0, 0, 768, 66);
    }
    // if the device is an iPhone 6/6s plus, change height to 75 and width to 621 as Apple Guidlines recommend
    else if ([machineName() isEqualToString:@"iPhone7,1"] || [machineName() isEqualToString:@"iPhone8,2"]) {
        self.adsHeightConstraint.constant = 75;
        self.adsWidthConstraint.constant = 621;
        [self.adsView removeConstraint:self.adsCenterXConstraint];
        [self createCenterXConstraint];
        
        adView.frame = CGRectMake(0, 0, 621, 75);
    }
    // if the device is an iPhone 6/6s, change height to 50 and width yo 375 as Apple Guidlines recommend
    else if ([machineName() isEqualToString:@"iPhone7,2"] || [machineName() isEqualToString:@"iPhone8,1"]) {
        self.adsHeightConstraint.constant = 50;
        self.adsWidthConstraint.constant = 375;
        [self.adsView removeConstraint:self.adsCenterXConstraint];
        [self createCenterXConstraint];
        
        adView.frame = CGRectMake(0, 0, 375, 50);
    }
    // if the device is any of the rest of the iPhone models, change height to 50 and width to 320 as Apple Guidlines recommend
    else {
        self.adsHeightConstraint.constant = 50;
        self.adsWidthConstraint.constant = 320;
        
        adView.frame = CGRectMake(0, 0, 320, 75);
    }
    
    [self.adsView addSubview:adView];
    
    [self.adsView setNeedsUpdateConstraints];
    [self.adsView setNeedsLayout];
    
    adView.delegate = self;
}

// get the name of the device model
NSString* machineName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

// create a centerX constraint for the ads view
- (void)createCenterXConstraint {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.adsView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
}

// iAd delegate methods
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Failed to retrieve ad");
}

// change layout if the screen is small
- (void)changeLayout {
    if (self.view.bounds.size.height <= 480)
    {
        // change constants value to fit the small screen
        self.buttonHeightConstraint.constant = 0;
        self.buttonMarginConstraint.constant = 0;
    }
    else
    {
        // hide the repeated button
        self.navItem.rightBarButtonItem = nil;
    }
}

// init stickers array
- (void)initStickers {
    stickers = [[NSMutableArray alloc] init];
    // Use this loop to add as many stickers as you want flawlessly
    // just change the next int to the total amount of stickers you have
    int totalStickers = 6;
    NSString *stickerName = @"sticker_";
    NSString *stickerFormat = @".png";
    
    for (int i = 1; i <= totalStickers; i++)
    {
        [stickers addObject:[NSString stringWithFormat:@"%@%i%@", stickerName, i, stickerFormat]];
    }
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [stickers count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StickerCell" forIndexPath:indexPath];
    
    // init the sticker class
    ((Sticker*)[cell viewWithTag:1]).image = [UIImage imageNamed: [stickers objectAtIndex:indexPath.row]];
    ((Sticker*)[cell viewWithTag:1]).topView = self.view;
    ((Sticker*)[cell viewWithTag:1]).filename = [stickers objectAtIndex:indexPath.row];
    ((Sticker*)[cell viewWithTag:1]).vc = self;
    
    return cell;
}

#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80.0f, 80.0f);
}

// gestures
- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized)
    {
        [sender.view.superview bringSubviewToFront:sender.view];
    }
}

- (void)pinchPicture:(UIPinchGestureRecognizer*)recognizer {
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
   	recognizer.scale = 1;
}

- (void)panPicture:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGRect narrowBounds = CGRectMake(recognizer.view.superview.bounds.origin.x + 10.0, recognizer.view.superview.bounds.origin.y + 10.0, recognizer.view.superview.bounds.size.width - 30.0, recognizer.view.superview.bounds.size.height - 30.0);
        if(!CGRectIntersectsRect([recognizer.view.superview convertRect:narrowBounds toView:self.view], [recognizer.view convertRect:recognizer.view.bounds toView:self.view]))
        {
            if (recognizer.view.tag == 100)
            {
                [self showPickPhotoInfo];
            }
            
            recognizer.view.hidden = true;
            [recognizer.view.superview bringSubviewToFront:recognizer.view];
            [recognizer.view removeFromSuperview];
        }
    }
}

- (void)rotatePicture:(UIRotationGestureRecognizer *)recognizer {
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

// utils
- (void)showPickPhotoInfo {
    self.pickPhotoInfo.hidden = false;
}

- (void)hidePickPhotoInfo {
    self.pickPhotoInfo.hidden = true;
}

- (IBAction)showResetCanvasAlertView:(id)sender {
    [self createAlertView:@"Reset canvas" withMessage:@"Do you really want to reset your canvas?" okTitle:@"Yes" cancelTitle:@"Cancel" okSelector:@selector(resetCanvas) cancelSelector:nil];
}

// Done Button Action
- (IBAction)Done:(id)sender {
    NSLog(@"Done");
    // create photo
    CGSize screenshotBounds = CGSizeMake(self.canvas.bounds.size.width, self.canvas.bounds.size.height);
    
    float maxSize = 1280.0f;
    float maxDim = MAX(self.canvas.bounds.size.width, self.canvas.bounds.size.height);
    float scale = maxSize / maxDim;
    
    UIGraphicsBeginImageContextWithOptions(screenshotBounds, NO, scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(ctx, 0, 0);
    [self.canvas.layer renderInContext:ctx];
    
    self.screenCapture = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *sticker = [[UIImageView alloc] initWithImage:self.screenCapture];
    sticker.contentMode = UIViewContentModeScaleAspectFit;
    sticker.userInteractionEnabled = NO;
    [self.canvas addSubview:sticker];
}

- (IBAction)Undo:(id)sender {
    NSLog(@"Undo");
    int viewNumber = 0;
    
    for (UIView* v in self.canvas.subviews)
    {
        viewNumber = viewNumber + 1;
        if (v.tag != 3 && (viewNumber == self.canvas.subviews.count))
        {
            v.hidden = true;
            [v.superview bringSubviewToFront:v];
            [v removeFromSuperview];
            break;
        }
    }
}

- (void)resetCanvas {
    for (UIView* v in self.canvas.subviews)
    {
        if (v.tag != 3)
        {
            v.hidden = true;
            [v.superview bringSubviewToFront:v];
            [v removeFromSuperview];
        }
    }
    
    [self showPickPhotoInfo];
}

// image picker
- (void)getPhoto {
     [self createAlertView:@"Pick a photo" withMessage:@"Choose from where do you want to pick a photo." okTitle:@"From Gallery" cancelTitle:@"From Camera" okSelector:@selector(getPictureFromGallery) cancelSelector:@selector(getPictureFromCamera)];
}

- (IBAction)createPhoto:(id)sender {
    // create photo
    CGSize screenshotBounds = CGSizeMake(self.canvas.bounds.size.width, self.canvas.bounds.size.height);
    
    float maxSize = 1280.0f;
    float maxDim = MAX(self.canvas.bounds.size.width, self.canvas.bounds.size.height);
    float scale = maxSize / maxDim;
    
    UIGraphicsBeginImageContextWithOptions(screenshotBounds, NO, scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(ctx, 0, 0);
    [self.canvas.layer renderInContext:ctx];
    
    self.screenCapture = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/stickers_photo.png"];
    [UIImagePNGRepresentation(self.screenCapture) writeToFile:path atomically:YES];
    
    NSURL *documentURL = [NSURL fileURLWithPath:path];
    
    // pass it to our document interaction controller
    self.controller.URL = documentURL;
    
    // present the preview
    [self.controller presentPreviewAnimated:YES];
    
    self.needToShowAds = true;
}

// add photo and scale it to fit the canvas
- (void)addPhoto:(UIImage *)img
{
    float maxWidth = self.canvas.bounds.size.width - 40.0f;
    float maxHeight = self.canvas.bounds.size.height - 40.0f;
    
    float maxWDim = MIN(maxWidth, img.size.width);
    float maxHDim = MIN(maxHeight, img.size.height);
    
    if (maxHDim > maxWDim) {
        maxWDim = img.size.width * (maxHDim / img.size.height);
    }
    else {
        maxHDim = img.size.height * (maxWDim / img.size.width);
    }
    
    UIImageView *mainImage = [[UIImageView alloc] initWithImage:img];
    mainImage.frame = CGRectMake((self.canvas.frame.size.width / 2.0f) - (maxWDim / 2.0f), (self.canvas.frame.size.height / 2.0f) - (maxHDim / 2.0f), maxWDim, maxHDim);
    mainImage.userInteractionEnabled = true;
    mainImage.contentMode = UIViewContentModeScaleAspectFit;
    mainImage.clipsToBounds = YES;
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchPicture:)];
    pinch.delegate = self;
    [mainImage addGestureRecognizer:pinch];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPicture:)];
    pan.delegate = self;
    [mainImage addGestureRecognizer:pan];
    
    
    UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePicture:)];
    rotate.delegate = self;
    [mainImage addGestureRecognizer:rotate];
    
    [self hidePickPhotoInfo];
    
    mainImage.tag = 100;
    [self.canvas insertSubview:mainImage atIndex:1];
}

// image picker controller
- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self addPhoto:img];
}

- (void)getPictureFromCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    //[picker setAllowsEditing:YES];
    
    picker.delegate = (id)self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        [self createAlertView:@"Error" withMessage:@"There's been an error with the galery" okTitle:@"Ok" cancelTitle:nil okSelector:nil cancelSelector:nil];
    }
}

- (void)getPictureFromGallery
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    //[picker setAllowsEditing:YES];
    
    picker.delegate = (id)self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        [self createAlertView:@"Error" withMessage:@"There's been an error with the camera" okTitle:@"Ok" cancelTitle:nil okSelector:nil cancelSelector:nil];
    }
}

// document interaction controller
#pragma mark - Delegate Methods
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return  (id)self;
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application
{
    if ([self isWhatsAppApplication:application]) {
        NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/stickers_photo.wai"];
        [UIImagePNGRepresentation(self.screenCapture) writeToFile:savePath atomically:YES];
        self.controller.URL = [NSURL fileURLWithPath:savePath];
        self.controller.UTI = @"net.whatsapp.image";
    }
}

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller
{
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application
{
}

- (BOOL)isWhatsAppApplication:(NSString *)application
{
    if ([application rangeOfString:@"whats"].location == NSNotFound)
    {
        // unfortunately, no other way...
        return NO;
    }
    else
    {
        return YES;
    }
}

// alert view
- (void)createAlertView:(NSString *)title withMessage:(NSString *)message okTitle:(NSString *)okTitle cancelTitle:(NSString *)cancelTitle okSelector:(SEL)okSelector cancelSelector:(SEL)cancelSelector
{
    UIAlertController *alert =	[UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [alert.view setTintColor:[UIColor colorWithRed:93.0f/255.0f green:156.0f/255.0f blue:236.0f/255.0f alpha:1.0f]];
    
    if (okTitle != nil)
    {
        UIAlertAction *okButton = [UIAlertAction
                                   actionWithTitle:okTitle
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       if (okSelector != nil) {
                                           ((void (*)(id, SEL))[self methodForSelector:okSelector])(self, okSelector);
                                       }
                                       
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                   }];
        
        [alert addAction:okButton];
    }
    
    if (cancelTitle != nil)
    {
        UIAlertAction *cancelButton = [UIAlertAction
                                       actionWithTitle:cancelTitle
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           if (cancelSelector != nil) {
                                               ((void (*)(id, SEL))[self methodForSelector:cancelSelector])(self, cancelSelector);
                                           }
                                           
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                       }];
        
        [alert addAction:cancelButton];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

// scroll
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        self.dragAllowed = true;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.dragAllowed = true;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.dragAllowed = false;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.dragAllowed = false;
}

@end
