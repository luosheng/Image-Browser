//
//  XANThumbCell.m
//  XANPhotoBrowser
//
//  Created by Chen Xian'an on 12/17/10.
//  Copyright 2010 lazyapps.com. All rights reserved.
//

#import "XANThumbsCell.h"
#import <QuartzCore/QuartzCore.h>

#define TAG_BASE 1000

@interface XANThumbsCell()
- (CGRect)buttonFrameAtColumn:(NSUInteger)column;
- (UIButton *)createButtonForColumn:(NSUInteger)column;
@end

@implementation XANThumbsCell
@synthesize numberOfImages, capacityOfImages, rowIndex;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier 
                thumbDelegate:(NSObject <XANThumbsCellDelegate> *)theThumbDelegate

{
  if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]){
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    thumbDelegate = theThumbDelegate;
  }
  
  return self;
}

- (void)dealloc
{
  thumbDelegate = nil;

  [super dealloc];
}

- (void)layoutSubviews
{
  [super layoutSubviews];

  CGRect r = self.contentView.frame;
  r.size.width = self.bounds.size.width;
  self.contentView.frame = r;

  NSUInteger numberOfButtons = [self.contentView.subviews count];
  if (numberOfButtons == 0) numberOfButtons = numberOfImages;

  for (NSUInteger i=0; i<numberOfButtons; i++){
    UIButton *button = (UIButton *)[self.contentView viewWithTag:TAG_BASE+i];
    if (i < numberOfImages){
      if (!button) [self createButtonForColumn:i];
      else button.frame = [self buttonFrameAtColumn:i];
    } else {
      [button removeFromSuperview];
    }
  }
}

#pragma mark methods
- (void)updateImage:(UIImage *)image 
          forColumn:(NSUInteger)column
{
  UIButton *button = (UIButton *)[self.contentView viewWithTag:TAG_BASE+column];
  if (!button){
    button = [self createButtonForColumn:column];
  }
  
  [button setImage:image forState:UIControlStateNormal];
}

#pragma mark button action
- (void)didTouchButton:(UIButton *)button
{
  if (thumbDelegate && [thumbDelegate respondsToSelector:@selector(didSelectPhotoAtIndex:inRow:)]){
    [thumbDelegate didSelectPhotoAtIndex:(button.tag-TAG_BASE) inRow:rowIndex];
  }
}

#pragma mark privates
- (CGRect)buttonFrameAtColumn:(NSUInteger)column
{
  CGFloat x = (self.bounds.size.width - kImageSize.width * capacityOfImages - kSpacing * (capacityOfImages-1)) / 2;
  if (column > 0)
    x += (kImageSize.width + kSpacing) * column;
  
  return CGRectMake(x, 0, kImageSize.width, kImageSize.height);
}

- (UIButton *)createButtonForColumn:(NSUInteger)column
{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.tag = TAG_BASE + column;
  button.layer.borderWidth = 1.0;
  button.layer.borderColor = [UIColor darkGrayColor].CGColor;
  [button addTarget:self action:@selector(didTouchButton:) forControlEvents:UIControlEventTouchUpInside];
  button.frame = [self buttonFrameAtColumn:column];
  [self.contentView addSubview:button];

  return button;
}

@end
