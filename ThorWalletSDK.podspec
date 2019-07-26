#
# Be sure to run `pod lib lint ThorWalletSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ThorWalletSDK'
  s.version          = '1.0.0'
  s.summary          = 'Vechain wallet SDK'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Vechain wallet SDK provides a series of functional interface can help the iOS developers, for example: quickly create the wallet, the private key signature, call the vechain block interface, put data in the vechain block, and support dapp development environment.
                       DESC

  s.homepage         = 'https://github.com/vechain/wallet-iOS-sdk'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'VeChain' => 'support@vechain.com' }
  s.source           = { :git => 'https://github.com/vechain/wallet-iOS-sdk.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  
  s.resource = 'ThorWalletSDK/Assets/ThorWalletSDKBundle.bundle'
  
  s.subspec 'DApp' do |ss|
        ss.source_files = 'ThorWalletSDK/Classes/DApp/**/*.{h,m}'
        ss.dependency  'ThorWalletSDK/BasicWallet'
  end
  
  
   s.subspec 'BasicWallet' do |ss|
       ss.source_files = 'ThorWalletSDK/Classes/BasicWallet/*.{h,m}','ThorWalletSDK/Classes/BasicWallet/**/*.{h,m}'
       ss.dependency  'ThorWalletSDK/Tool'
       ss.dependency  'ThorWalletSDK/DApp'
      #ss.public_header_files = ''
   end
  
  s.subspec 'Tool' do |ss|
      ss.source_files = 'ThorWalletSDK/Classes/Lib/**/*.{h,m,c,table}'
      ss.dependency  'ThorWalletSDK/BasicWallet'
      #ss.public_header_files = ''
  end

  
  s.dependency 'AFNetworking', '~> 3.0'
    
  s.dependency 'SocketRocket', '~> 0.4.2'
  
  s.dependency 'YYModel', '~>  1.0.4'
  
end
