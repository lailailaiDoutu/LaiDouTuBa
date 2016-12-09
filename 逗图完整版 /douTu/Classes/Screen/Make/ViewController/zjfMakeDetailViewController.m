//
//  MakeDetailViewController.m
//  斗图APP
//
//  Created by wyzc04 on 16/12/1.
//  Copyright © 2016年 wyzc04. All rights reserved.
//

#import "zjfMakeDetailViewController.h"
#import "zjfWenziColorController.h"
#import "zjfDetailTableViewCell.h"
#import <sqlite3.h>
#import <UShareUI/UMSocialUIManager.h>
#import "UIImage+WaterMark.h"
@interface zjfMakeDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextViewDelegate>

@property (nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic,strong) UITableView * tableView;
//显示文字色的颜色滑块
@property (nonatomic,strong) UISlider * wenZiColorsliderR;

@property (nonatomic,strong) UISlider * wenZiColorsliderG;

@property (nonatomic,strong) UISlider * wenZiColorsliderB;

//背景色

@property (nonatomic,strong) UISlider * backColorsliderR;

@property (nonatomic,strong) UISlider * backColorsliderG;

@property (nonatomic,strong) UISlider * backColorsliderB;

//传递过来的图片
@property (nonatomic,strong)UIImageView * douTuImage ;

@property (nonatomic,strong) NSMutableArray * dataArray;
//网址
@property (nonatomic,copy) NSString * url;

//添加在view上图片的label
@property (nonatomic,strong) UILabel * label;
@property (nonatomic,strong) UITextView * textView;

//添加在
@property (nonatomic,strong) UIView * viewsBack;

//添加在图库上图片的label
@property (nonatomic,strong) UITextField * localTextfield;

//当前选中的button
@property (nonatomic,strong) UIButton * selectedButton;

@property (nonatomic,strong)  NSMutableArray * sendArr;

@property (nonatomic,strong)     NSString * insertPicture;
//文字颜色
@property (nonatomic,strong) UIColor * textColor;
//文字字体
@property (nonatomic,strong) NSString * textFont;


@end

@implementation zjfMakeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textFont = @"KohinoorTelugu-Regular";
    _textColor = [UIColor blackColor];
    
    self.title = @"制作表情";
    self.view.backgroundColor = [UIColor colorWithRed:229/256.0 green:229/256.0 blue:229/256.0 alpha:1];

    //创建tableView
     [self setTableView];
    //改变文字颜色
    [self setWenziColor];
    //改变背景颜色
    [self setbackColor];
    //创建nav按钮
    [self setNav];
   //添加字体
    [self setFont];
    _dataArray = [NSMutableArray array];
    _sendArr = [NSMutableArray array];
    
    //设置图库传到制作页的图片和文字
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 30+64, SCREENWIDTH-60, SCREENHEIGHT * 0.65- 150)];
    imageView.userInteractionEnabled = YES;
    //判断是否是图库的图片
    if((imageView.image = self.localImage)){
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0,(SCREENHEIGHT *0.65-124)*0.7 ,SCREENWIDTH -60, 50)];
        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.font = [UIFont systemFontOfSize:25];
        _textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _textView.backgroundColor = [UIColor clearColor];
        _textView.scrollEnabled = NO;
        //_localTextfield.backgroundColor = [UIColor blueColor];
//        [_localTextfield addTarget:self action:@selector(lostResponder:) forControlEvents:UIControlEventTouchDown];
        [imageView addSubview:_textView];
        [self.view addSubview:imageView];

    }else{
       
        [self requesetData];
        [self setCell];
        
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)lostResponder:(UITextField *)textfield{
    
    [textfield resignFirstResponder];
    
}

- (void)setCell{
    //设置其他页传过来的图片和文字
     _douTuImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 30+64, SCREENWIDTH-60, SCREENHEIGHT *0.65-124)];
    _douTuImage.userInteractionEnabled = YES;
    
    _viewsBack =[[UIView alloc]initWithFrame:CGRectMake(0,(SCREENHEIGHT *0.65-124)*0.7 ,SCREENWIDTH -60, 50)];
//    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-60, 50)];
//    _label.textAlignment = NSTextAlignmentCenter;
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(20, -10, self.douTuImage.frame.size.width-40,50)];
    _textView.delegate = self;
    _textView.textAlignment = NSTextAlignmentCenter;
    _textView.font = [UIFont systemFontOfSize:25];
    _textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _textView.backgroundColor = [UIColor clearColor];
    _textView.scrollEnabled = NO;
    if(self.model){
        [_douTuImage sd_setImageWithURL:[NSURL URLWithString:self.model.gifPath]];
        _textView.text = self.model.name;

    }else if (self.hotModel){
        [_douTuImage sd_setImageWithURL:[NSURL URLWithString:self.hotModel.gifPath]];
        _textView.text = self.hotModel.name;

    }else if(self.newzjfModel){
        [_douTuImage sd_setImageWithURL:[NSURL URLWithString:self.newzjfModel.gifPath]];
        _textView.text = self.newzjfModel.name;

    }else if(self.personDetailModel){
        [_douTuImage sd_setImageWithURL:[NSURL URLWithString:self.personDetailModel.gifPath]];
        _textView.textColor = [UIColor whiteColor];
        _textView.text = self.personDetailModel.name;
        
    }else if(self.sortModel){
        [_douTuImage sd_setImageWithURL:[NSURL URLWithString:self.sortModel.gifPath]];
        _textView.textColor = [UIColor blackColor];
        _textView.text = self.sortModel.name;
        
    }

//    _label.numberOfLines = 0;
//    _label.frame = CGRectMake(20, 10, self.douTuImage.frame.size.width-40,100);

    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(move:)];
    
    [_viewsBack addGestureRecognizer:pan];
   [_viewsBack addSubview:_textView];
    [_douTuImage addSubview:_viewsBack];
    
    [self.view addSubview:_douTuImage];
    
    
}
-(void)textViewDidChange:(UITextView *)textView{
    static CGFloat maxHeight =100.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
    }else{
        if (size.height >= maxHeight)
        {
            size.height = maxHeight;
            textView.editable = NO;
            textView.scrollEnabled = YES;   // 允许滚动
        }
        else
        {
            textView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    return [textView resignFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
}
//手势
- (void)move:(UIPanGestureRecognizer *)pan{
    //取到view
    UIView * view = (UIView *)[pan view];
    
    //取到当前的手指位置
    CGPoint point = [pan translationInView:self.view];
    
    //确定每次平移距离加0
    [pan setTranslation:CGPointZero inView:self.view];
    
    //移动
    view.transform = CGAffineTransformTranslate(view.transform, point.x, point.y);
}


- (void)setTableView{
    
    NSArray * array = @[@"peiwen",@"wenzise",@"beijingse",@"ziti"];
    NSArray * arrayLv = @[@"peiwenlv",@"wenziselv",@"beijingselv",@"zitilv"];
    
    //按钮添加在图片上的
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT*0.65, SCREENWIDTH, 80)];
    imageView.image = [UIImage imageNamed:@"gongjubg"];
    imageView.userInteractionEnabled = YES;
   
    
    //添加按钮
    for(int i = 0;i < 4;i ++){
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:arrayLv[i]] forState:UIControlStateSelected];
        CGFloat buttonW = SCREENWIDTH/4;
        CGFloat buttonH = 80;
        CGFloat buttonX = buttonW * i;
        CGFloat buttonY = 0;
        button.tag = 1000 + i;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            button.selected = YES;
            self.selectedButton = button;
        }
        
        [imageView addSubview:button];
        
   }
        [self.view addSubview:imageView];
    //添加scrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT*0.65+80, SCREENWIDTH, SCREENHEIGHT * 0.35)];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.scrollEnabled = NO;
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH *4, SCREENHEIGHT * 0.35-49);
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor colorWithRed:229/256.0 green:243/256.0 blue:233/256.0 alpha:1];
    [self.view addSubview:_scrollView];

        //添加tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT * 0.35-71) style:UITableViewStylePlain];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerClass:[zjfDetailTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [_scrollView addSubview:_tableView];
    
}
 //添加颜色滑块
- (void)setWenziColor{
   
    _wenZiColorsliderR = [[UISlider alloc]initWithFrame:CGRectMake(SCREENWIDTH+50, 30, SCREENWIDTH-100, 20)];
    _wenZiColorsliderG = [[UISlider alloc]initWithFrame:CGRectMake(SCREENWIDTH+50, 60, SCREENWIDTH-100, 20)];
    _wenZiColorsliderB = [[UISlider alloc]initWithFrame:CGRectMake(SCREENWIDTH+50, 90, SCREENWIDTH-100, 20)];
    [_wenZiColorsliderR addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    [_wenZiColorsliderG addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    [_wenZiColorsliderB addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    _wenZiColorsliderR.minimumValue = 0;
    _wenZiColorsliderR.maximumValue = 256;
    _wenZiColorsliderR.value = 0;
    _wenZiColorsliderG.minimumValue = 0;
    _wenZiColorsliderG.maximumValue = 256;
    _wenZiColorsliderG.value = 0;
    _wenZiColorsliderB.minimumValue = 0;
    _wenZiColorsliderB.maximumValue = 256;
    _wenZiColorsliderB.value = 0;
    [self.scrollView addSubview:_wenZiColorsliderR];
    [self.scrollView addSubview:_wenZiColorsliderG];
    [self.scrollView addSubview:_wenZiColorsliderB];

}
//添加背景滑块
- (void)setbackColor{
    
    _backColorsliderR = [[UISlider alloc]initWithFrame:CGRectMake(SCREENWIDTH*2 +50, 30, SCREENWIDTH-100, 20)];
    _backColorsliderG = [[UISlider alloc]initWithFrame:CGRectMake(SCREENWIDTH *2+50, 60, SCREENWIDTH-100, 20)];
    _backColorsliderB = [[UISlider alloc]initWithFrame:CGRectMake(SCREENWIDTH*2+50, 90, SCREENWIDTH-100, 20)];
    [_backColorsliderR addTarget:self action:@selector(changeBack:) forControlEvents:UIControlEventValueChanged];
    [_backColorsliderG addTarget:self action:@selector(changeBack:) forControlEvents:UIControlEventValueChanged];
    [_backColorsliderB addTarget:self action:@selector(changeBack:) forControlEvents:UIControlEventValueChanged];
    _backColorsliderR.minimumValue = 0;
    _backColorsliderR.maximumValue = 256;
    _backColorsliderR.value = 0;
    _backColorsliderR.minimumValue = 0;
    _backColorsliderG.maximumValue = 256;
    _backColorsliderB.value = 0;
    _backColorsliderR.minimumValue = 0;
    _backColorsliderG.maximumValue = 256;
    _backColorsliderB.value = 0;
    [self.scrollView addSubview:_backColorsliderR];
    [self.scrollView addSubview:_backColorsliderG];
    [self.scrollView addSubview:_backColorsliderB];

}

//设置字体
- (void)setFont{
    NSArray * array = @[@"宋体",@"楷体",@"黑体"];
    for(int i = 0; i< 3;i ++){
    
    UIButton * fontButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fontButton.frame = CGRectMake(SCREENWIDTH * 3 +80 *(i + 1), 40, 80, 50);
        [fontButton setTitle:array[i] forState:UIControlStateNormal];
    fontButton.tag = 200+ i;
    fontButton.backgroundColor = [UIColor redColor];
        [fontButton addTarget:self action:@selector(addFont:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:fontButton];
    }
}
- (void)addFont:(UIButton *)button{
    
    if(button.tag == 200){

        NSString * str = @"KohinoorTelugu-Regular";
        _textView.font = [UIFont fontWithName:str size:25];
//        _localTextfield.font =[UIFont fontWithName:str size:25];
        _textFont = str;
    }else if (button.tag == 201){
        NSString * str = @"AppleSDGothicNeo-Bold";
        _textView.font = [UIFont fontWithName:str size:25];
        //_localTextfield.font =[UIFont fontWithName:str size:25];
        _textFont = str;
    }else{
        NSString * str = @"AvenirNextCondensed-BoldItalic";
        _textView.font = [UIFont fontWithName:str size:25];
        //_localTextfield.font =[UIFont fontWithName:str size:25];
        _textFont = str;
        
    }
}

- (void)changeBack:(UISlider *)slider{
    UIColor * color = [UIColor colorWithRed:_backColorsliderR.value/256.0 green:_backColorsliderG.value/256.0 blue:_backColorsliderB.value/256.0 alpha:0.5];
    _textView.backgroundColor = color;
    //_localTextfield.backgroundColor = color;
}

- (void)changeValue:(UISlider *)slider{
    
    UIColor * color = [UIColor colorWithRed:_wenZiColorsliderR.value/256.0 green:_wenZiColorsliderG.value/256.0 blue:_wenZiColorsliderB.value/256.0 alpha:1];
    
    _textView.textColor = color;
    //_localTextfield.textColor = color;
    _textColor = color;
}



- (void)click:(UIButton *)button
{
    if (button != self.selectedButton) {
        self.selectedButton.selected = NO;
        self.selectedButton = button;
    }
    self.selectedButton.selected = YES;
    
    if(button.tag == 1000){
       
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }else if(button.tag == 1001){
        self.scrollView.contentOffset = CGPointMake(SCREENWIDTH, 0);

    }else if(button.tag == 1002){

        self.scrollView.contentOffset = CGPointMake(SCREENWIDTH*2, 0);
        
    }else if(button.tag == 1003){


        self.scrollView.contentOffset = CGPointMake(SCREENWIDTH*3, 0);
        
    }

}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    zjfDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:229/256.0 green:243/256.0 blue:233/256.0 alpha:1];
    cell.detailModel = _dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    zjfMakeDetailModel * makeDetailModel = _dataArray[indexPath.row];
    _textView.text = makeDetailModel.word;
    
    
}

- (void)requesetData{
    
    //判断从哪个页面传过来的id
    if(self.model){
    _url = [NSString stringWithFormat:@"http://api.jiefu.tv/app2/api/dt/item/getDetail.html?itemId=%@",self.model.id];
    }else if (self.hotModel){
        _url = [NSString stringWithFormat:@"http://api.jiefu.tv/app2/api/dt/item/getDetail.html?itemId=%@",self.hotModel.id];
    }else if (self.newzjfModel){
        _url = [NSString stringWithFormat:@"http://api.jiefu.tv/app2/api/dt/item/getDetail.html?itemId=%@",self.newzjfModel.id];
    }else if (self.personDetailModel){
        _url = [NSString stringWithFormat:@"http://api.jiefu.tv/app2/api/dt/item/getDetail.html?itemId=%@",self.personDetailModel.id];
    }else if (self.sortModel){
        _url = [NSString stringWithFormat:@"http://api.jiefu.tv/app2/api/dt/item/getDetail.html?itemId=%@",self.sortModel.id];
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:_url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray * muarr = [NSMutableArray array];
        NSArray * array = responseObject[@"data"][@"list"];
        for (NSDictionary * dic in array) {
            zjfMakeDetailModel * makeDetailModel = [[zjfMakeDetailModel alloc]init];
            //NSString * word = dic[@"word"];
            [makeDetailModel setValuesForKeysWithDictionary:dic];
            
            [muarr addObject:makeDetailModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_dataArray addObjectsFromArray:muarr];
            [_tableView reloadData];
            
            
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"===%@===",error);
    }];
    
    
}

//发送按钮
- (void)setNav{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(push:)];
    
}


//数据库句柄
sqlite3 * db;
- (void)push:(UIBarButtonItem *)barButton{
    //制作
    [self setMakeCreat];
    
    __weak typeof(self) weakSelf = self;
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Middle;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRoundAndSuperRadius;
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [weakSelf shareTextToPlatformType:platformType];
    }];
}
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    UIImage * baseImage = _douTuImage.image;
    
    UIImage * resultImage = [baseImage imageWaterMarkWithString:_textView.text point:CGPointMake(_viewsBack.frame.origin.x + 10,_viewsBack.frame.origin.y) attribute:@{NSForegroundColorAttributeName:_textColor,NSFontAttributeName:[UIFont fontWithName:_textFont size:30]}];
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareImageObject * object = [[UMShareImageObject alloc]init];
    
    object.shareImage = resultImage;
    
    messageObject.shareObject = object;
        
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            //发送图片到我发送的
            [self setDataBase];
            NSLog(@"response data is %@",data);
        }
    }];
}
- (void)setMakeCreat{
    //打开或者创建数据库路径
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"dataBase.sqlite"];
    
    int result = sqlite3_open(path.UTF8String, &db);
    if(result == SQLITE_OK){
        NSLog(@"数据库打开成功");
    }else{
        
        NSLog(@"数据库打开失败");
    }
    
    NSString * createTablesql = @"create table if not exists Make (picture text)";
    //创建错误
    char * error = NULL;
    //标志creat语句是否成功
    int result2 = sqlite3_exec(db, createTablesql.UTF8String, NULL, NULL, &error);
    if(result2 == SQLITE_OK){
        
        NSLog(@"创建表成功");
    }else{
        
        NSLog(@"创建表失败%s",error);
    }
    
    //插入数据
    if(self.model){
        _insertPicture = [NSString stringWithFormat:@"insert into Make(picture) values ('%@')",self.model.gifPath];
    }else if (self.hotModel){
        _insertPicture = [NSString stringWithFormat:@"insert into Make(picture) values ('%@')",self.hotModel.gifPath];
    }else if (self.newzjfModel){
        _insertPicture = [NSString stringWithFormat:@"insert into Make(picture) values ('%@')",self.newzjfModel.gifPath];
    }else if (self.personDetailModel){
        _insertPicture = [NSString stringWithFormat:@"insert into Make(picture) values ('%@')",self.personDetailModel.gifPath];
    }else if (self.sortModel){
        _insertPicture = [NSString stringWithFormat:@"insert into Make(picture) values ('%@')",self.sortModel.gifPath];
    }
    
    
    
    char * error3 = NULL;
    
    //判断是否插入成功
    int result3 = sqlite3_exec(db, _insertPicture.UTF8String, NULL, NULL, &error3);
    
    if(result3 == SQLITE_OK){
        
        NSLog(@"插入数据成功");
    }else{
        NSLog(@"插入数据失败%s",error);
        
    }

}

- (void)setDataBase{
    //打开或者创建数据库路径
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"dataBase.sqlite"];
    
    int result = sqlite3_open(path.UTF8String, &db);
    if(result == SQLITE_OK){
        NSLog(@"数据库打开成功");
    }else{
        
        NSLog(@"数据库打开失败");
    }
    
    NSString * createTablesql = @"create table if not exists Send (picture text)";
    //创建错误
    char * error = NULL;
    //标志creat语句是否成功
    int result2 = sqlite3_exec(db, createTablesql.UTF8String, NULL, NULL, &error);
    if(result2 == SQLITE_OK){
        
        NSLog(@"创建表成功");
    }else{
        
        NSLog(@"创建表失败%s",error);
    }
    
    //插入数据
    if(self.model){
    _insertPicture = [NSString stringWithFormat:@"insert into Send(picture) values ('%@')",self.model.gifPath];
    }else if (self.hotModel){
        _insertPicture = [NSString stringWithFormat:@"insert into Send(picture) values ('%@')",self.hotModel.gifPath];
    }else if (self.newzjfModel){
        _insertPicture = [NSString stringWithFormat:@"insert into Send(picture) values ('%@')",self.newzjfModel.gifPath];
    }else if (self.personDetailModel){
        _insertPicture = [NSString stringWithFormat:@"insert into Send(picture) values ('%@')",self.personDetailModel.gifPath];
    }else if (self.sortModel){
        _insertPicture = [NSString stringWithFormat:@"insert into Send(picture) values ('%@')",self.sortModel.gifPath];
    }



    char * error3 = NULL;
    
    //判断是否插入成功
    int result3 = sqlite3_exec(db, _insertPicture.UTF8String, NULL, NULL, &error3);
    
    if(result3 == SQLITE_OK){
        
        NSLog(@"插入数据成功");
    }else{
        NSLog(@"插入数据失败%s",error);
        
    }

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
