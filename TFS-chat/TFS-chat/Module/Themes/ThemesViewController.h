//
//  ThemesViewController.h
//  TFS-chat
//
//  Created by Evgeniy on 14/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ThemesViewController;

@protocol ​ThemesViewControllerDelegate <NSObject>

- (void)themesViewController:(ThemesViewController *)controller didSelectTheme:(UIColor *)selectedTheme;

@end

@interface ThemesViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
