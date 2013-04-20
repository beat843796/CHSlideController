Pod::Spec.new do |s|
  s.name         = "CHSlideController"
  s.version      = "0.1.0"
  s.summary      = "A View controller that contains 1 static non moving ViewController and 1 swipeable ViewController that can cover the static one."
  s.homepage     = "https://github.com/beat843796/CHSlideController"
  s.license      = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors       = { "Clemens Beat" => "beat84@me.com", "Alex" => "alex@ablfx.com" }

  s.source       = { :git => "https://github.com/ablfx/CHSlideController.git", :tag => "v0.1.0" }
  s.platform     = :ios, '5.1'
  s.source_files = 'Classes', 'CHSlideController/CHSlideController.{h,m}'
  s.frameworks   = 'QuartzCore'
  s.requires_arc = true
end
