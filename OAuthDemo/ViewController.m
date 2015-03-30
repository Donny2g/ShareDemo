//
//  ViewController.m
//  OAuthDemo
//
//  Created by Donny2g Hu on 15/3/30.
//  Copyright (c) 2015年 Donny2g Hu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"微博";
    }else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"qq";
    }else if(indexPath.row == 2)
    {
        cell.textLabel.text = @"微信";
    }else if (indexPath.row == 3)
    {
        cell.textLabel.text = @"百度";
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"Weibo" sender:self];
    }else if (indexPath.row == 1)
    {
        [self performSegueWithIdentifier:@"QQ" sender:self];
        
    }else if (indexPath.row == 2)
    {
        [self performSegueWithIdentifier:@"Weixin" sender:self];

    }else if (indexPath.row == 3)
    {
        [self performSegueWithIdentifier:@"Baidu" sender:self];
    }
}
@end
