//
//  DKDemoViewController.m
//  DKPhonePicker
//
//  Created by David Kasper on 1/1/14.
//  Copyright (c) 2014 David Kasper. All rights reserved.
//

#import "DKDemoViewController.h"
#import "DKCountryPickerViewController.h"

@interface DKDemoViewController ()<DKCountryPickerDelegate>

@end

@implementation DKDemoViewController

-(IBAction)showPicker:(id)sender {
    DKCountryPickerViewController *picker = [[DKCountryPickerViewController alloc] initWithStyle:UITableViewStylePlain];
    picker.pickerDelegate = self;
    picker.showPhoneCodes = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)countryPickerValueSelected:(NSDictionary *)userInfo {
    NSLog(@"%@",userInfo[@"name"]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ModalPickerSegue"]) {
        DKCountryPickerViewController *pickerViewController = (DKCountryPickerViewController *)[segue destinationViewController];
        pickerViewController.pickerDelegate = self;
    }
}

@end
