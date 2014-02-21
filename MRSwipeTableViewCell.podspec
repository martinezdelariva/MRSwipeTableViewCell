
Pod::Spec.new do |s|

  s.name         = "MRSwipeTableViewCell"
  s.version      = "0.1"
  s.summary      = "A UITableViewCell that allow swipe left to reveal a background view with parallax effect."
  s.homepage     = "https://github.com/martinezdelariva/MRSwipeTableViewCell"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { "martinezdelariva" => "martinezdelariva@gmail.com"}

  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'

  s.source       = { :git => "https://github.com/martinezdelariva/MRSwipeTableViewCell.git", :tag => "0.1" }
  s.source_files  = 'MRSwipeCell/MRSwipeTableViewCell.{h,m}'

  s.requires_arc = true
end
