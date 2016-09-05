//
//  CTTableViewCell.h
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTTableViewCell : UITableViewCell


- (void)willDisplayCell;
- (void)endDisplayCell;

- (void)loadData:(id)data;
@end
