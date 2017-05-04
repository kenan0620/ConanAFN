//
//  ConanAFNViewController.m
//  ConanAFN
//
//  Created by acct<blob>=<NULL> on 03/20/2017.
//  Copyright (c) 2017 acct<blob>=<NULL>. All rights reserved.
//

#import "ConanAFNViewController.h"
#import <ConanAFN/ConanAfnAPI.h>
@interface ConanAFNViewController ()

@end

@implementation ConanAFNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self Post];
}

- (void)Post
{
    
    NSString *jsonUrl=@"statuses/public_timeline.json";
    NSString *access_token=@"2.00NofgBD0L1k4pc584f79cc48SKGdD";
    NSString *count=@"10";
    
    NSDictionary *jsonDic = NSDictionaryOfVariableBindings(access_token,count);
    [ConanAfnAPI RequestWithURL:ConanAfnRequestMethodTypeGET Url:jsonUrl Params:jsonDic SuccessBlock:^(id returnData) {
        
        
    } FailureBlock:^(NSError *error) {
        
    } ShowHUB:ConanShowNothing ShowMessage:@""];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
