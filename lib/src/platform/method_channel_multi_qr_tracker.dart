import 'package:flutter/services.dart';
import 'multi_qr_tracker_platform.dart';

/// An implementation of [MultiQrTrackerPlatform] that uses method channels.
class MethodChannelMultiQrTracker extends MultiQrTrackerPlatform {
  /// The method channel used to interact with the native platform.
  static const MethodChannel _channel = MethodChannel('multi_qr_tracker');

  @override
  Future<Map<String, dynamic>> initialize(final String orientation) async {
    try {
      final result = await _channel.invokeMethod<Map<Object?, Object?>>(
        'initialize',
        {'orientation': orientation},
      );
      return Map<String, dynamic>.from(result ?? {});
    } on PlatformException catch (e) {
      throw Exception('Failed to initialize camera: ${e.message}');
    }
  }

  @override
  Future<void> dispose() async {
    try {
      await _channel.invokeMethod<void>('dispose');
    } on PlatformException catch (e) {
      throw Exception('Failed to dispose camera: ${e.message}');
    }
  }

  @override
  void setDetectionCallback(
    final void Function(Map<String, dynamic>) callback,
  ) {
    _channel.setMethodCallHandler((final call) async {
      if (call.method == 'onBarcodesDetected') {
        final data = Map<String, dynamic>.from(call.arguments as Map);
        callback(data);
      }
    });
  }
}
