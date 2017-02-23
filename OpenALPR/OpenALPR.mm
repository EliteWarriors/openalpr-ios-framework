#import "OpenALPR.h"
#include "alpr.h"
#include "opencv2/highgui/highgui.hpp"
#include "filesystem.h"
#include "opencv2/imgproc/imgproc.hpp"
#include "constants.h"
#import "UIImage+OpenCV.h"
#include <Block.h>

@implementation OpenALPR {
    Alpr *alpr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *pathConfig = [[NSBundle mainBundle] pathForResource:@"openalpr" ofType:@"conf"];
        NSString *pathRunTime = [[NSBundle mainBundle] pathForResource:@"runtime_data" ofType:nil];
        
        BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:pathConfig];
        
        
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
        
        NSString *dataPath = [documentPath stringByAppendingPathComponent:@"tessdata"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // If the expected store doesn't exist, copy the default store.
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:@"/runtime_data/ocr"];
        
        setenv("TESSDATA_PREFIX", [tessdataPath UTF8String], 1);
        
        alpr = new Alpr([@"us" UTF8String], [pathConfig UTF8String], [pathRunTime UTF8String]);
        alpr->setTopN(3);
        alpr->isLoaded();
        alpr->setDetectRegion(true);
    }
    
    return self;
}

+ (NSString *)processImageAndGetBestPlate:(NSString *)img ofCountry:(NSString *)country forNbResults:(int)nb withConfig:(NSString *)config withRuntimeDir:(NSString *)runDir
{
    setenv("TESSDATA_PREFIX", [[runDir stringByAppendingString:@"/ocr/"] UTF8String], 1);
    
    Alpr alpr([country UTF8String], [config UTF8String], [runDir UTF8String]);
    alpr.setTopN(nb);
    if (!alpr.isLoaded()) {
        NSLog(@"Error loading OpenALPR");
    } else {
        if (fileExists([img UTF8String])) {
            cv::Mat frame = cv::imread([img UTF8String]);
            std::vector<uchar> buffer;
            cv::imencode(".bmp", frame, buffer);
            
            std::vector<AlprResult> results = alpr.recognize(buffer);
            if (results.size() < 1) {
                NSLog(@"No results found");
            } else {
                return [NSString stringWithCString:results[0].bestPlate.characters.c_str() encoding:[NSString defaultCStringEncoding]];
            }
        } else {
            NSLog(@"Image file not found");
        }
    }
    return @"";
}

+ (NSString *)proccessImage:(UIImage *)image ofCountry:(NSString *)country forNbResults:(int)nb withConfig:(NSString *)config runTimeDirectory:(NSString *)runDir {
    Alpr alpr([country UTF8String], [config UTF8String], [runDir UTF8String]);
    alpr.setTopN(nb);
    std::vector<uchar> buffer;
    cv::imencode(".bmp", [image CVMat], buffer);
    
    std::vector<AlprResult> results = alpr.recognize(buffer);
    if (results.size() < 1) {
        NSLog(@"No results found");
    } else {
        return [NSString stringWithCString:results[0].bestPlate.characters.c_str() encoding:[NSString defaultCStringEncoding]];
    }
    return @"";
}

@end
