//
//  CollectionViewCell.h
//  xiaojiaoyi
//
//  Created by chen on 9/11/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic) NSString *name;
@property (nonatomic) NSURL *imageURL;
@property (nonatomic) UIImage *image;
@property (nonatomic) BOOL hasImage;
@property (nonatomic) BOOL hasURL;
@property (nonatomic) BOOL isFailed;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *label;


-(CollectionViewCell *)initWithName:(NSString *)name andURL:(NSURL*)url;

@end




