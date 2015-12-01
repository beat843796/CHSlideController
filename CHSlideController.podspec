Pod::Spec.new do |s|
  s.name         = "CHSlideController"
  s.version      = "2.0"
  s.description  = "A View controller that contains 2 static non moving UIViewControllers and 1 swipeable UIViewController that can cover the static ones."
  s.homepage     = "https://github.com/beat843796/CHSlideController"
  s.license      = 'MIT'
  s.authors      = { "Clemens Beat" => "beat84@me.com", "Alex" => "alex@ablfx.com" }
  s.source       = { :git => "https://github.com/ablfx/CHSlideController.git" :tag => s.version.to_s }
  s.platform     = :ios, '8.1'
  s.source_files = 'Classes', 'CHSlideController/CHSlideController.{h,m}'
  s.frameworks   = 'QuartzCore'
  s.requires_arc = true
end
