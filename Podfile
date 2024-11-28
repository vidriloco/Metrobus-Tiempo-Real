# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

use_frameworks!

def shared
  pod 'Google-Mobile-Ads-SDK'
  pod 'AppReview', :git => 'https://github.com/mezhevikin/AppReview.git'
  pod 'FBAudienceNetwork'
end

target 'Metrobus RT' do
  shared
end

target 'Mexibus' do
  shared
end

target 'TransportCore' do
  shared
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