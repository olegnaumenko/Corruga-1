use_frameworks!

target 'Corruga' do
  platform :ios, '12.3'

#  pod 'youtube-ios-player-helper-swift'
  pod "YoutubePlayer-in-WKWebView"#, "~> 0.3.0"
  pod 'AFNetworking'
  pod 'Firebase/Core'
  pod 'Firebase/Analytics'
  pod 'Firebase/Database'
  pod 'AltHanekeSwift'
  pod 'Branch'
  pod 'FTLinearActivityIndicator'
  
  #  pod 'ReachabilitySwift'
#    pod 'RealmSwift'
  #  pod 'youtube-ios-player-helper', '~> 0.1.4'
  #  pod 'UIDevice-Hardware'
  #  pod 'FacebookSDK', '~> 4.44.1'
  pod 'SwiftSoup'
#  pod 'PeekPop'
#  pod 'SwiftEmoji'

end

target 'CorrugaTests' do
  
  platform :ios, '12.3'
  
#  pod 'youtube-ios-player-helper-swift'
  pod "YoutubePlayer-in-WKWebView"#, "~> 0.3.0"
  pod 'AFNetworking'
  pod 'Firebase/Core'
  pod 'Firebase/Analytics'
  pod 'Firebase/Database'
  pod 'AltHanekeSwift'
  pod 'Branch'
  pod 'SwiftSoup'
  
end
  
post_install do |lib|
    lib.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        end
    end
end
