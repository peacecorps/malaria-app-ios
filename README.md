<h1>Malaria App Project</h1>

The malaria-app-readme repository is intended to be the central repo for discussions, decision making, and feedback about the project goals and features so that the user experience across platforms is uniform. Comments and coding for a specific platform can happen at the repositories linked to below.

<h3>Link to README Repo:</h3> https://github.com/PeaceCorps/malaria-app-readme


Please keep all discussion regarding features that will be cross-platform on that repository, and code-specific discussion on this one.

<h2>Application Description</h2>

Peace Corps is looking to build a mobile app that will aid the Volunteer in sustaining life-saving malaria prevention tactics over their 2+ years of service. Prevention is focused on sustained use of preventive medications, which are taken either daily or weekly, depending on the medicine. The application will feature a reminder system; an ability to indicate that medication was taken on time or missed; the ability for the volunteer to track their usage history; a trip indicator to help remind volunteers to pack certain supplies to prevent malaria if they leave their home village; and an Info Hub that will provide accurate information about Malaria and the medications they are taking. 

<h3>Contact Information:</h3>

Patrick Choquette - Director of the Office of Innovation
pchoquette@peacecorps.gov

Matthew McAllister - Special Assistant in the Office of Innovation
mmcallister@peacecorps.gov

<h2>Development</h2>

<h3>Install and run </h3>

1. Install CocoaPods (manage libraries and dependencias like RestKit):
> sudo gem install cocoapods

2. Setup cocoapods environment:
> pod setup

3. In same folder as Podfile:
> pod install

4. Open malaria-ios.xcworkspace


<h3>How to regenerate docs:</h3>

1. Install jazzy (https://github.com/Realm/jazzy):

> sudo gem install jazzy

2. Run:

> jazzy -c --skip-undocumented

<h3>How to handle dependencies:</h3>

Dependencies must, as possible, be managed using CocoaPods. And use swift as preference.

Existing dependencies taken from Podfile: 
```
pod 'Alamofire', '~> 1.2.3'
pod 'SwiftyJSON', '~> 2.2.0'
pod 'Charts', '~> 2.1.0'
pod 'CircleProgressView', :git => 'https://github.com/bphenriques/CircleProgressView.git', :tag => '0.9.10'
pod 'HorizontalProgressView', :git => 'https://github.com/bphenriques/HorizontalProgressView.git', :tag => '0.9.5'
pod 'PickerSwift', :git => 'https://github.com/bphenriques/PickerSwift.git', :tag => '0.9.0'
pod 'DoneToolBarSwift', :git => 'https://github.com/bphenriques/done-toolbar-swift.git', :tag => '0.9.3'
```
