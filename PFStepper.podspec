Pod::Spec.new do |s|
  s.name                  = "PFStepper"
  s.version               = "2.0.0"
  s.summary               = "It may be the most elegant stepper you have ever had!"
  s.homepage              = "https://github.com/PerfectFreeze/PFStepper"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.author                = { "Cee" => "cee@chu2byo.com" }
  s.social_media_url      = "https://twitter.com/Ceecirno"
  s.platform              = :ios, "8.0"
  s.source                = { :git => "https://github.com/PerfectFreeze/PFStepper.git", :tag => "v#{s.version.to_s}" }
  s.source_files          = "Class/*.swift"
  s.requires_arc          = true
end