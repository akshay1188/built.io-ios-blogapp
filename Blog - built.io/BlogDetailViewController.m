//
//  BlogDetailViewController.m
//  Blog - built.io
//
//  Created by Akshay Mhatre on 13/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import "BlogDetailViewController.h"
#import "Built.h"
#import "CommentsListViewController.h"
#import "BuiltUILoginController.h"
#import "ComposeViewController.h"
#import "REDateLabel.h"
@interface BlogDetailViewController ()

@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong)BuiltUILoginController *loginController;
@end

@implementation BlogDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    self.title = [self.blogObject objectForKey:@"title"];
    [self.blogTitle setText:[self.blogObject objectForKey:@"title"]];
    
    NSDateFormatter* creationDateFormatter = [[NSDateFormatter alloc]init];
    [creationDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    
    NSDateFormatter* displayDateFormatter = [[NSDateFormatter alloc]init];
    [displayDateFormatter setDateFormat:@"dd MMM yyyy h:mm a"];
    
    [self.creationDate setText:[NSString stringWithFormat:@"%@",[displayDateFormatter stringFromDate:[creationDateFormatter dateFromString:[self.blogObject objectForKey:@"created_at"]]]]];
    
    [self.creationDate setDate:[self dateWithUTCDateString:[self.blogObject objectForKey:@"created_at"]]];

    
    [self.authorAvatar setImage:[UIImage imageNamed:@"111-user"]];
    [self.authorAvatar setContentMode:UIViewContentModeCenter];
    {
        // Initialization code
        [self.authorAvatar setBackgroundColor:[UIColor whiteColor]];
        self.authorAvatar.layer.shadowColor = [UIColor blackColor].CGColor;
        self.authorAvatar.layer.shadowOffset = CGSizeMake(0, 0);
        self.authorAvatar.layer.shadowOpacity = 0.5;
        self.authorAvatar.layer.shadowRadius = 3.0;
        
        //white border part
        [self.authorAvatar.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [self.authorAvatar.layer setBorderWidth: 1.0];
        
        self.authorAvatar.layer.cornerRadius = 3;
        self.authorAvatar.layer.masksToBounds = NO;
        
        UIBezierPath* bezierPath =[UIBezierPath bezierPathWithRect:CGRectMake(3, 3, CGRectGetWidth(self.authorAvatar.frame)-6, CGRectGetHeight(self.authorAvatar.frame)-6)];
        [self.authorAvatar.layer setShadowPath:bezierPath.CGPath];

    }

    [self.blogContent setBackgroundColor:[UIColor clearColor]];
    
    [self.author setText:@"User"];
    if ([self.blogObject hasOwner]) {
        if ([[self.blogObject owner] objectForKey:@"auth_data"] != nil) {
            if ([[[[[self.blogObject owner] objectForKey:@"auth_data"] objectForKey:@"google"] objectForKey:@"google_user"] objectForKey:@"name"]) {
                [self.author setText:[[[[[self.blogObject owner] objectForKey:@"auth_data"] objectForKey:@"google"] objectForKey:@"google_user"] objectForKey:@"name"]];
            }
        }
        
        if ([[self.blogObject owner] objectForKey:@"first_name"]) {
            [self.author setText:[[self.blogObject owner] objectForKey:@"first_name"]];
        }else if ([[self.blogObject owner] objectForKey:@"email"]){
            [self.author setText:[[self.blogObject owner] objectForKey:@"email"]];
        }
        
    }
    
    
    [self.blogContent setText:[self.blogObject objectForKey:@"body"]];
    [self.blogContent setEditable:NO];
    
    //comment is the name of the class created on built.io
    BuiltQuery *query = [BuiltQuery queryWithClassUID:@"comment"];
    [query whereRefKey:@"post_ref.uid" equalTo:[self.blogObject objectForKey:@"uid"]];
    [query includeCount:YES];
    [query includeFilterWithKey:@"include_user" andValue:@"true"];
    if ([[BuiltUser currentUser] isAuthenticated]) {
        [query setHeaders:@{@"authtoken": [BuiltUser currentUser].authtoken}];
    }
    
    [query exec:^(QueryResult *result) {
        self.comments = [NSMutableArray array];
        self.comments = [result getResult];
        [self.viewComments setTitle:[NSString stringWithFormat:@"%@(%d)",self.viewComments.titleLabel.text,[result count]] forState:UIControlStateNormal];
    } onError:^(NSError *error) {
        
    }];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewComments:(id)sender {
    if (self.comments.count > 0) {
        CommentsListViewController *commentsList = [[CommentsListViewController alloc]initWithStyle:UITableViewStylePlain];
        [commentsList setComments:self.comments];
        [self.navigationController pushViewController:commentsList animated:YES];        
    }
}

- (IBAction)comment:(id)sender {
    BuiltUser *user = [BuiltUser currentUser];
    if (user) {
        [self showCommentCompose];
    }else{
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

-(void)loginSuccessWithUser:(BuiltUser *)user{
    [user saveUserSession];
    [[self.loginController navigationController] dismissViewControllerAnimated:YES completion:^{
        [self showCommentCompose];
    }];
}

-(void)loginFailedWithError:(NSError *)error{

}

- (void)closeSignUpScreen{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)showCommentCompose{
    ComposeViewController *compose = [[ComposeViewController alloc]init];
    [compose setTypeOfPost:postTypeComment];
    [compose setBlogObject:self.blogObject];
    UINavigationController *composeNavigationController = [[UINavigationController alloc]initWithRootViewController:compose];
    [self presentViewController:composeNavigationController animated:YES completion:^{
    }];
}

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

- (NSString*)googleAppClientID{
    return @"1092637695085.apps.googleusercontent.com";
}

- (NSString*)googleAppClientSecret{
    return @"cJtBWIg4aLakaRE57FrQ3bRQ";
}

@end
