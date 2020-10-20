# Uncomment the next line to define a global platform for your project
# platform :ios, '14.0'

target 'PlantCare' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PlantCare
  pod 'Firebase/Analytics'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'FirebaseFirestoreSwift'
  pod 'Firebase/Auth'
  pod 'Resolver'

  target 'PlantCareTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PlantCareUITests' do
    # Pods for testing
  end

   post_install do |pi|
        pi.pods_project.targets.each do |t|
          t.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
          end
        end
    end
end
