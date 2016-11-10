Pod::Spec.new do |s|

  s.name         = "ConvenientFileManager"
  s.version      = "2.0.8"
  s.summary      = "A suite of extensions to ease using NSFileManager for common tasks."

  s.homepage     = "http://www.williamboles.me"
  s.license      = { :type => 'MIT', 
  					 :file => 'LICENSE.md' }
  s.author       = "William Boles"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/wibosco/ConvenientFileManager.git", 
  					 :branch => "master", 
  					 :tag => s.version }

  s.source_files  = "ConvenientFileManager/**/*.swift"
	
  s.requires_arc = true
  
end
