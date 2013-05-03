//
//  CommentsListViewController.m
//  Blog - built.io
//
//  Created by Akshay Mhatre on 14/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import "CommentsListViewController.h"
#import "CommentsListViewCell.h"
#import "REDateLabel.h"
@interface CommentsListViewController ()

@end

@implementation CommentsListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Comments";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
//self.title = @"Comments";
    NSString *comment = [[self.comments objectAtIndex:indexPath.row] objectForKey:@"body"];
    
    CommentsListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CommentsListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.commentThumbnailView setImage:[UIImage imageNamed:@"111-user"]];
    
    [cell.commentTitleLabel setText:@"User"];
    if ([[self.comments objectAtIndex:indexPath.row] hasOwner]) {
        if ([[[self.comments objectAtIndex:indexPath.row] owner] objectForKey:@"auth_data"] != nil) {
            if ([[[[[[self.comments objectAtIndex:indexPath.row] owner] objectForKey:@"auth_data"] objectForKey:@"google"] objectForKey:@"google_user"] objectForKey:@"name"]) {
                [cell.commentTitleLabel setText:[[[[[[self.comments objectAtIndex:indexPath.row] owner] objectForKey:@"auth_data"] objectForKey:@"google"] objectForKey:@"google_user"] objectForKey:@"name"]];
            }
        }
        
        if ([[[self.comments objectAtIndex:indexPath.row] owner] objectForKey:@"first_name"]) {
            [cell.commentTitleLabel setText:[[[self.comments objectAtIndex:indexPath.row] owner] objectForKey:@"first_name"]];
        }else if ([[[self.comments objectAtIndex:indexPath.row] owner] objectForKey:@"email"]){
            [cell.commentTitleLabel setText:[[[self.comments objectAtIndex:indexPath.row] owner] objectForKey:@"email"]];
        }
    }
    
    [cell.commentShortTextLabel setText:comment];

    NSDateFormatter* creationDateFormatter = [[NSDateFormatter alloc]init];
    [creationDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    
    NSDateFormatter* displayDateFormatter = [[NSDateFormatter alloc]init];
    [displayDateFormatter setDateFormat:@"dd MMM yyyy h:mm a"];
    
    [cell.commentTimeStampLabel setDate:[self dateWithUTCDateString:[[self.comments objectAtIndex:indexPath.row] objectForKey:@"created_at"]]];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *comment = [[self.comments objectAtIndex:indexPath.row] objectForKey:@"body"];
    
    CGSize constraint = CGSizeMake(self.view.bounds.size.width - 70, CGFLOAT_MAX);
    
    CGSize size = [comment sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];

    CGFloat height = 60;
    
    height += size.height;
    
    if (height < 70) {
        height = 70;
    }
    
    return height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
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


@end
