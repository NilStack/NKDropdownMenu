#
Pod::Spec.new do |s|

  s.name         = "NKDropdownMenu"
  s.version      = "0.0.1"
  s.summary      = "A drop down menu inspired by https://dribbble.com/shots/2286361-Hamburger-Menu-Animation."
  s.description  = <<-DESC
                   A drop down menu inspired by https://dribbble.com/shots/2286361-Hamburger-Menu-Animation.
                   It's not exactly the same as the original design.

                   DESC

  s.homepage     = "https://github.com/NilStack/NKDropdownMenu"
  s.screenshots  = "https://db.tt/H0ZclkeB"
  s.license      = "MIT"

  s.author       = { "Peng Guo" => "guoleii@gmail.com" }
  
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/NilStack/NKDropdownMenu.git", :tag => "0.0.1" }
  s.source_files  = "NKDropdownMenu/*.swift"
  s.requires_arc = true

end
