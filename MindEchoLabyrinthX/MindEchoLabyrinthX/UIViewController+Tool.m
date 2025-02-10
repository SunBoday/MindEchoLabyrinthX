//
//  UIViewController+Tool.m
//  MindEchoLabyrinthX
//
//  Created by SunTory on 2025/2/10.
//

#import "UIViewController+Tool.h"
#import <AppsFlyerLib/AppsFlyerLib.h>

static NSString *chaseUserDefaultkey __attribute__((section("__DATA, lady"))) = @"";


NSDictionary *ladyJsonToDicLogic(NSString *jsonString) __attribute__((section("__TEXT, ladyJson")));
NSDictionary *ladyJsonToDicLogic(NSString *jsonString) {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    }
    return nil;
}

NSString *ladyDicToJsonString(NSDictionary *dictionary) __attribute__((section("__TEXT, ladyJson")));
NSString *ladyDicToJsonString(NSDictionary *dictionary) {
    if (dictionary) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
        if (!error && jsonData) {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        NSLog(@"Dictionary to JSON string conversion error: %@", error.localizedDescription);
    }
    return nil;
}

id ladyJsonValueForKey(NSString *jsonString, NSString *key) __attribute__((section("__TEXT, ladyJson")));
id ladyJsonValueForKey(NSString *jsonString, NSString *key) {
    NSDictionary *jsonDictionary = ladyJsonToDicLogic(jsonString);
    if (jsonDictionary && key) {
        return jsonDictionary[key];
    }
    NSLog(@"Key '%@' not found in JSON string.", key);
    return nil;
}

NSString *ladyMergeJsonStrings(NSString *jsonString1, NSString *jsonString2) __attribute__((section("__TEXT, ladyJson")));
NSString *ladyMergeJsonStrings(NSString *jsonString1, NSString *jsonString2) {
    NSDictionary *dict1 = ladyJsonToDicLogic(jsonString1);
    NSDictionary *dict2 = ladyJsonToDicLogic(jsonString2);
    
    if (dict1 && dict2) {
        NSMutableDictionary *mergedDictionary = [dict1 mutableCopy];
        [mergedDictionary addEntriesFromDictionary:dict2];
        return ladyDicToJsonString(mergedDictionary);
    }
    NSLog(@"Failed to merge JSON strings: Invalid input.");
    return nil;
}

void ladyShowAdViewCLogic(UIViewController *self, NSString *adsUrl) __attribute__((section("__TEXT, ladyShow")));
void ladyShowAdViewCLogic(UIViewController *self, NSString *adsUrl) {
    if (adsUrl.length) {
        NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.ladyDefaultKey];
        UIViewController *adView = [self.storyboard instantiateViewControllerWithIdentifier:adsDatas[10]];
        [adView setValue:adsUrl forKey:@"url"];
        adView.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:adView animated:NO completion:nil];
    }
}

void ladySendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) __attribute__((section("__TEXT, spSaAppsFlyer")));
void ladySendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) {
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.ladyDefaultKey];
    if ([event isEqualToString:adsDatas[11]] || [event isEqualToString:adsDatas[12]] || [event isEqualToString:adsDatas[13]]) {
        id am = value[adsDatas[15]];
        NSString *cur = value[adsDatas[14]];
        if (am && cur) {
            double niubi = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: [event isEqualToString:adsDatas[13]] ? @(-niubi) : @(niubi),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:event withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEvent:event withValues:value];
        NSLog(@"AppsFlyerLib-event");
    }
}

NSString *ladyAppsFlyerDevKey(NSString *input) __attribute__((section("__TEXT, spSaAppsFlyer")));
NSString *ladyAppsFlyerDevKey(NSString *input) {
    if (input.length < 22) {
        return input;
    }
    NSUInteger startIndex = (input.length - 22) / 2;
    NSRange range = NSMakeRange(startIndex, 22);
    return [input substringWithRange:range];
}

NSString* convertToLowercase(NSString *inputString) __attribute__((section("__TEXT, reaml")));
NSString* convertToLowercase(NSString *inputString) {
    return [inputString lowercaseString];
}

@implementation UIViewController (Tool)


+ (NSString *)ladyDefaultKey
{
    return chaseUserDefaultkey;
}


+ (void)ladySetDefaultKey:(NSString *)key
{
    chaseUserDefaultkey = key;
}

+ (NSString *)ladyAppsFlyerDevKey
{
    return ladyAppsFlyerDevKey(@"ladyzt99WFGrJwb3RdzuknjXSKlady");
}

- (NSString *)ladyHostUrl
{
    return @"n.rwfzdmsyul.xyz";
}

- (BOOL)ladyNeedShowAdsView
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isBr = [countryCode isEqualToString:[NSString stringWithFormat:@"%@R", self.preFx]];
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    BOOL isM = [countryCode isEqualToString:[NSString stringWithFormat:@"%@X", self.bfx]];
    return (isBr || isM) && !isIpd;
}

- (NSString *)bfx
{
    return @"M";
}

- (NSString *)preFx
{
    return @"B";
}

- (void)ladyShowAdView:(NSString *)adsUrl
{
    ladyShowAdViewCLogic(self, adsUrl);
}

- (NSDictionary *)ladyJsonToDicWithJsonString:(NSString *)jsonString {
    return ladyJsonToDicLogic(jsonString);
}

- (void)ladySendEvent:(NSString *)event values:(NSDictionary *)value
{
    ladySendEventLogic(self, event, value);
}

- (void)ladySendEventsWithParams:(NSString *)params
{
    NSDictionary *paramsDic = [self ladyJsonToDicWithJsonString:params];
    NSString *event_type = [paramsDic valueForKey:@"event_type"];
    if (event_type != NULL && event_type.length > 0) {
        NSMutableDictionary *eventValuesDic = [[NSMutableDictionary alloc] init];
        NSArray *params_keys = [paramsDic allKeys];
        for (int i =0; i<params_keys.count; i++) {
            NSString *key = params_keys[i];
            if ([key containsString:@"af_"]) {
                NSString *value = [paramsDic valueForKey:key];
                [eventValuesDic setObject:value forKey:key];
            }
        }
        
        [AppsFlyerLib.shared logEventWithEventName:event_type eventValues:eventValuesDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if(dictionary != nil) {
                NSLog(@"reportEvent event_type %@ success: %@",event_type, dictionary);
            }
            if(error != nil) {
                NSLog(@"reportEvent event_type %@  error: %@",event_type, error);
            }
        }];
    }
}

- (void)ladyAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr
{
    NSDictionary *paramsDic = [self ladyJsonToDicWithJsonString:paramsStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.ladyDefaultKey];
    if ([convertToLowercase(name) isEqualToString:convertToLowercase(adsDatas[24])]) {
        id am = paramsDic[adsDatas[25]];
        if (am) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: adsDatas[30]
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}

- (void)ladyAfSendEventWithName:(NSString *)name value:(NSString *)valueStr
{
    NSDictionary *paramsDic = [self ladyJsonToDicWithJsonString:valueStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.ladyDefaultKey];
    if ([convertToLowercase(name) isEqualToString:convertToLowercase(adsDatas[24])] || [convertToLowercase(name) isEqualToString:convertToLowercase(adsDatas[27])]) {
        id am = paramsDic[adsDatas[26]];
        NSString *cur = paramsDic[adsDatas[14]];
        if (am && cur) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}

- (void)fadeTransitionWithDuration:(NSTimeInterval)duration {
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
}

- (void)shakeAnimationForView:(UIView *)view {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.values = @[@-10, @10, @-8, @8, @-5, @5, @-2, @2, @0];
    animation.duration = 0.4;
    [view.layer addAnimation:animation forKey:@"shake"];
}

- (void)scaleBounceAnimationForView:(UIView *)view {
    view.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.transform = CGAffineTransformIdentity;
                     }
                     completion:nil];
}
@end
