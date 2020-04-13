Pod::Spec.new do |s|
s.name         = 'LFAssetExportSession'
s.version      = '1.0.1'
s.summary      = 'Video compression tool. (Small size and high definition)'
s.homepage     = 'https://github.com/lincf0912/LFAssetExportSession'
s.license      = 'MIT'
s.author       = { 'lincf0912' => 'dayflyking@163.com' }
s.platform     = :ios
s.ios.deployment_target = '7.0'
s.source       = { :git => 'https://github.com/lincf0912/LFAssetExportSession.git', :tag => s.version, :submodules => true }
s.requires_arc = true
s.source_files = 'LFAssetExportSession/LFAssetExportSession/class/*.{h,m}'
s.public_header_files = 'LFAssetExportSession/LFAssetExportSession/class/*.h'

end
