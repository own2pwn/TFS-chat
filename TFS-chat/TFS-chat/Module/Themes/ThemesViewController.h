//
//  ThemesViewController.h
//  TFS-chat
//
//  Created by Evgeniy on 14/10/2018.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "ThemesViewControllerDelegate.h"
#include "Themes.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThemesViewController : UIViewController
{
    IBOutletCollection(UIButton) NSArray *themeButtons;
}

@property (weak, nonatomic) id <​ThemesViewControllerDelegate> delegate;

@property (retain, nonatomic) Themes* model;

@end

NS_ASSUME_NONNULL_END
