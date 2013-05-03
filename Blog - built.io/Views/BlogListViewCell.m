//
//  BlogListViewCell.m
//  Blog - built.io
//
//  Created by Samir Bhide on 14/03/13.
//  Copyright (c) 2013 raweng. All rights reserved.
//

#import "BlogListViewCell.h"
#import "REDateLabel.h"
@implementation BlogListViewCell
@synthesize blogThumbnailView, blogShortTextLabel, blogTitleLabel, blogAuthorNameLabel, blogTimeStampLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        // Initialization code
        [self.blogThumbnailView setBackgroundColor:[UIColor whiteColor]];
        self.blogThumbnailView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.blogThumbnailView.layer.shadowOffset = CGSizeMake(0, 0);
        self.blogThumbnailView.layer.shadowOpacity = 0.5;
        self.blogThumbnailView.layer.shadowRadius = 3.0;
        
        //white border part
        [self.blogThumbnailView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [self.blogThumbnailView.layer setBorderWidth: 1.0];
        
        self.blogThumbnailView.layer.cornerRadius = 3;
        self.blogThumbnailView.layer.masksToBounds = NO;
        
        UIBezierPath* bezierPath =[UIBezierPath bezierPathWithRect:CGRectMake(3, 3, 40-6, 36-6)];
        [self.blogThumbnailView.layer setShadowPath:bezierPath.CGPath];

    }
    return self;
}

-(UIImageView *)blogThumbnailView{
    if (!blogThumbnailView) {
        blogThumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 36)];
        [blogThumbnailView setImage:[UIImage imageNamed:@"111-user"]];
        [blogThumbnailView setBackgroundColor:[UIColor whiteColor]];
        [blogThumbnailView setContentMode:UIViewContentModeCenter];
        [self addSubview:blogThumbnailView];
    }
    return blogThumbnailView;
}

-(UILabel *)blogTitleLabel{
    if (!blogTitleLabel) {
        blogTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.blogThumbnailView.frame) + 10, 5, self.frame.size.width - CGRectGetMaxX(self.blogThumbnailView.frame) + 10, 50)];
        [blogTitleLabel setText:@"Short Title title title"];
        [blogTitleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        blogTitleLabel.numberOfLines = 1;
        [blogTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:blogTitleLabel];
    }
    return blogTitleLabel;
}

-(UILabel *)blogShortTextLabel{
    if (!blogShortTextLabel) {
        blogShortTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.blogThumbnailView.frame) + 10, CGRectGetMaxY(self.blogTitleLabel.frame) + 0, self.frame.size.width - CGRectGetMaxX(self.blogThumbnailView.frame) + 50, 100)];
        [blogShortTextLabel setText:@"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."];
        [blogShortTextLabel setFont:[UIFont systemFontOfSize:12.0]];
        [blogShortTextLabel setBackgroundColor:[UIColor clearColor]];
        blogShortTextLabel.numberOfLines = 2;
        [self addSubview:blogShortTextLabel];
    }
    return blogShortTextLabel;
}

-(REDateLabel *)blogTimeStampLabel{
    if (!blogTimeStampLabel) {
        blogTimeStampLabel = [[REDateLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.blogThumbnailView.frame), CGRectGetMaxY(self.blogThumbnailView.frame) + 5, 0, 0)];
        blogTimeStampLabel.numberOfLines = 1;
//        [blogTimeStampLabel setTextColor:[UIColor whiteColor]];
        [blogTimeStampLabel setBackgroundColor:[UIColor clearColor]];
        [blogTimeStampLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self addSubview:blogTimeStampLabel];
    }
    return blogTimeStampLabel;
}

-(UILabel *)blogAuthorNameLabel{
    if (!blogAuthorNameLabel) {
        blogAuthorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.blogThumbnailView.frame) + 5, 0, 0)];
        blogAuthorNameLabel.numberOfLines = 1;
        [blogAuthorNameLabel setTextColor:[UIColor darkGrayColor]];
        [blogAuthorNameLabel setBackgroundColor:[UIColor clearColor]];
        [blogAuthorNameLabel setFont:[UIFont systemFontOfSize:12.0]];
        [blogAuthorNameLabel setText:@"Napolean Bonaparto"];
//        [blogAuthorNameLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:blogAuthorNameLabel];
    }
    return blogAuthorNameLabel;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.blogThumbnailView setFrame:CGRectMake(5, 5, 40, 36)];
    [self.blogTitleLabel setFrame:CGRectMake(CGRectGetMaxX(self.blogThumbnailView.frame) + 10, 5, self.frame.size.width - (CGRectGetMaxX(self.blogThumbnailView.frame) + 20), 25)];
//    [self.blogTitleLabel sizeToFit];
    [self.blogShortTextLabel setFrame:CGRectMake(CGRectGetMaxX(self.blogThumbnailView.frame) + 10, CGRectGetMaxY(self.blogTitleLabel.frame) + 0, self.frame.size.width - (CGRectGetMaxX(self.blogThumbnailView.frame) + 20), 0)];
    [self.blogShortTextLabel sizeToFit];
    
    [self.blogTimeStampLabel setFrame:CGRectMake(CGRectGetMinX(self.blogShortTextLabel.frame), CGRectGetMaxY(self.blogThumbnailView.frame) + 24, 0, 0)];
    [self.blogTimeStampLabel sizeToFit];
    
    CGFloat constrainedWidth = 100.0f;
    NSString *text = self.blogAuthorNameLabel.text;
    CGSize sizeText = [text sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(constrainedWidth, CGFLOAT_MAX)];
    
    [self.blogAuthorNameLabel setFrame:CGRectMake((self.contentView.frame.size.width - sizeText.width)-10, CGRectGetMaxY(self.blogThumbnailView.frame) + 24, sizeText.width, 15)];

//    [self.blogAuthorNameLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [self.blogThumbnailView setBackgroundColor:[UIColor whiteColor]];
    // Configure the view for the selected state
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    [self.blogThumbnailView setBackgroundColor:[UIColor whiteColor]];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    blogShortTextLabel.text = nil;
    blogTitleLabel.text = nil;
    blogTimeStampLabel.text = nil;
    blogAuthorNameLabel.text = nil;
}
@end
