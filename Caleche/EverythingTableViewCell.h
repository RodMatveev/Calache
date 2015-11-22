//
//  EverythingTableViewCell.h
//  Caleche
//
//  Created by Rod Matveev on 21/11/2015.
//  Copyright © 2015 Rod Matveev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EverythingTableViewCell : UITableViewCell

@property(weak,nonatomic) IBOutlet UIView *background;
@property(weak,nonatomic) IBOutlet UIView *extendedBackground;
@property(weak,nonatomic) IBOutlet UIView *resultsView;
@property(weak,nonatomic) IBOutlet UIButton *bookButton;
@property(weak,nonatomic) IBOutlet UILabel *companyName;
@property(weak,nonatomic) IBOutlet UILabel *priceAndTime;
@property(weak,nonatomic) IBOutlet UILabel *oneLetter;
@property(weak,nonatomic) IBOutlet UIView *oneLetterBackground;


@end
