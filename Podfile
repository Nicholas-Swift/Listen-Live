# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'ListenLive' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ListenLive
  pod "XCDYouTubeKit", "~> 2.5"
  pod 'Alamofire', '~> 4.3'
  pod 'SwiftyJSON'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod "FBSDKCoreKit"
  pod "FBSDKLoginKit"
  pod 'NTPKit'

end

post_install do |installer|
   installer.pods_project.targets.each do |target|
       target.build_configurations.each do |config|
           config.build_settings['SWIFT_VERSION'] = '3.0'
       end
   end
end
