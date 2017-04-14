Pod::Spec.new do |s|
  s.name          = "AllYourMemoriesAreBelong2iOS"
  s.version       = "1.0"
  s.summary       = "Simulate iOS on-device memory warnings like a hero."

  s.homepage      = "https://github.com/TorinKwok/AllYourMemoriesAreBelong2iOS"
  s.license       = { :type => "MIT",
                      :file => "LICENSE" }
  s.author        = { "Torin Kwok" => "torin@kwok.im" }
  s.social_media_url = "https://github.com/TorinKwok"

  s.source        = { :git => "https://github.com/TorinKwok/AllYourMemoriesAreBelong2iOS.git",
                      :tag => s.version }
  s.source_files  = 'AllYourMemoriesAreBelong2iOS/*.{h,m}'
  
  s.module_name = 'AllYourMemoriesAreBelong2iOS'
  s.ios.deployment_target     = '8.0'
  
  s.requires_arc  = true
  s.library       = 'z'
  s.preserve_path = 'zlib/*'
end
