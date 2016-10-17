//
//  TYHInternalAssetGridToolBar.m
//  TaiYangHua
//
//  Created by Lc on 16/2/17.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "VeFileManagerToolBar.h"
#import "UIImage+TYHSetting.h"
#import "VeFileObjModel.h"
#import "Masonry.h"
#define color01a  [UIColor colorWithRed:0.004 green:0.651 blue:0.996 alpha:1.000]

@interface VeFileManagerToolBar ()

//@property (weak, nonatomic) UIButton *originalButton;
@property (weak, nonatomic) UIButton *senderButton;
@property (weak, nonatomic) UILabel *originalLabel;
@property (assign, nonatomic) NSInteger bytes;

@end

@implementation VeFileManagerToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectedItems = @[].mutableCopy;
//        [self originalButton];
        [self originalLabel];
        [self senderButton];
    }
    return self;
}

#pragma mark - lazy
//- (UIButton *)previewButton
//{
//    if (!_previewButton) {
//        UIButton *previewButton = [[UIButton alloc] init];
//        [previewButton setTitle:@"预览" forState:UIControlStateNormal];
//        [previewButton setTitleColor:color227shallblue forState:UIControlStateNormal];
//        [previewButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
//        [previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
//        [previewButton setEnabled:NO];
//        [previewButton addTarget:self action:@selector(clickPreviewButton:) forControlEvents:UIControlEventTouchUpInside];
//        _previewButton = previewButton;
//        [self addSubview:_previewButton];
//    }
//    
//    return _previewButton;
//}

//- (UIButton *)originalButton
//{
//    if (!_originalButton) {
//        UIButton *originalButton = [[UIButton alloc] init];
//        [originalButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
//        [originalButton setTitle:@"总大小" forState:UIControlStateNormal];
//        [originalButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [originalButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
//        [originalButton setImage:[UIImage imageNamed:@"notselect"] forState:UIControlStateNormal];
//        [originalButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
//        [originalButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//        [originalButton setUserInteractionEnabled:NO];
//        [originalButton addTarget:self action:@selector(clickOriginalButton:) forControlEvents:UIControlEventTouchUpInside];
//        _originalButton = originalButton;
//        [self addSubview:_originalButton];
//    }
//    
//    return _originalButton;
//}

- (UILabel *)originalLabel
{
    if (!_originalLabel) {
        UILabel *originalLabel = [[UILabel alloc] init];
        [originalLabel setFont:[UIFont systemFontOfSize:14]];
        [originalLabel setTextColor:color01a];
        _originalLabel = originalLabel;
        [self addSubview:_originalLabel];
    }
    
    return _originalLabel;
}

- (UIButton *)senderButton
{
    if (!_senderButton) {
        UIButton *senderButton = [[UIButton alloc] init];
        [senderButton setBackgroundImage:[UIImage createImageWithColor:color01a] forState:UIControlStateNormal];
        [senderButton setBackgroundImage:[UIImage createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
        [senderButton setTitle:@"发送" forState:UIControlStateDisabled];
        [senderButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [senderButton.layer setCornerRadius:5];
        [senderButton.layer setMasksToBounds:YES];
        [senderButton setEnabled:NO];
        [senderButton addTarget:self action:@selector(clickSenderButton:) forControlEvents:UIControlEventTouchUpInside];
        _senderButton = senderButton;
        [self addSubview:_senderButton];
    }
    
    return _senderButton;
}

#pragma mark - allButton Action
- (void)clickPreviewButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didClickPreviewInAssetGridToolBar:)]) {
        [self.delegate didClickPreviewInAssetGridToolBar:self];
    }
}

- (void)clickOriginalButton:(UIButton *)button
{
    button.selected = !button.isSelected;
//    self.originalLabel.hidden = !button.isSelected;
    [self calculateAllselectedItemsBytes];
}

- (void)clickSenderButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didClickSenderButtonInAssetGridToolBar:)]) {
        [self.delegate didClickSenderButtonInAssetGridToolBar:self];
    }
}

- (void)setSelectedItems:(NSMutableArray *)selectedItems
{
     _selectedItems = selectedItems;
    
    // 按钮能否点击
//    self.previewButton.enabled = selectedItems.count > 0 ? YES : NO;
//    self.originalButton.userInteractionEnabled = selectedItems.count > 0 ? YES : NO;
    self.senderButton.enabled = selectedItems.count > 0 ? YES : NO;
    
    // 按钮是否显示
//    if (selectedItems.count == 0) self.originalButton.selected = NO;
    if (selectedItems.count > 0) [self.senderButton setTitle:[NSString stringWithFormat:@"%@(%ld)", @"发送", selectedItems.count] forState:UIControlStateNormal];
//    if (selectedItems.count == 0) self.originalLabel.hidden = YES;
    
    // 显示大小
    [self calculateAllselectedItemsBytes];
}

// 计算所有选中文件的大小
- (void)calculateAllselectedItemsBytes
{
        __block NSInteger dataLength = 0;
        __block NSInteger lastSelectedItem = 0;
        NSString *bytes = nil;

        for (VeFileObjModel *fileObj in self.selectedItems) {
            lastSelectedItem++;
            dataLength += fileObj.fileSizefloat;
            
        }
        if (lastSelectedItem == self.selectedItems.count) {
            //                NSString *bytes = nil;
            if (dataLength >= 0.1 * (1000 * 1000)) {
                bytes = [NSString stringWithFormat:@"%0.1fM",dataLength/1000/1000.0];
            } else if (dataLength >= 1000) {
                bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1000.0];
            } else {
                bytes = [NSString stringWithFormat:@"%zdB",dataLength];
            }
            
            
        }
    if ([bytes isEqualToString:@"0B"]) {
        self.originalLabel.hidden = YES;
    }else{
        self.originalLabel.hidden = NO;
    }
        self.originalLabel.text = [NSString stringWithFormat:@"总文件大小约(%@)", bytes];


}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];

//    [_originalButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(10);
//        make.width.equalTo(@(90));
//        make.centerY.equalTo(self);
//    }];
    
    [_originalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
                make.left.equalTo(self).offset(10);
    }];
    [_originalLabel sizeToFit];
    [_senderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.centerY.equalTo(self);
        make.height.equalTo(@(29));
        make.width.equalTo(@(68));
    }];
}

@end
