//
//  CommentsListViewCell.m
//  Blog - built.io
//
//  Created by Samir Bhide on 15/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import "CommentsListViewCell.h"
#import "REDateLabel.h"

@implementation CommentsListViewCell
@synthesize commentAuthorNameLabel, commentShortTextLabel, commentThumbnailView, commentTimeStampLabel, commentTitleLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.commentThumbnailView setBackgroundColor:[UIColor whiteColor]];
        self.commentThumbnailView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.commentThumbnailView.layer.shadowOffset = CGSizeMake(0, 0);
        self.commentThumbnailView.layer.shadowOpacity = 0.5;
        self.commentThumbnailView.layer.shadowRadius = 3.0;
        
        //white border part
        [self.commentThumbnailView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [self.commentThumbnailView.layer setBorderWidth: 1.0];
        
        self.commentThumbnailView.layer.cornerRadius = 3;
        self.commentThumbnailView.layer.masksToBounds = NO;
        
        UIBezierPath* bezierPath =[UIBezierPath bezierPathWithRect:CGRectMake(3, 3, 40-6, 36-6)];
        [self.commentThumbnailView.layer setShadowPath:bezierPath.CGPath];
    }
    return self;
}

-(UIImageView *)commentThumbnailView{
    if (!commentThumbnailView) {
        commentThumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 36)];
        [commentThumbnailView setImage:[UIImage imageNamed:@"111-user"]];
        [commentThumbnailView setBackgroundColor:[UIColor clearColor]];
        [commentThumbnailView setContentMode:UIViewContentModeCenter];
        [self addSubview:commentThumbnailView];
    }
    return commentThumbnailView;
}

-(UILabel *)commentTitleLabel{
    if (!commentTitleLabel) {
        commentTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.commentThumbnailView.frame) + 10, 5, self.frame.size.width - CGRectGetMaxX(self.commentThumbnailView.frame) + 10, 50)];
        [commentTitleLabel setText:@"Short Title title title"];
        [commentTitleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        commentTitleLabel.numberOfLines = 1;
        [commentTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:commentTitleLabel];
    }
    return commentTitleLabel;
}

-(UILabel *)commentShortTextLabel{
    if (!commentShortTextLabel) {
        commentShortTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.commentThumbnailView.frame) + 10, CGRectGetMaxY(self.commentTitleLabel.frame) + 0, self.frame.size.width - CGRectGetMaxX(self.commentThumbnailView.frame) + 50, 100)];
        [commentShortTextLabel setText:@"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."];
        [commentShortTextLabel setFont:[UIFont systemFontOfSize:12.0]];
        [commentShortTextLabel setBackgroundColor:[UIColor clearColor]];
        commentShortTextLabel.numberOfLines = 0;
        [commentShortTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:commentShortTextLabel];
    }
    return commentShortTextLabel;
}

-(REDateLabel *)commentTimeStampLabel{
    if (!commentTimeStampLabel) {
        commentTimeStampLabel = [[REDateLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.commentThumbnailView.frame), CGRectGetMaxY(self.commentThumbnailView.frame) + 5, 0, 0)];
        commentTimeStampLabel.numberOfLines = 1;
        //        [blogTimeStampLabel setTextColor:[UIColor whiteColor]];
        [commentTimeStampLabel setBackgroundColor:[UIColor clearColor]];
        [commentTimeStampLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self addSubview:commentTimeStampLabel];
    }
    return commentTimeStampLabel;
}

-(UILabel *)commentAuthorNameLabel{
    if (!commentAuthorNameLabel) {
        commentAuthorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.commentThumbnailView.frame) + 5, 0, 0)];
        commentAuthorNameLabel.numberOfLines = 1;
        //        [blogAuthorNameLabel setTextColor:[UIColor whiteColor]];
        [commentAuthorNameLabel setBackgroundColor:[UIColor clearColor]];
        [commentAuthorNameLabel setFont:[UIFont systemFontOfSize:12.0]];
        [commentAuthorNameLabel setText:@"Napolean Bonaparto"];
//        [self addSubview:commentAuthorNameLabel];
    }
    return commentAuthorNameLabel;
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.commentShortTextLabel.text = nil;
    self.commentTitleLabel.text = nil;
    self.commentTimeStampLabel.text = nil;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.commentThumbnailView setFrame:CGRectMake(5, 5, 40, 36)];
    [self.commentTitleLabel setFrame:CGRectMake(CGRectGetMaxX(self.commentThumbnailView.frame) + 10, 5, self.contentView.frame.size.width - (CGRectGetMaxX(self.commentThumbnailView.frame) + 20), 25)];
    
    
    NSString *comment = self.commentShortTextLabel.text;
    
    CGSize constraint = CGSizeMake(self.contentView.bounds.size.width - 70, CGFLOAT_MAX);
    
    CGSize size = [comment sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.commentShortTextLabel setFrame:CGRectMake(CGRectGetMaxX(self.commentThumbnailView.frame) + 10, CGRectGetMaxY(self.commentTitleLabel.frame) + 0, size.width, size.height)];
    
    CGFloat y = 0.0;
    
    y = (CGRectGetMaxY(self.commentThumbnailView.frame)) > CGRectGetMaxY(self.commentShortTextLabel.frame) == true ? (CGRectGetMaxY(self.commentThumbnailView.frame)) : CGRectGetMaxY(self.commentShortTextLabel.frame);
    
    
    [self.commentTimeStampLabel setFrame:CGRectMake(CGRectGetMinX(commentShortTextLabel.frame), y + 10, 0, 0)];
    [self.commentTimeStampLabel sizeToFit];
    
    CGFloat constrainedWidth = 100.0f;
    NSString *text = @"Author's Name";
    CGSize sizeText = [text sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(constrainedWidth, CGFLOAT_MAX)];
    
    [self.commentAuthorNameLabel setFrame:CGRectMake(self.frame.size.width - sizeText.width - 10 , y + 10, constrainedWidth, 15)];
}

@end
