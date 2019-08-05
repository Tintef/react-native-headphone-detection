#import "RNHeadphoneDetection.h"
#import <AVFoundation/AVFoundation.h>

#if __has_include(<React/RCTBridge.h>)
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#elif __has_include("RCTBridge.h")
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#else
#import "React/RCTBridge.h"
#import "React/RCTEventDispatcher.h"
#endif

@implementation RNHeadphoneDetection
{
    BOOL hasListeners;
}

RCT_EXPORT_MODULE(RNHeadphoneDetection)

static NSString * const AUDIO_DEVICE_CHANGED_NOTIFICATION = @"AUDIO_DEVICE_CHANGED_NOTIFICATION";
static NSString * const IS_AUDIO_DEVICE_CONNECTED = @"isAudioDeviceConnected";

- (instancetype) init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
    }
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (BOOL) requiresMainQueueSetup
{
    return YES;
}

- (dispatch_queue_t) methodQueue
{
    return dispatch_get_main_queue();
}

- (NSDictionary *)constantsToExport
{
    return @{ @"AUDIO_DEVICE_CHANGED_NOTIFICATION": AUDIO_DEVICE_CHANGED_NOTIFICATION };
}

-(void) startObserving
{
    hasListeners = YES;
}

-(void) stopObserving
{
    hasListeners = NO;
}

- (NSArray<NSString *> *) supportedEvents
{
    return @[AUDIO_DEVICE_CHANGED_NOTIFICATION];
}

- (void) audioRouteChangeListenerCallback:(NSNotification*)notification
{
    if (hasListeners) { // Only send events if anyone is listening
        NSDictionary * res = [RNHeadphoneDetection isAudioDeviceConnected];
        [self sendEventWithName:AUDIO_DEVICE_CHANGED_NOTIFICATION
                           body: res
         ];
    }
}

+ (NSDictionary *) isAudioDeviceConnected
{
    NSMutableDictionary *res = [
                                @{ @"audioJack": @NO, @"bluetooth": @NO }
                                mutableCopy
                                ];

    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];

    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones]) {
            res[@"audioJack"] = @YES;
        }

        if (
            [[desc portType] isEqualToString:AVAudioSessionPortBluetoothA2DP] ||
            [[desc portType] isEqualToString:AVAudioSessionPortBluetoothHFP] ||
            [[desc portType] isEqualToString:AVAudioSessionPortBluetoothLE]
            ) {
            res[@"bluetooth"] = @YES;
        }
    }

    return res;
}

RCT_EXPORT_METHOD(isAudioDeviceConnected:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    resolve([RNHeadphoneDetection isAudioDeviceConnected]);
}

@end
