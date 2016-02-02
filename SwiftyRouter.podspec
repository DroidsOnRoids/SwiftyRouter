Pod::Spec.new do |s|
  s.name             = "SwiftyRouter"
  s.version          = "0.1.0"
  s.summary          = "SwiftyRouter makes it easy to deal with network connection in Swift"

  s.description      = <<-DESC
                       DESC

  s.homepage         = "https://github.com/DroidsOnRoids/SwiftyRouter"
  s.license          = 'MIT'
  s.author           = { "Piotr Sochalewski" => "piotr.sochalewski@droidsonroids.pl", "Łukasz Mróz" => "lukasz.mroz@droidsonroids.pl" }
  s.source           = { :git => "https://github.com/DroidsOnRoids/SwiftyRouter.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.frameworks = 'Foundation'

  s.subspec 'Core' do |cs|
    cs.source_files = 'SwiftyRouter.swift'
    cs.dependency 'Alamofire', '~> 3.1'
  end

  s.subspec 'ObjectMapper' do |cs|
    cs.source_files = 'ObjectMapper/SwiftyRouter+ObjectMapper.swift'
    cs.dependency 'ObjectMapper', '~> 1.1'
  end

  s.subspec 'SwiftyJSON' do |cs|
    cs.source_files = 'SwiftyJSON/SwiftyRouter+SwiftyJSON.swift'
    cs.dependency 'SwiftyJSON', '~> 2.3'
  end

  s.subspec 'ModelMapper' do |cs|
    cs.source_files = 'ModelMapper/SwiftyRouter+ModelMapper.swift'
    cs.dependency 'ModelMapper'
  end

  s.default_subspecs = 'Core'

end
