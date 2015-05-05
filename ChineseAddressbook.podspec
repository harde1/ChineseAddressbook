#
#  Be sure to run `pod spec lint ChineseAddressbook.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ChineseAddressbook"
  s.version      = "0.0.1"
  s.summary      = "ChineseAddressbook"

  s.description  = 'ChineseAddressbook是一个中文拼音排序的通讯录'

  s.homepage     = "https://github.com/harde1/ChineseAddressbook"

  s.license      = "MIT (example)"

  s.author             = { "harde1" => "email@address.com" }
  # Or just: s.author    = "harde1"

  s.source       = { :git => "https://github.com/harde1/ChineseAddressbook.git", :commit => "ea0bcd87cfb95b8dc2b5fb0d66071596507db42f" }
  s.source_files  = "Addressbook"
  # s.exclude_files = "Classes/Exclude"

 
end
