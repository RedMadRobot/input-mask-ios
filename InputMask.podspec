Pod::Spec.new do |spec|
  spec.name                  = "InputMask"
  spec.version               = "7.3.2"
  spec.summary               = "InputMask"
  spec.description           = "User input masking library."
  spec.homepage              = "https://github.com/RedMadRobot/input-mask-ios"
  spec.license               = "MIT"
  spec.author                = { "Yehor Taflanidi" => "jeorge.morpheus@gmail.com" }
  spec.source                = { :git => "https://github.com/RedMadRobot/input-mask-ios.git", :tag => spec.version.to_s }
  spec.ios.deployment_target = "15.6"
  spec.osx.deployment_target = "10.13"
  spec.requires_arc          = true
  spec.source_files          = "Source/InputMask/InputMask/Classes/**/*"
  spec.swift_version         = '5.7'
end
