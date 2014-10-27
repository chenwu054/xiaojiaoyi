//
//  DealDescriptionViewController.h
//  xiaojiaoyi
//
//  Created by chen on 10/20/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DealObject.h"
#import "DataModalUtils.h"
#import "DealSummaryViewController.h"

@interface DealDescriptionViewController : UIViewController <UITextFieldDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,UIAlertViewDelegate>


@property (nonatomic) DealObject* myNewDeal;

@end
