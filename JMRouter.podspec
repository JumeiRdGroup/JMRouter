#
# Be sure to run `pod lib lint JMRouter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'JMRouter'
    s.version          = '1.0.0'
    s.summary          = '一个轻量级，纯Swift，协议化的路由控件'

    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!

    s.description      = <<-DESC
    一个轻量级，纯Swift，协议化的路由控件，简单易用
    DESC

    s.homepage         = 'https://github.com/JumeiRdGroup/JMRouter'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'yuany' => 'cgcym1234@163.com' }
    s.source           = { :git => 'https://github.com/JumeiRdGroup/JMRouter.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

    s.ios.deployment_target = '8.0'
    s.swift_version    = '5.0'

    s.source_files = 'JMRouter/Classes/**/*'

    # s.resource_bundles = {
    #   'YYRouter' => ['JMRouter/Assets/*.png']
    # }

    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    # s.dependency 'AFNetworking', '~> 2.3'
end
