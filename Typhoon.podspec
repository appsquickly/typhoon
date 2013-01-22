pod do |spec|
  spec.name         = 'Typhoon'
  spec.version      = '1.0.3'
  spec.source       = { :git => 'https://github.com/jasperblues/Typhoon', :tag => '1.0.3' }
  spec.source_files = 'Source/**/*.{h,m}'
  spec.libraries    =  'z', 'xml2'
  spec.xcconfig     =  { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
end 
