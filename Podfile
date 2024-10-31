platform :ios, '15.0'
use_frameworks!

target 'Yukre' do
  # Core dependencies
  pod 'SwiftLint'
  pod 'KeychainAccess'
  
  # Networking
  pod 'Alamofire'
  
  # Security
  pod 'CryptoSwift'
  pod 'SwiftKeychainWrapper'
  
  # UI/UX
  pod 'SnapKit'
  pod 'Lottie'
  
  # Testing
  target 'YukreTests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end