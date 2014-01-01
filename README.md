DKPhonePicker
=============

Was surprised that I couldn't find one so I made a simple control for searching/selecting countries. Especially useful for using in signup forms where you need to select a country for a phone number or postal address.

Example
-------

    -(IBAction)showPicker:(id)sender {
        DKCountryPickerViewController *picker = [[DKCountryPickerViewController alloc] initWithStyle:UITableViewStylePlain];
        picker.pickerDelegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
    
    -(void)countryPickerValueSelected:(NSDictionary *)userInfo {
        NSLog(@"%@",userInfo[@"name"]);
        [self dismissViewControllerAnimated:YES completion:nil];
    }


Screenshot
----------
![ScreenShot](/ScreenShot.png "Screenshot")

