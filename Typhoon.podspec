pod do |spec|
    spec.name         = 'Typhoon'
    spec.version      = '1.0.6'
    spec.license      = 'Apache2.0'
    spec.summary      = 'A dependency injection container for Objective-C. Light-weight, yet flexible and full-featured.'
    spec.homepage     = 'https://github.com/jasperblues/Typhoon.git'
    spec.author       = { 'Jasper Blues' => 'jasper@appsquick.ly' }
    spec.source       = { :git => 'https://github.com/jasperblues/Typhoon.git', :tag => '1.0.6' }
    spec.source_files = 'Source/**/*.{h,m}'
    spec.libraries    =  'z', 'xml2'
    spec.xcconfig     =  { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
    spec.requires_arc = true
end 
