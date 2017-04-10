#
# Be sure to run `pod lib lint TBCounter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TBCounter'
  s.version          = '1.0.2'
  s.summary          = 'Native progress task counter'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    Task counter with progress calculation. Could be selfreatin.
    Fired completion when tasks count is 0.
                       DESC

  s.homepage         = 'https://github.com/truebucha/TBCounter'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'truebucha' => 'truebucha@gmail.com' }
  s.source           = { :git => 'https://github.com/truebucha/TBCounter.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/truebucha'

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.10'

  s.source_files = 'TBCounter/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TBCounter' => ['TBCounter/Assets/*.png']
  # }

  s.public_header_files = 'TBCounter/Classes/**/*.h'
  s.frameworks = 'Foundation'
  s.dependency 'CDBKit', '~> 1.1'
end
