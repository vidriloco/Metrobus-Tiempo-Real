# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Metrobus RT' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Metrobus RT
	pod 'MBProgressHUD', '~> 1.2.0'
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