Pod::Spec.new do |spec|
  spec.name = 'Typhoon'
  spec.version = '4.0.2'
  spec.license = 'Apache2.0'
  spec.summary = 'Dependency injection for Objective-C and Swift. Light-weight, yet flexible and full-featured.'
  spec.homepage = 'http://www.typhoonframework.org'
  spec.author = {'Jasper Blues, Aleksey Garbarev, Robert Gilliam, Daniel Rodríguez, Erik Sundin & Contributors' => 'info@typhoonframework.org'}
  spec.source = {:git => 'https://github.com/appsquickly/Typhoon.git', :tag => spec.version.to_s, :submodules => true}

  spec.ios.deployment_target = '5.0'
  spec.osx.deployment_target = '10.7'
  spec.tvos.deployment_target = '9.0'

  spec.source_files = 'Source/**/*.{h,m}'
  non_arc_files = 'Source/Factory/Internal/NSInvocation+TCFInstanceBuilder.{h,m}'
  spec.ios.exclude_files = 'Source/osx', non_arc_files
  spec.osx.exclude_files = 'Source/ios', non_arc_files
  spec.tvos.exclude_files = 'Source/osx', non_arc_files

  spec.requires_arc = true
  spec.subspec 'no-arc' do |sna|
    sna.requires_arc = false
    sna.source_files = non_arc_files
    sna.dependency 'Typhoon/IntrospectionUtils'
  end

  spec.subspec 'IntrospectionUtils' do |sna|
    sna.source_files = 'Source/Utils/TyphoonIntrospectionUtils.{h,m}', 'Source/TypeConversion/TyphoonTypeDescriptor.{h,m}', 'Source/Utils/TyphoonUtils.h'
  end

  spec.subspec 'DeallocNotifier' do |sna|
    sna.source_files = 'Source/Utils/NSObject+DeallocNotification.{h,m}'
  end


  spec.documentation_url = 'http://www.typhoonframework.org/docs/latest/api/'
end 
