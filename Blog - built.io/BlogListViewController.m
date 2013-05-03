//
//  BlogListViewController.m
//  Blog - built.io
//
//  Created by Akshay Mhatre on 13/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import "BlogListViewController.h"
#import "BuiltObject.h"
#import "BuiltQuery.h"
#import "BlogDetailViewController.h"
#import "BlogListViewCell.h"
#import "ComposeViewController.h"
#import "REDateLabel.h"

static NSString *CellIdentifier = @"Cell";

@interface BlogListViewController ()

@property (nonatomic, strong)BuiltUILoginController *loginController;

@end

@implementation BlogListViewController


-(id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Blogs";
        self.enablePullToRefresh = YES;
        self.fetchLimit = 10;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    [self.builtQuery includeFilterWithKey:@"include_user" andValue:@"true"];
    
    [self refresh];
    
    UIBarButtonItem *compose = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                            target:self
                                                                            action:@selector(compose:)];
    [self.navigationItem setRightBarButtonItem:compose];
}

- (void)compose:(id)sender{
    if ([[BuiltUser currentUser] authtoken]) {
        UIAlertView *titleAlert = [[UIAlertView alloc]initWithTitle:@"Enter Title for your Blog" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [titleAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [titleAlert setTag:1];
        [titleAlert show];        
    }else{
        UIAlertView *loginAlert = [[UIAlertView alloc]initWithTitle:@"Login to Post" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
        [loginAlert setTag:2];
        [loginAlert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            ComposeViewController *compose = [[ComposeViewController alloc]init];
            UINavigationController *composeNavigationController = [[UINavigationController alloc]initWithRootViewController:compose];
            compose.title = [alertView textFieldAtIndex:0].text;
            [self presentViewController:composeNavigationController animated:YES completion:^{
            }];
        }
    }else if (alertView.tag == 2){
        if (buttonIndex != alertView.cancelButtonIndex) {
            self.loginController = [[BuiltUILoginController alloc]initWithNibName:nil bundle:nil];
            UINavigationController *loginNavigationController = [[UINavigationController alloc]initWithRootViewController:self.loginController];
            self.loginController.delegate = self;
            self.loginController.googleAppSettingDelegate = self;
            [self presentViewController:loginNavigationController animated:YES completion:^{
                self.loginController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                                         initWithTitle:@"Cancel"
                                                                         style:UIBarButtonItemStyleDone
                                                                         target:self
                                                                         action:@selector(closeSignUpScreen)];
            }];
        }
    }
}

-(void)closeSignUpScreen{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark
#pragma mark BuiltUILoginDelegate

-(void)loginSuccessWithUser:(BuiltUser *)user{
    [user saveUserSession];
    [[self.loginController navigationController] dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)loginFailedWithError:(NSError *)error{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - BuiltTableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath builtObject:(BuiltObject *)builtObject {
    
    NSDateFormatter* creationDateFormatter = [[NSDateFormatter alloc]init];
    [creationDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    
    NSDateFormatter* displayDateFormatter = [[NSDateFormatter alloc]init];
    [displayDateFormatter setDateFormat:@"dd MMM yyyy h:mm a"];
    
    BlogListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell) {
        cell = [[BlogListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.blogTitleLabel setText:[builtObject objectForKey:@"title"]];
    [cell.blogShortTextLabel setText:[builtObject objectForKey:@"body"]];
    [cell.blogTimeStampLabel setDate:[self dateWithUTCDateString:[builtObject objectForKey:@"created_at"]]];
    
    [cell.blogAuthorNameLabel setText:@"User"];

    if ([builtObject hasOwner]) {
        if ([[builtObject owner] objectForKey:@"auth_data"] != nil) {
            if ([[[[[builtObject owner] objectForKey:@"auth_data"] objectForKey:@"google"] objectForKey:@"google_user"] objectForKey:@"name"]) {
                [cell.blogAuthorNameLabel setText:[[[[[builtObject owner] objectForKey:@"auth_data"] objectForKey:@"google"] objectForKey:@"google_user"] objectForKey:@"name"]];
            }
        }
        if ([[builtObject owner] objectForKey:@"first_name"]) {
            [cell.blogAuthorNameLabel setText:[[builtObject owner] objectForKey:@"first_name"]];
        }else if ([[builtObject owner] objectForKey:@"email"]){
            [cell.blogAuthorNameLabel setText:[[builtObject owner] objectForKey:@"email"]];
        }
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BlogDetailViewController *blogDetail = [[BlogDetailViewController alloc]init];
    [blogDetail setBlogObject:[self builtObjectAtIndexPath:indexPath]];
    [self.navigationController pushViewController:blogDetail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}
#pragma mark - Table view delegate

-(NSDate*)dateWithUTCDateString:(NSString*)dateString{
	NSString* mydate = [dateString substringToIndex:[dateString length] - 1];
	mydate = [mydate stringByAppendingFormat:@"GMT%@",@"-00:00" ];
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc]
                                 initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormat setLocale:enUSPOSIXLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    return [dateFormat dateFromString:mydate];
}

#pragma mark
#pragma mark BuiltUIGoogleAppSettingDelegate

- (NSString*)googleAppClientID{
    return @"1092637695085.apps.googleusercontent.com";
}

- (NSString*)googleAppClientSecret{
    return @"cJtBWIg4aLakaRE57FrQ3bRQ";
}
@end
