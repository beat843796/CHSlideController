Pod::Spec.new do |s|
  s.name     = 'CHSlideController'
  s.version  = '2.0'
  s.platform = :ios, '8.1'
  s.license  = 'MIT'
  s.summary  = 'A ViewController that manages 3 contained viewcontrollers'
  s.authors   = { 'Clemens Hammerl' => 'beat84@me.com' }
  s.source   = { :git => 'https://github.com/beat843796/CHSlideController.git', :tag => s.version.to_s }
  s.homepage = 'https://github.com/beat843796/CHSlideController'
  s.description = 'Easy to use viewcontroller managing 3 contained viewcontrollers'

  s.source_files = 'CHSlideController/CHSlideController/*.{h,m}'
  s.requires_arc = true
end