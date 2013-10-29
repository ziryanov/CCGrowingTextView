Pod::Spec.new do |s|
  s.name         = "CCGrowingTextView"
  s.version      = "0.1"
  s.summary      = "Multi-line/Autoresizing UITextView similar to SMS-app."
  s.description  = "An UITextView which grows/shrinks with the text"
  s.homepage     = "https://github.com/ziryanov/CCGrowingTextView"
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author       = { "Ivan Ziryanov" => "ivan.ziryanov@gmail.com" }
  s.source       = { :git => "https://github.com/ziryanov/CCGrowingTextView.git", :tag => s.version.to_s }
  s.platform     = :ios, '6.0'
  s.source_files = 'Classes', 'Classes/**/*.{h,m}'
  s.requires_arc = true
end
