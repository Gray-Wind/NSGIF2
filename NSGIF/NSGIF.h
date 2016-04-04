//
//  NSGIF.h
//
//  Created by Sebastian Dobrincu
//  Modified by Brian Lee (github.com/metasmile)
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>

#if TARGET_OS_IPHONE
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <CoreServices/CoreServices.h>
    #import <WebKit/WebKit.h>
#endif

typedef NS_ENUM(NSInteger, NSGIFScale) {
    NSGIFScaleOptimize,
    NSGIFScaleVeryLow,
    NSGIFScaleLow,
    NSGIFScaleMedium,
    NSGIFScaleHigh,
    NSGIFScaleOriginal
};

@interface NSGIFRequest : NSObject

/* required. a file's url of source video */
@property(nullable, nonatomic) NSURL * sourceVideoFile;
/* optional. defaults to nil. automatically assign the file name of source video (ex: IMG_0000.MOV -> IMG_0000.gif)  */
@property(nullable, nonatomic) NSURL * destinationVideoFile;
/* optional. Defaults to NSGIFScaleOptimize (not set). */
@property(nonatomic, assign) NSGIFScale scalePreset;
/* optional. Defaults to 4. number of frames in seconds */
@property(nonatomic, assign) NSUInteger framesPerSecond;
/* optional. Defaults is to not set. How far along the video track we want to move, in seconds. It will automatically assign from duration of video and framesPerSecond  */
@property(nonatomic, assign) NSUInteger frameCount;
/* optional. Defaults to 0, the number of times the GIF will repeat. which means repeat infinitely. */
@property(nonatomic, assign) NSUInteger loopCount;
/* optional. Defaults to 0.13. unit is 10ms, 1/100s, the amount of time for each frame in the GIF */
@property(nonatomic, assign) CGFloat delayTime;
/* optional. Defaults is to not set. unit is seconds, which means unlimited */
@property(nonatomic, assign) NSTimeInterval maxDuration;

- (NSGIFRequest * __nonnull)initWithSourceVideo:(NSURL * __nullable)fileURL;
+ (NSGIFRequest * __nonnull)requestWithSourceVideo:(NSURL * __nullable)fileURL;
+ (NSGIFRequest * __nonnull)requestWithSourceVideo:(NSURL * __nullable)fileURL destination:(NSURL * __nullable)videoFileURL;
+ (NSGIFRequest * __nonnull)requestWithSourceVideoForLivePhoto:(NSURL *__nullable)fileURL;
@end

@interface NSGIF : NSObject

+ (void)create:(NSGIFRequest *__nullable)request completion:(void (^ __nullable)(NSURL * __nullable))completionBlock;
@end
