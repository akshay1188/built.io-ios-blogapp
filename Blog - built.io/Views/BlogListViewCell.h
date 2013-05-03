//
//  BlogListViewCell.h
//  Blog - built.io
//
//  Created by Samir Bhide on 14/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class REDateLabel;

@interface BlogListViewCell : UITableViewCell
@property (nonatomic ,strong) UIImageView *blogThumbnailView;
@property (nonatomic, strong) UILabel *blogTitleLabel;
@property (nonatomic, strong) UILabel *blogShortTextLabel;
@property (nonatomic, strong) REDateLabel *blogTimeStampLabel;
@property (nonatomic, strong) UILabel *blogAuthorNameLabel;
@end
