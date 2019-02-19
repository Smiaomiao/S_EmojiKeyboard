//
//  S_CustomEmojiKeyBoard.h
//  affinityApp
//
//  Created by apple on 2019/2/19.
//  Copyright © 2019年 杜菲. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CustomEmojiDelegate;


@interface S_CustomEmojiKeyBoard : UIView

@property (nonatomic, weak) id<CustomEmojiDelegate> delegate;

//当前输入控件
@property (nonatomic, strong) UITextField *insertTF;
@property (nonatomic, strong) UITextView *inserTV;


@end


@protocol CustomEmojiDelegate <NSObject>

@optional

//输入表情时回调
- (void)didClickEmojiLabel:(NSString *)emojiStr;

//点击键盘发送时回调
- (void)didClickSendEmojiBtn;

@end
NS_ASSUME_NONNULL_END
