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
    BOOL sortByPrice;
}

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    unselectedTextColor = [UIColor colorWithRed:0.573f green:0.580f blue:0.592f alpha:1.00f];
    
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
    sortByPrice = YES;
    NSLog(@"FINAL RESULTS:%@",self.resultsDictionary[@"cheapest"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if(sortByPrice == YES){
        return 6;
    }else{
        return 6;
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
            
            backgroundRight.layer.borderColor = [UIColor whiteColor].CGColor;
            backgroundRight.layer.borderWidth = 1.5;
            
            
            taxiName1.text = [self.resultsDictionary[@"cheapest"][@"type"] stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                      withString:[[self.resultsDictionary[@"cheapest"][@"type"] substringToIndex:1] capitalizedString]];
            
            taxiName2.text = [self.resultsDictionary[@"closest"][@"type"] stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                                                   withString:[[self.resultsDictionary[@"closest"][@"type"] substringToIndex:1] capitalizedString]];

            price1.text = [NSString stringWithFormat:@"£%.02f",[self.resultsDictionary[@"cheapest"][@"price"] floatValue]];
            price2.text = [NSString stringWithFormat:@"£%.02f",[self.resultsDictionary[@"closest"][@"price"] floatValue]];
            distance1.text = [NSString stringWithFormat:@"%d",[self.resultsDictionary[@"cheapest"][@"eta"] intValue]];
            distance2.text = [NSString stringWithFormat:@"%d",[self.resultsDictionary[@"closest"][@"eta"] intValue]];
            
            oneLetter1.text = [NSString stringWithFormat:@"%@",[self.resultsDictionary[@"cheapest"][@"type"] substringToIndex:1]];
            oneLetter2.text = [NSString stringWithFormat:@"%@",[self.resultsDictionary[@"closest"][@"type"] substringToIndex:1]];
            [oneLetter1 setText:[oneLetter1.text uppercaseString]];
            [oneLetter2 setText:[oneLetter2.text uppercaseString]];
            
            return cell;
        }else if(indexPath.row == 1){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EverythingHeader"];
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
                cell.companyName.text = self.resultsDictionary[@"others_price"][indexPath.row - 2][@"type"];
                NSString *timeString = [NSString stringWithFormat:@"%d",[self.resultsDictionary[@"others_price"][indexPath.row -2][@"eta"] intValue]];
                NSString *priceString = [NSString stringWithFormat:@"£%.02f",[self.resultsDictionary[@"others_price"][indexPath.row -2][@"price"] floatValue]];
                
                cell.priceAndTime.text = [NSString stringWithFormat:@"%@  |  %@ mins",priceString,timeString];
            }else{
                cell.companyName.text = self.resultsDictionary[@"others_time"][indexPath.row - 2][@"type"];
                NSString *timeString = [NSString stringWithFormat:@"%d",[self.resultsDictionary[@"others_time"][indexPath.row -2][@"eta"] intValue]];
                NSString *priceString = [NSString stringWithFormat:@"£%.02f",[self.resultsDictionary[@"others_time"][indexPath.row -2][@"price"] floatValue]];
                
                cell.priceAndTime.text = [NSString stringWithFormat:@"%@  |  %@ mins",priceString,timeString];
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

@end
