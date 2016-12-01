//
//  MakeViewController.m
//  douTu
//
//  Created by  wyzc02 on 16/12/1.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "MakeViewController.h"
#import "MakeCollectionViewCell.h"
#import "zjfHotViewController.h"
#import "zjfSortViewController.h"
#import "zjfNewViewController.h"
#import "zjfPersonViewController.h"
#import "zjfMakeDetailViewController.h"
@interface MakeViewController ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

//请求数据的数组
@property (nonatomic,strong)NSMutableArray * dataArray;
//搜索框
@property (nonatomic,strong)UISearchBar * searchbar;
//collectionView
@property (nonatomic,strong)UICollectionView * collectionView;

@end

static NSString * const reuse = @"cell";
@implementation MakeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"制图";
    self.view.backgroundColor = [UIColor colorWithRed:229/256.0 green:229/256.0 blue:229/256.0 alpha:1];
    
    [self setSeacherbar];
    
    [self setUpbutton];
    
    [self setCollectionView];
    
    // Do any additional setup after loading the view.
}

- (void)requestData{
    
    
}

- (void)setCollectionView{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.itemSize = CGSizeMake((SCREENWIDTH-80)/3, (SCREENHEIGHT-194-49)/4.5);
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = 10;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 0, 20);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64+50+80, SCREENWIDTH, SCREENHEIGHT-194-49) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor =[UIColor colorWithRed:229/256.0 green:229/256.0 blue:229/256.0 alpha:1];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[MakeCollectionViewCell class] forCellWithReuseIdentifier:reuse];
    
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:_collectionView];
}

#pragma mark collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 18;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MakeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
    cell.layer.cornerRadius = 10;
    cell.contentView.layer.cornerRadius = 10;
    cell.contentView.layer.masksToBounds = YES;
    
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    header.backgroundColor = [UIColor colorWithRed:229/256.0 green:229/256.0 blue:229/256.0 alpha:1];
    
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tuijian"]];
    [header addSubview:imageView];
    
    return header;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    
    return CGSizeMake(30, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    zjfMakeDetailViewController * detail = [[zjfMakeDetailViewController alloc]init];
    
    [self.navigationController pushViewController:detail animated:YES];
    
    
}


//添加按钮
- (void)setUpbutton{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 64+50, SCREENWIDTH, 80)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView * backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 60)];
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
    [self.view addSubview:view];
}


//按钮跳转方法
- (void)trunUp:(UIButton *)button{
    
    if(button.tag == 1000){
        zjfHotViewController * hot = [[zjfHotViewController alloc]init];
        [self.navigationController pushViewController:hot animated:YES];
    }else if (button.tag == 1001){
        zjfSortViewController * sort = [[zjfSortViewController alloc]init];
        
        [self.navigationController pushViewController:sort animated:YES];
    }else if (button.tag ==1002){
        zjfNewViewController * new = [[zjfNewViewController alloc]init];
        [self.navigationController pushViewController:new animated:YES];
    }else if (button.tag ==1003){
        zjfPersonViewController * person = [[zjfPersonViewController alloc]init];
        [self.navigationController pushViewController:person animated:YES];
    }
    
}

//添加搜索框
- (void)setSeacherbar{
    _searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH, 50)];
    [_searchbar setPlaceholder:@"搜索模板"];//搜索框占位符
    [self.searchbar setBarStyle:UIBarStyleDefault];//searchbar的类型
    
    [self.searchbar setTranslucent:YES];//半透明
    
    [_searchbar setSearchResultsButtonSelected:NO];
    [self.searchbar setSearchResultsButtonSelected:NO];//设置搜索结果按钮
    [self.searchbar setShowsSearchResultsButton:NO];//是否显示结果按钮
    
    [self.searchbar setKeyboardType:UIKeyboardTypeDefault];//设置键盘样式
    
    
    
    
    self.searchbar.delegate = self;
    [self.view addSubview:_searchbar];
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
