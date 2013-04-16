Pod::Spec.new do |s|
  s.name     = 'CHSlideController'
  s.version  = '0.1'
  s.author   = { 'Clemens Hammerl' => 'beat84@me.com' }
  s.homepage = 'https://github.com/beat843796/CHSlideController'
  s.summary  = 'A View controller that contains 1 static non moving ViewController and 1 swipeable ViewController that can cover the static one.'
  s.license  = 'Apache License, Version 2.0'
  s.source   = { :git => 'git://github.com/beat843796/CHSlideController.git' }
  s.source_files = FileList['CHSlideController/CHSlideController*.{h,m}']
end
