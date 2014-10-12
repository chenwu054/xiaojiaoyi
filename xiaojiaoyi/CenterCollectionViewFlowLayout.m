//
//  CenterCollectionViewFlowLayout.m
//  xiaojiaoyi
//
//  Created by chen on 10/10/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "CenterCollectionViewFlowLayout.h"

@implementation CenterCollectionViewFlowLayout


-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //NSLog(@"calling elements in rect origin x=%f,y=%f: and size: width=%f,height=%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    
    NSArray * ret= [super layoutAttributesForElementsInRect:rect];
//    for(UICollectionViewLayoutAttributes *attributes in ret){
//        NSLog(@"attributes are: %@",attributes);
//    }
    return ret;
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return [self layoutAttributesForItemAtIndexPath:indexPath];
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"!!calling layout for supplementary view");
    UICollectionViewLayoutAttributes *attribute = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    if(kind == UICollectionElementKindSectionHeader){
        if(!attribute){
            attribute = [[UICollectionViewLayoutAttributes alloc] init];
            attribute.bounds = CGRectMake(0, 0, 320, 250);
        }
    }
    return attribute;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    NSLog(@"!!! calling haeader size");
    CGSize size = CGSizeMake(320, 250);
    return size;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    return [super layoutAttributesForDecorationViewOfKind:decorationViewKind atIndexPath:indexPath];
    
}


@end
