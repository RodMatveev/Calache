//
//  ResultsViewController.h
//  Caleche
//
//  Created by Rod Matveev on 21/11/2015.
//  Copyright © 2015 Rod Matveev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIColor *unselectedTextColor;
}

@property (retain, nonatomic) NSDictionary *resultsDictionary;
@property (weak,nonatomic) IBOutlet UITableView *resultsTable;
@property CLLocationCoordinate2D startCoordinate;
@property CLLocationCoordinate2D endCoordinate;
@property (weak, nonatomic) IBOutlet UILabel *startAddress;
@property (weak, nonatomic) IBOutlet UILabel *endAddress;

@end
