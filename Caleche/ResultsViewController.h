//
//  ResultsViewController.h
//  Caleche
//
//  Created by Rod Matveev on 21/11/2015.
//  Copyright © 2015 Rod Matveev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak,nonatomic) IBOutlet UITableView *resultsTable;

@end
