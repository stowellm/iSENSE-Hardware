//
//  AutomaticViewController.m
//  iOS Data Collector
//
//  Created by Jeremy Poulin on 1/10/13.
//  Copyright 2013 iSENSE Development Team. All rights reserved.
//  Engaging Computing Lab, Advisor: Fred Martin
//

#import "AutomaticViewController.h"

@implementation AutomaticViewController

@synthesize isRecording, motionManager, dataToBeJSONed, expNum, timer, recordDataTimer, elapsedTime, locationManager, dfm, qrResults, sessionTitle, sessionTitleLabel, recommendedSampleInterval, geoCoder, city, address, country, dataSaver, managedObjectContext, isenseAPI, longClickRecognizer;

// displays the correct xib based on orientation and device type - called automatically upon view controller entry
-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            [[NSBundle mainBundle] loadNibNamed:@"Automatic-landscape~ipad"
                                          owner:self
                                        options:nil];
            [self viewDidLoad];
        } else {
            [[NSBundle mainBundle] loadNibNamed:@"Automatic~ipad"
                                          owner:self
                                        options:nil];
            [self viewDidLoad];
        }
    } else {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            [[NSBundle mainBundle] loadNibNamed:@"Automatic-landscape~iphone"
                                          owner:self
                                        options:nil];
            [self viewDidLoad];
        } else {
            [[NSBundle mainBundle] loadNibNamed:@"Automatic~iphone"
                                          owner:self
                                        options:nil];
            [self viewDidLoad];
        }
    }
}


// Long Click Responder
//- (IBAction)onStartStopLongClick:(UILongPressGestureRecognizer*)longClickRecognizer {
//
//    // Handle long press.
//    if (longClickRecognizer.state == UIGestureRecognizerStateBegan) {
//
//        // Make button unclickable until it gets released
//        longClickRecognizer.enabled = NO;
//
//        // Start Recording
//        if (![self isRecording]) {
//
//            // Check for a chosen experiment
//            if (!expNum) {
//                [self.view makeToast:@"No experiment chosen" duration:TOAST_LENGTH_SHORT position:TOAST_BOTTOM image:TOAST_RED_X];
//                return;
//            }
//
//            // Check for login
//            if (![isenseAPI isLoggedIn]) {
//                [self.view makeToast:@"Not logged in" duration:TOAST_LENGTH_SHORT position:TOAST_BOTTOM image:TOAST_RED_X];
//                return;
//            }
//
//            // Check for a session title
//            if ([[sessionTitle text] length] == 0) {
//                [self.view makeToast:@"Enter a session title first" duration:TOAST_LENGTH_SHORT position:TOAST_BOTTOM image:TOAST_RED_X];
//                return;
//            }
//
//            // Switch to green mode
//            startStopButton.image = [UIImage imageNamed:@"green_button.png"];
//            mainLogo.image = [UIImage imageNamed:@"logo_green.png"];
//            startStopLabel.text = [StringGrabber grabString:@"stop_button_text"];
//            [containerForMainButton updateImage:startStopButton];
//
//            // Get Field Order
//            [dfm getFieldOrderOfExperiment:expNum];
//            NSLog(@"%@", [dfm order]);
//
//            // Record Data
//            [self setIsRecording:TRUE];
//            [self recordData];
//
//            // Update elapsed time
//            elapsedTime = 0;
//            [self updateElapsedTime];
//            NSLog(@"updated Time");
//            timer = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateElapsedTime) userInfo:nil repeats:YES] retain];
//            NSLog(@"timer was launched");
//
//        // Stop Recording
//        } else {
//            // Stop Timers
//            [timer invalidate];
//            [timer release];
//            [recordDataTimer invalidate];
//            [recordDataTimer release];
//
//            // Back to red mode
//            startStopButton.image = [UIImage imageNamed:@"red_button.png"];
//            mainLogo.image = [UIImage imageNamed:@"logo_red.png"];
//            startStopLabel.text = [StringGrabber grabString:@"start_button_text"];
//            [containerForMainButton updateImage:startStopButton];
//
//            [self stopRecording:motionManager];
//            [self setIsRecording:FALSE];
//
//            // Open up description dialog
//            UIAlertView *message = [[UIAlertView alloc] initWithTitle:[StringGrabber grabString:@"description_or_delete"]
//                                                              message:nil
//                                                             delegate:self
//                                                    cancelButtonTitle:@"Delete"
//                                                    otherButtonTitles:@"Upload", nil];
//
//            message.tag = DESCRIPTION_AUTOMATIC;
//            message.delegate = self;
//            [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
//            [message textFieldAtIndex:0].keyboardType = UIKeyboardTypeDefault;
//            [message show];
//            [message release];
//
//        }
//
//        // Make the beep sound
//        NSString *path = [NSString stringWithFormat:@"%@%@",
//                          [[NSBundle mainBundle] resourcePath],
//                          @"/button-37.wav"];
//        SystemSoundID soundID;
//        NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
//        AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
//        AudioServicesPlaySystemSound(soundID);
//
//    }
//
//}

//- (bool) uploadData:(NSMutableArray *)results withDescription:(NSString *)description {
//
//    // Check login status
//    if (![isenseAPI isLoggedIn]) {
//        [self.view makeToast:@"Not logged in" duration:TOAST_LENGTH_SHORT position:TOAST_BOTTOM image:TOAST_RED_X];
//        return false;
//    }
//
//    // Create a session on iSENSE/dev.
//    NSString *name = @"Session From Mobile";
//    if (sessionTitle.text.length != 0) name = sessionTitle.text;
//    NSNumber *exp_num = [[NSNumber alloc] initWithInt:expNum];
//
//    NSNumber *session_num = [isenseAPI createSession:name withDescription:description Street:address City:city Country:country toExperiment:exp_num];
//    if ([session_num intValue] == -1) {
//        DataSet *ds = (DataSet *) [NSEntityDescription insertNewObjectForEntityForName:@"DataSet" inManagedObjectContext:managedObjectContext];
//        [ds setName:name];
//        [ds setDataDescription:description];
//        [ds setEid:exp_num];
//        [ds setData:nil];
//        [ds setPicturePaths:nil];
//        [ds setSid:[NSNumber numberWithInt:-1]];
//        [ds setCity:city];
//        [ds setCountry:country];
//        [ds setAddress:address];
//        [ds setUploadable:[NSNumber numberWithBool:true]];
//        // Add the new data set to the queue
//        [dataSaver addDataSet:ds];
//        NSLog(@"There are %d dataSets in the dataSaver.", dataSaver.count);
//
//        // Commit the changes
//        NSError *error = nil;
//        if (![managedObjectContext save:&error]) {
//            // Handle the error.
//            NSLog(@"%@", error);
//        }
//
//        return false;
//    }
//
//    // Upload to iSENSE (pass me JSON data)
//    NSError *error = nil;
//    NSData *dataJSON = [NSJSONSerialization dataWithJSONObject:results options:0 error:&error];
//    if (error != nil) {
//        NSLog(@"%@", error);
//        return false;
//    }
//
//    bool success = [isenseAPI putSessionData:dataJSON forSession:session_num inExperiment:exp_num];
//    if (!success) {
//        DataSet *ds = [NSEntityDescription insertNewObjectForEntityForName:@"DataSet" inManagedObjectContext:managedObjectContext];
//        [ds setName:name];
//        [ds setDataDescription:description];
//        [ds setEid:exp_num];
//        [ds setData:results];
//        [ds setPicturePaths:nil];
//        [ds setSid:session_num];
//        [ds setCity:city];
//        [ds setCountry:country];
//        [ds setAddress:address];
//        [ds setUploadable:[NSNumber numberWithBool:true]];
//
//        // Add the new data set to the queue
//        [dataSaver addDataSet:ds];
//        NSLog(@"There are %d dataSets in the dataSaver.", dataSaver.count);
//
//        // Commit the changes
//        NSError *error = nil;
//        if (![managedObjectContext save:&error]) {
//            // Handle the error.
//            NSLog(@"%@", error);
//        }
//    }
//    [exp_num release];
//    return success;
//}

// Implement viewDidLoad after the nib has been loaded
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIAlertView *message = [self getDispatchDialogWithMessage:@"Loading..."];
    [message show];
    
    // Add a menu button
    menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(displayMenu)];
    self.navigationItem.rightBarButtonItem = menuButton;
    
    // Attempt Login
    isenseAPI = [iSENSE getInstance];
    [isenseAPI toggleUseDev:YES];
    
    motionManager = [[CMMotionManager alloc] init];
    
    [self initLocations];
    dfm = [DataFieldManager alloc];
    [self resetAddressFields];
    recommendedSampleInterval = DEFAULT_SAMPLE_INTERVAL;
    
    dataSaver = [[DataSaver alloc] init];
    
    if (managedObjectContext == nil) {
        managedObjectContext = [(Data_CollectorAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    // Fetch the old DataSets
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *dataSetEntity = [NSEntityDescription entityForName:@"DataSet" inManagedObjectContext:managedObjectContext];
    if (dataSetEntity) {
        [request setEntity:dataSetEntity];
        
        // Sort results for DataSets
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
        
        // Actually make the request
        NSError *error = nil;
        NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        if (mutableFetchResults == nil) {
            // Handle the error.
        }
        
        // fill dataSaver's DataSet Queue
        for (int i = 0; i < mutableFetchResults.count; i++) {
            [dataSaver addDataSet:mutableFetchResults[i]];
        }
        
        // release the fetched objects
        [sortDescriptor release];
        [sortDescriptors release];
        [mutableFetchResults release];
        [request release];
    }
    
    [message dismissWithClickedButtonIndex:nil animated:YES];
}

// Is called every time AutomaticView appears
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Update ExperimentNumber status
    [self willRotateToInterfaceOrientation:(self.interfaceOrientation) duration:0];
}

- (void) displayMenu {
	UIActionSheet *popupQuery = [[UIActionSheet alloc]
                                 initWithTitle:nil
                                 delegate:self
                                 cancelButtonTitle:@"Cancel"
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:@"Experiment", @"Login", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[popupQuery showInView:self.view];
	[popupQuery release];
}

// Allows the device to rotate as necessary.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

// iOS6 enable rotation
- (BOOL)shouldAutorotate {
    return YES;
}

// iOS6 enable rotation
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

// Release all the extra
- (void)dealloc {
    [mainLogo release];
    [menuButton release];
    [qrResults release];
    [locationManager release];
    locationManager = nil;
    [super dealloc];
    
}

// Log you into to iSENSE using the iSENSE API
- (void) login:(NSString *)usernameInput withPassword:(NSString *)passwordInput {
    
    UIAlertView *message = [self getDispatchDialogWithMessage:@"Logging in..."];
    [message show];
    
    dispatch_queue_t queue = dispatch_queue_create("automatic_login_from_login_function", NULL);
    dispatch_async(queue, ^{
        BOOL success = [isenseAPI login:usernameInput with:passwordInput];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [self.view makeToast:@"Login Successful!"
                            duration:TOAST_LENGTH_SHORT
                            position:TOAST_BOTTOM
                               image:TOAST_CHECKMARK];
                
                // save the username and password in prefs
                NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
                [prefs setObject:usernameInput forKey:[StringGrabber grabString:@"key_username"]];
                [prefs setObject:passwordInput forKey:[StringGrabber grabString:@"key_password"]];
                [prefs synchronize];
                
            } else {
                [self.view makeToast:@"Login Failed!"
                            duration:TOAST_LENGTH_SHORT
                            position:TOAST_BOTTOM
                               image:TOAST_RED_X];
            }
            [message dismissWithClickedButtonIndex:nil animated:YES];
        });
    });
    
}

// Catches long click, starts and stops recording and beeps
- (IBAction) onRecordLongClick:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (!isRecording) {
            // Get Field Order
            [dfm getFieldOrderOfExperiment:expNum];
            NSLog(@"%@", [dfm order]);
            
            // Record Data
            isRecording = TRUE;
            [self recordData];
        } else {
            // Stop Recording
            isRecording = FALSE;
            [self stopRecording:motionManager];
        }
        
        // Make the beep sound
        NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/button-37.wav"];
        SystemSoundID soundID;
        NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
        AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
}

// Record the data and return the NSMutable array to be JSONed
- (void) recordData {
    //recommendedSampleInterval = [[NSString stringWithString:[sampleInterval text]] floatValue];
    
    // Make a new float
    float rate = .125;
    //if (recommendedSampleInterval > 0) rate = recommendedSampleInterval / 1000;
    NSLog(@"Rate: %f", rate);
    
    // Set the accelerometer update interval to reccomended sample interval, and start updates
    motionManager.accelerometerUpdateInterval = rate;
    motionManager.magnetometerUpdateInterval = rate;
    motionManager.gyroUpdateInterval = rate;
    if (motionManager.accelerometerAvailable) [motionManager startAccelerometerUpdates];
    if (motionManager.magnetometerAvailable) [motionManager startMagnetometerUpdates];
    if (motionManager.gyroAvailable) [motionManager startGyroUpdates];
    
    // New JSON array to hold data
    dataToBeJSONed = [[NSMutableArray alloc] init];
    
    // Start the new timer
    recordDataTimer = [[NSTimer scheduledTimerWithTimeInterval:rate target:self selector:@selector(buildRowOfData) userInfo:nil repeats:YES] retain];
}

// Fill dataToBeJSONed with a row of data
- (void) buildRowOfData {
    Fields *fieldsRow = [[Fields alloc] autorelease];
    
    // Fill a new row of data starting with time
    double time = [[NSDate date] timeIntervalSince1970];
    fieldsRow.time_millis = [[[NSNumber alloc] initWithDouble:time * 1000] autorelease];
    
    
    // acceleration in meters per second squared
    fieldsRow.accel_x = [[[NSNumber alloc] initWithDouble:[motionManager.accelerometerData acceleration].x * 9.80665] autorelease];
    NSLog(@"Current accel x is: %@.", fieldsRow.accel_x);
    fieldsRow.accel_y = [[[NSNumber alloc] initWithDouble:[motionManager.accelerometerData acceleration].y * 9.80665] autorelease];
    fieldsRow.accel_z = [[[NSNumber alloc] initWithDouble:[motionManager.accelerometerData acceleration].z * 9.80665] autorelease];
    fieldsRow.accel_total = [[[NSNumber alloc] initWithDouble:
                              sqrt(pow(fieldsRow.accel_x.doubleValue, 2)
                                   + pow(fieldsRow.accel_y.doubleValue, 2)
                                   + pow(fieldsRow.accel_z.doubleValue, 2))] autorelease];
    
    // latitude and longitude coordinates
    CLLocationCoordinate2D lc2d = [[locationManager location] coordinate];
    double latitude  = lc2d.latitude;
    double longitude = lc2d.longitude;
    fieldsRow.latitude = [[[NSNumber alloc] initWithDouble:latitude] autorelease];
    fieldsRow.longitude = [[[NSNumber alloc] initWithDouble:longitude] autorelease];
    
    // magnetic field in microTesla
    fieldsRow.mag_x = [[[NSNumber alloc] initWithDouble:[motionManager.magnetometerData magneticField].x] autorelease];
    fieldsRow.mag_y = [[[NSNumber alloc] initWithDouble:[motionManager.magnetometerData magneticField].y] autorelease];
    fieldsRow.mag_z = [[[NSNumber alloc] initWithDouble:[motionManager.magnetometerData magneticField].z] autorelease];
    fieldsRow.mag_total = [[[NSNumber alloc] initWithDouble:
                            sqrt(pow(fieldsRow.mag_x.doubleValue, 2)
                                 + pow(fieldsRow.mag_y.doubleValue, 2)
                                 + pow(fieldsRow.mag_z.doubleValue, 2))] autorelease];
    
    // rotation rate in radians per second
    if (motionManager.gyroAvailable) {
        fieldsRow.gyro_x = [[[NSNumber alloc] initWithDouble:[motionManager.gyroData rotationRate].x] autorelease];
        fieldsRow.gyro_y = [[[NSNumber alloc] initWithDouble:[motionManager.gyroData rotationRate].y] autorelease];
        fieldsRow.gyro_z = [[[NSNumber alloc] initWithDouble:[motionManager.gyroData rotationRate].z] autorelease];
    }
    
    // Update parent JSON object
    [dfm orderDataFromFields:fieldsRow];
    
    if (dfm.data != nil && dataToBeJSONed != nil)
        [dataToBeJSONed addObject:dfm.data];
    else {
        NSLog(@"something is wrong");
    }
    
}

// This inits locations
- (void) initLocations {
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
        geoCoder = [[CLGeocoder alloc] init];
    }
}

// Stops the recording and returns the actual data recorded :)
-(void) stopRecording:(CMMotionManager *)finalMotionManager {
    // Stop Timers
    [timer invalidate];
    [timer release];
    [recordDataTimer invalidate];
    [recordDataTimer release];
    
    // Stop Sensors
    if (finalMotionManager.accelerometerActive) [finalMotionManager stopAccelerometerUpdates];
    if (finalMotionManager.gyroActive) [finalMotionManager stopGyroUpdates];
    if (finalMotionManager.magnetometerActive) [finalMotionManager stopMagnetometerUpdates];
    
    // Back to recording mode
    //    startStopButton.image = [UIImage imageNamed:@"red_button.png"];
    //    mainLogo.image = [UIImage imageNamed:@"logo_red.png"];
    //    startStopLabel.text = [StringGrabber grabString:@"start_button_text"];
    //    containerForMainButton updateImage:startStopButton];
    
    // Open up description dialog
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:[StringGrabber grabString:@"description_or_delete"]
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Delete"
                                            otherButtonTitles:@"Upload", nil];
    
    message.tag = DESCRIPTION_AUTOMATIC;
    message.delegate = self;
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [message textFieldAtIndex:0].keyboardType = UIKeyboardTypeDefault;
    [message show];
    [message release];
    
}

// Fetch the experiments from iSENSE
- (void) getExperiments {
    NSMutableArray *results = [isenseAPI getExperiments:[NSNumber numberWithUnsignedInt:1] withLimit:[NSNumber numberWithUnsignedInt:10] withQuery:@"" andSort:@"recent"];
    if ([results count] == 0) NSLog(@"No experiments found.");
    
    NSMutableArray *resultsFields = [isenseAPI getExperimentFields:[NSNumber numberWithUnsignedInt:514]];
    if ([resultsFields count] == 0) NSLog(@"No experiment fields found.");
    
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	UIAlertView *message;
    
	switch (buttonIndex) {
		case MENU_EXPERIMENT:
            message = [[UIAlertView alloc] initWithTitle:nil
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"Enter Experiment #", @"Browse", @"Scan QR Code", nil];
            message.tag = MENU_EXPERIMENT;
            [message show];
            [message release];
            
			break;
            
		case MENU_LOGIN:
            message = [[UIAlertView alloc] initWithTitle:@"Login"
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"Okay", nil];
            message.tag = MENU_LOGIN;
			[message setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
            [message show];
            [message release];
            
            break;
            
		default:
			break;
	}
	
}

- (void) alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == MENU_LOGIN) {
        
        if (buttonIndex != OPTION_CANCELED) {
            NSString *usernameInput = [[actionSheet textFieldAtIndex:0] text];
            NSString *passwordInput = [[actionSheet textFieldAtIndex:1] text];
            [self login:usernameInput withPassword:passwordInput];
        }
        
    } else if (actionSheet.tag == MENU_EXPERIMENT){
        
        if (buttonIndex == OPTION_ENTER_EXPERIMENT_NUMBER) {
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Enter Experiment #:"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Okay", nil];
            
            message.tag = EXPERIMENT_MANUAL_ENTRY;
            [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [message textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
            [message show];
            [message release];
            
        } else if (buttonIndex == OPTION_BROWSE_EXPERIMENTS) {
            
            ExperimentBrowseViewController *browseView = [[ExperimentBrowseViewController alloc] init];
            browseView.title = @"Browse for Experiments";
            browseView.chosenExperiment = &expNum;
            [self.navigationController pushViewController:browseView animated:YES];
            [browseView release];
        }
        
    } else if (actionSheet.tag == EXPERIMENT_MANUAL_ENTRY) {
        
        if (buttonIndex != OPTION_CANCELED) {
            
            expNum = [[[actionSheet textFieldAtIndex:0] text] intValue];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setInteger:expNum forKey:[StringGrabber grabString:@"key_exp_automatic"]];
            
        }
        
    } else if (actionSheet.tag == DESCRIPTION_AUTOMATIC) {
        
        if (buttonIndex != OPTION_CANCELED) {
            
            UIAlertView *message = [self getDispatchDialogWithMessage:@"Uploading data set..."];
            [message show];
            
            dispatch_queue_t queue = dispatch_queue_create("automatic_upload_data", NULL);
            dispatch_async(queue, ^{
                
                NSString *description = [[actionSheet textFieldAtIndex:0] text];
                if ([description length] == 0) {
                    description = @"Session data gathered and uploaded from mobile phone using iSENSE DataCollector application.";
                }
                
                bool success = true;//[self uploadData:dataToBeJSONed withDescription:description];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success) {
                        [self.view makeToast:@"Upload success"
                                    duration:TOAST_LENGTH_SHORT
                                    position:TOAST_BOTTOM
                                       image:TOAST_CHECKMARK];
                    } else {
                        [self.view makeToast:@"Upload failed"
                                    duration:TOAST_LENGTH_SHORT
                                    position:TOAST_BOTTOM
                                       image:TOAST_RED_X];
                    }
                    
                    [message dismissWithClickedButtonIndex:nil animated:YES];
                });
            });
            
        } else {
            
            [self.view makeToast:@"Data set deleted." duration:TOAST_LENGTH_SHORT position:TOAST_BOTTOM image:TOAST_CHECKMARK];
            
        }
    }
}

// Finds the associated address from a GPS location.
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (geoCoder) {
        [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if ([placemarks count] > 0) {
                city = [[[placemarks objectAtIndex:0] locality] retain];
                country = [[[placemarks objectAtIndex:0] country] retain];
                NSString *subThoroughFare = [[placemarks objectAtIndex:0] subThoroughfare];
                NSString *thoroughFare = [[placemarks objectAtIndex:0] thoroughfare];
                address = [[NSString stringWithFormat:@"%@ %@", subThoroughFare, thoroughFare] retain];
                
                if (!address || !city || !country)
                    [self resetAddressFields];
                
                if ((NSNull *)address == [NSNull null] || (NSNull *)city == [NSNull null] || (NSNull *)country == [NSNull null])
                    [self resetAddressFields];
            } else {
                [self resetAddressFields];
            }
        }];
    }
}

- (void)resetAddressFields {
    city = [[NSString alloc] initWithString:@"N/a"];
    country = [[NSString alloc] initWithString:@"N/a"];
    address = [[NSString alloc] initWithString:@"N/a"];
}

// This is for the loading spinner when the app starts automatic mode
- (UIAlertView *) getDispatchDialogWithMessage:(NSString *)dString {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:dString
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:nil];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(139.5, 75.5);
    [message addSubview:spinner];
    [spinner startAnimating];
    [spinner release];
    return [message autorelease];
}


// Calls step one to get an experiment, sample interval, test length, etc.
- (IBAction) setup:(UIButton *)sender {
    
    StepOneSetup *stepView = [[StepOneSetup alloc] init];
    stepView.title = @"Step 1: Setup";
    [self.navigationController pushViewController:stepView animated:YES];
    [stepView release];
    
}

- (IBAction) uploadData:(UIButton *)sender {
    
}

@end
