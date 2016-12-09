//
//  SearchCellViewController.m
//  Project
//
//  Created by  张泽军 on 2016/12/7.
//  Copyright © 2016年 HITWORLD. All rights reserved.
//

#import "SearchCellViewController.h"

#import "SearchCellCollectionViewCell.h"
#import "cellLabel.h"
#import "CImage.h"

#import "AFNetworking.h"
#import "MJRefresh.h"

@interface SearchCellViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView * collectionV;

@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,assign) int pageNum;

@property (nonatomic,strong)UIImage * selectedImage;
@end

static NSString * const cellResueIdentifier = @"collect";

@implementation SearchCellViewController

- (void)viewDidLoad
{
    _dataArray = [NSMutableArray array];
    
    _pageNum = 0;
    
    [super viewDidLoad];
    
    self.title = self.model.name;
    
    [self colloectionView];
    
    [self requestData];
    
    [self reloadMoreData];
    
    [self Refresh];
}

- (void)colloectionView
{
    UICollectionViewFlowLayout * floewLayout = [[UICollectionViewFlowLayout alloc]init];
    
    _collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) collectionViewLayout:floewLayout];
    
    floewLayout.minimumInteritemSpacing = 15;
    
    _collectionV.dataSource = self;
    
    _collectionV.delegate = self;
    
    _collectionV.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    
    [_collectionV registerClass:[SearchCellCollectionViewCell class] forCellWithReuseIdentifier:cellResueIdentifier];
    
    [self.view addSubview:_collectionV];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCellCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellResueIdentifier forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 10;
    
    cell.contentView.layer.cornerRadius = 10;
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.model = _dataArray[indexPath.item];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((SCREENWIDTH - 65) / 4, (SCREENWIDTH - 65) / 4);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 10, 5, 10);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)Refresh
{
    // 下拉刷新
    _collectionV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestData];
    }];
    
    [_collectionV.mj_header beginRefreshing];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _collectionV.mj_header.automaticallyChangeAlpha = YES;
    
    _collectionV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self reloadMoreData];
    }];
}

- (void)reloadMoreData
{
    _pageNum ++;
    
    [self requestData];
}

- (void)requestData
{
    NSString * str = [NSString stringWithFormat:@"http://api.jiefu.tv/app2/api/dt/item/getByTag.html?tagId=%@&pageNum=%d&pageSize=48",self.model.Id,_pageNum];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress)
    {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        
        NSMutableArray * muarr = [NSMutableArray array];
        for (NSDictionary * dic in responseObject[@"data"]){
            
            CImage * mamodel = [[CImage alloc]init];
            [mamodel setValuesForKeysWithDictionary:dic];
            [muarr addObject:mamodel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_dataArray addObjectsFromArray:muarr];
            
            [_collectionV reloadData];
        });
        
        [_collectionV.mj_header endRefreshing];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSLog(@"++++%@+++",error);
    }];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self) weakSelf = self;
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [weakSelf shareTextToPlatformType:platformType];
    }];
    CImage * model = _dataArray[indexPath.item];
    
    
    UIImageView * image = [[UIImageView alloc]init];
    [image sd_setImageWithURL:[NSURL URLWithString:model.picPath]];
    _selectedImage = image.image;
    
}
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    
    //    UIImage * baseImage = _douTuImage.image;
    //
    //    UIImage * resultImage = [baseImage imageWaterMarkWithString:_textView.text point:CGPointMake(_viewsBack.frame.origin.x + 10,_viewsBack.frame.origin.y) attribute:@{NSForegroundColorAttributeName:_textColor,NSFontAttributeName:[UIFont fontWithName:_textFont size:30]}];
    
    
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

@end
