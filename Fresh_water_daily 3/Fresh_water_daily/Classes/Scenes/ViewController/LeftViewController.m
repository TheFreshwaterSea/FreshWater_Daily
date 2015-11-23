//
//  LeftViewController.m
//  Fresh_water_daily
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 yangkenneg.com. All rights reserved.
//

#import "LeftViewController.h"

#import "FirstTableViewController.h"
#import "AFNetworking.h"
#import "ClassModel.h"
#import "CategoryTableViewController.h"

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *leftTableView;
// 存放数据的数组
@property(nonatomic,retain)NSMutableArray *dataArray;
- (IBAction)btn4IntoFirst:(UIButton *)sender;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    //设置代理源
    _leftTableView.dataSource =self;
    _leftTableView.delegate = self;

    [self parsing];
    
}

// 解析
-(void)parsing{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    self.dataArray =[NSMutableArray array];
    
    
    
    __weak typeof(self)temp =self;
    [manager GET:@"http://news-at.zhihu.com/api/4/themes" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功 %@",responseObject);
        
        self.dataArray = [NSMutableArray array];
        NSArray *array = responseObject[@"others"];
        
        for (NSDictionary *dic in array) {
            ClassModel *class = [ClassModel new];
            [class setValuesForKeysWithDictionary:dic];
            
            [temp.dataArray addObject:class];
            
            
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [temp.leftTableView reloadData];
        });
        NSLog(@"////////.%lu",(unsigned long)temp.dataArray.count);
        
    }
     
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败");
         }];
    
}




//分区的个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//每个分区的row数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
    
}
//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell" forIndexPath:indexPath];
    ClassModel *class = self.dataArray[indexPath.row];
    
    cell.textLabel.text =class.name;
    
       
    
//    if(cell==nil)
//    {
//        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leftCell"];
//    }
//    
//    switch (indexPath.row)
//    {
//        case 0:
//        {
//            cell.textLabel.text=@"首页";
//        }
//            break;
//            
//        case 1:
//        {
//            cell.textLabel.text=@"用户推荐日报";
//        }
//            break;
//            
//        case 2:
//        {
//            cell.textLabel.text=@"设计日报";
//        }
//            break;
//         case 3:
//        {
//            cell.textLabel.text=@"互联网安全";
//        }
//            break;
//        case 4:{
//            cell.textLabel.text = @"开始游戏";
//        }
//            break;
//        case 5:{
//            cell.textLabel.text = @"音乐日报";
//        }
//            break;
//        case 6:{
//            cell.textLabel.text = @"动漫日报";
//        }
//            break;
//            
//        default:
//            break;
//    }
    
    
    return cell;
    
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryTableViewController *category = [[CategoryTableViewController alloc] init];
    
    ClassModel *class = self.dataArray[indexPath.row];
    
    category.ID = class.id;
    
    
    [self.navigationController pushViewController:category animated:YES];
    
    
}
//    if (indexPath.row == 0) {
//        
//        UserHobbyTableViewController *use = [[UserHobbyTableViewController alloc] init];
//        
//        [self presentViewController:use animated:YES completion:nil];
//
//        
//    }else{
//        return ;
//    }
//   
//    switch (indexPath.row)
//    {
//        case 0:
//        {
//            FirstTableViewController *first = [[FirstTableViewController alloc] init];
//             [self presentViewController:first animated:YES completion:nil];
//            
//        }
//            break;
//            
//        case 1:
//        {
//                    UserHobbyTableViewController *use = [[UserHobbyTableViewController alloc] init];
//            
//                //    [self presentViewController:use animated:YES completion:nil];
//            [self.navigationController pushViewController:use animated:YES];
//            
//        }
//            break;
//
//        case 2:
//        {
//            cell.textLabel.text=@"设计日报";
//        }
//            break;
//        case 3:
//        {
//            cell.textLabel.text=@"互联网安全";
//        }
//            break;
//        case 4:{
//            cell.textLabel.text = @"开始游戏";
//        }
//            break;
//        case 5:{
//            cell.textLabel.text = @"音乐日报";
//        }
//            break;
//        case 6:{
//            cell.textLabel.text = @"动漫日报";
//        }
//            break;
//            
//        default:
//            break;
//    }

    
    
    







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn4IntoFirst:(UIButton *)sender {
    
//    FirstTableViewController *first = [[FirstTableViewController alloc] init];
//    [self presentViewController:first animated:YES completion:nil];
    
    
}
@end
