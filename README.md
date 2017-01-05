# HypeKit

[![CI Status](http://img.shields.io/travis/Tony Heupel/HypeKit.svg?style=flat)](https://travis-ci.org/Tony Heupel/HypeKit)
[![Version](https://img.shields.io/cocoapods/v/HypeKit.svg?style=flat)](http://cocoapods.org/pods/HypeKit)
[![License](https://img.shields.io/cocoapods/l/HypeKit.svg?style=flat)](http://cocoapods.org/pods/HypeKit)
[![Platform](https://img.shields.io/cocoapods/p/HypeKit.svg?style=flat)](http://cocoapods.org/pods/HypeKit)

There are so many common tasks we as iOS developers need to do in every app -- 
rounded corners, views as circles, placeholder text in UITextViews,  
calculating distances between CGPoints, custom UIActivityViews, and creating
URLRequest-based Data Tasks that return JSON and then parsing that JSON Data
to name a few.  

HypeKit is simply a set of extensions to built-in classes as well as a few 
custom subclasses for making these common tasks simple without repetitive coding
or making common mistakes (e.g., forgetting to set clipsToBounds when rounding corners).

HypeKit is NOT a framework (in the more traditional "software framework" sense).
You do not have to change your existing class heirarchy and practices.  In most
cases, you can simply call HypeKit extension methods on exsting classes and
delete many lines of repetitive code from your codebase.


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

HypeKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "HypeKit"
```

## Author

Tony Heupel, tony@heupel.net

## License

HypeKit is available under the MIT license. See the LICENSE file for more info.
