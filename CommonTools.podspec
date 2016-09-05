#
# Be sure to run `pod lib lint CommonTools.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CommonTools'
  s.version          = '0.1.0'
  s.summary          = 'common tools, like base request, base tableview etc.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
common tools, like base request, base tableview etc.
                       DESC

  s.homepage         = 'https://github.com/hengyizhangcn/CommonTools'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hengyizhangcn@gmail.com' => 'hengyizhangcn@gmail.com' }
  s.source           = { :git => 'https://github.com/hengyizhangcn/CommonTools.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.source_files = 'CommonTools/CommonTools.h'
  
  s.subspec 'BaseRequest' do |ss|
    ss.source_files = 'CommonTools/BaseRequest/*'
    ss.public_header_files = 'CommonTools/BaseRequest/CTBaseRequest.h'
    ss.frameworks = 'BaseRequest'
  end

  s.subspec 'Utility' do |ss|
    ss.source_files = 'CommonTools/Utility/*'
    ss.public_header_files = 'CommonTools/Utility/CTUtility.h'
    ss.frameworks = 'Utility'
  end

  s.subspec 'YAUIKit' do |ss|
    ss.source_files = 'CommonTools/YAUIKit/*'
    ss.public_header_files = 'CommonTools/YAUIKit/YAPanBackController.h'
    ss.frameworks = 'YAUIKit'
  end

  s.subspec 'Categories' do |ss|
    ss.source_files = 'CommonTools/Categories/*'
    ss.public_header_files = 'CommonTools/Categories/UIView+shortCut.h'
    ss.frameworks = 'Categories'
  end

  s.subspec 'BaseTableView' do |ss|
    ss.source_files = 'CommonTools/BaseTableView/*'
    ss.public_header_files = 'CommonTools/BaseTableView/CTBaseTableView.h'
    ss.frameworks = 'BaseTableView'
  end

  s.subspec 'BaseViewController' do |ss|
    ss.source_files = 'CommonTools/BaseViewController/*'
    ss.public_header_files = 'CommonTools/BaseViewController/CTBaseViewController.h'
    ss.frameworks = 'BaseViewController'
  end

  # s.resource_bundles = {
  #   'CommonTools' => ['CommonTools/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 2.5.3'
end
