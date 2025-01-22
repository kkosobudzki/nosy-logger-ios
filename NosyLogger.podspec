#
# Be sure to run `pod lib lint NosyLogger.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NosyLogger'
  s.version          = '2.0.0'
  s.summary          = 'Collects, encrypts and transport logs'

  s.homepage         = 'https://github.com/kkosobudzki/NosyLogger'
  s.license          = { :type => 'GPL v3', :file => 'LICENSE' }
  s.author           = { 'kkosobudzki' => 'krzysztof.kosobudzki@gmail.com' }
  s.source           = { :git => 'https://github.com/kkosobudzki/NosyLogger.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'

  s.source_files = 'Sources/NosyLogger/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
