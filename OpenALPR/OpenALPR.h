#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include "opencv2/highgui/highgui.hpp"

typedef void(^onPlateScanSuccess)(NSArray *plates, NSArray *confidence, NSArray *frames);
typedef void(^onPlateScanFailure)();

@interface OpenALPR : NSObject

// Use for an image with only one plate
+ (NSString *)processImageAndGetBestPlate:(NSString *)img ofCountry:(NSString *)country forNbResults:(int)nb withConfig:(NSString *)config withRuntimeDir:(NSString *)runDir;

+ (NSString *)proccessImage:(UIImage *)image ofCountry:(NSString *)country forNbResults:(int)nb withConfig:(NSString *)config runTimeDirectory:(NSString *)runDir;
@end
