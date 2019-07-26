//
//  WalletChooseNodeView.m
//  walletSDKDemo
//
//  Created by VeChain on 2019/1/30.
//  Copyright © 2019 VeChain. All rights reserved.
//
// This code is distributed under the terms and conditions of the MIT license. 

/**
    Copyright (c) 2019 VeChain <support@vechain.com>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

**/



#import "WalletChooseNodeView.h"
#import "WalletDemoMacro.h"
#import "WalletUtils.h"


@interface WalletChooseNodeView()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_nodeList;    /* It is used to save all the node environment */
}
@end


@implementation WalletChooseNodeView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}


/**
*  Config subviews and load it.
*/
- (void)initView{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [bgView setAlpha:0.4];
    bgView.backgroundColor = [UIColor blackColor];
    [self addSubview:bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
    [bgView addGestureRecognizer:tap];
    [tap setNumberOfTapsRequired:1];
    
    
    UIView *chooseNodeCotainView = [[UIView alloc] init];
    chooseNodeCotainView.backgroundColor = UIColor.whiteColor;
    [self addSubview:chooseNodeCotainView];
    
    NSArray *nodeList = [[NSUserDefaults standardUserDefaults] objectForKey:@"nodeList"];
    _nodeList = [NSMutableArray array];
    
    NSMutableDictionary *dictMain = [NSMutableDictionary dictionary];
    [dictMain setObject:NSLocalizedString(@"item0", nil) forKey:@"nodeName"];
    [dictMain setObject:Main_Node forKey:@"nodeUrl"];
    [_nodeList addObject:dictMain];
    
    NSMutableDictionary *dictTest = [NSMutableDictionary dictionary];
    [dictTest setObject:NSLocalizedString(@"item1", nil) forKey:@"nodeName"];
    [dictTest setObject:Test_Node forKey:@"nodeUrl"];
    [_nodeList addObject:dictTest];

    if (nodeList.count > 0) {
        [_nodeList addObjectsFromArray:nodeList];
    }
    
    if (_nodeList.count >= 6) {
        chooseNodeCotainView.frame = CGRectMake(self.frame.size.width - 200, 80, 180, 50 * 6 + 10 + 50);
        
    }else {
        chooseNodeCotainView.frame = CGRectMake(self.frame.size.width - 200, 80, 180, 50 * _nodeList.count + 10 + 50);
    }
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:chooseNodeCotainView.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [chooseNodeCotainView addSubview:tableView];
    
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 50)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(15, 0, 165, 50);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setTitle:NSLocalizedString(@"item2", nil) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addNode) forControlEvents:UIControlEventTouchUpInside];
    [footV addSubview:btn];
    tableView.tableFooterView = footV;
}


#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _nodeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndef = @"cellIndef";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndef];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndef];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(15, 49, 165, 1.0)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:line];
    }
    NSDictionary *dict = _nodeList[indexPath.row];
    cell.textLabel.text = dict[@"nodeName"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = _nodeList[indexPath.row];
    NSString *serverName = dict[@"nodeName"];
    NSString *serverUrl = dict[@"nodeUrl"];
    
    if (_block) {
        _block(serverName, serverUrl);
    }
    
    if (serverUrl.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"currentNode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self removeFromSuperview];
}


/**
*  When you click the foot View will call this method.
*/
- (void)addNode{
    
    if (_block) {
        _block(@"Custom", @"");
    }
    
    [self removeFromSuperview];
}


@end
