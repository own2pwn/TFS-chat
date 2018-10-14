//
//  Themes.m
//  TFS-chat
//
//  Created by Evgeniy on 14.10.18.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

#import "Themes.h"

@implementation Themes

@synthesize theme1 = _theme1;
@synthesize theme2 = _theme2;
@synthesize theme3 = _theme3;

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

- (UIColor *)theme1 {
    return _theme1;
}

- (void)setTheme1:(UIColor *)theme1 {
    if (_theme1 != theme1) {
        UIColor *oldValue = _theme1;
        _theme1 = [theme1 retain];

        [oldValue release];
    }
}

- (UIColor *)theme2 {
    return _theme2;
}

- (void)setTheme2:(UIColor *)theme2 {
    if (_theme2 != theme2) {
        UIColor *oldValue = _theme2;
        _theme2 = [theme2 retain];

        [oldValue release];
    }
}

- (UIColor *)theme3 {
    return _theme3;
}

- (void)setTheme3:(UIColor *)theme3 {
    if (_theme3 != theme3) {
        UIColor *oldValue = _theme3;
        _theme3 = [theme3 retain];

        [oldValue release];
    }
}

@end
