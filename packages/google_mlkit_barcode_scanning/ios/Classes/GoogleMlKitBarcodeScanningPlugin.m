#import <Foundation/Foundation.h>
#import "GoogleMlKitBarcodeScanningPlugin.h"

#define channelName @"google_mlkit_barcode_scanning"
#define startBarcodeScanner @"vision#startBarcodeScanner"
#define closeBarcodeScanner @"vision#closeBarcodeScanner"

@implementation GoogleMlKitBarcodeScanningPlugin {
    MLKBarcodeScanner *barcodeScanner;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:channelName
                                     binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {}


@end
