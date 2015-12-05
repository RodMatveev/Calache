//
//  ResultsViewController.m
//  Caleche
//
//  Created by Rod Matveev on 21/11/2015.
//  Copyright © 2015 Caleche. All rights reserved.
//

#import "ResultsViewController.h"
#import "EverythingTableViewCell.h"
#import "AppDelegate.h"

@interface ResultsViewController (){
    int selectedService;
    float resultsViewHeight;
    BOOL sortByPrice;
}

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkPrices];
    [self createDatePicker];
    
    unselectedTextColor = [UIColor colorWithRed:0.573f green:0.580f blue:0.592f alpha:1.00f];
    
    [self setAddress];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    /*UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Caleche";
    titleLabel.font = [UIFont fontWithName:@"PierSans-Bold" size:18];
    titleLabel.frame = CGRectMake(0, 0, 130, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = unselectedTextColor;
    [titleView addSubview:titleLabel];*/
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"caleche logo"]];
    iv.frame = CGRectMake(0, 0, 30, 30);
    [titleView addSubview:iv];
    self.navigationItem.titleView = titleView;
    
    self.navigationController.navigationBar.tintColor = [AppDelegate calechePink];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"backArrow"];
    backBtnImage = [backBtnImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //backBtnImage = [AppDelegate calecheDark];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButton;
    timeButton = [[UIBarButtonItem alloc] initWithTitle:@"Now"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(openPicker:)];
    self.navigationItem.rightBarButtonItem = timeButton;
    // Do any additional setup after loading the view.
    self.resultsTable.delegate = self;
    self.resultsTable.dataSource = self;
    selectedService = 100;
    sortByPrice = YES;
    NSLog(@"FINAL RESULTS:%@",self.resultsDictionary[@"cheapest"]);
}

- (void)checkPrices
{
    if ([self.resultsDictionary[@"cheapest"][@"price"] integerValue] == 0){
        self.resultsDictionary[@"cheapest"] = self.resultsDictionary[@"others_price"][0];
    }
    if ([self.resultsDictionary[@"closest"][@"price"] integerValue] == 0){
        self.resultsDictionary[@"closest"] = self.resultsDictionary[@"others_time"][0];
    }
}

- (void)createDatePicker
{
    datePickerOpen = NO;
    datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/*self.view.frame.size.height *2/3-50*/, self.view.frame.size.width, self.view.frame.size.height *1/3 + 50)];
    datePickerView.backgroundColor = [UIColor whiteColor];
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height *1/3)];
    datePicker.backgroundColor = [UIColor clearColor];
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel addTarget:self
            action:@selector(openPicker:)
  forControlEvents:UIControlEventTouchUpInside];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel setTitleColor:[AppDelegate calechePink] forState:UIControlStateNormal];
    cancel.tintColor = [AppDelegate calechePink];
    cancel.frame = CGRectMake(0, 0, self.view.bounds.size.width/2, 50);
    [datePickerView addSubview:cancel];
    UIButton *set = [UIButton buttonWithType:UIButtonTypeCustom];
    [set addTarget:self
               action:@selector(setTime:)
     forControlEvents:UIControlEventTouchUpInside];
    [set setTitle:@"Set" forState:UIControlStateNormal];
    [set setTitleColor:[AppDelegate calechePink] forState:UIControlStateNormal];
    set.tintColor = [AppDelegate calechePink];
    set.frame = CGRectMake(self.view.bounds.size.width/2, 0, self.view.bounds.size.width/2, 50);
    [datePickerView addSubview:set];
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [datePickerView addSubview:datePicker];
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 3)];
    topBar.backgroundColor = [UIColor colorWithRed:0.757f green:0.757f blue:0.757f alpha:1.00f];
    [datePickerView addSubview:topBar];
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, 47, self.view.bounds.size.width, 3)];
    bottomBar.backgroundColor = [UIColor colorWithRed:0.757f green:0.757f blue:0.757f alpha:1.00f];
    [datePickerView addSubview:bottomBar];
    [self.view addSubview:datePickerView];
}

- (void)setTime:(id)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm, EE"];
    timeButton.title = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:datePicker.date]];
    [self openPicker:self];
    
}

- (void)openPicker:(id)sender
{
    if (datePickerOpen == NO){
        datePickerOpen = YES;
        [UIView animateWithDuration:0.3
                         animations:^{
                             datePickerView.frame = CGRectMake(0, self.view.frame.size.height *2/3 - 20, self.view.frame.size.width, self.view.frame.size.height *1/3 + 30);
                         }];
    } else {
        datePickerOpen = NO;
        [UIView animateWithDuration:0.3
                         animations:^{
                             datePickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height *1/3 + 30);
                         }];
    }

}

- (void)setAddress
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
        CLPlacemark *placemark = placemarks[0];
        NSLog(@"%@",placemark.name);
        NSString *string = [[NSString alloc] init];
        if (placemark.postalCode){
            string = [NSString stringWithFormat:@"%@", placemark.name];
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
            string = [NSString stringWithFormat:@"%@", placemark.name];
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
    if(sortByPrice == YES){
        return [self.resultsDictionary[@"others_price"] count] + 2;
    }else{
        return [self.resultsDictionary[@"others_time"] count] + 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedService == (int)indexPath.row){
        return 69 + (resultsViewHeight) + 20;
    }else{
        if(indexPath.row == 0){
            return 304;
        }else if(indexPath.row == 1){
            return 65;
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
            UILabel *taxiName1 = (UILabel*)[cell.contentView viewWithTag:8];
            UILabel *taxiName2 = (UILabel*)[cell.contentView viewWithTag:10];
            UILabel *price1 = (UILabel*)[cell.contentView viewWithTag:4];
            UILabel *price2 = (UILabel*)[cell.contentView viewWithTag:6];
            UILabel *distance1 = (UILabel*)[cell.contentView viewWithTag:5];
            UILabel *distance2 = (UILabel*)[cell.contentView viewWithTag:7];
            UILabel *oneLetter1 = (UILabel*)[cell.contentView viewWithTag:9];
            UILabel *oneLetter2 = (UILabel*)[cell.contentView viewWithTag:11];
            UIView *oneLetter1Background = (UIView *)[cell.contentView viewWithTag:20];
            UIView *oneLetter2Background = (UIView *)[cell.contentView viewWithTag:21];
            
            backgroundRight.layer.borderColor = [UIColor whiteColor].CGColor;
            backgroundRight.layer.borderWidth = 1.5;
            
            if([self.resultsDictionary[@"cheapest"][@"type"] containsString:@"uber"]){
                taxiName1.text = [NSString stringWithFormat:@"%@ (%@)",self.resultsDictionary[@"cheapest"][@"type"],self.resultsDictionary[@"cheapest"][@"display_name"]];
            } else {
                taxiName1.text = self.resultsDictionary[@"cheapest"][@"type"];
            }
            if([self.resultsDictionary[@"closest"][@"type"] containsString:@"uber"]){
                taxiName2.text = [NSString stringWithFormat:@"%@ (%@)",self.resultsDictionary[@"closest"][@"type"],self.resultsDictionary[@"closest"][@"display_name"]];
            } else {
                taxiName2.text = self.resultsDictionary[@"closest"][@"type"];
            }
            taxiName1.text = [taxiName1.text stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                      withString:[[taxiName1.text substringToIndex:1] capitalizedString]];
            
            taxiName2.text = [taxiName2.text stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                                                   withString:[[taxiName2.text substringToIndex:1] capitalizedString]];

            price1.text = [NSString stringWithFormat:@"£%.02f",[self.resultsDictionary[@"cheapest"][@"price"] floatValue]];
            price2.text = [NSString stringWithFormat:@"£%.02f",[self.resultsDictionary[@"closest"][@"price"] floatValue]];
            distance1.text = [NSString stringWithFormat:@"%d",[self.resultsDictionary[@"cheapest"][@"eta"] intValue]];
            distance2.text = [NSString stringWithFormat:@"%d",[self.resultsDictionary[@"closest"][@"eta"] intValue]];
            
            oneLetter1.text = [NSString stringWithFormat:@"%@",[self.resultsDictionary[@"cheapest"][@"type"] substringToIndex:1]];
            oneLetter2.text = [NSString stringWithFormat:@"%@",[self.resultsDictionary[@"closest"][@"type"] substringToIndex:1]];
            [oneLetter1 setText:[oneLetter1.text uppercaseString]];
            [oneLetter2 setText:[oneLetter2.text uppercaseString]];
            
            if([self.resultsDictionary[@"cheapest"][@"type"] containsString:@"uber"]){
                oneLetter1Background.backgroundColor = [UIColor colorWithRed:0.000f green:0.678f blue:0.769f alpha:1.00f];
            }else if([self.resultsDictionary[@"cheapest"][@"type"] containsString:@"hailo"]){
                oneLetter1Background.backgroundColor = [UIColor colorWithRed:1.000f green:0.729f blue:0.239f alpha:1.00f];
            }else{
                oneLetter1Background.backgroundColor = [UIColor colorWithRed:0.000f green:0.627f blue:0.863f alpha:1.00f];
            }
            if([self.resultsDictionary[@"closest"][@"type"] containsString:@"uber"]){
                oneLetter2Background.backgroundColor = [UIColor colorWithRed:0.000f green:0.678f blue:0.769f alpha:1.00f];
            }else if([self.resultsDictionary[@"closest"][@"type"] containsString:@"hailo"]){
                oneLetter2Background.backgroundColor = [UIColor colorWithRed:1.000f green:0.729f blue:0.239f alpha:1.00f];
            }else{
                oneLetter2Background.backgroundColor = [UIColor colorWithRed:0.000f green:0.627f blue:0.863f alpha:1.00f];
            }
            
            return cell;
        }else if(indexPath.row == 1){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EverythingHeader"];
            UISegmentedControl *cntrl = (UISegmentedControl*)[cell viewWithTag:2];
            if(sortByPrice == YES){
                cntrl.selectedSegmentIndex = 0;
            }else{
                cntrl.selectedSegmentIndex = 1;
            }
            return cell;
        }else{
            static NSString *EverythingCellIdentifier = @"EverythingCell";
            EverythingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: EverythingCellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EverythingTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            resultsViewHeight = cell.bookButton.frame.size.height;
            if(sortByPrice == YES){
                cell.companyName.text = [self.resultsDictionary[@"others_price"][indexPath.row - 2][@"type"] stringByReplacingCharactersInRange:NSMakeRange(0,1)
            withString:[[self.resultsDictionary[@"others_price"][indexPath.row - 2][@"type"] substringToIndex:1] capitalizedString]];
                
                NSString *timeString = [NSString stringWithFormat:@"%d",[self.resultsDictionary[@"others_price"][indexPath.row -2][@"eta"] intValue]];
                NSString *priceString = [NSString stringWithFormat:@"£%.02f",[self.resultsDictionary[@"others_price"][indexPath.row -2][@"price"] floatValue]];
                
                cell.priceAndTime.text = [NSString stringWithFormat:@"%@   |   %@ mins",priceString,timeString];
                cell.oneLetter.text = [NSString stringWithFormat:@"%@",[self.resultsDictionary[@"others_price"][indexPath.row - 2][@"type"] substringToIndex:1]];
                [cell.oneLetter setText:[cell.oneLetter.text uppercaseString]];
                if([self.resultsDictionary[@"others_price"][indexPath.row - 2][@"type"] containsString:@"uber"]){
                    cell.oneLetterBackground.backgroundColor = [UIColor colorWithRed:0.000f green:0.678f blue:0.769f alpha:1.00f];
                    cell.companyName.text = [NSString stringWithFormat:@"%@ (%@)",cell.companyName.text,self.resultsDictionary[@"others_price"][indexPath.row - 2][@"display_name"]];
                    cell.oneLetter.textColor = [UIColor whiteColor];
                }else if([self.resultsDictionary[@"others_price"][indexPath.row - 2][@"type"] containsString:@"hailo"]){
                    cell.oneLetterBackground.backgroundColor = [UIColor colorWithRed:1.000f green:0.729f blue:0.239f alpha:1.00f];
                    cell.oneLetter.textColor = [UIColor whiteColor];
                }else{
                    cell.oneLetterBackground.backgroundColor = [UIColor whiteColor];
                    cell.oneLetter.textColor = [UIColor colorWithRed:0.000f green:0.627f blue:0.863f alpha:1.00f];
                    cell.companyName.text = self.resultsDictionary[@"others_price"][indexPath.row - 2][@"company_name"];
                }
                

            }else{
                cell.companyName.text = [self.resultsDictionary[@"others_time"][indexPath.row - 2][@"type"] stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.resultsDictionary[@"others_time"][indexPath.row - 2][@"type"] substringToIndex:1] capitalizedString]];
                NSString *timeString = [NSString stringWithFormat:@"%d",[self.resultsDictionary[@"others_time"][indexPath.row -2][@"eta"] intValue]];
                NSString *priceString = [NSString stringWithFormat:@"£%.02f",[self.resultsDictionary[@"others_time"][indexPath.row -2][@"price"] floatValue]];
                
                cell.priceAndTime.text = [NSString stringWithFormat:@"%@   |   %@ mins",priceString,timeString];
                cell.oneLetter.text = [NSString stringWithFormat:@"%@",[self.resultsDictionary[@"others_time"][indexPath.row - 2][@"type"] substringToIndex:1]];
                [cell.oneLetter setText:[cell.oneLetter.text uppercaseString]];
                if([self.resultsDictionary[@"others_time"][indexPath.row - 2][@"type"] containsString:@"uber"]){
                    cell.oneLetterBackground.backgroundColor = [UIColor colorWithRed:0.000f green:0.678f blue:0.769f alpha:1.00f];
                    cell.companyName.text = [NSString stringWithFormat:@"%@ (%@)",cell.companyName.text,self.resultsDictionary[@"others_time"][indexPath.row - 2][@"display_name"]];
                    cell.oneLetter.textColor = [UIColor whiteColor];
                }else if([self.resultsDictionary[@"others_time"][indexPath.row - 2][@"type"] containsString:@"hailo"]){
                    cell.oneLetterBackground.backgroundColor = [UIColor colorWithRed:1.000f green:0.729f blue:0.239f alpha:1.00f];
                    cell.oneLetter.textColor = [UIColor whiteColor];
                }else{
                    cell.oneLetterBackground.backgroundColor = [UIColor whiteColor];
                    cell.oneLetter.textColor = [UIColor colorWithRed:0.000f green:0.627f blue:0.863f alpha:1.00f];
                    cell.companyName.text = self.resultsDictionary[@"others_time"][indexPath.row - 2][@"company_name"];
                }
            }
            if(indexPath.row %2 == 0){
                cell.background.backgroundColor = [UIColor lightGrayColor];
                cell.extendedBackground.backgroundColor = [UIColor colorWithRed:0.200f green:0.200f blue:0.200f alpha:1.00f];
            }else{
                cell.background.backgroundColor = [UIColor colorWithRed:0.200f green:0.200f blue:0.200f alpha:1.00f];
                cell.extendedBackground.backgroundColor = [UIColor lightGrayColor];
            }
            if(indexPath.row == 2){
                cell.extendedBackground.backgroundColor = [UIColor clearColor];
            }
            UIButton *button = (UIButton *)[cell.background viewWithTag:69];
            [button addTarget:self action:@selector(tableViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            /*if(sortByPrice == YES){
                cell.companyName.text = self.resultsDictionary[@"others_price"][indexPath.row - 2][@"display_name"];
                NSString *timeString = [NSString stringWithFormat:@"%d",[self.resultsDictionary[@"others_price"][indexPath.row -2][@"eta"] intValue]];
                NSString *priceString = [NSString stringWithFormat:@"£%.02f",[self.resultsDictionary[@"others_price"][indexPath.row -2][@"price"] floatValue]];

                cell.priceAndTime.text = [NSString stringWithFormat:@"%@  |  %@ mins",priceString,timeString];
            }else{
                cell.companyName.text = self.resultsDictionary[@"others_time"][indexPath.row - 2][@"display_name"];
                NSString *timeString = [NSString stringWithFormat:@"%d",[self.resultsDictionary[@"others_time"][indexPath.row -2][@"eta"] intValue]];
                NSString *priceString = [NSString stringWithFormat:@"£%.02f",[self.resultsDictionary[@"others_time"][indexPath.row -2][@"price"] floatValue]];
                
                cell.priceAndTime.text = [NSString stringWithFormat:@"%@  |  %@ mins",priceString,timeString];
            }*/
            //cell.companyName.text = @"1";
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

-(IBAction)segmentSwitch:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    if(selectedSegment == 0){
        sortByPrice = YES;
        [self.resultsTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        sortByPrice = NO;
        [self.resultsTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)deeplinkLeft:(id)sender{
    NSString *str = [self.endAddress.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    if([self.resultsDictionary[@"cheapest"][@"type"] isEqualToString:@"uber"]){
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uber://"]]){
            UIApplication *ourApplication = [UIApplication sharedApplication];
            NSString *urlStr = [NSString stringWithFormat:@"uber://?HS9A_R1GUu0j1vKEDgX8GCv8o5A90Pe9&action=setPickup&pickup[latitude]=%f&pickup[longitude]=%f&dropoff[latitude]=%f&dropff[longitude]=%f&product_id=%@",self.startCoordinate.latitude,self.startCoordinate.longitude,self.endCoordinate.latitude,self.endCoordinate.longitude,self.resultsDictionary[@"cheapest"][@"product_id"]];
            NSURL *ourURL = [NSURL URLWithString:urlStr];
            [ourApplication openURL:ourURL];
            
            
        }else{
            //NSString *urlStr = @"m.uber.com";
        }
    }else if([self.resultsDictionary[@"cheapest"][@"type"] isEqualToString:@"hailo"]){
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"hailoapp://"]]){
            UIApplication *ourApplication = [UIApplication sharedApplication];
            NSString *urlStr = [NSString stringWithFormat:@"hailoapp://confirm?pickupCoordinate=%f,%f&destinationCoordinate=%f,%f&destinationAddress=%@&referrer=iJgAldWT75/xfN7UrhupbKU+DN7foAU3I6uyMiGxJ1PLcWCpWbHyjP7E2ybH+BMmYo4Gh9i7ABbi7ZnYL8Dxf4NUiRaHwl0YKwp97+bR1ZFmmH1Rovc5vJzSD4ASfonh2KMFsv6ERZUwHcOBbUCQDjPjvoOiNyg/k9v+Ab8N2q4LUEY9fQwu3N1djz/LFGxamw+zoK6xMlYHyOVkKob93A",self.startCoordinate.latitude,self.startCoordinate.longitude,self.endCoordinate.latitude,self.endCoordinate.longitude, str];
            NSURL *ourURL = [NSURL URLWithString:urlStr];
            [ourApplication openURL:ourURL];
        }else{
            //NSString *urlStr = @"m.uber.com";
        }

    }else{
        NSLog(@"not uber or hailo");
    }
}

-(IBAction)deeplinkRight:(id)sender{
    NSString *str = [self.endAddress.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    if([self.resultsDictionary[@"closest"][@"type"] isEqualToString:@"uber"]){
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uber://"]]){
            UIApplication *ourApplication = [UIApplication sharedApplication];
            NSString *urlStr = [NSString stringWithFormat:@"uber://?HS9A_R1GUu0j1vKEDgX8GCv8o5A90Pe9&action=setPickup&pickup[latitude]=%f&pickup[longitude]=%f&dropoff[latitude]=%f&dropff[longitude]=%f&product_id=%@",self.startCoordinate.latitude,self.startCoordinate.longitude,self.endCoordinate.latitude,self.endCoordinate.longitude,self.resultsDictionary[@"closest"][@"product_id"]];
            NSURL *ourURL = [NSURL URLWithString:urlStr];
            [ourApplication openURL:ourURL];
            
            
        }else{
            //NSString *urlStr = @"m.uber.com";
        }
    }else if([self.resultsDictionary[@"closest"][@"type"] isEqualToString:@"hailo"]){
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"hailoapp://"]]){
            UIApplication *ourApplication = [UIApplication sharedApplication];
            NSString *urlStr = [NSString stringWithFormat:@"hailoapp://confirm?pickupCoordinate=%f,%f&destinationCoordinate=%f,%f&destinationAddress=%@&referrer=iJgAldWT75/xfN7UrhupbKU+DN7foAU3I6uyMiGxJ1PLcWCpWbHyjP7E2ybH+BMmYo4Gh9i7ABbi7ZnYL8Dxf4NUiRaHwl0YKwp97+bR1ZFmmH1Rovc5vJzSD4ASfonh2KMFsv6ERZUwHcOBbUCQDjPjvoOiNyg/k9v+Ab8N2q4LUEY9fQwu3N1djz/LFGxamw+zoK6xMlYHyOVkKob93A",self.startCoordinate.latitude,self.startCoordinate.longitude,self.endCoordinate.latitude,self.endCoordinate.longitude, str];
            NSURL *ourURL = [NSURL URLWithString:urlStr];
            [ourApplication openURL:ourURL];
        }else{
            //NSString *urlStr = @"m.uber.com";
        }
        
    }else{
        NSLog(@"not uber or hailo");
    }
}

-(void)tableViewButtonPressed:(UIButton*)sender{
    NSString *str = [self.endAddress.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    UITableViewCell *cell = (UITableViewCell *)[[[sender superview] superview]superview];
    NSIndexPath *path = [self.resultsTable indexPathForCell:cell];
    NSString *priceOrTime;
    if(sortByPrice == YES){
        priceOrTime = [NSString stringWithFormat:@"others_price"];
    }else{
        priceOrTime = [NSString stringWithFormat:@"others_time"];
    }
    NSLog(@"%@",self.resultsDictionary[priceOrTime][path.row - 2][@"type"]);
    if([self.resultsDictionary[priceOrTime][path.row-2][@"type"] containsString:@"uber"] || [self.resultsDictionary[priceOrTime][path.row - 2][@"type"] isEqualToString:@"Uber"]){
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uber://"]]){
            UIApplication *ourApplication = [UIApplication sharedApplication];
            NSString *urlStr = [NSString stringWithFormat:@"uber://?HS9A_R1GUu0j1vKEDgX8GCv8o5A90Pe9&action=setPickup&pickup[latitude]=%f&pickup[longitude]=%f&dropoff[latitude]=%f&dropff[longitude]=%f&product_id=%@",self.startCoordinate.latitude,self.startCoordinate.longitude,self.endCoordinate.latitude,self.endCoordinate.longitude,self.resultsDictionary[priceOrTime][path.row - 2][@"product_id"]];
            NSURL *ourURL = [NSURL URLWithString:urlStr];
            [ourApplication openURL:ourURL];
            
            
        }else{
            //NSString *urlStr = @"m.uber.com";
        }
    }else if([self.resultsDictionary[priceOrTime][path.row - 2][@"type"] containsString:@"hailo"] || [self.resultsDictionary[priceOrTime][path.row - 2][@"type"] isEqualToString:@"Hailo"]){
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"hailoapp://"]]){
            UIApplication *ourApplication = [UIApplication sharedApplication];
            NSString *urlStr = [NSString stringWithFormat:@"hailoapp://confirm?pickupCoordinate=%f,%f&destinationCoordinate=%f,%f&destinationAddress=%@&referrer=iJgAldWT75/xfN7UrhupbKU+DN7foAU3I6uyMiGxJ1PLcWCpWbHyjP7E2ybH+BMmYo4Gh9i7ABbi7ZnYL8Dxf4NUiRaHwl0YKwp97+bR1ZFmmH1Rovc5vJzSD4ASfonh2KMFsv6ERZUwHcOBbUCQDjPjvoOiNyg/k9v+Ab8N2q4LUEY9fQwu3N1djz/LFGxamw+zoK6xMlYHyOVkKob93A",self.startCoordinate.latitude,self.startCoordinate.longitude,self.endCoordinate.latitude,self.endCoordinate.longitude, str];
            NSURL *ourURL = [NSURL URLWithString:urlStr];
            [ourApplication openURL:ourURL];
        }else{
            //NSString *urlStr = @"m.uber.com";
        }
        
    }else{
        NSLog(@"not uber or hailo");
    }

}
    
- (IBAction)startAddressButtonPressed:(id)sender {
}
- (IBAction)endAddressButtonPressed:(id)sender {
}
@end
