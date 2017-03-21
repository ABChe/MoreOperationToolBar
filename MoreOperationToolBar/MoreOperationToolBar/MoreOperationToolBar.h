//
//  MoreOperationToolBar.h
//  MoreOperationToolBar
//
//  Created by 车 on 17/3/20.
//  Copyright © 2017年 abche. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MoreOperationToolBarType) {
    MoreOperationToolBarTypeDelete      = 0,    // 删除
    MoreOperationToolBarTypeMove,               // 移动
    MoreOperationToolBarTypeRename              // 重命名
};


@interface MoreOperationToolBarModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageNormal;
@property (nonatomic, strong) NSString *imageSelected;
@property (nonatomic, assign) MoreOperationToolBarType operationType;

+ (instancetype)initWithTitle:(NSString *)title
                  imageNormal:(NSString *)imageNormal
                imageSelected:(NSString *)imageSelected
                operationType:(MoreOperationToolBarType)operationType;
@end


@class MoreOperationToolBar;
@protocol MoreOperationToolBarDelegate <NSObject>

- (void)toolBar:(MoreOperationToolBar *)toolBar didSelectOperationType:(MoreOperationToolBarType)operationType;

@end

@interface MoreOperationToolBar : UIView

@property (nonatomic, strong) NSMutableArray<MoreOperationToolBarModel *> *itemArray;
@property (nonatomic, weak) id <MoreOperationToolBarDelegate> delegate;

- (instancetype)initWithItemArray:(NSArray<MoreOperationToolBarModel *> *)itemArray;

- (void)showView;

@end
