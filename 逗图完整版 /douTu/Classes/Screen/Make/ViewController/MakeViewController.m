//
//  MakeViewController.m
//  斗图APP
//
//  Created by wyzc04 on 16/11/30.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "MakeViewController.h"
#import "MakeCollectionViewCell.h"
#import "zjfHotViewController.h"
#import "zjfSortViewController.h"
#import "zjfNewViewController.h"
#import "zjfPersonViewController.h"
#import "zjfMakeDetailViewController.h"
#import "zjfHelpViewController.h"
#import "zjfSearchViewController.h"
@interface MakeViewController ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>

//请求数据的数组
@property (nonatomic,strong)NSMutableArray * dataArray;

//搜索框
@property (nonatomic,strong)UISearchBar * searchbar;
//collectionView
@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)UICollectionReusableView * header;


@property (nonatomic,assign)int pageNum;

@property (nonatomic,strong)NSMutableArray *flagArr;
@end

static NSString * const reuse = @"cell";
@implementation MakeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_searchbar resignFirstResponder];
    
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//        UITabBar *tabBar = self.tabBarController.tabBar;
//    
//        UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
//    
//        tabBar.selectedItem = item1;

    self.navigationItem.title = @"制图";
    self.view.backgroundColor = [UIColor colorWithRed:229/256.0 green:229/256.0 blue:229/256.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    _pageNum = 0;
    
    [self setCollectionView];
    
    [self requestDatata];
    
    [self shuaxin];

    [self setNavBar];
    
        
        // Do any additional setup after loading the view.
}

- (void)shuaxin{
    [_collectionView.mj_header endRefreshing];

    // 下拉刷新
    WEAKSELF;
    _collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestDatata];
        
    }];
    
    [_collectionView.mj_header beginRefreshing];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _collectionView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf requestMoreData];
        
    }];
    

}

- (void)requestMoreData{
    _pageNum ++;
    [self requestDatata];
    
    
}


- (void)requestDatata{
    NSString * str = [NSString stringWithFormat:@"http://api.jiefu.tv/app2/api/dt/item/recommendList.html?pageNum=%d&pageSize=48",_pageNum];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * muarr = [NSMutableArray array];
       
        for (NSDictionary * dic in responseObject[@"data"]) {
            makeModel * makemodel = [[makeModel alloc]init];
            [makemodel setValuesForKeysWithDictionary:dic];
            [muarr addObject:makemodel];
            
        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_dataArray addObjectsFromArray:muarr];
            [_collectionView reloadData];
            [_collectionView.mj_header endRefreshing];
            [_collectionView.mj_footer endRefreshing];
        });
            
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"++++%@+++",error);
    }];
    
}



- (void)setCollectionView{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.itemSize = CGSizeMake((SCREENWIDTH-80)/3, (SCREENHEIGHT-194-49)/4.5);
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = 10;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 0, 20);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor =[UIColor colorWithRed:229/256.0 green:229/256.0 blue:229/256.0 alpha:1];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[MakeCollectionViewCell class] forCellWithReuseIdentifier:reuse];
    
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:_collectionView];
}

#pragma mark collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MakeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
    cell.layer.cornerRadius = 10;
    cell.contentView.layer.cornerRadius = 10;
    cell.contentView.layer.masksToBounds = YES;
    
    makeModel * model = _dataArray[indexPath.item];
    
    cell.makemodel = model;
    if ([model.gifPath hasSuffix:@"gif"]) {
        cell.gifImageView.hidden = NO;
    }else{
        cell.gifImageView.hidden = YES;
    }


    
    return cell;
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    header.backgroundColor = [UIColor colorWithRed:229/256.0 green:229/256.0 blue:229/256.0 alpha:1];

    _searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH, 50)];
    [_searchbar setPlaceholder:@"搜索模板"];//搜索框占位符
    [self.searchbar setBarStyle:UIBarStyleDefault];//searchbar的类型
    
    [self.searchbar setTranslucent:YES];//半透明
    
    [_searchbar setSearchResultsButtonSelected:NO];
    [self.searchbar setSearchResultsButtonSelected:NO];//设置搜索结果按钮
    [self.searchbar setShowsSearchResultsButton:NO];//是否显示结果按钮
   // [self.searchbar setShowsCancelButton:YES];
    [self.searchbar setKeyboardType:UIKeyboardTypeDefault];//设置键盘样式
    
    self.searchbar.delegate = self;
    
    [header addSubview:_searchbar];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 80)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView * backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,10, SCREENWIDTH, 60)];
    backImageView.image = [UIImage imageNamed:@"gongjubg@2x1"];
    NSArray *array = @[@"remen",@"zhizuodafenlei",@"zuixin",@"dongtai"];
    
    for(int i = 0;i <4;i ++){
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(trunUp:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat buttonW = SCREENWIDTH/4;
        CGFloat buttonH = 80;
        CGFloat buttonX = buttonW * i;
        CGFloat buttonY = 0;
        button.tag = 1000 + i;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [view addSubview:button];
    }
    [view insertSubview:backImageView atIndex:0];
    [header addSubview:view];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 135, SCREENWIDTH-20, 35)];
    imageView.image = [UIImage imageNamed:@"tuijian"];
    
    [header addSubview:imageView];
    
    return header;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    
    return CGSizeMake(SCREENWIDTH, 160);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    zjfMakeDetailViewController * detail = [[zjfMakeDetailViewController alloc]init];
    
    detail.model = _dataArray[indexPath.item];
    
    [self.navigationController pushViewController:detail animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}


//按钮跳转方法
- (void)trunUp:(UIButton *)button{
    
    if(button.tag == 1000){
        self.tabBarController.tabBar.hidden = YES;
        self.hidesBottomBarWhenPushed = YES;
        zjfHotViewController * hot = [[zjfHotViewController alloc]init];
        [self.navigationController pushViewController:hot animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if (button.tag == 1001){
        self.tabBarController.tabBar.hidden = YES;
        self.hidesBottomBarWhenPushed = YES;
        zjfSortViewController * sort = [[zjfSortViewController alloc]init];
        [self.navigationController pushViewController:sort animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if (button.tag ==1002){
        self.tabBarController.tabBar.hidden = YES;
        self.hidesBottomBarWhenPushed = YES;
        zjfNewViewController * new = [[zjfNewViewController alloc]init];
        [self.navigationController pushViewController:new animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if (button.tag ==1003){
        self.tabBarController.tabBar.hidden = YES;
        self.hidesBottomBarWhenPushed = YES;
        zjfPersonViewController * person = [[zjfPersonViewController alloc]init];
        [self.navigationController pushViewController:person animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
}


#pragma mark 添加帮助按钮和照相机
- (void)setNavBar{
    UIImage * image = [UIImage imageNamed:@"help"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(help)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"zhaoxiangji"] style:UIBarButtonItemStylePlain target:self action:@selector(camera)];
    
}

#pragma mark 帮助按钮点击跳转
- (void)help{
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;

    zjfHelpViewController * help = [[zjfHelpViewController alloc]init];
    
    [self.navigationController pushViewController:help animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)camera{
    
    UIAlertController * alerControl = [UIAlertController alertControllerWithTitle:@"" message:@"请选择照片" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * acton = [UIAlertAction actionWithTitle:@"从相机拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController  * picker = [[UIImagePickerController alloc]init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //是否可以编辑
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }else{
            NSLog(@"模拟器无法使用相机");
        }
        
        
    }];
    
    UIAlertAction * acton2 = [UIAlertAction actionWithTitle:@"从照片库选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.allowsEditing = YES;
            imagePicker.delegate = self;
            
            [self presentViewController:imagePicker animated:YES completion:^{
                
            }];
            
        }
        
        
    }];
    
    UIAlertAction * acton3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];

    [alerControl addAction:acton];
    [alerControl addAction:acton2];
    [alerControl addAction:acton3];
    [self showDetailViewController:alerControl sender:nil];
    
}

#pragma mark 照相机的代理实现
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"%@",info);
    if([info[@"UIImagePickerControllerMediaType"]isEqualToString:@"public.image"]){
        UIImage * image = info[@"UIImagePickerControllerOriginalImage"];
        zjfMakeDetailViewController * detail = [[zjfMakeDetailViewController alloc]init];
        
        detail.localImage = image;
        
        self.tabBarController.tabBar.hidden = YES;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}



//点击搜索框时调用

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    zjfSearchViewController * searchView = [[zjfSearchViewController alloc]init];
    
    [self.navigationController pushViewController:searchView animated:NO];
    //[self presentViewController:searchView animated:YES completion:nil];
    return YES;
}




//拖拽时不能再显示键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
