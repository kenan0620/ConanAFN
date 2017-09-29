//
//  ConanAFNViewController.m
//  ConanAFN
//
//  Created by acct<blob>=<NULL> on 03/20/2017.
//  Copyright (c) 2017 acct<blob>=<NULL>. All rights reserved.
//

#import "ConanAFNViewController.h"
@interface ConanAFNViewController ()

@end

@implementation ConanAFNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self writefile:@"Do any additional "];
    [self writefile:@"after loading the view, "];
    [self writefile:@"Do typically from a nib."];
}
- (void)writefile:(NSString *)string
{
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *homePath = [paths objectAtIndex:0];
    
    NSString *filePath = [homePath stringByAppendingPathComponent:@"testfile.text"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:filePath]) //如果不存在
    {
        NSString *str = @"姓  名/手  机  号/邮  件";
        [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
    [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *str = [NSString stringWithFormat:@"\n%@\n%@",datestr,string];
    
    NSData* stringData  = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [fileHandle writeData:stringData]; //追加写入数据
    NSLog(@"%@",filePath);
    [fileHandle closeFile];
}
- (void)cache{
    
}

- (void)afn{
    
}

- (void)showmessage{
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
