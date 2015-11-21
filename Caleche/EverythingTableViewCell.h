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

@end
