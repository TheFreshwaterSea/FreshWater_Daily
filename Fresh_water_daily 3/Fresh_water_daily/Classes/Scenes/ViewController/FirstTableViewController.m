//
//  FirstTableViewController.m
//  Fresh_water_daily
//
//  Created by lanou3g on 15/11/16.
//  Copyright © 2015年 yangkenneg.com. All rights reserved.
//

#import "FirstTableViewController.h"

#import "FirstNews.h"
#import "FirstTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "Scoll.h"
#import "FirstDetailViewController.h"
#import "FirstDetail.h"
#import "SWRevealViewController.h"
#import "MJRefresh.h"

#import "DataHandle.h"

@interface FirstTableViewController ()<UIScrollViewDelegate>
// 盛放cell数据的数组
@property (nonatomic,retain) NSMutableArray *array;
// 下拉刷新
@property(nonatomic,retain)UIRefreshControl *refreControl;

@property(nonatomic,retain)UIScrollView *scorllView;
@property(nonatomic,retain)UIPageControl *page;
@property(nonatomic,retain)NSTimer *time;
@property(nonatomic,retain)UIView *contextView;

// 盛放轮播图数据的数组
@property(nonatomic,retain)NSMutableArray *scrollArray;

@end

@implementation FirstTableViewController


//-(NSMutableArray *)array {
//    if (!_array) {
//        _array = [NSMutableArray arrayWithCapacity:20];
//    }
//    return _array;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealVC =[self revealViewController];
    [revealVC panGestureRecognizer];
    [revealVC tapGestureRecognizer];
    
    self.title = @"1111";
    
    self.navigationItem.title = @"今日新闻";
    self.navigationController.title = @"1111";
    // 透明度
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    //  self.navigationController.navigationBar.translucent = NO;
    
    
    // 下拉刷新
    [self refresh];
    
    // 解析
    //    [self parsing];
    
    
    
    [self.tableView reloadData];
    
    // 刷新(调用)
    [DataHandle sharedHandle].myUpdataUI = ^(){
        [self.tableView  reloadData];
        // 解析轮播图(必须写在这,block回调)
        [self scrol];
        
        
    };
    
    
    
}
// 下拉刷新
-(void)refresh{
    
    // 下拉刷新数据
    self.refreControl=[[UIRefreshControl alloc] init];
    // 添加事件
    [self.refreControl addTarget:self action:@selector(tog:) forControlEvents:UIControlEventValueChanged];
    // 添加到视图上
    [self.tableView addSubview:self.refreControl];
    
    
    
    
    
}
// 下拉刷新事件
- (void)tog:(UIRefreshControl *)sender{
    // 开始
    [sender beginRefreshing];
    // 刷新圈颜色
    self.refreshControl.tintColor=[UIColor cyanColor];
    // 刷新
    [self.tableView reloadData];
    // 结束
    [sender endRefreshing];
}


//- (void)timeAction
//{
//    static int i = 0;
//    i ++;
//    if (i > 4) {
//        i = 0;
//    }
//    [self.scorllView setContentOffset:CGPointMake(self.view.frame.size.width*i, 0)];
//    _page.currentPage = i;
//    
//}



- (void)pageAction:(UIPageControl *)sender
{
    NSInteger index = sender.currentPage;
    _scorllView.contentOffset = CGPointMake(self.view.frame.size.width*index, 0);
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/self.view.frame.size.width;
    _page.currentPage = index;
    
}


-(NSArray *)array1 {
    return self.array;
}

-(void)scrol{
    //向tableHeaderView添加轮播图,先创建一个视图,然后在这个视图中添加东西,让tableHeaderView等于这个视图
    self.contextView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    self.scorllView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    _scorllView.contentSize = CGSizeMake(self.view.frame.size.width*5, 180);
    _scorllView.delegate = self;
    _scorllView.pagingEnabled = YES;
    //    _scorllView.backgroundColor = [UIColor redColor];
    
    
    
    [self.contextView addSubview:self.scorllView];
    self.tableView.tableHeaderView = self.contextView;
    
    
    
    
    
    _page = [[UIPageControl alloc] initWithFrame:CGRectMake(100, 180, 150, 20)];
    _page.currentPageIndicatorTintColor = [UIColor redColor];
    _page.numberOfPages = 5;
    _page.currentPage = 0;
    _page.pageIndicatorTintColor = [UIColor lightGrayColor];
    [_page addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
    [self.contextView addSubview:_page];
    
    // 轮播图
//    _time = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    
    for (int i = 0; i < [ DataHandle sharedHandle].topNewsArray.count; i ++) {
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, 180)];
        
        Scoll *goods = [DataHandle sharedHandle].topNewsArray[i];
        [imgView sd_setImageWithURL:[NSURL URLWithString: goods.image]];
        
        NSLog(@"%ld",[DataHandle sharedHandle].topNewsArray.count);
        imgView.backgroundColor = [UIColor yellowColor];
        
        [_scorllView addSubview:imgView];
        
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(50 +i *self.view.frame.size.width, 100, self.view.frame.size.width/2, self.contextView.frame.size.height/3)];
        //  lable.backgroundColor = [UIColor yellowColor];
        
        lable.text = goods.title;
        NSLog(@"======%@",lable.text);
        lable.numberOfLines = 0;
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont boldSystemFontOfSize:15.0];
        
        [self.scorllView addSubview:lable];
        
        [self.contextView addSubview:self.scorllView];
        
        
        
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
  //  return [DataManager sharedManager].sectionArray.count ;
    return [DataHandle sharedHandle].sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = [DataHandle sharedHandle].dataDictionary[[DataHandle sharedHandle].sectionArray[section]];
    return array.count;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellResue" forIndexPath:indexPath];
    
 //   FirstNews *news = _array[indexPath.row];
   
 //   FirstNews *news = [[DataManager sharedManager]firstNewsWithIndex:indexPath.row];
    
    NSArray *array =[DataHandle sharedHandle].dataDictionary[[DataHandle sharedHandle].sectionArray[indexPath.section]];
    
    FirstNews *news = array[indexPath.row];
  
    
    
    
    [cell.image4pic sd_setImageWithURL:[NSURL URLWithString:news.images[0]]];
    cell.label4title.text = news.title;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FirstDetailViewController *detailVC = [[FirstDetailViewController alloc] init];
    
 //  FirstNews *FN = self.array[indexPath.row];
    
    NSArray *array =[DataHandle sharedHandle].dataDictionary[[DataHandle sharedHandle].sectionArray[indexPath.section]];
    
    FirstNews *news = array[indexPath.row];
    detailVC.ID = news.id;
    
    [self presentViewController:detailVC animated:YES completion:nil];
  //  [self.navigationController pushViewController:detailVC animated:YES];
    
    
}
// 分组
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    
    
    return [DataHandle sharedHandle].sectionArray[section];
}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//   
//    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 64)];
//    
//    headerView.backgroundColor = [UIColor colorWithRed: 33.0/255.0 green:104.0 / 255.0 blue:205.0 /255.0 alpha:1];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.tableView.frame.size.width - 20, 60)];
//    
//    NSString *yearStr = [[DataManager sharedManager].sectionArray[section] substringToIndex:4];
//    
//    NSString *monthStr =[[DataManager sharedManager].sectionArray[section]  substringWithRange:NSMakeRange(4, 2)];
//    
//    NSString *dayStr = [[DataManager sharedManager].sectionArray[section] substringWithRange:NSMakeRange(6, 2)];
//    
//    label.textAlignment = NSTextAlignmentCenter;
//    
//    label.text = [NSString stringWithFormat:@" %@ 年 %@ 月 %@ 日",yearStr,monthStr,dayStr];
//    
//    [ headerView addSubview:label];
//    
//    return headerView;
//    
//}







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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//   
//    // 判断是否是cell触发的方法
//    if ([sender isKindOfClass:[FirstTableViewCell class] ]) {
//        
//        // 获取到cell对应的班级
//        FirstTableViewCell *cell = sender;
//        NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
//        
//        FirstNews *FN = self.array[indexpath.row];
//        // 获取到目标页面
//        FirstDetailViewController *sc = [segue destinationViewController];
//        sc.ID = FN.id;
//        NSLog(@"111111%ld",(long)FN.id);
//    }
//
//
//}


@end
