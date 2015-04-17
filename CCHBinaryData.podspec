Pod::Spec.new do |spec|
  spec.name     = 'CCHBinaryData'
  spec.version  = '1.0.1'
  spec.license  = 'MIT'
  spec.summary  = 'Utility classes for handling binary data.'
  spec.homepage = 'https://github.com/choefele/CCHBinaryData'
  spec.authors  = { 'Claus Höfele' => 'claus@claushoefele.com' }
  spec.social_media_url = 'https://twitter.com/claushoefele'
  spec.source   = { :git => 'https://github.com/choefele/CCHBinaryData.git', :tag => spec.version.to_s }
  spec.requires_arc = true

  spec.ios.deployment_target = '7.0'
  spec.osx.deployment_target = '10.9'

  spec.source_files = 'CCHBinaryData/*.{h,m}'
end
