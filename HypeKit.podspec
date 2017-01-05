Pod::Spec.new do |s|
  s.name             = 'HypeKit'
  s.version          = '0.1.0'
  s.summary          = 'A set of commonly useful extensions to built-in classes as well as some useful new classes.'

  s.description      = <<-DESC
HypeKit is not a framework.  HypeKit is a set of extensions to built-in classes
that make doing common tasks very easy.  This includes: making views have rounded corners,
creating data tasks from url requests, parsing JSON from Data, setting images on the left of
UITextEdit controls, and putting an icon on the right of a UIButton.

HypeKit also includes new classes that override base functionality to provide commonly-needed
features.  These features include: using placeholder text with a UITextView, using a single
ActivityIndicatorView that allows you to set the image and also reuse a single ActivityIndicatorView
across your entire application, even when multiple calls or ViewControllers trigger it at the same time,
StackedCollectionView (ala Pinterest) that allows dynamically sized elements to flow naturally
across one or more columns in one or more sections in a vertically scrolling UICollectionView, and
a CollectionViewLayout that will make a horizontally scrolling UICollectionView smoothly scroll the cells so that
the destination cell will snap to the center of the UICollectionView.

                       DESC

  s.homepage         = 'https://github.com/tchype/HypeKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tony Heupel' => 'tony@heupel.net' }
  s.source           = { :git => 'https://github.com/tchype/HypeKit.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/tc_hype'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HypeKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'HypeKit' => ['HypeKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit' #, 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
