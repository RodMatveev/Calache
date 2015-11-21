//
//  AKAdressSearchTextField.m
//  Caleche
//
//  Created by Adrian  Kozhevnikov on 21/11/2015.
//  Copyright © 2015 Rod Matveev. All rights reserved.
//

#import "AKAdressSearchTextField.h"

@implementation AKAdressSearchTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 40, 0);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 40, 0);
}

@end
