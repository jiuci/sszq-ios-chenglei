//
//  BYBDmapVC.m
//  IBY
//
//  Created by kangjian on 15/7/17.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "BYBDmapVC.h"
#import <BaiduMapAPI/BMKMapView.h>
#import "BYNavVC.h"
//#import "BYMapPointAnnotation.h"
//#import "BYMapMark.h"
//#import "BYCalloutMapAnnotation.h"
@interface BYBDmapVC ()
@property (nonatomic, strong) BMKMapView* mapView;
@property (nonatomic, strong) BMKMapManager* mapManager;
@property (nonatomic, strong) BMKLocationService* locationService;
@property (nonatomic, strong) BMKPoiSearch* poiSearch;
@property (nonatomic, assign) int curPage;
@property (nonatomic, strong) NSMutableDictionary* poiDic;
//@property (nonatomic, strong) BYCalloutMapAnnotation * calloutMapAnnotation;
@end

@implementation BYBDmapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem backBarItem:^(id sender) {
        [self.navigationController dismissViewControllerAnimated:YES
                                                      completion:nil];
    }];
    self.view.height = SCREEN_HEIGHT - self.navigationController.navigationBar.height -20;
    
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"A2Qq7tbEj98fG7op7xt5c0M6" generalDelegate:self];
    
    _mapView = [[BMKMapView alloc]init];
    [self.view addSubview:_mapView];
    _mapView.frame = self.view.frame;
    _mapView.zoomLevel = 14;
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)) {
        self.navigationController.navigationBar.translucent = NO;
    }
    _locationService = [[BMKLocationService alloc]init];
    
    _poiSearch = [[BMKPoiSearch alloc]init];
    
    
    // Do any additional setup after loading the view.
}
-(void)start
{
    [_locationService startUserLocationService];
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    
   
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_mapView viewWillAppear];
    _poiSearch.delegate = self;
    _mapView.delegate = self;
    _locationService.delegate = self;
    [self start];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_locationService stopUserLocationService];
    _mapView.showsUserLocation = NO;
    [_mapView viewWillDisappear];
    _poiSearch.delegate = nil;
    _mapView.delegate = nil;
    _locationService.delegate = nil;
}
-(void)willStartLocatingUser
{
}
-(void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    _curPage = 0;
    [_locationService stopUserLocationService];
    BMKNearbySearchOption * option = [[BMKNearbySearchOption alloc]init];
    option.keyword = @"验光配镜";
//    option.pageIndex = _curPage;
    option.pageCapacity = 10;
    option.radius = 5000;
    option.sortType = BMK_POI_SORT_BY_DISTANCE;
    option.location = userLocation.location.coordinate;

    [_poiSearch poiSearchNearBy:option];
}
-(BMKAnnotationView*)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    NSString*AnnotationViewID = @"pointMark";
    
    
    BMKPinAnnotationView * annotationView = (BMKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }

    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * .5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES;
    annotationView.draggable = NO;
    
    annotationView.paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:[self buildCusViewWithInfo:_poiDic[annotation.title]]];
    annotationView.paopaoView.backgroundColor = [UIColor whiteColor];
    annotationView.paopaoView.layer.shadowColor = [[UIColor blackColor] CGColor];
    annotationView.paopaoView.layer.shadowOpacity = 1.0;
    annotationView.paopaoView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    annotationView.paopaoView.layer.cornerRadius = 5;
    annotationView.paopaoView.layer.masksToBounds = YES;
    annotationView.paopaoView.layer.borderWidth = 1;
    annotationView.paopaoView.layer.borderColor = [HEXCOLOR(0x1aabde) CGColor];
    return annotationView;
}
-(UIView *)buildCusViewWithInfo:(NSMutableArray*)info
{
    UIView* cusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    float offset = 10;
    for (int i = 0; i<info.count; i++) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 250, 0)];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.text = info[i];
        if (i == 0) {
            label.font = [UIFont systemFontOfSize:18];
        }else{
            label.font = [UIFont systemFontOfSize:14];
        }
        label.textColor = HEXCOLOR(0x523669);
        label.top = offset;
        [label sizeToFit];
        [cusView addSubview:label];
        cusView.width = cusView.width < label.width? label.width:cusView.width;
        offset += label.height + 5;
    }
    cusView.width += 20;
    cusView.centerX = 0;
    cusView.height = offset +5;
    cusView.bottom = 0;
    cusView.backgroundColor = [UIColor whiteColor];
    return cusView;
    
}
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
-(void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    
}
-(void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    NSArray * array = [NSArray arrayWithArray:_mapView.annotations];
    _poiDic = [NSMutableDictionary dictionary];
    [_mapView removeAnnotations:array];
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        NSMutableArray * annotations = [NSMutableArray array];
        for (int i = 0; i<poiResult.poiInfoList.count; i++) {
            BMKPoiInfo* poi = poiResult.poiInfoList[i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            item.subtitle = [NSString stringWithFormat:@"地址:%@\n电话:%@",poi.address,poi.phone];
            NSMutableArray*array = [NSMutableArray array];
            if (poi.name) {
                [array addObject:poi.name];
            }
            if (poi.address) {
                [array addObject:[NSString stringWithFormat:@"地址:%@",poi.address]];
            }
            if (poi.phone) {
                [array addObject:[NSString stringWithFormat:@"电话:%@",poi.phone]];
            }
            [_poiDic setObject:array forKey:poi.name];
            [annotations addObject:item];
        }
        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];
    }
}
-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    
    [mapView sendSubviewToBack:view];
    [mapView setNeedsDisplay];

}
-(void)didFailToLocateUserWithError:(NSError *)error
{
    UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"定位失败" message:@"请在设置-隐私下开启定位权限"];
    __weak BYBDmapVC * bself = self;
    [alert bk_addButtonWithTitle:@"确定" handler:^{
        [bself.navigationController dismissViewControllerAnimated:YES
                                                      completion:nil];
    }];
    [alert show];
}
-(void)didStopLocatingUser
{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onGetNetworkState:(int)iError
{
    if (iError != 0) {
        [MBProgressHUD topShowTmpMessage:@"网络连接异常，请调整后重试"];
    }
}
-(void)dealloc
{
    if (_mapView) {
        _mapView = nil;
    }
    if (_poiSearch) {
        _poiSearch = nil;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
BYNavVC* makeMapnav()
{
    BYBDmapVC* vc = [[BYBDmapVC alloc] init];
    BYNavVC* nav = [BYNavVC nav:vc title:@"附近验光点"];
    
    return nav;
}
@end
