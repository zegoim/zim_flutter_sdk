#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint zim_flutter_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'zego_zim'
  s.version          = '2.5.0'
  s.summary          = 'ZIM macOS SDK for Flutter.'
  s.description      = <<-DESC
  ZIM Flutter SDK is a flutter plugin wrapper based on ZIM native macOS SDK
                       DESC
  s.homepage         = 'https://zego.im'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'ZEGO' => 'developer@zego.im' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'FlutterMacOS'
  s.dependency 'ZIM','2.5.0'
  #s.vendored_frameworks = "ZIM.xcframework"

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
