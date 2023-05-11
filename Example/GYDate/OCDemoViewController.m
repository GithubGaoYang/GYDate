//
//  OCDemoViewController.m
//  GYDate_Example
//
//  Created by 高扬 on 2023/5/11.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

#import "OCDemoViewController.h"
#import "GYDate_Example-Swift.h"
@import GYDate;

@interface OCDemoViewController ()

@property (nonatomic, copy) UILabel * systemTimeTagLabel;
@property (nonatomic, copy) UILabel * systemTimeLabel;
@property (nonatomic, copy) UILabel * serverTimeTagLabel;
@property (nonatomic, copy) UILabel * serverTimeLabel;
@property (nonatomic, copy) UIButton * syncButton;

@end

@implementation OCDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    // 定时器 - 每秒钟执行一次
    [[[GYTimer alloc] init] start:^{
        self.systemTimeLabel.text = [[NSDate date] description];
        self.serverTimeLabel.text = [[GYDate date] description];
    }];
}

// MARK: - Private Methods

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // add subviews
    [self.view addSubview:self.systemTimeTagLabel];
    [self.view addSubview:self.systemTimeLabel];
    [self.view addSubview:self.serverTimeTagLabel];
    [self.view addSubview:self.serverTimeLabel];
    [self.view addSubview:self.syncButton];
    
    // layouts
    [self.systemTimeTagLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.systemTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.serverTimeTagLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.serverTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.syncButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraints:@[
        [NSLayoutConstraint constraintWithItem:self.systemTimeTagLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
        
        [NSLayoutConstraint constraintWithItem:self.systemTimeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.systemTimeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.systemTimeTagLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:8],
        
        [NSLayoutConstraint constraintWithItem:self.serverTimeTagLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.serverTimeTagLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.serverTimeTagLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.systemTimeLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:16],
        
        [NSLayoutConstraint constraintWithItem:self.serverTimeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.serverTimeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.serverTimeTagLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:8],
        
        [NSLayoutConstraint constraintWithItem:self.syncButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.syncButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.serverTimeLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:16]
    ]];
}

// MARK: Actions

- (void)syncButtonAction {
    [self.syncButton setTitle:@"正在同步" forState:UIControlStateNormal];
    
    [GYDate syncServerDateWith:[NSURL URLWithString:@"https://www.baidu.com/"] dateFormat:@"EEE, dd MMM yyyy HH:mm:ss z" success:^(NSDate * _Nullable date) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.syncButton setTitle:@"重新同步" forState:UIControlStateNormal];
        });
        
    } failure:^(NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.syncButton setTitle:@"正在同步" forState:UIControlStateNormal];
        });
        
    }];
}

// MARK: - Lazy Initialization

- (UILabel *)systemTimeTagLabel {
    if (!_systemTimeTagLabel) {
        UILabel * systemTimeTagLabel = [[UILabel alloc] init];
        systemTimeTagLabel.numberOfLines = 0;
        systemTimeTagLabel.textAlignment = NSTextAlignmentCenter;
        systemTimeTagLabel.text = @"系统时间：";
        _systemTimeTagLabel = systemTimeTagLabel;
    }
    return _systemTimeTagLabel;
}

- (UILabel *)systemTimeLabel {
    if (!_systemTimeLabel) {
        UILabel * systemTimeLabel = [[UILabel alloc] init];
        systemTimeLabel.numberOfLines = 0;
        systemTimeLabel.textAlignment = NSTextAlignmentCenter;
        systemTimeLabel.text = [[NSDate date] description];
        _systemTimeLabel = systemTimeLabel;
    }
    return _systemTimeLabel;
}

- (UILabel *)serverTimeTagLabel {
    if (!_serverTimeTagLabel) {
        UILabel * serverTimeTagLabel = [[UILabel alloc] init];
        serverTimeTagLabel.numberOfLines = 0;
        serverTimeTagLabel.textAlignment = NSTextAlignmentCenter;
        serverTimeTagLabel.text = @"服务器时间";
        _serverTimeTagLabel = serverTimeTagLabel;
    }
    return _serverTimeTagLabel;
}

- (UILabel *)serverTimeLabel {
    if (!_serverTimeLabel) {
        UILabel * serverTimeLabel = [[UILabel alloc] init];
        serverTimeLabel.numberOfLines = 0;
        serverTimeLabel.textAlignment = NSTextAlignmentCenter;
        serverTimeLabel.text = [[GYDate date] description];
        _serverTimeLabel = serverTimeLabel;
    }
    return _serverTimeLabel;
}

- (UIButton *)syncButton {
    if (!_syncButton) {
        UIButton * syncButton = [[UIButton alloc] init];
        syncButton.backgroundColor = [UIColor redColor];
        syncButton.contentEdgeInsets = UIEdgeInsetsMake(10, 30, 10, 30);
        switch (GYDate.syncState) {
            case DateSyncStateUnsynced:
                [syncButton setTitle:@"点击同步" forState:UIControlStateNormal];
                break;
                
            case DateSyncStateSyncing:
                [syncButton setTitle:@"正在同步" forState:UIControlStateNormal];
                break;
                
            case DateSyncStateFailed:
                [syncButton setTitle:@"同步失败" forState:UIControlStateNormal];
                break;
                
            case DateSyncStateSynced:
                [syncButton setTitle:@"重新同步" forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
        [syncButton addTarget:self action:@selector(syncButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _syncButton = syncButton;
    }
    return _syncButton;
}

@end
