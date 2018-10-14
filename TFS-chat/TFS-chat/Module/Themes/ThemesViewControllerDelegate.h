//
//  ThemesViewControllerDelegate.h
//  TFS-chat
//
//  Created by Evgeniy on 14.10.18.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

#ifndef ThemesViewControllerDelegate_h
#define ThemesViewControllerDelegate_h

#import <UIKit/UIKit.h>

@class ThemesViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol ​ThemesViewControllerDelegate <NSObject>

- (void)themesViewController:(ThemesViewController *)controller didSelectTheme:(UIColor *)selectedTheme;

@end

NS_ASSUME_NONNULL_END

#endif /* ThemesViewControllerDelegate_h */
