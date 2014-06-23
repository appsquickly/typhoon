Pod::Spec.new do |spec|
  spec.name = 'Typhoon'
  spec.version = '2.1.1'
  spec.license = 'Apache2.0'
  spec.summary = 'A dependency injection container for Objective-C. Light-weight, yet flexible and full-featured.'
  spec.homepage = 'http://www.typhoonframework.org'
  spec.author = {'Jasper Blues, Robert Gilliam, Daniel Rodríguez, Erik Sundin, Aleksey Garbarev & Contributors' => 'info@typhoonframework.org'}
  spec.source = {:git => 'https://github.com/typhoon-framework/Typhoon.git', :tag => spec.version.to_s, :submodules => true}

  spec.ios.deployment_target = '5.0'
  spec.osx.deployment_target = '10.7'


  non_arc_files = 'Source/Factory/Internal/NSInvocation+TCFInstanceBuilder.{h,m}'

  spec.documentation_url = 'http://www.typhoonframework.org/docs/latest/api/'

  spec.requires_arc = true

  spec.source_files = 'Source/*.{h,m}'

  spec.subspec 'Definition' do |definition|
    definition.source_files = 'Source/Definition/*.{h,m}'
    definition.subspec 'Method' do |method|
      method.source_files = 'Source/Definition/Method/*.{h,m}'
      method.subspec 'Internal' do |internal|
        internal.source_files = 'Source/Definition/Method/Internal/*.{h,m}'
      end
    end
    definition.subspec 'Injections' do |injections|
      injections.source_files = 'Source/Definition/Injections/*.{h,m}'
    end
    definition.subspec 'Internal' do |internal|
      internal.source_files = 'Source/Definition/Internal/*.{h,m}'
    end
  end

  spec.subspec 'Factory' do |factory|
	factory.source_files = 'Source/Factory/*.{h,m}'
	factory.subspec 'Block' do |block|
	  block.source_files = 'Source/Factory/Block/*.{h,m}'
	end
    factory.subspec 'Hooks' do |hooks|
      hooks.source_files = 'Source/Factory/Hooks/*.{h,m}'
    end
    factory.subspec 'Internal' do |internal|
      internal.source_files = 'Source/Factory/Internal/*.{h,m}'
      internal.exclude_files = non_arc_files
    end
    factory.subspec 'Pool' do |pool|
      pool.source_files = 'Source/Factory/Pool/*.{h,m}'
    end
    factory.dependency 'Typhoon/Definition'
    factory.dependency 'Typhoon/Utils'
    factory.dependency 'Typhoon/no-arc'
    factory.dependency 'Typhoon/Configuration'
    factory.dependency 'Typhoon/TypeConversion'
  end

  spec.subspec 'Configuration' do |config|
  	config.source_files = 'Source/Configuration/*.{h,m}'
  	config.subspec 'DefinitionOptionConfiguration' do |defOptConf|
  	  defOptConf.source_files = 'Source/Configuration/DefinitionOptionConfiguration/*.{h,m}'
  	  defOptConf.subspec 'Factory' do |factory|
  	    factory.source_files = 'Source/Configuration/DefinitionOptionConfiguration/Factory/*.{h,m}'
  	  end
  	end
    config.subspec 'ConfigPostProcessor' do |cfgPostProcessor|
      cfgPostProcessor.source_files = 'Source/Configuration/ConfigPostProcessor/**/*.{h,m}'
    end
    config.subspec 'Resource' do |resource|
      resource.source_files = 'Source/Configuration/Resource/*.{h,m}'
    end
    config.subspec 'Startup' do |startup|
      startup.source_files = 'Source/Configuration/Startup/*.{h,m}'
    end
  end

  spec.subspec 'ios' do |ios|
    ios.platform     = :ios, '5.0'
   	ios.source_files = 'Source/ios/*.{h,m}'
  	ios.subspec 'Configuration' do |ioscfg|
  	  ioscfg.source_files = 'Source/ios/Configuration/**/*.{h,m}'
  	end
    ios.subspec 'Storyboard' do |storyboard|
      storyboard.source_files = 'Source/ios/Storyboard/**/*.{h,m}'
    end
    ios.subspec 'TypeConversion' do |typeConversion|
      typeConversion.source_files = 'Source/ios/TypeConversion/**/*.{h,m}'
    end
  end

  spec.subspec 'TypeConversion' do |typeConversion|
    typeConversion.source_files = 'Source/TypeConversion/*.{h,m}'
    typeConversion.subspec 'Converters' do |converters|
      converters.source_files = 'Source/TypeConversion/Converters/*.{h,m}'
    end
  end

  spec.subspec 'Utils' do |utils|
    utils.source_files = 'Source/{Utils,Vendor}/**/*.{h,m}'
  end

  spec.subspec 'Test' do |test|
    test.source_files = 'Source/Test/**/*.{h,m}'
  end

  spec.subspec 'no-arc' do |sna|
    sna.requires_arc = false
    sna.source_files = non_arc_files
  end

  spec.dependency 'Typhoon/Factory'

end
