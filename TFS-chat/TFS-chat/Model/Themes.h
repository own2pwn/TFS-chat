//
//  Themes.h
//  TFS-chat
//
//  Created by Evgeniy on 14.10.18.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Themes : NSObject

-(instancetype)initWithFirstColor:(UIColor* )firstColor
                   andSecondColor:(UIColor* )secondColor
                    andThirdColor:(UIColor* )thirdColor;

@property(retain, nonatomic) UIColor* theme1;
@property(retain, nonatomic) UIColor* theme2;
@property(retain, nonatomic) UIColor* theme3;

@end

NS_ASSUME_NONNULL_END
