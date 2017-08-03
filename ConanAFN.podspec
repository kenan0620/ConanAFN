
Pod::Spec.new do |s|
  s.name             = 'ConanAFN'
  s.version          = '1.1.3'
  s.summary          = '网络框架库 ConanAFN.'


  s.description      = <<-DESC
ConanAFN。对AFN进行二次封装，逐步增加新的方法，不断的进行更新。
                       DESC

  s.homepage         = 'https://github.com/kenan0620/ConanAFN'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kenan' => 'houkenan0620@126.com' }
  s.source           = { :git => 'https://github.com/kenan0620/ConanAFN.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'
s.requires_arc = true
s.source_files = 'ConanAFN/*.{h,m}'
s.dependency 'AFNetworking', '~> 3.1.0'
s.dependency 'RealReachability', '~> 1.1.9'
end
