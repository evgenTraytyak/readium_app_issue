#import "React/RCTViewManager.h"

@interface RCT_EXTERN_MODULE(ReadiumViewManager, RCTViewManager)

// Shared
RCT_EXPORT_VIEW_PROPERTY(file, NSDictionary *)
RCT_EXPORT_VIEW_PROPERTY(location, NSDictionary *)
RCT_EXPORT_VIEW_PROPERTY(onTableOfContents, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onReady, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onDownloaded, RCTDirectEventBlock)

// Reader
RCT_EXPORT_VIEW_PROPERTY(settings, NSDictionary *)
RCT_EXPORT_VIEW_PROPERTY(onLocationChange, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFullModeChange, RCTDirectEventBlock)
RCT_EXTERN_METHOD(goToPosition:(nonnull NSNumber*) reactTag
                  position:(CGFloat*) position)
RCT_EXTERN_METHOD(goToLocation:(nonnull NSNumber*) reactTag
                  location:(NSDictionary*) position)

// Audio
RCT_EXTERN_METHOD(playAudio:(nonnull NSNumber*) reactTag)
RCT_EXTERN_METHOD(pauseAudio:(nonnull NSNumber*) reactTag)
RCT_EXTERN_METHOD(seekAudio:(nonnull NSNumber*) reactTag value:(CGFloat*) value)
RCT_EXTERN_METHOD(setAudioRate:(nonnull NSNumber*) reactTag rate:(CGFloat*) rate)
RCT_EXTERN_METHOD(goToNextAudio:(nonnull NSNumber*) reactTag)
RCT_EXTERN_METHOD(goToPreviousAudio:(nonnull NSNumber*) reactTag)
RCT_EXTERN_METHOD(goToAudioPosition:(nonnull NSNumber*) reactTag
                  position:(CGFloat*) position)
RCT_EXPORT_VIEW_PROPERTY(onAudioPlaybackChange, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onDownloading, RCTDirectEventBlock)
@end
