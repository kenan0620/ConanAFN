//
//  ConanAFNViewController.m
//  ConanAFN
//
//  Created by acct<blob>=<NULL> on 03/20/2017.
//  Copyright (c) 2017 acct<blob>=<NULL>. All rights reserved.
//

#import "ConanAFNViewController.h"
//#define SaveFilePath(fileClassify,fileType,fileName) [[[NSHomeDirectory() stringByAppendingPathComponent:fileClassify] stringByAppendingPathComponent:fileType] stringByAppendingPathComponent:fileName]

#define SaveFilePath(fileName) [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:fileName]

#define TempFilePath(fileName) [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]stringByAppendingPathComponent:fileName]

#import <ConanAFN/ConanSaveFilePath.h>
#define FileArc4 1000000000000+arc4random() % 9999999999999

#import <ConanAFN/ConanAfnAPI.h>

#import <ConanAFN/ConanEncryption.h>
#import <ConanAFN/XYXMBProgressHUD+Event.h>
@interface ConanAFNViewController ()

@end

@implementation ConanAFNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIImage *imag = [UIImage imageNamed:@"1.png"];

    UIImage *imag1 = [UIImage imageNamed:@"2.png"];
    UIImage *imag2 = [UIImage imageNamed:@"4.png"];

    [ConanAfnAPI UploadPhoto:@[imag1,imag2,imag] showUploadResult:YES];
    
//    NSLog(@"conan42~%@",[ConanEncryption ConanMd5EncryptionImage:imag2]);
//    NSLog(@"conan43~%@",[ConanEncryption ConanMd5EncryptionImage:imag1]);
//    NSLog(@"conan44~%@",[ConanEncryption ConanMd5EncryptionImage:imag]);
}

- (void)Post
{
//   NSString *sdgsd= SaveFilePath(@"doc", @"photo", @"md5");
//    NSLog(@"%@",sdgsd);
//    
//    NSLog(@"%@",[ConanSaveFilePath ConanConanSaveFilePath:ConanCacheFilePathTypeDocuments FileType:@"photo" FileName:@"md6"]);
//    UIImage *imag = [UIImage imageNamed:@"de1101e93901213ff6a3a62954e736d12e2e95b0.jpg"];
//    [ConanAfnAPI UploadPhoto:@[imag] showUploadResult:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
