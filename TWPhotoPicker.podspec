Pod::Spec.new do |s|

  s.name         = "TWPhotoPicker"
  s.version      = "1.0.1"
  s.summary      = "A image picker like Instagram."

  s.description  = <<-DESC
                   Present Image Picker like Instagram.You can crop a image using it.
                   DESC
  s.homepage     = "https://github.com/vladzz/InstagramPhotoPicker"
  s.screenshots  = "https://raw.githubusercontent.com/vladzz/InstagramPhotoPicker/master/Screenshots/Screenshot01.png"
  s.license      = "MIT"
  s.author       = { "wenzhaot" => "tanwenzhao1025@gmail.com", "vladzz" => "vladzz@gmail.com" }
  s.source       = { :git => "https://github.com/vladzz/InstagramPhotoPicker.git"}
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files  = "TWPhotoPicker/*.{h,m}"

  s.frameworks = "Foundation", "CoreGraphics", "UIKit"

  s.ios.resource_bundle = { 'TWPhotoPicker' => "TWPhotoPicker/Resources/*.png" }

end
