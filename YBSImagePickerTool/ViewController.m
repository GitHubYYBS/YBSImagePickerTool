//
//  ViewController.m
//  YBSImagePickerTool
//
//  Created by 严兵胜 on 2018/4/25.
//  Copyright © 2018年 严兵胜. All rights reserved.
//

#import "ViewController.h"

#import "YBSImagePickerTool.h"


/**  尺寸 */
#define YBSSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define YBSSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// 宽度适配
#define LQScalingStyle(Value) (Value*YBSSCREEN_WIDTH/750)

@interface ViewController ()

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(LQScalingStyle(48), LQScalingStyle(334), LQScalingStyle(654), LQScalingStyle(410))];
    imageView.center = self.view.center;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_imageView = imageView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}




- (void)clickBtn{
    
    YBSImagePickerTool *tool = [YBSImagePickerTool new];
    tool.ybs_fullScreenTakePickerBool =true;
    
    [tool ybs_ImagePickerToolWithMaxImagesCount:2 didFinishPickingPhotos:^(NSArray *imagesArray) {
        self.imageView.image = imagesArray[0];
    } failure:^(NSString *errorStr) {
        
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
