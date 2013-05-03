//
//  ComposeViewController.m
//  Blog - built.io
//
//  Created by Akshay Mhatre on 14/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import "ComposeViewController.h"
#import "SVProgressHUD.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController

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
    
    if (self.typeOfPost == postTypeComment) {
        self.title = @"Comment";
    }
    
    [self.blogTextView becomeFirstResponder];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleDone target:self action:@selector(post:)];
    [self.navigationItem setRightBarButtonItem:doneButton];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
}

- (void)post:(id)sender{
    [self.blogTextView resignFirstResponder];
    
    if ([self.blogTextView.text length]>0) {
        if (self.typeOfPost == postTypeBlog) {
            
            [self savePostWithTitle:self.title andBody:self.blogTextView.text];
            
        }else if (self.typeOfPost == postTypeComment){
            [self saveComment:self.blogTextView.text];
        }
    }else{
        UIAlertView *noContentAlert = [[UIAlertView alloc]initWithTitle:@"Nothing to Post?" message:@"Please enter something to post" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noContentAlert show];
    }
}

- (void)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)savePostWithTitle:(NSString *)title andBody:(NSString *)body{
    [SVProgressHUD showWithStatus:@"Posting..." maskType:SVProgressHUDMaskTypeGradient];
    
    BuiltObject *postObject = [BuiltObject objectWithClassUID:@"post"];
    [postObject setObject:title forKey:@"title"];
    [postObject setObject:body forKey:@"body"];
    
    BuiltACL *postACL = [BuiltACL ACL]; 
    [postACL setPublicReadAccess:YES]; //anyone can read the blog
    [postACL setWriteAccess:YES forUserId:[BuiltUser currentUser].uid]; //only the owner can make changes to the blog
    
    [postObject setACL:postACL]; //apply the ACL
    
    //save the blog
    [postObject saveOnSuccess:^{
        [SVProgressHUD popActivity];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } onError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Oops Failed Posting! Try Again."];
    }];
}

- (void)saveComment:(NSString *)commentBody{
    [SVProgressHUD showWithStatus:@"Commenting..." maskType:SVProgressHUDMaskTypeGradient];
    
    //comment is the name of the class created on built.io
    BuiltObject *commentObj = [BuiltObject objectWithClassUID:@"comment"];
    [commentObj setObject:commentBody forKey:@"body"];
    [commentObj setReference:[self.blogObject objectForKey:@"uid"] forKey:@"post_ref"];
    
    //set ACL
    BuiltACL *commentACL = [BuiltACL ACL];
    [commentACL setPublicReadAccess:YES];
    if ([commentObj hasOwner]) {
        [commentACL setWriteAccess:YES forUserId:[self.blogObject ownerUID]];
        [commentACL setDeleteAccess:YES forUserId:[self.blogObject ownerUID]];
    }
    [commentObj setACL:commentACL];
    [commentObj saveOnSuccess:^{
        [SVProgressHUD popActivity];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } onError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Oops Failed Posting! Try Again."];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
