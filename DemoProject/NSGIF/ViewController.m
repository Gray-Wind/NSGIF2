//
//  ViewController.m
//  NSGIF
//
//  Created by Sebastian Dobrincu on 30/08/15. (My birthday 🎉)
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import "NSGIF.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:0.13 green:0.16 blue:0.19 alpha:1];
    self.webView.backgroundColor = [UIColor colorWithRed:0.13 green:0.16 blue:0.19 alpha:1];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSURL *url = info[UIImagePickerControllerMediaURL];
    if (url){
        
        [self.activityIndicator startAnimating];
        self.button1.enabled = NO;
        self.button2.enabled = NO;
        self.button3.enabled = NO;

        NSGIFRequest * request = [NSGIFRequest requestWithSourceVideo:url];
        request.progressHandler = ^(double progress, NSUInteger position, NSUInteger length, CMTime time, BOOL *stop, NSDictionary *frameProperties) {
            NSLog(@"%f - %lu - %lu - %lld - %@", progress, position, length, time.value, frameProperties);
        };
        
        [NSGIF create:request completion:^(NSURL * GifURL) {
            NSLog(@"Finished generating GIF: %@", GifURL);
            
            [self.activityIndicator stopAnimating];
            [UIView animateWithDuration:0.3 animations:^{
                self.button1.alpha = 0.0f;
                self.button2.alpha = 0.0f;
                self.button3.alpha = 0.0f;
                self.webView.alpha = 1.0f;
            }];
            [self.webView loadRequest:[NSURLRequest requestWithURL:GifURL]];
            
            UIAlertView *alert;
            if (GifURL)
                alert = [[UIAlertView alloc] initWithTitle:@"Yaay!" message:@"You successfully created your GIF!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            else
                alert = [[UIAlertView alloc] initWithTitle:@"Ooops!" message:@"Hmm... Something went wrong here!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"Received memory warning. Try to tweak your GIF parameters to optimise the converting process.");
    
    // Dispose of any resources that can be recreated.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (IBAction)button1Tapped:(id)sender {

    [self.activityIndicator startAnimating];
    self.button1.enabled = NO;
    self.button2.enabled = NO;
    self.button3.enabled = NO;
    
    NSURL *videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"]];
    
    [NSGIF create:[NSGIFRequest requestWithSourceVideo:videoURL] completion:^(NSURL * GifURL) {
        NSLog(@"Finished generating GIF: %@", GifURL);
        
        [self.activityIndicator stopAnimating];
        [UIView animateWithDuration:0.3 animations:^{
            self.button1.alpha = 0.0f;
            self.button2.alpha = 0.0f;
            self.button3.alpha = 0.0f;
            self.webView.alpha = 1.0f;
        }];
        [self.webView loadRequest:[NSURLRequest requestWithURL:GifURL]];
    }];
}

- (IBAction)button2Tapped:(id)sender {
    
    #if TARGET_IPHONE_SIMULATOR
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"You can't use the camera demo in the simulator. Try the video demo." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    #endif

    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = @[(NSString *)kUTTypeMovie];
        
        // Present the picker
        [self presentViewController:picker animated:YES completion:nil];
    });
}

- (IBAction)button3Tapped:(id)sender {

    [self.activityIndicator startAnimating];
    self.button1.enabled = NO;
    self.button2.enabled = NO;
    self.button3.enabled = NO;

    NSURL *videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"]];

    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];

    NSFrameExtractingFromVideoRequest * request = [NSFrameExtractingFromVideoRequest requestWithSourceVideo:videoURL];
    request.progressHandler = ^(double progress, NSUInteger offset, NSUInteger length, CMTime time, BOOL *stop, NSDictionary *frameProperties) {
        NSLog(@"Progress: %@, %@, %@", [@(progress) stringValue], [@(offset) stringValue], [@(time.value) stringValue]);
    };
    request.frameCount = 10;

    [NSGIF extract:request completion:^(NSArray<NSURL *> *extractedFrameImageUrls) {
        NSLog(@"Finished generating frames: %@", extractedFrameImageUrls);

        [self.activityIndicator stopAnimating];
        [UIView animateWithDuration:0.3 animations:^{
            self.button1.alpha = 0.0f;
            self.button2.alpha = 0.0f;
            self.button3.alpha = 0.0f;
            self.webView.alpha = 1.0f;
        }];

        for(NSURL * imageUrl in extractedFrameImageUrls){
            UIView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imageUrl.path]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.frame = CGRectMake(0,((CGFloat)[extractedFrameImageUrls indexOfObject:imageUrl])*30, 30,30);
            [scrollView addSubview:imageView];
        }
    }];

    [self.view addSubview:scrollView];
}

@end
