Pod::Spec.new do |s|
  s.name         = "SComponents"
  s.version      = "0.0.1"
  s.summary      = "Native SwiftUI components "
  s.description  = <<-DESC
    Native SwiftUI components 
  DESC
  s.homepage     = "https://github.com/shial4/SComponents.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Szymon Lorenz" => "shial184686@gmail.com" }
  s.social_media_url   = "https://www.facebook.com/SLSolutionsAU/"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/shial4/SComponents.git", :tag => s.version.to_s }
  s.source_files  = "SComponents/**/*"
end