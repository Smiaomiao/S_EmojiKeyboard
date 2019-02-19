//
//  ViewController.m
//  S_CustomEmojiKeyboard
//
//  Created by apple on 2019/2/19.
//  Copyright © 2019年 dufei. All rights reserved.
//

#import "ViewController.h"
#import "S_CustomEmojiKeyBoard.h"

@interface ViewController ()<CustomEmojiDelegate>

@property (nonatomic, strong) UITextField *inserTF;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) S_CustomEmojiKeyBoard *emojiKeyboard;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.inserTF];
    [self.view addSubview:self.changeBtn];
    [self.view addSubview:self.sendBtn];
}


- (UITextField *)inserTF {
    if (!_inserTF) {
        _inserTF = [[UITextField alloc]initWithFrame:CGRectMake(20, 100, 150, 40)];
        _inserTF.font = [UIFont systemFontOfSize:15];
        _inserTF.backgroundColor = [UIColor redColor];
        _inserTF.textColor = [UIColor whiteColor];
    }
    return _inserTF;
}

- (UIButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeBtn.frame = CGRectMake(190, 100, 50, 40);
        [_changeBtn setTitle:@"表情" forState:UIControlStateNormal];
        [_changeBtn setTitle:@"键盘" forState:UIControlStateSelected];
        [_changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _changeBtn.backgroundColor = [UIColor blueColor];
        [_changeBtn addTarget:self action:@selector(changeEmoji) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeBtn;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(250, 100, 50, 40);
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendBtn.backgroundColor = [UIColor blueColor];
        [_sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (S_CustomEmojiKeyBoard *)emojiKeyboard {
    if (!_emojiKeyboard) {
        _emojiKeyboard = [[S_CustomEmojiKeyBoard alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 250, CGRectGetWidth(self.view.frame), 250)];
        _emojiKeyboard.delegate = self;
        _emojiKeyboard.insertTF = self.inserTF;
    }
    return _emojiKeyboard;
}

#pragma mark - EmojiDelegate
- (void)didClickSendEmojiBtn {
    [self send];
}

#pragma mark - Action
- (void)changeEmoji {
    if ([self.inserTF.inputView isKindOfClass:[S_CustomEmojiKeyBoard class]]) {
        //键盘为表情键盘时切换为普通键盘

        self.inserTF.inputView = nil;
        self.changeBtn.selected = NO;
    } else {
        //键盘为普通键盘时切换为表情键盘

        self.inserTF.inputView = self.emojiKeyboard;
        self.changeBtn.selected = YES;
    }
    
    //刷新inputView
    [self.inserTF reloadInputViews];
    
}

- (void)send {
    NSLog(@"%@",self.inserTF.text);
}

@end
