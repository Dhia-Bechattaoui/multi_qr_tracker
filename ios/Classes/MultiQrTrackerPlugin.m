#import "MultiQrTrackerPlugin.h"
#if __has_include(<multi_qr_tracker/multi_qr_tracker-Swift.h>)
#import <multi_qr_tracker/multi_qr_tracker-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "multi_qr_tracker-Swift.h"
#endif

@implementation MultiQrTrackerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  [SwiftMultiQrTrackerPlugin registerWithRegistrar:registrar];
}
@end
