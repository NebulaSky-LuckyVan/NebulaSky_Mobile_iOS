//
//  ViewController.m
//  MultipleTargetProjectBrDemand
//
//  Created by VanZhang on 2020/11/20.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"主页";
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSString *EnviromentValueDesc = @"";
    switch (ProjEnvState) {
        case 0:{
            EnviromentValueDesc = @"1";
        } break;
        case 1:{
            EnviromentValueDesc = @"2";
        } break;
        case 2:{
            EnviromentValueDesc = @"3";
        } break;
        case 3:{
            EnviromentValueDesc = @"4";
        } break;
        case 4:{
            EnviromentValueDesc = @"5";
        } break;
    }
    
    NSLog(@"工程环境状态值:%@",EnviromentValueDesc);
}


@end
