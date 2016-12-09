//
//  zjfSearchViewController.m
//  斗图APP
//
//  Created by wyzc04 on 16/12/6.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "zjfSearchViewController.h"
#import "zjfSearchCollectionViewCell.h"
#import "zjfMakeDetailViewController.h"
#import <UShareUI/UMSocialUIManager.h>
@interface zjfSearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,strong)UISearchBar * searchBar;

@property (nonatomic,assign)int pageNum;

@property (nonatomic,strong)UIImage * selectedImage;
@end

@implementation zjfSearchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 6, SCREENWIDTH, 64)];
    _searchBar.backgroundColor = [UIColor grayColor];
    [_searchBar setPlaceholder:@"搜索表情"];
    [_searchBar setBarStyle:UIBarStyleDefault];
    [_searchBar setBarTintColor:[UIColor colorWithRed:229/256.0 green:229/256.0 blue:229/256.0 alpha:1]];
    [_searchBar setTranslucent:YES];
    [_searchBar setShowsCancelButton:YES];
    [_searchBar setSearchResultsButtonSelected:NO];
    [_searchBar setKeyboardType:UIKeyboardTypeDefault];
    
    self.searchBar.delegate = self;
    
    [self.view addSubview:_searchBar];
    
    [_searchBar becomeFirstResponder];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:229/256.0 green:229/256.0 blue:229/256.0 alpha:1];
    _dataArray = [NSMutableArray array];
    _pageNum = 0;
    [self setCollectionView];
    
    self.navigationController.navigationBar.hidden = YES;
    [self Refresh];
    
    // Do any additional setup after loading the view.
}

- (void)Refresh
{
    
    //下拉刷新
    WEAKSELF;
    _collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
        [_collectionView.mj_header endRefreshing];
        
    }];
    
    [_collectionView.mj_header beginRefreshing];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _collectionView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if(_dataArray.count == INT_MAX){
            
            [SVProgressHUD showProgress:2 status:@"没有更多"];
            
            _collectionView.mj_footer.hidden = YES;
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD dismiss];
            [weakSelf requestMoreData];
            [_collectionView.mj_footer endRefreshing];
            
            
        }
        
        
    }];
}


- (void)setCollectionView{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.itemSize = CGSizeMake((SCREENWIDTH-80)/3, (SCREENHEIGHT-194-49)/4.5);
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = 10;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 70, SCREENWIDTH, SCREENHEIGHT-49) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor =[UIColor colorWithRed:229/256.0 green:229/256.0 blue:229/256.0 alpha:1];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[zjfSearchCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:_collectionView];
    //[self Refresh];
    
}

#pragma mark collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
    //return  10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    zjfSearchCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 10;
    cell.contentView.layer.cornerRadius = 10;
    cell.contentView.layer.masksToBounds = YES;
    zjfSearchModel * searchModel =  _dataArray[indexPath.item];
    
    cell.searchModel = searchModel;
    cell.backgroundColor = [UIColor whiteColor];
    
    if ([searchModel.gifPath hasSuffix:@"gif"]) {
        cell.gifImageView.hidden = NO;
    }else{
        cell.gifImageView.hidden = YES;
    }    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [_searchBar resignFirstResponder];
    __weak typeof(self) weakSelf = self;
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [weakSelf shareTextToPlatformType:platformType];
    }];
    zjfSearchModel * model = _dataArray[indexPath.item];
    
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

- (void)requestMoreData{
    _pageNum ++;
    [self requestData];
    
    
}

- (void)requestData{
    
    NSMutableDictionary * mudic = [NSMutableDictionary dictionary];
    mudic[@"keyWord"] = _searchBar.text;
    mudic[@"pageNum"] = @"0";
    mudic[@"pageSize"] = @"100";
    
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager POST:@"http://api.jiefu.tv/app2/api/dt/shareItem/search.html" parameters:mudic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * muarr = [NSMutableArray array];
        for (NSDictionary * dic in responseObject[@"data"]) {
            zjfSearchModel * searchModel = [[zjfSearchModel alloc]init];
            [searchModel setValuesForKeysWithDictionary:dic];
            
            [muarr addObject:searchModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_dataArray addObjectsFromArray: muarr];
            [_collectionView reloadData];
            // [_collectionView.mj_header endRefreshing];
            
            
        });
        // [_collectionView.mj_header endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
        
    }];
    
}

//拖拽时不能再显示键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
//点击取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:NO];
    //[self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0){
       
        [_dataArray removeAllObjects];
        [_collectionView reloadData];
    }
    [_dataArray removeAllObjects];
    [self requestData];
    
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
