#
# Be sure to run `pod lib lint JSwiftON.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JSwiftON'
  s.version          = '0.1.2'
  s.summary          = 'Very simple JSON convenience library.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is a very simple convenience library for using JSON from Swift. It was
written at the point where I became bored with optional unwrapping and still
did not want to pull a 3rd-party dependency into my project.
                       DESC

  s.homepage         = 'https://github.com/Uragawa/JSwiftON'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'Alex Felippe Chiozo'
  s.source           = { :git => 'https://github.com/Uragawa/JSwiftON.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'

  s.source_files = 'JSwiftON/Classes/**/*'
  
  s.frameworks = 'Foundation'
end
