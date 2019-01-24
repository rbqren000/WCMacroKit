//
//  Test.m
//  Test
//
//  Created by wesley chen on 16/8/28.
//
//

#import <XCTest/XCTest.h>
#import "WCMacroKit.h"

#define UITextFieldDelegateEnabled 0

#if UITextFieldDelegateEnabled
#define UITextFieldDelegateProtocol UITextFieldDelegate
#else
WCDummyProtocol(UITextFieldDelegate)
#define UITextFieldDelegateProtocol WCDummyProtocol_UITextFieldDelegate
#endif

@interface Test : XCTestCase <UITextFieldDelegateProtocol>

@end

@implementation Test

- (void)setUp {
    [super setUp];
    
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_NILABLE {
    NSString *nilString;
    NSArray *arr = @[@"aString"];
    
    // @warning Only use NILABLE wrap/re-wrap values of literal NSDictionary
    NSDictionary *dict = @{
                           @"maybe nil": NILABLE(nilString), // Ok, value is nil
                           @"arr": NILABLE(arr),
                           @"dict": @{ @"key": @"value"},
                           };
    
    XCTAssertEqualObjects(dict[@"maybe nil"], @"(null)");
    XCTAssertNotNil(dict[@"arr"]);
    XCTAssertEqual(dict[@"arr"], arr);
    XCTAssertEqual(NILABLE(dict[@"arr"]), arr);
    NSDictionary *dictValue = NILABLE(dict[@"dict"]);
    XCTAssertTrue([dictValue isKindOfClass:[NSDictionary class]]);
}

- (void)test_WCLog {
    NSString *message = @"message"      @", a.k.a msg";
    
    NSLog(@"[ApolloSDK] " @"log: %@", message);
    WCLog(@"log: %@", message);
}

- (void)test_XLog {
    
    NSLog(@"Hello");
    
    NSLog((@"[ONEVoIP] %s [Line %d] " @"%@"), __PRETTY_FUNCTION__, __LINE__, @"var");
    
    ALog(@"%@", @"test Alert");
    CLog(@"%@", @"test Critial");
    ELog(@"%@", @"test Error");
    WLog(@"%@", @"test Warning");
    NLog(@"%@", @"test Notice");
    ILog(@"%@", @"test Info");
    DLog(@"%@", @"test Debug");
    
    __unused NSError *errorNil;
    LogError(errorNil); // Will not print
    
    __unused NSError *error = [NSError errorWithDomain:@"domain" code:-1 userInfo:@{ NSLocalizedDescriptionKey: @"CAUTION! An error occurred." }];
    LogError(error); // Will print
}

- (void)test_example {
    ALog(@"%@", @"test Alert");
}

- (void)test_STR_IF_EMPTY {
    
    NSString *nilString;
    XCTAssertFalse(STR_IF_EMPTY(nilString));
    
    NSString *emptyString = @"";
    XCTAssertTrue(STR_IF_EMPTY(emptyString));
    
    if (!STR_IF_EMPTY(emptyString)) {
        NSLog(@"%@ is not an empty string", nilString);
    }
    else {
        NSLog(@"an empty string");
    }
    
    NSString *notEmptyString = @"not empty";
    XCTAssertFalse(STR_IF_EMPTY(notEmptyString));
}

- (void)test_STR_IF_NOT_EMPTY {
    NSString *nilString;
    XCTAssertFalse(STR_IF_NOT_EMPTY(nilString));
    
    if (STR_IF_NOT_EMPTY(nilString)) {
        NSLog(@"%@ is not an nil string", nilString);
    }
    else {
        NSLog(@"a nil string");
    }
    
    NSString *emptyString = @"";
    XCTAssertFalse(STR_IF_NOT_EMPTY(emptyString));
    
    // A string and not empty
    if (STR_IF_NOT_EMPTY(emptyString)) {
        NSLog(@"%@ is not an empty string", nilString);
    }
    else {
        NSLog(@"an empty string");
    }
    
    NSString *notEmptyString = @"not empty";
    XCTAssertTrue(STR_IF_NOT_EMPTY(notEmptyString));
}

- (void)test_STR_FORMAT {
    NSLog(@"%@", STR_FORMAT(@"本地文件不存在, 路径是%@", @"path/to/file"));
    NSLog(@"%@", STR_FORMAT(@"参数不对, 参数1是%@，参数2是%@", @"a", @"b"));
    
    XCTAssertEqualObjects(STR_FORMAT(@"本地文件不存在, 路径是%@", @"path/to/file"), @"本地文件不存在, 路径是path/to/file");
    XCTAssertEqualObjects(STR_FORMAT(@"参数不对, 参数1是%@，参数2是%@", @"a", @"b"), @"参数不对, 参数1是a，参数2是b");
}

#pragma mark -

- (void)test_sel {
    //    NSString *selector = NSStringFromSelector(@selector(buttonClicked:));
    //    SEL_SAFE_CALL(self, @selector(buttonClicked));
    
    //    SEL_SAFE_CALL(self, @selector(actionWithFirstParam:), self);
    
    //    id receiver = self;
    //
    //    IMP imp__ = [receiver methodForSelector:selector__];
    //    void (*func__)(id, SEL, __VA_ARGS__) = (void *)imp__;
    //    func__(receiver, selector, __VA_ARGS__);
}

- (void)actionWithFirstParam:(id)firstParam {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

- (void)buttonClicked {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

#pragma mark - NSArray

- (void)test_NSARRAY_M_SAFE_SET {
    NSMutableArray *arrM1 = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
    NSARRAY_M_SAFE_SET(arrM1, 0, @"6");
    XCTAssertEqualObjects(arrM1[0], @"6");
    
    NSMutableArray *arrM2 = [NSMutableArray array];
    NSARRAY_M_SAFE_SET(arrM1, 0, @"7");
    XCTAssertTrue(arrM2.count == 0);
}

- (void)test_NSARRAY_M_SAFE_ADD {
    NSMutableArray *arrM1 = [NSMutableArray array];

    NSARRAY_M_SAFE_ADD(arrM1, @"1");
    NSARRAY_M_SAFE_ADD(arrM1, @"2");
    NSARRAY_M_SAFE_ADD(arrM1, @"");
    id nilValue = nil;
    NSARRAY_M_SAFE_ADD(arrM1, nilValue);
    XCTAssertTrue(arrM1.count == 3);
    
    NSMutableArray *arrM2 = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", nil];
    NSARRAY_M_SAFE_ADD(arrM2, @"4");
    NSARRAY_M_SAFE_ADD(arrM2, @"5");
    XCTAssertTrue(arrM2.count == 5);
}

- (void)test_NSARRAY_SAFE_GET {
    NSArray *arr1 = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
    NSString *firstObject = NSARRAY_SAFE_GET(arr1, 0);
    NSLog(@"%@", firstObject);
    
    XCTAssertEqualObjects(NSARRAY_SAFE_GET(arr1, 0), @"1");
    XCTAssertNil(NSARRAY_SAFE_GET(arr1, 5));
    
    NSArray *arr2 = nil;
    XCTAssertNil(NSARRAY_SAFE_GET(arr2, 0));
    
    NSArray *arr3 = [NSArray array];
    XCTAssertNil(NSARRAY_SAFE_GET(arr3, 0));
}

#pragma mark - Delegate caller

- (void)test_DELEGATE_SAFE_CALL2 {
    DELEGATE_SAFE_CALL2(self, @selector(delegateMethodWithSender:YESBoolValue:), self, @(YES));
}

#pragma mark > Sample methods

- (void)delegateMethodWithSender:(id)sender YESBoolValue:(NSNumber *)yesOrNo {
    XCTAssert(sender == self);
    XCTAssert([yesOrNo boolValue] == YES);
}

#pragma mark - WCDumpXXX

- (void)test_WCDumpBool {
    WCDumpBool(YES);
    WCDumpBool(NO);
    
    BOOL boolValue = YES;
    WCDumpBool(boolValue);
    boolValue = NO;
    WCDumpBool(boolValue);
    
    WCDumpBool([self class] == [super class]);
}

- (void)test_WCDumpObject {
    WCDumpObject([self class]);
    WCDumpObject([super class]);
    WCDumpObject([self superclass]);
    
    WCDumpObject(@"");
    
    id nilValue = nil;
    WCDumpObject(nilValue);
    
    NSString *emptyStr= @"";
    WCDumpObject(emptyStr);
}

#pragma mark -

- (void)test_FrameSetSize {
    CGSize size;
    CGRect frame;
    CGRect output;
    
    // Case 1
    size = CGSizeMake(200, 200);
    frame = CGRectMake(10, 10, 100, 100);
    output = FrameSetSize(frame, size.width, size.height);
    XCTAssertTrue(output.size.width == 200 && output.size.height == 200);
    
    // Case 2
    size = CGSizeMake(200, 200);
    frame = CGRectMake(10, 10, 100, 100);
    output = FrameSetSize(frame, size.width, NAN);
    XCTAssertTrue(output.size.width == 200 && output.size.height == 100);
}

- (void)test_strongify_weakify {
    id foo = [[NSObject alloc] init];
    id bar = [[NSObject alloc] init];
    
    weakify(self);
    weakify(foo);
    
    // this block will not keep 'foo' or 'bar' alive
    BOOL (^matchesFooOrBar)(id) = ^ BOOL (id obj){
        // but now, upon entry, 'foo' and 'bar' will stay alive until the block has
        // finished executing
        strongify(self);
        strongify(foo);
        
        NSLog(@"self: %@", self);
        NSLog(@"foo: %@", foo);
        
        return [foo isEqual:obj] || [bar isEqual:obj];
    };
    
    matchesFooOrBar([NSDate date]);
}

@end
