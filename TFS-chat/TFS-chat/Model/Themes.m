//
//  Themes.m
//  TFS-chat
//
//  Created by Evgeniy on 14.10.18.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

#import "Themes.h"

@implementation Themes

- (instancetype)initWithFirstColor:(UIColor *)firstColor
                    andSecondColor:(UIColor *)secondColor
                     andThirdColor:(UIColor *)thirdColor {
    self = [super init];
    if (self) {
        _theme1 = [firstColor retain];
        _theme2 = [secondColor retain];
        _theme3 = [thirdColor retain];
    }
    return self;
}

- (void)dealloc {
    [_theme1 release];
    [_theme2 release];
    [_theme3 release];

    [super dealloc];
}

@end
