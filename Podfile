# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'AmplifyGettingStarted' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'amplify-tools', '~> 0.2.0'

  pod 'Amplify', '~> 0.10.0'
  pod 'AWSPluginsCore', '~> 0.10.0'
  pod 'AmplifyPlugins/AWSAPIPlugin' , '~> 0.10.0'
  
  # auth
  pod 'AWSMobileClient', '~> 2.12.0'      # Required dependency
  pod 'AWSAuthUI', '~> 2.12.0'            # Optional dependency required to use drop-in UI
  pod 'AWSUserPoolsSignIn', '~> 2.12.0'   # Optional dependency required to use drop-in UI
  
  pod 'AWSS3', '~> 2.12.5' # S3用のSDKを追加
  pod 'AWSAppSync', '~> 3.0.0' # AppSync用のSDK
  
  # Pods for AmplifyGettingStarted

  target 'AmplifyGettingStartedTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'AmplifyGettingStartedUITests' do
    # Pods for testing
  end

end
