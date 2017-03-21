//
//  MoreOperationToolBar.m
//  MoreOperationToolBar
//
//  Created by 车 on 17/3/20.
//  Copyright © 2017年 abche. All rights reserved.
//

#import "MoreOperationToolBar.h"

#define kAnimationTime      0.3
#define kItemHeight         60
#define kItemCountPreRow    4
#define kImageVLineHeight   20
#define kCancelButtonHeight 50
#define kCellTitleColor       [UIColor blackColor]
#define kCellTitleSelectColor [UIColor greenColor]
#define kScreenWidth          CGRectGetWidth([[UIScreen mainScreen] bounds])
#define kScreenHeight         CGRectGetHeight([[UIScreen mainScreen] bounds])
//#define kRandomColor          [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/  \
//                              255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
#define kRandomColor          [UIColor whiteColor]

@implementation MoreOperationToolBarModel

+ (instancetype)initWithTitle:(NSString *)title imageNormal:(NSString *)imageNormal imageSelected:(NSString *)imageSelected operationType:(MoreOperationToolBarType)operationType {
    MoreOperationToolBarModel *model = [[MoreOperationToolBarModel alloc] init];
    model.title = title;
    model.imageNormal = imageNormal;
    model.imageSelected = imageSelected;
    model.operationType = operationType;
    return model;
}
@end


@interface MoreOperationToolBarCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageVIcon;
@property (nonatomic, strong) UILabel *labelTitle;

- (void)setCellWithModel:(MoreOperationToolBarModel *)model;

@end

@implementation MoreOperationToolBarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kRandomColor;
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.imageVIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageVIcon];
    
    self.labelTitle = [[UILabel alloc] init];
    self.labelTitle.font = [UIFont systemFontOfSize:16];
    self.labelTitle.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.labelTitle];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageVIcon.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 - 10, 10, 20, 20);
    self.labelTitle.frame = CGRectMake(0, 10 + 20 + 7, CGRectGetWidth(self.frame), 13);
}

- (void)setCellWithModel:(MoreOperationToolBarModel *)model {
    self.labelTitle.textColor = kCellTitleColor;
    self.imageVIcon.image = [UIImage imageNamed:model.imageNormal];
    self.labelTitle.text  = model.title;
}
@end


static NSString *MOTBCellMain = @"MOTBCellMain";

@interface MoreOperationToolBar ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *imageVLine;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) CGFloat collectionViewHeight;

@end

@implementation MoreOperationToolBar


#pragma mark - Init

- (instancetype)initWithItemArray:(NSArray<MoreOperationToolBarModel *> *)itemArray {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.itemArray = [NSMutableArray arrayWithArray:itemArray];
        [self addSubview:self.maskView];
        [self addSubview:self.mainView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _collectionView.frame = CGRectMake(0, 0, kScreenWidth, self.collectionViewHeight);
    _imageVLine.frame     = CGRectMake(0, self.collectionViewHeight, kScreenWidth, kImageVLineHeight);
    _cancelButton.frame   = CGRectMake(0, self.collectionViewHeight + kImageVLineHeight, kScreenWidth, kCancelButtonHeight);
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.itemArray count];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MoreOperationToolBarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MOTBCellMain forIndexPath:indexPath];
    MoreOperationToolBarModel *model = self.itemArray[indexPath.row];
    [cell setCellWithModel:model];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MoreOperationToolBarCollectionViewCell *cell = (MoreOperationToolBarCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    MoreOperationToolBarModel *model = self.itemArray[indexPath.row];
    cell.labelTitle.textColor = kCellTitleSelectColor;
    cell.imageVIcon.image = [UIImage imageNamed:model.imageSelected];
    
    if ([self.delegate respondsToSelector:@selector(toolBar:didSelectOperationType:)]) {
        MoreOperationToolBarModel *model = self.itemArray[indexPath.row];
        [self.delegate toolBar:self didSelectOperationType:model.operationType];
    }
    [self tapMaskView];
}


#pragma mark - Methods

- (void)clickCancelButton {
    [self tapMaskView];
}

- (void)tapMaskView {
    [CATransaction begin];
    
    [UIView animateWithDuration:kAnimationTime animations:^{
        self.mainView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 0);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    [CATransaction commit];
}

- (void)showView {
    UIWindow *window =[[[UIApplication sharedApplication] windows] lastObject];
    [window addSubview: self];
    self.mainView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 0);
    
    [CATransaction begin];

    [UIView animateWithDuration:kAnimationTime animations:^{
        self.mainView.frame = CGRectMake(0, kScreenHeight - self.collectionViewHeight - 20 - kCancelButtonHeight, kScreenWidth, self.collectionViewHeight + kImageVLineHeight + kCancelButtonHeight);
        
    } completion:^(BOOL finished) {
        
    }];
    
    [CATransaction commit];
}


#pragma mark - Lazyloading

- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tapMaskView)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (UIView *)mainView {
    if (_mainView == nil) {
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = [UIColor whiteColor];
        [_mainView addSubview:self.collectionView];
        [_mainView addSubview:self.imageVLine];
        [_mainView addSubview:self.cancelButton];
    }
    return _mainView;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:self.flowLayout];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MoreOperationToolBarCollectionViewCell class] forCellWithReuseIdentifier:MOTBCellMain];
        _collectionView.backgroundColor = kRandomColor;
    }
    return _collectionView;
}

- (UIImageView *)imageVLine {
    if (_imageVLine == nil) {
        _imageVLine = [[UIImageView alloc] init];
        _imageVLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }
    return _imageVLine;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.backgroundColor = kRandomColor;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(kScreenWidth / kItemCountPreRow, kItemHeight);
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
    }
    return _flowLayout;
}


#pragma mark - Setter

- (void)setItemArray:(NSMutableArray<MoreOperationToolBarModel *> *)itemArray {
    _itemArray = itemArray;
    self.collectionViewHeight = (self.itemArray.count / kItemCountPreRow) * kItemHeight + ((self.itemArray.count % kItemCountPreRow) ? kItemHeight : 0);
    [self.collectionView reloadData];
}


@end
