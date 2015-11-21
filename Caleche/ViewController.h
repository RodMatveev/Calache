//
//  ViewController.h
//  Caleche
//
//  Created by Rod Matveev on 21/11/2015.
//  Copyright © 2015 Rod Matveev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "AKAdressSearchTextField.h"
#import "AKPointAnnotation.h"
#import "PulsingHaloLayer.h"
#import "MarqueeLabel.h"

@interface ViewController : UIViewController <UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
{
    UIImageView *calecheLogo;
    UIView *whiteView;
    AKPointAnnotation *annot;
    UIColor *unselectedColor;
    UIColor *unselectedTextColor;
    BOOL end;
    UIButton *stopEditing;
    NSArray *textSuggestions;
    UITapGestureRecognizer *tap;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goButtonBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *textFieldView;
@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) MKPolyline *polyline; //your line
@property (nonatomic, retain) MKPolylineView *lineView;
@property (weak, nonatomic) IBOutlet AKAdressSearchTextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property(nonatomic) CLLocationCoordinate2D endCoordinate;
@property(nonatomic) CLLocationCoordinate2D startCoordinate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet UIImageView *pinImageView;
- (IBAction)goButtonPressed:(id)sender;

- (IBAction)startButtonPressed:(id)sender;
- (IBAction)endButtonPressed:(id)sender;


@end

