//
//  BlogDetailViewController.h
//  Blog - built.io
//
//  Created by Akshay Mhatre on 13/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuiltUILoginController.h"

@class BuiltObject;
@class REDateLabel;
@interface BlogDetailViewController : UIViewController<BuiltUILoginDelegate, BuiltUIGoogleAppSettingDelegate>
@property (weak, nonatomic) BuiltObject *blogObject;
@property (weak, nonatomic) IBOutlet UIImageView *authorAvatar;
@property (weak, nonatomic) IBOutlet UILabel *blogTitle;
@property (weak, nonatomic) IBOutlet REDateLabel *creationDate;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UITextView *blogContent;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIButton *viewComments;
- (IBAction)viewComments:(id)sender;
- (IBAction)comment:(id)sender;

@end
