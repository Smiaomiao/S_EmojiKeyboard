//
//  S_CustomEmojiKeyBoard.m
//  affinityApp
//
//  Created by apple on 2019/2/19.
//  Copyright © 2019年 杜菲. All rights reserved.
//

//系统表情
#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);


#import "S_CustomEmojiKeyBoard.h"

@interface S_CustomEmojiKeyBoard () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *emojiCollectionView;
@property (nonatomic, strong) NSMutableArray *emojiArr;//系统表情数组
@property (nonatomic, strong) UIView *footerActionView;//底部view
@property (nonatomic, strong) UIButton *sendBtn;//发送按钮

@property (nonatomic, assign) NSInteger showLineNum;//一行显示几个
@property (nonatomic, assign) NSInteger showPageNum;//一页显示几个

@property (nonatomic, assign) CGFloat emojiSpace;//表情之间的间距
@property (nonatomic, assign) CGFloat emojiSize;//表情显示大小


@end

@implementation S_CustomEmojiKeyBoard
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showLineNum = 9;
        self.showPageNum = self.showLineNum * 3;
        self.emojiSpace = 15;
        self.emojiSize = 30;
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.emojiCollectionView];
    [self addSubview:self.footerActionView];
    [self.footerActionView addSubview:self.sendBtn];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return (self.emojiArr.count / self.showPageNum) + (self.emojiArr.count % self.showPageNum == 0 ? 0 : 1);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.showPageNum;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.emojiSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.emojiSpace;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.emojiSize, self.emojiSize);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //每个分区的左右边距
    CGFloat sectionOffset = (CGRectGetWidth(self.frame) - self.showLineNum * self.emojiSize - (self.showLineNum - 1) * self.emojiSpace) / 2;
    //分区内容偏移
    return UIEdgeInsetsMake(self.emojiSize, sectionOffset, self.emojiSize, sectionOffset);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"S_EmojiCollectionCellIdentifier" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UICollectionViewCell alloc]init];
    }
    
    [self setCell:cell withIndexPath:indexPath];
    
    return cell;
}

- (void)setCell:(UICollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *emojiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.emojiSize, self.emojiSize)];
    if (self.showPageNum * indexPath.section + indexPath.item < self.emojiArr.count) {
        emojiLabel.text = self.emojiArr[indexPath.section * self.showPageNum + indexPath.row];
    }else {
        emojiLabel.text = @"";
    }
    emojiLabel.font = [UIFont systemFontOfSize:25];
    [cell.contentView addSubview:emojiLabel];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *emojiStr = @"";
    if (self.showPageNum * indexPath.section + indexPath.item < self.emojiArr.count) {
        emojiStr = self.emojiArr[indexPath.section * self.showPageNum + indexPath.row];
    }
    //NSLog(@"表情 %@", emojiStr);
    if (self.inserTV) {
        self.inserTV.text = [self.inserTV.text stringByAppendingString:emojiStr];
        [self.inserTV insertText:@""];
    } else if (self.insertTF) {
        self.insertTF.text = [self.insertTF.text stringByAppendingString:emojiStr];
        [self.insertTF insertText:@""];
    } else {
        NSLog(@"未设置输入框");
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickEmojiLabel:)]) {
        [self.delegate didClickEmojiLabel:emojiStr];
    }
}

//发送表情
- (void)sendEmoji {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSendEmojiBtn)]) {
        [self.delegate didClickSendEmojiBtn];
    }
}

#pragma mark - Get
//表情包
- (NSArray *)defaultEmoticons {
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0x1F600; i <= 0x1F64F; i++) {
        if (i < 0x1F641 || i > 0x1F644) {
            int sym = EMOJI_CODE_TO_SYMBOL(i);
            NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
            [array addObject:emoT];
        }
    }
    return array;
}

- (NSMutableArray *)emojiArr {
    if (!_emojiArr) {
        _emojiArr = [[NSMutableArray alloc]init];
        [_emojiArr addObjectsFromArray:[self defaultEmoticons]];
    }
    return _emojiArr;
}

- (UICollectionView *)emojiCollectionView {
    if (!_emojiCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _emojiCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 50) collectionViewLayout:layout];
        _emojiCollectionView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        _emojiCollectionView.delegate = self;
        _emojiCollectionView.dataSource = self;
        _emojiCollectionView.bounces = NO;
        _emojiCollectionView.pagingEnabled = YES;
        _emojiCollectionView.showsVerticalScrollIndicator = NO;
        _emojiCollectionView.showsHorizontalScrollIndicator = NO;
        [_emojiCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"S_EmojiCollectionCellIdentifier"];
    }
    return _emojiCollectionView;
}

- (UIView *)footerActionView {
    if (!_footerActionView) {
        _footerActionView = [[UIView alloc]init];
        _footerActionView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        CGFloat bottomHeight = 50;
        _footerActionView.frame = CGRectMake(0, self.frame.size.height - bottomHeight, self.frame.size.width, 50);
    }
    return _footerActionView;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(self.frame.size.width - 70, 0, 70, 50);
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:[UIColor redColor]];
        [_sendBtn addTarget:self action:@selector(sendEmoji) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

@end

