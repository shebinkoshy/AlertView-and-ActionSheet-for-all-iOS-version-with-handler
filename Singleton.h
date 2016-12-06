//
//  Singleton.h
//  TabBarTest
//
//  Created by Shebin Koshy on 11/18/16.
//  Copyright © 2016 Shebin Koshy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Singleton : NSObject

+(nonnull instancetype)sharedInstance;

-(void)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message arrayOfOtherButtonTitles:(nullable NSArray*)arrayButtonTitles cancelButtonTitle:(nullable NSString*)cancelButtonTitle presentInViewController:(nullable UIViewController*)viewController actionHandler:(void (^ __nullable)( NSString * _Nonnull  buttonTitle, NSInteger buttonIndex))actionHandler;/**NOTE : for cancel button 'buttonIndex' will be zero*/

-(void)showActionSheetWithTitle:(nullable NSString *)title arrayOfOtherButtonTitles:(nonnull NSArray*)arrayButtonTitles cancelButtonTitle:(nullable NSString*)cancelButtonTitle presentInViewController:(nonnull UIViewController*)viewController actionHandler:(void (^ __nullable)( NSString * _Nonnull  buttonTitle, NSInteger buttonIndex))actionHandler;/**NOTE : for cancel button 'buttonIndex' will be zero*/

@end
