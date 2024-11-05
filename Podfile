# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'Metrobus RT' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Metrobus RT
  pod 'AppReview', :git => 'https://github.com/mezhevikin/AppReview.git'
  pod 'Google-Mobile-Ads-SDK'
end

post_install do |installer|
  installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
             end
        end
 end
end