//
//  CommentsListViewCell.h
//  Blog - built.io
//
//  Created by Samir Bhide on 15/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class REDateLabel;
@interface CommentsListViewCell : UITableViewCell
@property (nonatomic ,strong) UIImageView *commentThumbnailView;
@property (nonatomic, strong) UILabel *commentTitleLabel;
@property (nonatomic, strong) UILabel *commentShortTextLabel;
@property (nonatomic, strong) REDateLabel *commentTimeStampLabel;
@property (nonatomic, strong) UILabel *commentAuthorNameLabel;
@end
