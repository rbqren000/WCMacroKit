//
//  WCMacroDollarSign.h
//  WCMacroKit
//
//  Created by wesley_chen on 2019/9/2.
//

#ifndef WCMacroDollarSign_h
#define WCMacroDollarSign_h

#import "WCMacroSafeValue.h"

#pragma mark - $xxx as alias

/**
 Alias for NSDICTIONARY_SAFE_WRAP
 */
#define $dict(...) NSDICTIONARY_SAFE_WRAP(__VA_ARGS__)

/**
 Alias for NSARRAY_SAFE_WRAP
 */
#define $arr(...) NSARRAY_SAFE_WRAP(__VA_ARGS__)

#endif /* WCMacroDollarSign_h */