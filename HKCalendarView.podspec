Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '11.0'
s.name = "HKCalendarView"
s.summary = "Calendar control that represent single month view calendar"
s.requires_arc = true
s.version = "0.0.26"
s.license = 'MIT'
s.author = { "Kyryl" => "kirill.ge@gmail.com" }
s.homepage = "https://github.com/kirillgorbushko/CalendarView"
s.source = { :git => "https://github.com/kirillgorbushko/CalendarView.git",
                :tag => "#{s.version}" }
s.framework = "UIKit"
s.source_files = "Calendar/Source/**/*.{swift}"
s.resources = "Calendar/Source/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
s.swift_version = "5.1"

end
