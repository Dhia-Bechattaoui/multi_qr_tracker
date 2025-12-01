#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint multi_qr_tracker.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'multi_qr_tracker'
  s.version          = '0.4.0'
  s.summary          = 'A Flutter package for detecting and tracking multiple QR codes simultaneously.'
  s.description      = <<-DESC
A Flutter package for detecting and tracking multiple QR codes simultaneously.
                       DESC
  s.homepage         = 'https://github.com/Dhia-Bechattaoui/multi_qr_tracker'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Dhia Bechattaoui' => 'dhia.bechattaoui@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
