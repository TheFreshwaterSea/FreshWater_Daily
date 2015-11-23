//
//  FirstDetailViewController.m
//  Fresh_water_daily
//
//  Created by lanou3g on 15/11/17.
//  Copyright © 2015年 yangkenneg.com. All rights reserved.
//

#import "FirstDetailViewController.h"
#import "FMDB.h"
#import "FirstDetail.h"

@interface FirstDetailViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)UITableView *myTableView;

// 存放数据的数组
@property(nonatomic,retain)NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UIWebView *webControl;
//最外层大字典
@property (nonatomic , retain) NSMutableDictionary *dic;
- (IBAction)action4Back:(UIBarButtonItem *)sender;

- (IBAction)CollectionMyFavorite:(UIBarButtonItem *)sender;

@property(nonatomic,retain)NSMutableArray *titleArray;


//数据库
@property(nonatomic,retain)NSString *titlestr;
@property(nonatomic,strong)FMDatabase *db;



@end

@implementation FirstDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 返回手势
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backLast)];
    swip.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swip];
    
    
  //  self.navigationController.navigationBar.barTintColor = [UIColor yellowColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    self.webControl.delegate = self;
    // 边框是否允许滑动
   // self.webControl.scrollView.bounces=NO;
    
    //1.数据库路径
    NSString *doucument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [doucument stringByAppendingString:@"/data.sqlite"];
    NSLog(@"%@",path);
    
    //2.创建数据库
    
    self.db = [FMDatabase databaseWithPath:path];
    
    //3.打开数据库
    if ([self.db open]) {
        NSLog(@"数据库打开成功");
        BOOL result = [self.db executeUpdate:@"create table collection (title text);"];
        if (result) {
            NSLog(@"创建表成功");
        }else{
            NSLog(@"创建表失败");
        }
    }else{
        NSLog(@"打开数据库失败");
    }
    
    
    
    
    [self parer];
// 数据库
    [self parseTitle];
    
}

-(void)backLast{
    [self backLastPage];
}




-(void)back:(UIBarButtonItem *)sender{
    [self backLastPage];
}


-(void)parer{
    NSLog(@"====%ld",_ID);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%ld",(long)self.ID]];
    NSLog(@"%@",url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof (self) temp = self;
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data != nil) {
            self.dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"%@",_dic);
            
            
        }
        NSURL *shareURL= [NSURL URLWithString:_dic[@"share_url"]] ;
        NSLog(@"%@",shareURL);
        NSURLRequest *shareRequest = [NSURLRequest requestWithURL:shareURL];
        
        [self.webControl loadRequest:shareRequest];
        
        //返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [temp.webControl reload];
        });
        
    
        
    }];
    
    
    
    [task resume];

    
}

// 去掉上面的广告
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('header-for-mobile')[0].style.display = 'none'"];
}

// 改变导航栏的透明度
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"offset---scroll:%f",self.myTableView.contentOffset.y);
    UIColor *color=[UIColor redColor];
    CGFloat offset=self.myTableView.contentOffset.y;
    if (offset<0) {
        self.navigationController.navigationBar.backgroundColor = [color colorWithAlphaComponent:0];
    }else {
        CGFloat alpha=1-((64-offset)/64);
        self.navigationController.navigationBar.backgroundColor=[color colorWithAlphaComponent:alpha];
    }
}

// 数据库
-(void)parseTitle{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        // 开辟空间
        __weak typeof(self)temp =self;
        
        NSString *str = [@"http://news-at.zhihu.com/api/4/story/" stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)self.ID] ];
        [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            self.titleArray = responseObject[@"title"];
            
            NSLog(@"----------------%@",self.titleArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                [temp.webControl reload];
                
            });
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败");
        }];
        
    });
}





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

- (IBAction)action4Back:(UIBarButtonItem *)sender {
    
     [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)CollectionMyFavorite:(UIBarButtonItem *)sender {
    
    NSString *titleStr = [NSString stringWithFormat:@"%@",self.titleArray];
    [self.db executeUpdate:@"insert into collection (title) values (?);",titleStr];
    
}

-(void)backLastPage{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
