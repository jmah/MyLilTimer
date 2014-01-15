Pod::Spec.new do |s|
  s.name         = "MyLilTimer"
  s.version      = "0.1.0"
  s.summary      = "Timer class for iOS and OS X offering a choice of behaviors."
  s.homepage     = "https://github.com/jmah/MyLilTimer"
  s.license      = 'MIT'
  s.author       = { "Jonathon Mah" => "me@JonathonMah.com" }
  s.source       = { :git => "https://github.com/jmah/MyLilTimer.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '4.0'
  s.osx.deployment_target = '10.6'
  s.requires_arc = true

  s.source_files = 'Classes'
end
