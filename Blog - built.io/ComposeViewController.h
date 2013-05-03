//
//  ComposeViewController.h
//  Blog - built.io
//
//  Created by Akshay Mhatre on 14/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    postTypeBlog = 0,
    postTypeComment = 1
} postType;

@interface ComposeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *blogTextView;
@property (nonatomic, assign) postType typeOfPost;
@property (nonatomic, strong) BuiltObject* blogObject;
@end
