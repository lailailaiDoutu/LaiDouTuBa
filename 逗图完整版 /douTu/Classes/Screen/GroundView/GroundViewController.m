//
//  GroundViewController.m
//  GroupProject
//
//  Created by  张泽军 on 2016/11/30.
//  Copyright © 2016年 HITWORLD. All rights reserved.
//

#import "GroundViewController.h"

#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MJRefresh.h"

#import "SearchViewController.h"
#import "ImageCollectionViewCell.h"
#import "CellImage.h"
#import "MoreViewController.h"
#import "MoreCellViewController.h"

@interface GroundViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UIImageView * TopImage;

@property (nonatomic,strong) UIButton * TopButton;

@property (nonatomic,strong) UIView * topView;

@property (nonatomic,strong) UICollectionView * TopCollectionView;

@property (nonatomic,strong) UIView * HeaderView;

@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,assign) int pageNum;

@property (nonatomic,strong)UIImage * selectedImage;


@end

static NSString * const cellResueIdentifier = @"collect";

static NSString * const headerResueIdentifier = @"header";

static NSString * const footerResueIdengtifier = @"footer";


@implementation GroundViewController

- (void)viewDidLoad
{
    _dataArray = [NSMutableArray array];
    
    _pageNum = 0;
    
    [super viewDidLoad];
    
    [self XRSearch];
    
    [self HeaderTop];
    
    [self CollectionView];
    
    [self requestdata];
    
    [self Refresh];
}

- (void)Refresh
{
    //下拉刷新
    _TopCollectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestdata];
    }];
    
    [_TopCollectionView.mj_header beginRefreshing];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _TopCollectionView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    _TopCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self reloadData];
    }];
}

- (void)HeaderTop
{
    UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT * 0.5) ];
    
    UIImageView * HeaderImage = [[UIImageView alloc]initWithFrame:CGRectMake(10,SCREENHEIGHT * 0.5 - 45, 20, 20)];
    
    HeaderImage.tag = 101;
    
    HeaderImage.image = [UIImage imageNamed:@"lanmuicon"];
    
    [header addSubview:HeaderImage];
    
    UILabel * HeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, SCREENHEIGHT * 0.5 - 45, 200, 20)];
    
    HeaderLabel.text = @"今日最新表情";
    
    HeaderLabel.font = [UIFont systemFontOfSize:15];
    
    [header addSubview:HeaderLabel];
    
    _TopImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    
    _TopImage.image = [UIImage imageNamed:@"topImage"];
    
    _TopImage.userInteractionEnabled = YES;
    
    UIButton * imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    imageButton.frame = CGRectMake(0, 0, SCREENWIDTH, 100);
    
    [imageButton addTarget:self action:@selector(imageButtonPush:) forControlEvents:UIControlEventTouchUpInside];
    
    [_TopImage addSubview:imageButton];

    [header addSubview:_TopImage];
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, SCREENHEIGHT * 0.5 - 150)];
    
    _topView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    UIImageView * ButtonView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT * 0.5 - 150)];
    
    ButtonView.userInteractionEnabled = YES;
    
    ButtonView.image = [UIImage imageNamed:@"TabViewButton"];
    
    [_topView addSubview:ButtonView];
    
    int maxButtonNumber = 4;
    
    CGFloat buttonWidth = SCREENWIDTH / maxButtonNumber;
    
    CGFloat buttonHeight = (SCREENHEIGHT * 0.5 - 150) * 0.5;
    
    for (int i = 0; i < 8; i ++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button addTarget:self action:@selector(buttonPush:) forControlEvents:UIControlEventTouchUpInside];
        
        [ButtonView addSubview:button];
        
        CGFloat butttonX = (i % maxButtonNumber) * buttonWidth;
        CGFloat buttonY = (i / maxButtonNumber) * buttonHeight;
        
        button.frame = CGRectMake(butttonX, buttonY, buttonWidth, buttonHeight);
        
        button.tag = 200 + i;
    }
    
    [header addSubview:_topView];
    
    [self.view addSubview:header];
    
    self.HeaderView = header;
}

//设置collectionView
- (void)CollectionView
{
    UICollectionViewFlowLayout * FlowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    _TopCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) collectionViewLayout:FlowLayout];
    
    FlowLayout.minimumInteritemSpacing = 15;
    
    _TopCollectionView.dataSource = self;
    
    _TopCollectionView.delegate = self;
    
    _TopCollectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    [_TopCollectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:cellResueIdentifier];
    
    [_TopCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerResueIdentifier];
    
    [self.view addSubview:_TopCollectionView];
    
}

//设置Collection的分区
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREENWIDTH - 65) / 4, (SCREENWIDTH - 65) / 4);
}

//设置上下左右的距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 10, 5, 10);
}

//头的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREENWIDTH, _HeaderView.frame.size.height - 20);
}

//区的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//Item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellResueIdentifier forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 10;
    
    cell.contentView.layer.cornerRadius = 10;
    
    cell.model = _dataArray[indexPath.item];
    
    CellImage * model = _dataArray[indexPath.item];
    
    cell.model = model;
    
    return cell;
}

- (void)reloadData
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    _pageNum ++;
    
    [manager GET:[NSString stringWithFormat:@"http://api.jiefu.tv/app2/api/dt/shareItem/newList.html?pageNum=%d&pageSize=48",_pageNum] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         for (NSDictionary * dic in responseObject[@"data"])
         {
             
             CellImage * model = [[CellImage alloc]init];
             
             [model setValuesForKeysWithDictionary:dic];
             
             [_dataArray addObject:model];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [_TopCollectionView reloadData];
                 [_TopCollectionView.mj_header endRefreshing];

             });
             [_TopCollectionView.mj_footer endRefreshing];
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
     }];
}

//请求数据
- (void)requestdata
{
    [_dataArray removeAllObjects];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager GET:@"http://api.jiefu.tv/app2/api/dt/shareItem/newList.html?pageNum=0&pageSize=48" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         for (NSDictionary * dic in responseObject[@"data"])
         {
             
             CellImage * model = [[CellImage alloc]init];
             
             [model setValuesForKeysWithDictionary:dic];
             [_dataArray addObject:model];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [_TopCollectionView reloadData];
                 
             });
             [_TopCollectionView.mj_header endRefreshing];
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"%@",error);
     }];
}

- (UICollectionReusableView * )collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerResueIdentifier forIndexPath:indexPath];
    
    header.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    [header addSubview:_HeaderView];
    
    return header;
}

//Button点击方法
- (void)buttonPush:(UIButton *)button
{
        if(button.tag == 200)
        {
            MoreCellViewController * moreView = [[MoreCellViewController alloc]init];
            
            NSString * jin = @"5";
            
            moreView.Id = jin;
            
            [self.navigationController pushViewController:moreView animated:YES];
        }else if (button.tag == 201)
        {
            MoreCellViewController * moreView = [[MoreCellViewController alloc]init];
            
            NSString * jin = @"7";
            
            moreView.Id = jin;

            
            [self.navigationController pushViewController:moreView animated:YES];
        }else if (button.tag == 202)
        {
            MoreCellViewController * moreView = [[MoreCellViewController alloc]init];
            
            NSString * jin = @"8";
            
            moreView.Id = jin;

            
            [self.navigationController pushViewController:moreView animated:YES];
        }else if (button.tag == 203)
        {
            MoreCellViewController * moreView = [[MoreCellViewController alloc]init];
            
            NSString * jin = @"9";
            
            moreView.Id = jin;

            
            [self.navigationController pushViewController:moreView animated:YES];
        }else if (button.tag == 204)
        {
            MoreCellViewController * moreView = [[MoreCellViewController alloc]init];
            
            NSString * jin = @"10";
            
            moreView.Id = jin;

            
            [self.navigationController pushViewController:moreView animated:YES];
        }else if (button.tag == 205)
        {
            MoreCellViewController * moreView = [[MoreCellViewController alloc]init];
            
            NSString * jin = @"13";
            
            moreView.Id = jin;

            
            [self.navigationController pushViewController:moreView animated:YES];
        }else if (button.tag == 206)
        {
            MoreCellViewController * moreView = [[MoreCellViewController alloc]init];
            
            NSString * jin = @"14";
            
            moreView.Id = jin;

            
            [self.navigationController pushViewController:moreView animated:YES];
        }else if (button.tag == 207)
        {
            self.tabBarController.tabBar.hidden = YES;
            
            self.hidesBottomBarWhenPushed = YES;
            
            MoreViewController * MoreView = [[MoreViewController alloc]init];
            
            MoreView.title = @"更多表情";
            
            [self.navigationController pushViewController:MoreView animated:YES];
            
            self.tabBarController.tabBar.hidden = NO;
            
            self.hidesBottomBarWhenPushed = NO;
        }
}

- (void)imageButtonPush:(UIButton *)button
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms://itunes.apple.com/cn/app/bao-xiao-jie-fu-zui-gao-xiao/id996788058?mt=8"] options:@{} completionHandler:nil];
}

- (void)XRSearch
{
    UIImage * xrSearch = [UIImage imageNamed:@"Search"];
    xrSearch = [xrSearch imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:xrSearch style:UIBarButtonItemStyleDone target:self action:@selector(Right)];
}

- (void)Right
{
    self.tabBarController.tabBar.hidden = YES;
    
    self.hidesBottomBarWhenPushed = YES;
    
    SearchViewController * SearchView = [[SearchViewController alloc]init];
    
    SearchView.title = @"搜索";
    
    [self.navigationController pushViewController:SearchView animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [weakSelf shareTextToPlatformType:platformType];
    }];
    CellImage * model = _dataArray[indexPath.item];

    
    UIImageView * image = [[UIImageView alloc]init];
    [image sd_setImageWithURL:[NSURL URLWithString:model.picPath]];
    _selectedImage = image.image;
    
}
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareImageObject * object = [[UMShareImageObject alloc]init];
    
    object.shareImage = self.selectedImage;
    
    messageObject.shareObject = object;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}


- (void)didReceiveMemoryWarning
{
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

@end
