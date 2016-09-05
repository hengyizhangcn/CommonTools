//
//  CTTableViewCell.m
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

#import "CTTableViewCell.h"

@implementation CTTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)willDisplayCell
{}
- (void)endDisplayCell
{}

- (void)loadData:(id)data
{
    
}
@end
