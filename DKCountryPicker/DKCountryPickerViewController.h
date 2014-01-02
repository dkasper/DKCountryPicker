//
//  DKCountryCodeViewController.h
//  PhoneCountries
//
//  Created by David Kasper on 1/1/14.
//  Copyright (c) 2014 David Kasper. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DKCountryPickerDelegate <NSObject>

/* userInfo will have keys: phoneCode   ~ @"1"
 *                          countryCode ~ @"US"
 *                          country     ~ @"United States"
 */
-(void)countryPickerValueSelected:(NSDictionary *)userInfo;

@end

@interface DKCountryPickerViewController : UITableViewController

//Use a custom class to control the display of the table
//The value is set to cell.textLabel.text so make sure your cell has a textLabel outlet
@property (unsafe_unretained) Class cellClass;

//Show A-Z indexes on the side of the table
@property (nonatomic, assign) BOOL showIndexes;

//Show phone code (eg +44) next to country
@property (nonatomic, assign) BOOL showPhoneCodes;

@property (nonatomic, weak) id<DKCountryPickerDelegate> pickerDelegate;

@end
