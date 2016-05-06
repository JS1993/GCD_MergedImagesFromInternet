//
//  ViewController.m
//  GCD_MergedImagesFromInternet
//
//  Created by  江苏 on 16/5/6.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong)UIImage* image1;

@property(nonatomic,strong)UIImage* image2;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建一个队列
    dispatch_group_t group=dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL* url=[NSURL URLWithString:@"http://d.hiphotos.baidu.com/image/h%3D200/sign=5dd4abde3f6d55fbdac671265d224f40/a044ad345982b2b7abe1fec433adcbef76099bb0.jpg"];
        
        NSData* data=[NSData dataWithContentsOfURL:url];
        
        self.image1=[UIImage imageWithData:data];
        
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL* url=[NSURL URLWithString:@"http://h.hiphotos.baidu.com/image/h%3D200/sign=52e860e6932397ddc9799f046983b216/dc54564e9258d109840ef0b3d358ccbf6d814dc5.jpg"];
        
        NSData* data=[NSData dataWithContentsOfURL:url];
        
        self.image2=[UIImage imageWithData:data];
        
    });
    
    //线程队列里的任务完成才会进行这个队列
    dispatch_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        UIGraphicsBeginImageContext(CGSizeMake(320, 568));
        
        [self.image1 drawInRect:CGRectMake(0, 0, 320, 200)];
        
        [self.image2 drawInRect:CGRectMake(0, 200, 320, 369)];
        
        UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
        
        //渲染完成后，回到主界面更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.imageView.image=image;
            
        });
        
        
        
        
    });
}

@end
