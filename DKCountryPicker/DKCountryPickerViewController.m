//
//  DKCountryCodeViewController.m
//  PhoneCountries
//
//  Created by David Kasper on 1/1/14.
//  Copyright (c) 2014 David Kasper. All rights reserved.
//

#import "DKCountryPickerViewController.h"
#import <libPhoneNumber-iOS/NBPhoneNumberUtil.h>

@interface __Country : NSObject

@property (nonatomic, copy) NSString *name, *phoneCode, *countryCode;

@end

@implementation __Country

-(NSString *)description {
    return self.name;
}

-(NSString *)descriptionWithPhoneCode {
    return [NSString stringWithFormat:@"%@ (+%@)", self.name, self.phoneCode];
}

@end

@interface DKCountryPickerViewController ()<UISearchDisplayDelegate, UISearchBarDelegate> {
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    
    NSMutableDictionary *countryDictionary;
    NSMutableArray *searchData;
    NSArray *sortedKeys;
}

@end

@implementation DKCountryPickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setup];
    }
    return self;
}

-(void)setup {
    searchData = [[NSMutableArray alloc] init];
    countryDictionary = [[NSMutableDictionary alloc] init];
    NSLocale *locale = [NSLocale currentLocale];
    NBPhoneNumberUtil *util = [NBPhoneNumberUtil sharedInstance];
    
    for(NSString *countryCode in [NSLocale ISOCountryCodes]) {
        __Country *newCountry = [[__Country alloc] init];
        newCountry.countryCode = countryCode;
        newCountry.name = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
        newCountry.phoneCode = [util countryCodeFromRegionCode:countryCode];
        
        //code can be null
        if(!newCountry.phoneCode) {
            continue;
        }
        
        NSString *key = [[newCountry.name substringToIndex:1] uppercaseString];
        if(!countryDictionary[key]) {
            countryDictionary[key] = [[NSMutableArray alloc] init];
        }
        
        [(NSMutableArray *)countryDictionary[key] addObject:newCountry];
    }
    
    sortedKeys = [[countryDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.contentInset = UIEdgeInsetsMake(20, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right);

    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    self.tableView.tableHeaderView = searchBar;
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    if(!self.cellClass) {
        self.cellClass = [UITableViewCell class];
    }
    
    [self.tableView registerClass:self.cellClass forCellReuseIdentifier:@"Cell"];
    [self.searchDisplayController.searchResultsTableView registerClass:self.cellClass forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search Delegates
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [searchData removeAllObjects];

    if([searchString length] > 0) {
        NSString *key = [[searchString substringToIndex:1] uppercaseString];
        
        for(__Country *country in countryDictionary[key]) {
            NSRange range = [country.name rangeOfString:searchString options:NSCaseInsensitiveSearch];
            if(range.location == 0) {
                [searchData addObject:country];
            }
        }
    }
    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        return sortedKeys.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchData count];
    } else {
        return [countryDictionary[sortedKeys[section]] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    __Country *country;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        country = (__Country *)searchData[indexPath.row];
    } else {
        NSString *key = sortedKeys[indexPath.section];
        country = (__Country *)countryDictionary[key][indexPath.row];
    }
    
    if(self.showPhoneCodes) {
        cell.textLabel.text = [country descriptionWithPhoneCode];
    } else {
        cell.textLabel.text = [country description];
    }
    
    return cell;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if(self.showIndexes) {
        return sortedKeys;
    }
    return @[];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __Country *country;
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        country = searchData[indexPath.row];
    } else {
        NSString *key = sortedKeys[indexPath.section];
        country = countryDictionary[key][indexPath.row];
    }
    
    if(country && [self.pickerDelegate respondsToSelector:@selector(countryPickerValueSelected:)]) {
        [self.pickerDelegate countryPickerValueSelected:@{@"name": country.name, @"phoneCode": country.phoneCode, @"countryCode": country.countryCode}];
    }
}

@end
