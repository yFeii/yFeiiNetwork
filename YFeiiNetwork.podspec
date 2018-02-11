#
#  Be sure to run `pod spec lint YFeiiNetwork.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "YFeiiNetwork"
  s.version      = "0.0.1"
  s.summary      = "网络框架"

  
  s.description  = <<-DESC
             yFeiiNetwork OC
                   DESC

  s.homepage     = "https://github.com/yFeii/yFeiiNetwork"

  s.license      = "MIT"

  s.author             = { "git" => "15524589871@163.com" }
 
  # s.platform     = :ios
  # s.platform     = :ios, "5.0"

  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/yFeii/yFeiiNetwork.git", :tag => "#{s.version}" }

  s.source_files  = "Classes", "Classes/*.{h,m}"
  
  s.dependency "AFNetworking"
  s.requires_arc = true

end
