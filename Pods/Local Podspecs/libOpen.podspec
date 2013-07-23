Pod::Spec.new do |s|
  s.name = 'libOpen'
  s.version = '0.1.2'
  s.platform = :ios, '5.0'
  s.license = 'MIT'
  s.summary = 'An Objective-C library'
  s.homepage = 'https://github.com/traintrackcn/libOpen'
  s.author = { 'traintrackcn' => 'traintrackcn@gmail.com' }
# s.source = { :git => 'git://github.com/lukeredpath/libPusher.git', :tag => 'v1.3' }
#  s.source_files = 'libOpen/**/{NS,SD,UI,T,G}*.{h,m}'
# s.requires_arc = true
  
#  s.subspec 'ZUUIRevealController' do |zuui|
 #   zuui.source_files    = 'libOpen/ZUUIRevealController/*.{h,m}'
  #  zuui.requires_arc    = false
  #end
  
  s.subspec 'Tao' do |t|
    t.source_files    = 'libOpen/Tao/*.{h,m}'
    t.requires_arc    = true
  end
  
  s.subspec 'CommonARC' do |cArc|
    cArc.source_files    = 'libOpen/CommonARC/*.{h,m}'
    cArc.requires_arc    = true
  end
  
  s.subspec 'CommonNoARC' do |cNoArc|
    cNoArc.source_files    = 'libOpen/CommonNoARC/*.{h,m}'
    cNoArc.requires_arc    = false
  end
  

 # s.dependency 'SocketRocket'
 # s.framework = 'ImageIO'
end