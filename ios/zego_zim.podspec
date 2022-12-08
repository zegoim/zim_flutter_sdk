#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint zego_zim.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'zego_zim'
  s.version          = '2.5.0'
  s.summary          = 'ZIM SDK for Flutter.'
  s.description      = <<-DESC
  ZIM Flutter SDK is a flutter plugin wrapper based on ZIM native Android / iOS SDK
                       DESC
  s.homepage         = 'https://zego.im'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'ZEGO' => 'developer@zego.im' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'ZIM','2.5.0'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386','ENABLE_BITCODE' => 'NO' }
end
