//
//  ViewController.m
//  Caleche
//
//  Created by Adrian Kozhevnikov on 21/11/2015.
//  Copyright © 2015 Adrian Kozhevnikov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    end = YES;
    [self registerForKeyboardNotifications];
    self.tableView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    textSuggestions = [[NSArray alloc] init];
    
    [self.textField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    stopEditing = [UIButton buttonWithType:UIButtonTypeCustom];
    [stopEditing addTarget:self
               action:@selector(backButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.searchImageView.frame.size.width, self.searchImageView.frame.size.height)];
    imv.image = [[UIImage imageNamed:@"backArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imv.tintColor = [AppDelegate calecheDark];
    imv.backgroundColor = [UIColor whiteColor];
    stopEditing.frame = CGRectMake(self.searchImageView.frame.origin.x-10, self.searchImageView.frame.origin.y-10, self.searchImageView.frame.size.width+20, self.searchImageView.frame.size.height+20);
    stopEditing.alpha = 0;
    [stopEditing addSubview:imv];
    [self.textFieldView addSubview:stopEditing];
    
    self.mapView.delegate = self;
    self.textField.delegate = self;
    
    self.searchImageView.image = [self.searchImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.searchImageView setTintColor:[AppDelegate calecheDark]];
    
    self.pinImageView.image = [self.pinImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.pinImageView setTintColor:[AppDelegate calechePink]];
    
    unselectedColor = [UIColor colorWithRed:0.980f green:0.980f blue:0.980f alpha:1.00f];
    unselectedTextColor = [UIColor colorWithRed:0.573f green:0.580f blue:0.592f alpha:1.00f];
    
    [self.view bringSubviewToFront:self.goButton];
    
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
    
    self.endButton.backgroundColor = [AppDelegate calechePink];
    self.textFieldView.backgroundColor = [AppDelegate calechePink];
    [self.endButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startButton setTitleColor:unselectedTextColor forState:UIControlStateNormal];
    self.startButton.backgroundColor = unselectedColor;
    
    MKCoordinateRegion mapRegion;
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    mapRegion.center.latitude = appDelegate.locationManager.location.coordinate.latitude;
    mapRegion.center.longitude = appDelegate.locationManager.location.coordinate.longitude;
    //self.startCoordinate = self.mapView.centerCoordinate;
    NSLog(@"start:%f",self.startCoordinate.longitude);
    NSLog(@"center:%f",self.mapView.centerCoordinate.longitude);
    self.endCoordinate = self.mapView.centerCoordinate;
    mapRegion.span.latitudeDelta = 0.01;
    mapRegion.span.longitudeDelta = 0.01;
    [self.mapView setRegion:mapRegion animated: NO];
}

- (void)backButtonPressed:(id)sender
{
    [self.textField endEditing:YES];
    self.textField.text = @"";
}

#pragma mark AFNetworking

- (void)apiCall
{
    // 1
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat:self.startCoordinate.latitude], @"start_latitude",
                              [NSNumber numberWithFloat:self.startCoordinate.longitude], @"start_longitude",
                              [NSNumber numberWithFloat:self.endCoordinate.latitude], @"end_latitude", [NSNumber numberWithFloat:self.endCoordinate.longitude], @"end_longitude",
                              nil];
    
    NSString *baseURL = @"http://caleche.herokuapp.com/";
    NSString *path = @"web/v1/request";

    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
                                     
                                     
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:path parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"response:%@",responseObject);
        [self showResultsViewControllerWithDictionary:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"error:%@",error);

    }];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Unable to find your location" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [errorAlert addAction:defaultAction];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        NSLog(@"%@", [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
        NSLog(@"%@", [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goButtonPressed:(id)sender {
    [self apiCall];
    _goButtonBottom.constant = -80;
    _topLayout.constant = -110;
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    } completion:^ (BOOL finished)
     {
         scrollyLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 70, self.view.frame.size.width, 70) rate:50.0 andFadeLength:0];
         scrollyLabel.marqueeType = MLContinuous;
         NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Fuck public transport  Fuck public transport  Fuck public transport  Fuck public transport  Fuck public transport  Fuck public transport  Fuck public transport  Fuck public transport  Fuck public transport  Fuck public transport "];
         [text addAttribute: NSForegroundColorAttributeName value: [AppDelegate calechePink] range: NSMakeRange(0, 22)];
         [text addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:0.282f green:0.565f blue:0.886f alpha:1.00f] range: NSMakeRange(23, 45)];
         [text addAttribute: NSForegroundColorAttributeName value: [AppDelegate calecheDark] range: NSMakeRange(46, 68)];
         [text addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:0.325f green:1.000f blue:0.851f alpha:1.00f] range: NSMakeRange(69, 91)];
         [text addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:0.282f green:0.565f blue:0.886f alpha:1.00f] range: NSMakeRange(92, 114)];
         //[text addAttribute: NSForegroundColorAttributeName value: [UIColor grayColor] range: NSMakeRange(115, 137)];
         //[text addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: NSMakeRange(197, 220)];
         //[text addAttribute: NSForegroundColorAttributeName value: [UIColor blueColor] range: NSMakeRange(, 55)];
         [scrollyLabel setAttributedText: text];
         scrollyLabel.alpha = 0;
         scrollyLabel.font = [UIFont fontWithName:@"Futura" size:30];
         //scrollyLabel.textColor = [AppDelegate calecheDark];
         [self.view addSubview:scrollyLabel];
         halo = [PulsingHaloLayer layer];
         calecheLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width)];
         calecheLogo.center = self.mapView.center;
         calecheLogo.backgroundColor = [AppDelegate calecheDark];
         calecheLogo.layer.cornerRadius = 50;
         calecheLogo.layer.masksToBounds = YES;
         calecheLogo.image = [UIImage imageNamed:@"caleche logo"];
         calecheLogo.alpha = 0;
         [self.view addSubview:calecheLogo];
         [self startButtonPressed:self];
         whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
         whiteView.backgroundColor = [UIColor whiteColor];
         whiteView.alpha = 0;
         [self.view addSubview:whiteView];
         [UIView animateWithDuration:0.4 animations:^{
             scrollyLabel.alpha = 1;
             halo.position = self.mapView.center;
             [self.view.layer addSublayer:halo];
             [self.view bringSubviewToFront:calecheLogo];
             [self.view bringSubviewToFront:scrollyLabel];
             halo.haloLayerNumber = 5;
             halo.radius = 240.0;
             UIColor *color = [AppDelegate calecheDark];
             halo.backgroundColor = color.CGColor;
             calecheLogo.alpha = 1;
             calecheLogo.frame = CGRectMake(0, 0, 100, 100);
             calecheLogo.center = self.mapView.center;
             whiteView.alpha = 0.7;
         }];
     }];
}

- (void)showResultsViewControllerWithDictionary:(NSDictionary *)dic
{
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    ResultsViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ResultsViewController"];
    vc.startCoordinate = self.startCoordinate;
    vc.endCoordinate = self.endCoordinate;
    vc.resultsDictionary = dic;
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController pushViewController:vc animated:YES];
    whiteView.frame = CGRectNull;
    calecheLogo.frame = CGRectNull;
    scrollyLabel.frame = CGRectNull;
    halo.frame = CGRectNull;
    _goButtonBottom.constant = 30;
    _topLayout.constant = 0;
    [self.view setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];
    [self endButtonPressed:self];
    //[self.navigationController presentViewController:nav animated:YES completion:nil];
}



- (IBAction)startButtonPressed:(id)sender {
    [self.textField endEditing:YES];
    self.pinImageView.image = [self.pinImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.pinImageView setTintColor:[AppDelegate calecheDark]];
    self.textFieldView.backgroundColor = [AppDelegate calecheDark];
    if (self.startCoordinate.longitude == 0 && self.startCoordinate.latitude == 0)
    {
        self.startCoordinate = self.mapView.userLocation.coordinate;
    }
    self.startButton.backgroundColor = [AppDelegate calecheDark];
    self.endButton.backgroundColor = unselectedColor;
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.endButton setTitleColor:unselectedTextColor forState:UIControlStateNormal];
    end = NO;
    [self.mapView setCenterCoordinate:self.startCoordinate animated:YES];
    [self dropPinAtCoordinate:self.endCoordinate];
}

- (IBAction)endButtonPressed:(id)sender {
    [self.textField endEditing:YES];
    self.tableView.hidden = YES;
    self.pinImageView.image = [self.pinImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.pinImageView setTintColor:[AppDelegate calechePink]];
    self.textFieldView.backgroundColor = [AppDelegate calechePink];
    self.endButton.backgroundColor = [AppDelegate calechePink];
    self.startButton.backgroundColor = unselectedColor;
    [self.endButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startButton setTitleColor:unselectedTextColor forState:UIControlStateNormal];
    end = YES;
    [self.mapView setCenterCoordinate:self.endCoordinate animated:YES];
    [self dropPinAtCoordinate:self.startCoordinate];
}

- (void)dropPinAtCoordinate:(CLLocationCoordinate2D) coord
{
    [self.mapView removeOverlays:self.mapView.overlays];
    NSInteger toRemoveCount = self.mapView.annotations.count;
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:toRemoveCount];
    for (id annotation in self.mapView.annotations)
        if (annotation != self.mapView.userLocation)
            [toRemove addObject:annotation];
    [self.mapView removeAnnotations:toRemove];
    
    annot = [[AKPointAnnotation alloc] init];
    annot.coordinate = coord;
    annot.imageName = @"pin";
    [self.mapView addAnnotation:annot];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[AKPointAnnotation class]])
    {
        AKPointAnnotation *customAnnotation = annotation;
        
        static NSString *annotationIdentifier = @"MyAnnotation";
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!annotationView)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            annotationView.canShowCallout = NO;
            //annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        else
        {
            annotationView.annotation = annotation;
        }
        
        UIImage *image = [[UIImage imageNamed:customAnnotation.imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
        if (end == NO)
            [[AppDelegate calechePink] set];
        else
            [[AppDelegate calecheDark] set];
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        annotationView.image = image;
        annotationView.centerOffset = CGPointMake(0, -15);
        
        return annotationView;
    }
    
    return nil;
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    [self.mapView removeOverlays:self.mapView.overlays];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (end == YES){
        self.endCoordinate = self.mapView.centerCoordinate;
    } else {
        self.startCoordinate = self.mapView.centerCoordinate;
    }
    if (self.startCoordinate.longitude == 0 && self.startCoordinate.latitude == 0)
    {
        self.startCoordinate = self.mapView.userLocation.coordinate;
    }
    if (self.startCoordinate.longitude != 0 && self.startCoordinate.latitude != 0)
    {
        [self drawLine];
    }
    [self updateTextField];
}

-(MKOverlayRenderer*)mapView:(MKMapView*)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineRenderer* lineView = [[MKPolylineRenderer alloc] initWithPolyline:self.polyline];
    lineView.strokeColor = unselectedTextColor;
    lineView.lineWidth = 5;
    lineView.lineDashPattern = @[@5, @10];
    return lineView;
}

- (void)drawLine {
    
    NSLog(@"start:%f, end:%f",self.startCoordinate.longitude, self.endCoordinate.longitude);

    
    NSLog(@"start:%f",self.startCoordinate.longitude);
    NSLog(@"center:%f",self.mapView.userLocation.coordinate.longitude);
    
    CLLocationCoordinate2D coordinates[2];
    
    coordinates[0] = self.startCoordinate;
    coordinates[1] = self.endCoordinate;
    
    self.polyline = [MKPolyline polylineWithCoordinates:coordinates count:2];
    [self.mapView addOverlay:self.polyline];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.1 animations:^{
        stopEditing.alpha = 1;
    }];
}

-(void)textFieldDidChange:(UITextField *)textField
{
    MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] init];
    [searchRequest setNaturalLanguageQuery:textField.text];
    searchRequest.region = MKCoordinateRegionMakeWithDistance(self.mapView.centerCoordinate, 10000, 10000);
    
    // Create the local search to perform the search
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (!error) {
            textSuggestions = [response mapItems];
            if (textSuggestions.count>0){
                self.tableView.hidden = NO;
            } else {
                self.tableView.hidden = YES;
            }
            [self.tableView reloadData];
            for (MKMapItem *mapItem in [response mapItems]) {
                NSLog(@"Name: %@, Placemark title: %@", [mapItem name], [[mapItem placemark] title]);
            }
        } else {
            NSLog(@"Search Request Error: %@", [error localizedDescription]);
        }
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.1 animations:^{
        stopEditing.alpha = 0;
    }];
    self.tableView.hidden = YES;
}

- (void)updateTextField
{
    CLLocationCoordinate2D coord;
    if (end==YES){
        coord = self.endCoordinate;
    } else {
        coord = self.startCoordinate;
    }
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
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
        self.textField.text = string;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (textSuggestions.count > 0)
        return 1;
    else
        return 0;//count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return textSuggestions.count;    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier];
    }
    
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    MKMapItem *mapItem = textSuggestions[indexPath.row];
    NSLog(@"%@",mapItem);
    cell.textLabel.text = [NSString stringWithFormat:@"%@", mapItem.placemark];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0f];
    cell.textLabel.textColor = [AppDelegate calecheDark];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
    
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.tableView.hidden = YES;
    return YES;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)handleMapTap:(UITapGestureRecognizer *)sender
{
    [self.textField endEditing:YES];
    tap = nil;
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMapTap:)];
    tap.cancelsTouchesInView = YES;
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.mapView addGestureRecognizer:tap];
    //NSLog(@"received");
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    //NSLog(@"%f",kbSize.height);
    [self.view layoutIfNeeded];
    _bottomLayout.constant = kbSize.height;
    [UIView animateWithDuration:0.25
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
    /*[UIView beginAnimations:nil context:NULL];
     [UIView setAnimationDelegate:self];
     [UIView setAnimationDuration:0.5];
     [UIView setAnimationBeginsFromCurrentState:YES];
     _commentField.frame = CGRectMake(_commentField.frame.origin.x, (_commentField.frame.origin.y - kbSize.height), _commentField.frame.size.width, _commentField.frame.size.height);
     [UIView commitAnimations];*/
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self.view layoutIfNeeded];
    _bottomLayout.constant = 8;
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
    self.tableView.hidden = YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *string = textField.text;
    [self.textField endEditing:YES];
    [self findAddress:string];
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.textField endEditing:YES];
    MKMapItem *mapItem = textSuggestions[indexPath.row];
    [self goToCoordinate:mapItem.placemark.coordinate];
}

- (void)findAddress: (NSString *)address
{
    NSLog(@"findAddress called");
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    NSLog(@"address:%@",address);
    [geocoder geocodeAddressString:address
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         NSLog(@"%@",placemarks);
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         [self goToCoordinate:placemark.coordinate];
                        }
                 }
     ];
}

- (void)goToCoordinate:(CLLocationCoordinate2D)coordinate
{
    MKCoordinateRegion region = self.mapView.region;
    region.center = coordinate;
    if (end == YES){
        self.endCoordinate = region.center;
    } else {
        self.startCoordinate = region.center;
    }
    
    [self.mapView setRegion:region animated:YES];

}




@end
