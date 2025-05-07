# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'EvolveGT-iOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for EvolveGT-iOS
  pod 'SkyFloatingLabelTextField', '~> 3.0'
  pod 'Kingfisher', '~> 4.2'
  pod 'SnapKit', '~> 5.0.0'
  pod 'Alamofire', '~> 4.9.1'
  pod 'SVProgressHUD'
  pod 'IQKeyboardManagerSwift','6.0.4'
  pod 'RSSelectionMenu'
  pod 'Loaf'
  pod 'MBRadioCheckboxButton'
  pod 'DatePickerDialog'
  pod 'SideMenuSwift'
  pod 'SwiftSignatureView'
# pod 'BraintreeDropIn'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'Firebase/Core'
  pod 'AEOTPTextField'

end

target 'EvolveGT-QA' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for EvolveGT-QA

end

target 'EvolveGT-UAT' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for EvolveGT-UAT

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end
