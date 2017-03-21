//
//  ViewController.m
//  MoreOperationToolBar
//
//  Created by 车 on 17/3/20.
//  Copyright © 2017年 abche. All rights reserved.
//

#import "ViewController.h"
#import "MoreOperationToolBar.h"

@interface ViewController ()<MoreOperationToolBarDelegate>

@property (nonatomic, strong) MoreOperationToolBar *toolBar;
@property (nonatomic, strong) NSMutableArray *itemArray;

@end

@implementation ViewController {
    BOOL _single;
}


#pragma mark - Init

- (void)viewDidLoad {
    [super viewDidLoad];
    _single = YES;
}


#pragma mark - Responder

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_single) {
        self.toolBar.itemArray = [NSMutableArray arrayWithArray:self.itemArray];
    } else {
        self.toolBar.itemArray = [NSMutableArray arrayWithArray:[self.itemArray subarrayWithRange:NSMakeRange(0, 3)]];
    }
    [self.toolBar showView];
    _single= !_single;
}


#pragma mark - MoreOperationToolBarDelegate

- (void)toolBar:(MoreOperationToolBar *)toolBar didSelectOperationType:(MoreOperationToolBarType)operationType {
    NSLog(@"operationType---%ld",operationType);
}


#pragma mark - Lazyloading

- (MoreOperationToolBar *)toolBar {
    if (_toolBar == nil) {
        _toolBar = [[MoreOperationToolBar alloc] initWithItemArray:self.itemArray];
        _toolBar.delegate = self;
    }
    return _toolBar;
}

- (NSMutableArray *)itemArray {
    if (_itemArray == nil) {
        MoreOperationToolBarModel *model1 = [MoreOperationToolBarModel initWithTitle:@"删除"
                                                                         imageNormal:@"删除"
                                                                       imageSelected:@"删除-可编辑"
                                                                       operationType:MoreOperationToolBarTypeDelete];
        MoreOperationToolBarModel *model2 = [MoreOperationToolBarModel initWithTitle:@"移动"
                                                                         imageNormal:@"删除"
                                                                       imageSelected:@"删除-可编辑"
                                                                       operationType:MoreOperationToolBarTypeMove];
        MoreOperationToolBarModel *model3 = [MoreOperationToolBarModel initWithTitle:@"重命名"
                                                                         imageNormal:@"删除"
                                                                       imageSelected:@"删除-可编辑"
                                                                       operationType:MoreOperationToolBarTypeRename];
        _itemArray = [NSMutableArray arrayWithObjects:model1, model2, model3, model1, model2, model3, nil];
    }
    return _itemArray;
}

@end
