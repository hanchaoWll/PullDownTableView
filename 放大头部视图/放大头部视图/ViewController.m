//
//  ViewController.m
//  放大头部视图
//
//  Created by 微微笑了 on 2017/4/11.
//  Copyright © 2017年 微微笑了. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"

#import "ZJScreenAdaptation.h"

#import "UIImage+Extension.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+YFBlurtImage.h"

#define changeRate  (self.view.frame.size.width / self.view.frame.size.height)
#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
/** BXImageH */
#define imageH 200

/** 滚动到多少高度开始出现 */
static CGFloat const startH = 0;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>

/** 导航条View */
@property (nonatomic, weak) UIView *navBarView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,strong)UIView *otherView;


@property (nonatomic,assign)CGFloat headerImgHeight;
@property (nonatomic,assign)CGFloat iconHeight;

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIImageView *headImage;


@property (nonatomic,copy)NSString *name;

/**
 *  放大比例
 */
@property (nonatomic,assign)CGFloat scale;
/**
 *  名字label
 */
@property (nonatomic,strong)UILabel *label;

/** 标题 */
@property (nonatomic, copy) NSString *titleName;

@end

@implementation ViewController


- (UIView *)navBarView {
    if (!_navBarView) {
        UIView *navBarView = [[UIView alloc] init];
        navBarView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        [self.view addSubview:navBarView];
        self.navBarView = navBarView;
    }
    return _navBarView;
}

- (void) viewWillAppear:(BOOL)animated {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [super viewWillAppear:animated];
    //去掉分割线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
//    [_imageView removeFromSuperview];
//    [self createUI];
//    [self setupContentView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleName = @"个人中心";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    
    self.headerImgHeight  = heightEx(200);
    self.iconHeight = heightEx(90);
    
    [self createUI];
    [self createTableView];
    [self setupContentView];
    
}

#pragma mark -- 创建底视图

- (void) createUI {
    
    // imageView
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, self.headerImgHeight)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.scale =  self.imageView.frame.size.width / self.imageView.frame.size.height;
    UIImage *image = [UIImage imageNamed:@"blurtView1.jpg"];
    self.imageView.image = image;
    // 20 左右 R  模糊图片
    [self.imageView setImageToBlur:self.imageView.image blurRadius:10 completionBlock:nil];
    
    [self.view addSubview:self.imageView];
}

#pragma mark -- 创建表格视图

- (void) createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.decelerationRate = 2;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void) setupContentView {
    
    NSAssert(self.headerImgHeight >= self.iconHeight && self.iconHeight > 0, @"图片高度应当大于头像高度，头像高度应当大于零");
    
    // otherView
    UIView *otherVIew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, self.imageView.frame.size.height)];
    otherVIew.backgroundColor = [UIColor clearColor];
    self.otherView = otherVIew;
    self.tableView.tableHeaderView = self.otherView;

    
    // headImage
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - self.iconHeight) / 2, (self.headerImgHeight - self.iconHeight) / 2 + heightEx(10), self.iconHeight, self.iconHeight)];
    self.headImage.backgroundColor = [UIColor yellowColor];
    self.headImage.image = [UIImage imageNamed:@"blurtView1.jpg"];
    self.headImage.layer.cornerRadius = self.iconHeight * 0.5;
    self.headImage.clipsToBounds = YES;
    [self.otherView addSubview:self.headImage];

    // label
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headImage.frame) + heightEx(10), WIDTH, heightEx(20))];
    self.label = name;
    name.text = (self.name ? self.name : @"Charles");
    name.textAlignment = NSTextAlignmentCenter;
    name.textColor = [UIColor whiteColor];
    [self.otherView addSubview:self.label];
    
    // 获取网络图片
    //    [self.headImage sd_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:[UIImage imageNamed:@"blurtView1.jpg"]];
    //
    //    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:[UIImage imageNamed:@"blurtView1.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //        // 20 左右 R  模糊图片
    //        [imageView setImageToBlur:imageView.image blurRadius:21 completionBlock:nil];
    //    }];
   
    
}

#pragma mark - UIScrollViewDelgate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.titleName) {
        self.navigationItem.title = @"";
    }

    CGFloat offsetY = scrollView.contentOffset.y;
    
    /**
     *放大底视图
     *导航栏渐变
     */
    if (offsetY-200 > -imageH + startH) {
        
        CGFloat alpha = scrollView.contentOffset.y/(heightEx(200)-64);
        
        self.navBarView.backgroundColor = BXAlphaColor(255, 80, 0, alpha);
        
        self.navigationItem.title = @"个人中心";
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        
        if (offsetY >= (-imageH + startH + 64)){
            if (self.titleName) {
                self.navigationItem.title = self.titleName;
            }
        }
    } else {
        self.navBarView.backgroundColor = BXAlphaColor(255, 80, 0, 0);
    }

    
    /**
     *放头像
     */
    if (scrollView.contentOffset.y < 0) {
        // 高度宽度同时拉伸 从中心放大
        CGFloat imgH = self.headerImgHeight - scrollView.contentOffset.y * 2;
        CGFloat imgW = imgH * self.scale;
        self.imageView.frame = CGRectMake(scrollView.contentOffset.y * self.scale,0, imgW,imgH);
        
        CGFloat iconOriginalX = (WIDTH - self.iconHeight) / 2;
        CGFloat iconOriginalY = (self.headerImgHeight - self.iconHeight) / 2 + heightEx(10);
        
        self.headImage.frame = CGRectMake(iconOriginalX + offsetY * changeRate, iconOriginalY + offsetY * changeRate * 2, self.iconHeight - changeRate * offsetY * 2, self.iconHeight - changeRate * offsetY * 2);
        self.headImage.layer.cornerRadius = self.headImage.frame.size.width * 0.5;
        self.headImage.clipsToBounds = YES;
        
        self.label.frame = CGRectMake(self.label.frame.origin.x, CGRectGetMaxY(self.headImage.frame) + heightEx(10), self.label.frame.size.width, self.label.frame.size.height);
        
        
    } else {
        // 只拉伸高度
        self.imageView.frame = CGRectMake(0, 0, self.imageView.frame.size.width, heightEx(200) - scrollView.contentOffset.y);
    }

    NSLog(@"%0.0f",scrollView.contentOffset.y);
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return heightEx(44);
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.00001;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_tableView deselectRowAtIndexPath:indexPath  animated:YES];
    
    ViewController2 *vc = [[ViewController2 alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
