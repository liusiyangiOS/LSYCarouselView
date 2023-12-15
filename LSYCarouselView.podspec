Pod::Spec.new do |s|

  s.name         = "LSYCarouselView"
  s.version      = "1.0.0"
  s.summary      = "LSYCarouselView是一个基于Objective-C语言的无限轮播方案的实现"

  s.homepage     = "https://github.com/liusiyangiOS/LSYCarouselView"
  s.license      = "MIT"
  s.author       = { "liusiyangiOS" => "liusiyang_iOS@163.com" }
  
  s.ios.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/liusiyangiOS/LSYCarouselView.git", :tag => s.version.to_s }
  s.source_files = "LSYCarouselView/*.{h,m}"
  s.requires_arc = true
  
  s.dependency "Masonry", "~> 1.1.0"
  s.dependency "SDWebImage", "~> 5.18.7"
  
end
