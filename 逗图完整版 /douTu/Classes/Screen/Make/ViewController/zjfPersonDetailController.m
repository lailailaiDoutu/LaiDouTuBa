//
//  zjfPersonDetailController.m
//  斗图APP
//
//  Created by wyzc04 on 16/12/5.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "zjfPersonDetailController.h"
#import "zjfPersonDetailCollectionViewCell.h"
#import "zjfMakeDetailViewController.h"
@interface zjfPersonDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)NSMutableArray * personDetails;

@end

@implementation zjfPersonDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.personModel.name;
    _personDetails  = [NSMutableArray array];
    
    [self setCollectionView];
    
    [self requestData];
    // Do any additional setup after loading the view.
}
- (void)setCollectionView{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.itemSize = CGSizeMake((SCREENWIDTH-80)/3, (SCREENHEIGHT-194-49)/4.5);
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = 10;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 0, 20);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor =[UIColor colorWithRed:229/256.0 green:229/256.0 blue:229/256.0 alpha:1];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[zjfPersonDetailCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
}

#pragma mark collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _personDetails.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    zjfPersonDetailCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 10;
    cell.contentView.layer.cornerRadius = 10;
    cell.contentView.layer.masksToBounds = YES;
    zjfPersonDetailModel * personDetailModel = _personDetails[indexPath.item];
    cell.personDetailmodel = personDetailModel;
    
    if ([personDetailModel.gifPath hasSuffix:@"gif"]){
        cell.gifImageView.hidden = NO;
    }else{
        cell.gifImageView.hidden = YES;
    }

    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    zjfMakeDetailViewController * makeDetail = [[zjfMakeDetailViewController alloc]init];
    
    makeDetail.personDetailModel = _personDetails[indexPath.item];
    [self.navigationController pushViewController:makeDetail animated:YES];
    
}

//请求数据
- (void)requestData{

    //NSString * str = @"http://api.jiefu.tv/app2/api/dt/item/getByTag.html?tagId=86&pageNum=0&pageSize=48";
    

    
    NSString * str = [NSString stringWithFormat:@"http://api.jiefu.tv/app2/api/dt/item/getByTag.html?tagId=%@&pageNum=0&pageSize=48",self.personModel.id];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * muarr = [NSMutableArray array];
        
        for (NSDictionary * dic in responseObject[@"data"]) {
            zjfPersonDetailModel * personDetailModel = [[zjfPersonDetailModel alloc]init];
            [personDetailModel setValuesForKeysWithDictionary:dic];
            [muarr addObject:personDetailModel];
            
        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_personDetails addObjectsFromArray:muarr];
            [_collectionView reloadData];
        });
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"++++%@+++",error);
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
