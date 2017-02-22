#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenALPR : NSObject

// Use for an image with only one plate
+ (NSString *)processImageAndGetBestPlate:(NSString *)img ofCountry:(NSString *)country forNbResults:(int)nb withConfig:(NSString *)config withRuntimeDir:(NSString *)runDir;

// Use for an image with multiple plates
+ (NSMutableArray *)processImageAndGetBestPlates:(NSString *)img ofCountry:(NSString *)country forNbResults:(int)nb withConfig:(NSString *)config withRuntimeDir:(NSString *)runDir;

+ (NSString *)proccessImage:(UIImage *)image ofCountry:(NSString *)country forNbResults:(int)nb withConfig:(NSString *)config runTimeDirectory:(NSString *)runDir;

+ (NSMutableArray *)proccessImageAndGetBestPlates:(UIImage *)image ofCountry:(NSString *)country forNbResults:(int)nb withConfig:(NSString *)config runTimeDirectory:(NSString *)runDir;

+ (UIImage *)proccessAndReturnImageAndGetBestPlates:(UIImage *)image ofCountry:(NSString *)country forNbResults:(int)nb withConfig:(NSString *)config runTimeDirectory:(NSString *)runDir;
@end
