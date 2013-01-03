pod do |spec|
  spec.name         = 'spring-objective-c'
  spec.version      = '1.0.1'
  spec.source       = { :git => 'https://github.com/jasperblues/spring-objective-c', :tag => '1.0.1' }
  spec.source_files = 'Source/**/*.{h,m}'
  spec.libraries    =  'z', 'xml2'
  spec.xcconfig     =  { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
end 
