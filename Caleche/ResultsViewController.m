//
//  ResultsViewController.m
//  Caleche
//
//  Created by Rod Matveev on 21/11/2015.
//  Copyright © 2015 Rod Matveev. All rights reserved.
//

#import "ResultsViewController.h"
#import "EverythingTableViewCell.h"
#import "AppDelegate.h"

@interface ResultsViewController (){
    int selectedService;
    float resultsViewHeight;
}

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    unselectedTextColor = [UIColor colorWithRed:0.573f green:0.580f blue:0.592f alpha:1.00f];
    
    self.navigationController.navigationBar.tintColor = unselectedTextColor;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"backArrow"];
    backBtnImage = [backBtnImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //backBtnImage = [AppDelegate calecheDark];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    // Do any additional setup after loading the view.
    self.resultsTable.delegate = self;
    self.resultsTable.dataSource = self;
    selectedService = 100;
    [self convertCoordinates];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Caleche";
    titleLabel.font = [UIFont fontWithName:@"PierSans-Bold" size:18];
    titleLabel.frame = CGRectMake(0, 0, 130, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = unselectedTextColor;
    [titleView addSubview:titleLabel];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"caleche logo"]];
    iv.frame = CGRectMake(0, 0, 30, 30);
    [titleView addSubview:iv];
    self.navigationItem.titleView = titleView;
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)convertCoordinates
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
        CLPlacemark *placemark = placemarks[0];
        NSLog(@"%@",placemark.name);
        NSString *string = [[NSString alloc] init];
        if (placemark.postalCode){
            string = [NSString stringWithFormat:@"%@, %@", placemark.name, placemark.postalCode];
        } else {
            string = placemark.name;
        }
        self.startAddress.text = string;
    }];
    location = [[CLLocation alloc] initWithLatitude:self.endCoordinate.latitude longitude:self.endCoordinate.longitude];
    geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
        CLPlacemark *placemark = placemarks[0];
        NSLog(@"%@",placemark.name);
        NSString *string = [[NSString alloc] init];
        if (placemark.postalCode){
            string = [NSString stringWithFormat:@"%@, %@", placemark.name, placemark.postalCode];
        } else {
            string = placemark.name;
        }
        self.endAddress.text = string;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedService == (int)indexPath.row){
        return 69 + (resultsViewHeight * 3) + 10;
    }else{
        if(indexPath.row == 0){
            return 304;
        }else if(indexPath.row == 1){
            return 30;
        }else{
            return 69;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.resultsTable){
        if(indexPath.row == 0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheapCloseCell"];
            //UIView *square = (UIView *)[cell.contentView viewWithTag:3];
            UIView *backgroundRight = (UIView *)[cell.contentView viewWithTag:2];
            backgroundRight.layer.borderColor = [UIColor whiteColor].CGColor;
            backgroundRight.layer.borderWidth = 1.5;
            
            return cell;
        }else if(indexPath.row == 1){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EverythingHeader"];
            return cell;
        }else{
            static NSString *EverythingCellIdentifier = @"EverythingCell";
            EverythingTableViewCell *cell = (EverythingTableViewCell *)[tableView dequeueReusableCellWithIdentifier: EverythingCellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EverythingTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            resultsViewHeight = cell.resultsView.frame.size.height;
            if(indexPath.row %2 == 0){
                cell.background.backgroundColor = [UIColor lightGrayColor];
                cell.extendedBackground.backgroundColor = [UIColor darkGrayColor];
            }else{
                cell.extendedBackground.backgroundColor = [UIColor darkGrayColor];
                cell.extendedBackground.backgroundColor = [UIColor lightGrayColor];
            }
            if(indexPath.row == 2){
                cell.extendedBackground.backgroundColor = [UIColor clearColor];
            }
            /*if((int)indexPath.row == selectedService){
                cell.background.frame = CGRectMake(cell.background.frame.origin.x, cell.background.frame.origin.y, cell.background.frame.size.width, cell.background.frame.size.height+100);
            }*/
            return cell;
        }
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row > 1){
        selectedService = (int)indexPath.row;
        [tableView beginUpdates];
        [tableView endUpdates];
    }
}

@end
