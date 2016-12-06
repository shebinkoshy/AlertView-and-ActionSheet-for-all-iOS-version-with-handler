//
//  Singleton.m
//  TabBarTest
//
//  Created by Shebin Koshy on 11/18/16.
//  Copyright © 2016 Shebin Koshy. All rights reserved.
//

#import "Singleton.h"


@interface Singleton ()<UIAlertViewDelegate,UIActionSheetDelegate>

@property(nonatomic,strong) NSMutableArray *arrayAlertActionHandlers, *arrayActionSheetActionHandlers;

@end

@implementation Singleton

+(instancetype)sharedInstance
{
    static Singleton *singletonObj;
    static dispatch_once_t token;
    _dispatch_once(&token, ^{
        singletonObj = [[Singleton alloc]init];
        singletonObj.arrayAlertActionHandlers = [[NSMutableArray alloc]init];
        singletonObj.arrayActionSheetActionHandlers = [[NSMutableArray alloc]init];
    });
    return singletonObj;
}

#pragma mark - Alert View

-(void)addAlertActionHandlerToArray:(id)alertActionHandler
{
    if (alertActionHandler)
    {
        [_arrayAlertActionHandlers addObject:alertActionHandler];
    }
    else
    {
        [_arrayAlertActionHandlers addObject:[NSNull null]];
    }
}

-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message arrayOfOtherButtonTitles:(NSArray*)arrayButtonTitles cancelButtonTitle:(NSString*)cancelButtonTitle presentInViewController:(UIViewController*)viewController actionHandler:(void (^)(NSString * buttonTitle, NSInteger buttonIndex))actionHandler
{
    if (arrayButtonTitles.count == 0 && !cancelButtonTitle)
    {
        /**
         no buttons
         */
        NSLog(@"ERROR: No Buttons");
        return;
    }
    
    if ((([title isKindOfClass:[NSString class]] && title.length > 0) || ([message isKindOfClass:[NSString class]] && message.length > 0)) == NO)
    {
        /**
         no title or message
         */
        NSLog(@"ERROR: No title or message");
        return;
    }

    if ([UIAlertController class])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        for (NSString *buttonTitles in arrayButtonTitles)
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self alertButtonActionsWithButtonIndex:[arrayButtonTitles indexOfObject:action.title]+1 withButtonTitle:action.title actionHandler:actionHandler];
            }];
            [alert addAction:action];
        }
        if (cancelButtonTitle)
        {
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self alertButtonActionsWithButtonIndex:0 withButtonTitle:action.title actionHandler:actionHandler];
            }];
            [alert addAction:actionCancel];
        }
        [viewController presentViewController:alert animated:YES completion:^{
            [self addAlertActionHandlerToArray:actionHandler];
        }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        for (NSString *stringButtonTitle in arrayButtonTitles)
        {
            [alert addButtonWithTitle:stringButtonTitle];
        }
        
        if (cancelButtonTitle)
        {
            alert.cancelButtonIndex = [alert addButtonWithTitle:cancelButtonTitle];
        }
        
        [alert show];
        [self addAlertActionHandlerToArray:actionHandler];
    }
}


-(void)alertButtonActionsWithButtonIndex:(NSInteger)buttonIndex withButtonTitle:(NSString*)buttonTitle actionHandler:(id)actionHandler
{
    
    if (actionHandler && [actionHandler isKindOfClass:[NSNull class]] == NO)
    {
        void (^blockName)(NSString * buttonTitle1, NSInteger buttonIndex1) = actionHandler;
        {
            blockName(buttonTitle,buttonIndex);
        };
    }
    [_arrayAlertActionHandlers removeLastObject];
}


#pragma mark - UIAlertView delegate (iOS 7.0)

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger buttonIndexToPass = buttonIndex;
    if (alertView.cancelButtonIndex == buttonIndex && alertView.cancelButtonIndex != 0)
    {
        /**
         cancel button
         */
        buttonIndexToPass = 0;
    }
    if (alertView.cancelButtonIndex != buttonIndex && alertView.cancelButtonIndex != 0)
    {
        /**
         other buttons
         */
        buttonIndexToPass++;
    }
    [self alertButtonActionsWithButtonIndex:buttonIndexToPass withButtonTitle:[alertView buttonTitleAtIndex:buttonIndex] actionHandler:[_arrayAlertActionHandlers lastObject]];
}


#pragma mark - Action sheet

-(void)addActionSheetActionHandlerToArray:(id)actionSheetActionHandler
{
    if (actionSheetActionHandler)
    {
        [_arrayActionSheetActionHandlers addObject:actionSheetActionHandler];
    }
    else
    {
        [_arrayActionSheetActionHandlers addObject:[NSNull null]];
    }
}

-(void)showActionSheetWithTitle:(NSString *)title arrayOfOtherButtonTitles:(NSArray*)arrayButtonTitles cancelButtonTitle:(NSString*)cancelButtonTitle presentInViewController:(UIViewController*)viewController actionHandler:(void (^)(NSString * buttonTitle, NSInteger buttonIndex))actionHandler;
{
    if (arrayButtonTitles.count == 0 && !cancelButtonTitle)
    {
        /**
         no buttons
         */
        NSLog(@"ERROR: No Buttons");
        return;
    }
    if ([UIAlertController class])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSString *buttonTitles in arrayButtonTitles)
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self actionButtonActionsWithButtonIndex:[arrayButtonTitles indexOfObject:action.title]+1 withButtonTitle:action.title actionHandler:actionHandler];
            }];
            [alertController addAction:action];
        }
        if (cancelButtonTitle)
        {
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self actionButtonActionsWithButtonIndex:0 withButtonTitle:action.title actionHandler:actionHandler];
            }];
            [alertController addAction:actionCancel];
        }
        [viewController presentViewController:alertController animated:YES completion:^{
            [self addActionSheetActionHandlerToArray:actionHandler];
        }];        
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        
        for (NSString *title in arrayButtonTitles)
        {
            [actionSheet addButtonWithTitle:title];
        }
        
        if (cancelButtonTitle)
        {
            actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:cancelButtonTitle];
        }
        
        
        [actionSheet showInView:viewController.view];
        [self addActionSheetActionHandlerToArray:actionHandler];
    }
}


-(void)actionButtonActionsWithButtonIndex:(NSInteger)buttonIndex withButtonTitle:(NSString*)buttonTitle actionHandler:(id)actionHandler
{
    if (actionHandler && [actionHandler isKindOfClass:[NSNull class]] == NO)
    {
        void (^blockName)(NSString * buttonTitle1, NSInteger buttonIndex1) = actionHandler;
        {
            blockName(buttonTitle,buttonIndex);
        };
    }
    [_arrayActionSheetActionHandlers removeLastObject];
}

#pragma mark - UIActionSheet delegate (iOS 7.0)

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger buttonIndexToPass = buttonIndex;
    if (actionSheet.cancelButtonIndex == buttonIndex && actionSheet.cancelButtonIndex != 0)
    {
        /**
         cancel button
         */
        buttonIndexToPass = 0;
    }
    if (actionSheet.cancelButtonIndex != buttonIndex && actionSheet.cancelButtonIndex != 0)
    {
        /**
         other buttons
         */
        buttonIndexToPass++;
    }
    [self actionButtonActionsWithButtonIndex:buttonIndexToPass withButtonTitle:[actionSheet buttonTitleAtIndex:buttonIndex] actionHandler:[_arrayActionSheetActionHandlers lastObject]];
}


@end
