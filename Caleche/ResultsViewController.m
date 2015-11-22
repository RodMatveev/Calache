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
            resultsViewHeight = cell.bookButton.frame.size.height;
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

-(IBAction)segmentSwitch:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    if(selectedSegment == 0){
        sortByPrice = YES;
    }else{
        sortByPrice = NO;
    }
}

-(void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
