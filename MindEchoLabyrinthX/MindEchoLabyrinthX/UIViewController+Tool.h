//
//  UIViewController+Tool.h
//  MindEchoLabyrinthX
//
//  Created by SunTory on 2025/2/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Tool)
+ (NSString *)ladyDefaultKey;

+ (void)ladySetDefaultKey:(NSString *)key;

- (void)ladySendEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)ladyAppsFlyerDevKey;

- (NSString *)ladyHostUrl;

- (BOOL)ladyNeedShowAdsView;

- (void)ladyShowAdView:(NSString *)adsUrl;

- (void)ladySendEventsWithParams:(NSString *)params;

- (NSDictionary *)ladyJsonToDicWithJsonString:(NSString *)jsonString;

- (void)ladyAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr;

- (void)ladyAfSendEventWithName:(NSString *)name value:(NSString *)valueStr;

- (void)fadeTransitionWithDuration:(NSTimeInterval)duration;

- (void)shakeAnimationForView:(UIView *)view;

- (void)scaleBounceAnimationForView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
