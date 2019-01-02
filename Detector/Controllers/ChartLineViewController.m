//
//  ChartLineViewController.m
//  BlueToothTool
//
//  Created by Mac2 on 2018/10/10.
//  Copyright © 2018年 Mac2. All rights reserved.
//

#import "ChartLineViewController.h"
#import "AAChartKit.h"

@interface ChartLineViewController ()

@property (nonatomic, strong) AAChartModel *aaChartModel;
@property (nonatomic, strong) AAChartView  *aaChartView;
@property (nonatomic, assign) int maxValue;
@property (nonatomic, strong) NSMutableArray *dataNumbers;
@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation ChartLineViewController

- (NSMutableArray *)dataNumbers {
    if (!_dataNumbers) {
        _dataNumbers = [NSMutableArray array];
    }
    return _dataNumbers;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[UIDevice currentDevice] setValue: [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];

    self.maxValue = 0;
    NSArray *numbers = [self.dataString componentsSeparatedByString:@","];
    for (NSString *numberStr in numbers) {
        double value = [numberStr doubleValue];
        if (value > self.maxValue) {
            self.maxValue = ceil(value);
        }
        NSNumber * num = @(value);
        [self.dataNumbers addObject:num];
    }
    [self addChartLineView];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, 20, 80, 40);
    [self.backBtn setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(BackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"数据折线图";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn);
        make.left.mas_equalTo(80);
        make.right.mas_equalTo(-80);
        make.height.mas_equalTo(40);
    }];
}

- (void)BackAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addChartLineView {
    self.aaChartView = [[AAChartView alloc]init];
    self.aaChartView.scrollEnabled = NO;//禁用 AAChartView 滚动效果
    //    设置aaChartVie 的内容高度(content height)
    //    self.aaChartView.contentHeight = chartViewHeight*2;
    //    设置aaChartVie 的内容宽度(content  width)
    //    self.aaChartView.contentWidth = chartViewWidth*2;
    [self.view addSubview:self.aaChartView];
    [self.aaChartView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(0);
    }];
    
    //设置 AAChartView 的背景色是否为透明
    self.aaChartView.isClearBackgroundColor = YES;
    
    self.aaChartModel= AAObject(AAChartModel)
//    .legendEnabledSet(NO)//是否显示底部图表标题
//    .tooltipEnabledSet(NO)//是否显示提示框
    .zoomTypeSet(AAChartZoomTypeX)
    .chartTypeSet(AAChartTypeArea)//图表类型
    .titleSet(@"")//图表主标题
    .subtitleSet(@"")//图表副标题
    .yAxisLineWidthSet(@0.5)//Y轴轴线线宽为0即是隐藏Y轴轴线
    .colorsThemeSet(@[@"#6699FF"])//设置主体颜色数组
    .yAxisTitleSet(@"")//设置 Y 轴标题
    .tooltipValueSuffixSet(@"")//设置浮动提示框单位后缀
    .yAxisGridLineWidthSet(@0.5)//y轴横向分割线宽度为0(即是隐藏分割线)
    .xAxisGridLineWidthSet(@0.5)//x轴横向分割线宽度为0(即是隐藏分割线)
    .yAxisMaxSet(@(self.maxValue))//Y轴最大值
    .yAxisMinSet(@(0))//Y轴最小值
//    .yAxisTickPositionsSet(@[@(0),@(2000),@(4000),@(6000),@(8000),@(10000)])//指定y轴坐标
    .xAxisTickIntervalSet(@(300))//X轴数值间隔
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet(@"光谱采集数据")
                 .dataSet([self.dataNumbers copy])
                 ]
               );
    _aaChartModel.symbolStyle = AAChartSymbolStyleTypeInnerBlank;//设置折线连接点样式为:内部白色
    _aaChartModel.gradientColorEnabled = true;//启用渐变色
    _aaChartModel.animationType = AAChartAnimationEaseOutQuart;//图形的渲染动画为 EaseOutQuart 动画
    _aaChartModel.xAxisCrosshairWidth = @0.9;//Zero width to disable crosshair by default
    _aaChartModel.xAxisCrosshairColor = @"#FFE4C4";//(浓汤)乳脂,番茄色准星线
    _aaChartModel.xAxisCrosshairDashStyleType = AALineDashSyleTypeLongDashDot;
    _aaChartModel.yAxisVisible = true;
    [self.aaChartView aa_drawChartWithChartModel:_aaChartModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%@ dealloc",self);
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
