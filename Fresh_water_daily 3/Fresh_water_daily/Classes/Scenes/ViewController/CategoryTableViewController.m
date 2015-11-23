//
//  CategoryTableViewController.m
//  Fresh_water_daily
//
//  Created by lanou3g on 15/11/19.
//  Copyright © 2015年 yangkenneg.com. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "AFNetworking.h"
#import "UserHobby.h"
#import "UIImageView+WebCache.h"
#import "CategoryTableViewCell.h"
#import "FirstDetailViewController.h"
#import "CategoryTableViewCell2.h"




@interface CategoryTableViewController ()

// 存放数据的数组
@property(nonatomic,retain)NSMutableArray *dataArray;

@property(nonatomic,retain)UIView *contextView;

@end

static NSString *identifier = @"cellResue";

static NSString *identifier2 = @"cellResue2";

@implementation CategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"音乐日报";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryTableViewCell2" bundle:nil] forCellReuseIdentifier:identifier2];

    
    
    // 解析
    [self parsing];
    //在表头添加视图
    [self adding];

}
-(void)back:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)adding{
    self.contextView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    self.tableView.tableHeaderView = self.contextView;
    
    
  //  self.contextView.backgroundColor = [UIColor greenColor];
    
    
    
    
    
    
}

// 解析
-(void)parsing{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    self.dataArray =[NSMutableArray array];
    
    
    
    __weak typeof(self)temp =self;
    
    NSString *urlString = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/theme/%ld",(long)self.ID];
 //   NSString *string=[urlString stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)self.ID]];
    
    NSLog(@"%@",urlString);
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"请求成功 %@",responseObject);
        
        self.dataArray = [NSMutableArray array];
        NSArray *array = responseObject[@"stories"];
        
        for (NSDictionary *dic in array) {
            UserHobby *use = [UserHobby new];
            [use setValuesForKeysWithDictionary:dic];
            
        //    self.navigationItem.title = use.name;
            
            [temp.dataArray addObject:use];
            
            
        }
        
        
        
        
         UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(50 , 100, self.view.frame.size.width/2, self.contextView.frame.size.height/3)];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 190)];
        
        UserHobby *use1 = [UserHobby new];
        use1.name = responseObject[@"name"];
        self.navigationItem.title = use1.name;
        
        use1.Description = responseObject[@"description"];
        lable.text = use1.Description;
        lable.numberOfLines = 0;
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont boldSystemFontOfSize:15.0];
        [self.contextView addSubview:img];
        [self.contextView addSubview:lable];
        
        
        use1.image = responseObject[@"image"];
        
    
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [temp.tableView reloadData];
            
        });
        [img sd_setImageWithURL:[NSURL URLWithString:use1.image] placeholderImage:[UIImage imageNamed:@"33"]];
        
        NSLog(@"***********%@",use1.image);
        
        NSLog(@"////////.%lu",(unsigned long)temp.dataArray.count);
        
    }
     
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"请求失败");
         }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserHobby *user = _dataArray[indexPath.row];
    
    if (user.images.count == 0) {
        
        CategoryTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier2 forIndexPath:indexPath];
        cell.lab4Title.text = user.title;
        return cell;
        
    }else if (user.images.count == 1)
    
    {
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    
    
    
    cell.lab4Title.text =user.title;
    cell.lab4Title.numberOfLines = 0;
    
    [cell.img4Picture sd_setImageWithURL:[NSURL URLWithString:user.images[0]]];
    
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FirstDetailViewController *deatil = [[FirstDetailViewController alloc] init];
    
    UserHobby *use = self.dataArray[indexPath.row];
    
    deatil.ID = use.id;
    
    [self presentViewController:deatil animated:YES completion:nil];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
