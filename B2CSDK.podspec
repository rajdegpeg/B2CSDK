#
# Be sure to run `pod lib lint B2CSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'B2CSDK'
  s.version          = '0.1.0'
  s.summary          = 'A short description of B2CSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/rajdegpeg/B2CSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Raj Kadam' => 'rajendra.kadam@degpeg.com' }
  s.source           = { :git => 'https://github.com/rajdegpeg/B2CSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'B2CSDK/Classes/**/*'
  
   s.resource_bundles = {
     'B2CSDK' => ['B2CSDK/Assets/Images/*.png', 'B2CSDK/Assets/Images/*.mp4',  'B2CSDK/Assets/*.xib', 'B2CSDK/Assets/TableViewCell/*.xib', 'B2CSDK/Assets/CollectionView/*.xib', 'B2CSDK/Classes/Degpeg.storyboard', 'B2CSDK/Classes/*.xib', 'B2CFramework/Classes/*.xib']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.frameworks = 'UIKit', 'Foundation'
  s.dependency 'Alamofire'
  s.dependency 'Socket.IO-Client-Swift', '~> 16.0'
  s.dependency 'MBProgressHUD', '~> 1.2'
  s.dependency 'Kingfisher', '~> 7.0'
  s.dependency 'ObjectMapper', '~> 4.2'
end
