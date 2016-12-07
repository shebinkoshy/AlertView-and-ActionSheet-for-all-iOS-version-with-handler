# AlertView and ActionSheet for iOS 6 to iOS 10 version with action handler


<title>AlertView and ActionSheet for iOS 6 to iOS 10 version with action handler</title>

<br>

 <B>Advantages</B>

 used only native controllers

 Single line code

 easy to use

<br>

 <B>Disadvantage</B>

 cannot be used for complicated purposes

 unable to use for alert view with textFields

<br>

 <B>How to integrate in your project?</B>
Add Singleton.h & Singleton.m in your project. 

for alert view use the following method for showing alert and if you need to get the action of an alert pass actionHandler.

``[[Singleton sharedInstance] showAlertWithTitle:@"alert title" message:@"alert message" arrayOfOtherButtonTitles:@[@"OK",@"1",@"2"] cancelButtonTitle:@"Cancel" presentInViewController:self actionHandler:^(NSString *buttonTitle, NSInteger buttonIndex/**For cancel, buttonIndex will be zero*/) {
        NSLog(@"button action %d %@",(int)buttonIndex,buttonTitle);
    }];``


for action sheet use the following method for showing alert and if you need to get the action of an alert pass actionHandler.

```[[Singleton sharedInstance] showActionSheetWithTitle:@"action title" arrayOfOtherButtonTitles:@[@"OK"] cancelButtonTitle:@"cancel" presentInViewController:self actionHandler:^(NSString * _Nonnull buttonTitle, NSInteger buttonIndex) {
      NSLog(@"button action %d %@",(int)buttonIndex,buttonTitle);
  }];```
