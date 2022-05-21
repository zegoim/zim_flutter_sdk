import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zim_plugin/zim_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('zim_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  // test('getPlatformVersion', () async {
  //   expect(await ZimPlugin.platformVersion, '42');
  // });
}
