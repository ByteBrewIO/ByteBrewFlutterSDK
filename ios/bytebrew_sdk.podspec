#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint bytebrew_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'bytebrew_sdk'
  s.version          = '0.1.0'
  s.summary          = 'ByteBrew Flutter SDK Plugin'
  s.description      = <<-DESC
ByteBrew Flutter SDK Plugin
                       DESC
  s.homepage         = 'https://bytebrew.io'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'ByteBrew' => 'contact@bytebrew.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }

  s.vendored_frameworks = 'ByteBrew.xcframework'
end
