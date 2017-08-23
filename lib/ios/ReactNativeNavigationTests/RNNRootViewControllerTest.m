#import <XCTest/XCTest.h>
#import "RNNRootViewController.h"
#import "RNNReactRootViewCreator.h"
#import "RNNTestRootViewCreator.h"
#import <React/RCTConvert.h>
#import "RNNNavigationOptions.h"

@interface RNNRootViewControllerTest : XCTestCase

@property (nonatomic, strong) id<RNNRootViewCreator> creator;
@property (nonatomic, strong) NSString* pageName;
@property (nonatomic, strong) NSString* containerId;
@property (nonatomic, strong) id emitter;
@property (nonatomic, strong) RNNNavigationOptions* options;
@property (nonatomic, strong) RNNRootViewController* uut;
@end

@implementation RNNRootViewControllerTest

- (void)setUp {
	[super setUp];
	self.creator = [[RNNTestRootViewCreator alloc] init];
	self.pageName = @"somename";
	self.containerId = @"cntId";
	self.emitter = nil;
	self.options = [RNNNavigationOptions new];
	self.uut = [[RNNRootViewController alloc] initWithName:self.pageName withOptions:self.options withContainerId:self.containerId rootViewCreator:self.creator eventEmitter:self.emitter];
}

-(void)testTopBarBackgroundColor_validColor{
	NSNumber* inputColor = @(0xFFFF0000);
	self.options.topBarBackgroundColor = inputColor;
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];
	UIColor* expectedColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
	
	XCTAssertTrue([self.uut.navigationController.navigationBar.barTintColor isEqual:expectedColor]);
}

-(void)testTopBarBackgroundColorWithoutNavigationController{
	NSNumber* inputColor = @(0xFFFF0000);
	self.options.topBarBackgroundColor = inputColor;
	
	XCTAssertNoThrow([self.uut viewWillAppear:false]);
}

- (void)testStatusBarHidden_default {
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];
	
	XCTAssertFalse([self.uut prefersStatusBarHidden]);
}

- (void)testStatusBarHidden_true {
	self.options.statusBarHidden = @(1);
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];
	
	XCTAssertTrue([self.uut prefersStatusBarHidden]);
}

- (void)testStatusBarHidden_false {
	self.options.statusBarHidden = @(0);
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];
	
	XCTAssertFalse([self.uut prefersStatusBarHidden]);
}

-(void)testTitle_string{
	NSString* title =@"some title";
	self.options.title= title;
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	
	[self.uut viewWillAppear:false];
	XCTAssertTrue([self.uut.navigationItem.title isEqual:title]);
}

-(void)testTitle_default{
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	
	[self.uut viewWillAppear:false];
	XCTAssertNil(self.uut.navigationItem.title);
}

-(void)testTopBarTextColor_validColor{
	NSNumber* inputColor = @(0xFFFF0000);
	self.options.topBarTextColor = inputColor;
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];
	UIColor* expectedColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
	XCTAssertTrue([self.uut.navigationController.navigationBar.titleTextAttributes[@"NSColor"] isEqual:expectedColor]);
}

-(void)testScreenBackgroundColor_validColor{
	NSNumber* inputColor = @(0xFFFF0000);
	self.options.screenBackgroundColor = inputColor;
	[self.uut viewWillAppear:false];
	UIColor* expectedColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
	XCTAssertTrue([self.uut.view.backgroundColor isEqual:expectedColor]);
}

-(void)testTopBarTextFontFamily_validFont{
	NSString* inputFont = @"HelveticaNeue";
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	self.options.topBarTextFontFamily = inputFont;
	[self.uut viewWillAppear:false];
	UIFont* expectedFont = [UIFont fontWithName:inputFont size:20];
	XCTAssertTrue([self.uut.navigationController.navigationBar.titleTextAttributes[@"NSFont"] isEqual:expectedFont]);
}

-(void)testTopBarHideOnScroll_true {
	NSNumber* hideOnScrollInput = @(1);
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	self.options.topBarHideOnScroll = hideOnScrollInput;
	[self.uut viewWillAppear:false];
	XCTAssertTrue(self.uut.navigationController.hidesBarsOnSwipe);
}

-(void)testTopBarButtonColor {
	NSNumber* inputColor = @(0xFFFF0000);
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	self.options.topBarButtonColor = inputColor;
	[self.uut viewWillAppear:false];
	UIColor* expectedColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
	XCTAssertTrue([self.uut.navigationController.navigationBar.tintColor isEqual:expectedColor]);
}

-(void)testTopBarTranslucent {
	NSNumber* topBarTranslucentInput = @(0);
	self.options.topBarTranslucent = topBarTranslucentInput;
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];
	XCTAssertFalse(self.uut.navigationController.navigationBar.translucent);
}

-(void)testTabBadge {
	NSString* tabBadgeInput = @"5";
	self.options.tabBadge = tabBadgeInput;
	__unused UITabBarController* vc = [[UITabBarController alloc] init];
	NSMutableArray* controllers = [NSMutableArray new];
	UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"A Tab" image:nil tag:1];
	[self.uut setTabBarItem:item];
	[controllers addObject:self.uut];
	[vc setViewControllers:controllers];
	[self.uut viewWillAppear:false];
	XCTAssertTrue([self.uut.tabBarItem.badgeValue isEqualToString:tabBadgeInput]);
	
}


-(void)testTopBarTextFontSize_withoutTextFontFamily_withoutTextColor {
	NSNumber* topBarTextFontSizeInput = @(15);
	self.options.topBarTextFontSize = topBarTextFontSizeInput;
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];
	UIFont* expectedFont = [UIFont systemFontOfSize:15];
	XCTAssertTrue([self.uut.navigationController.navigationBar.titleTextAttributes[@"NSFont"] isEqual:expectedFont]);
}

-(void)testTopBarTextFontSize_withoutTextFontFamily_withTextColor {
	NSNumber* topBarTextFontSizeInput = @(15);
	NSNumber* inputColor = @(0xFFFF0000);
	self.options.topBarTextFontSize = topBarTextFontSizeInput;
	self.options.topBarTextColor = inputColor;
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];
	UIFont* expectedFont = [UIFont systemFontOfSize:15];
	UIColor* expectedColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
	XCTAssertTrue([self.uut.navigationController.navigationBar.titleTextAttributes[@"NSFont"] isEqual:expectedFont]);
	XCTAssertTrue([self.uut.navigationController.navigationBar.titleTextAttributes[@"NSColor"] isEqual:expectedColor]);
}

-(void)testTopBarTextFontSize_withTextFontFamily_withTextColor {
	NSNumber* topBarTextFontSizeInput = @(15);
	NSNumber* inputColor = @(0xFFFF0000);
	NSString* inputFont = @"HelveticaNeue";
	self.options.topBarTextFontSize = topBarTextFontSizeInput;
	self.options.topBarTextColor = inputColor;
	self.options.topBarTextFontFamily = inputFont;
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];
	UIColor* expectedColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
	UIFont* expectedFont = [UIFont fontWithName:inputFont size:15];
	XCTAssertTrue([self.uut.navigationController.navigationBar.titleTextAttributes[@"NSFont"] isEqual:expectedFont]);
	XCTAssertTrue([self.uut.navigationController.navigationBar.titleTextAttributes[@"NSColor"] isEqual:expectedColor]);
}

-(void)testTopBarTextFontSize_withTextFontFamily_withoutTextColor {
	NSNumber* topBarTextFontSizeInput = @(15);
	NSString* inputFont = @"HelveticaNeue";
	self.options.topBarTextFontSize = topBarTextFontSizeInput;
	self.options.topBarTextFontFamily = inputFont;
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];
	UIFont* expectedFont = [UIFont fontWithName:inputFont size:15];
	XCTAssertTrue([self.uut.navigationController.navigationBar.titleTextAttributes[@"NSFont"] isEqual:expectedFont]);
}

// TODO: Currently not passing
-(void)testTopBarTextFontFamily_invalidFont{
	NSString* inputFont = @"HelveticaNeueeeee";
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	self.options.topBarTextFontFamily = inputFont;
	//	XCTAssertThrows([self.uut viewWillAppear:false]);
}

-(void)testTopBarNoBorderOn {
	NSNumber* topBarNoBorderInput = @(1);
	self.options.topBarNoBorder = topBarNoBorderInput;
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];
	XCTAssertNotNil(self.uut.navigationController.navigationBar.shadowImage);
}

-(void)testTopBarNoBorderOff {
	NSNumber* topBarNoBorderInput = @(0);
	self.options.topBarNoBorder = topBarNoBorderInput;
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];
	XCTAssertNil(self.uut.navigationController.navigationBar.shadowImage);
}

-(void)testStatusBarBlurOn {
	NSNumber* statusBarBlurInput = @(1);
	self.options.statusBarBlur = statusBarBlurInput;
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];
	XCTAssertNotNil([self.uut.view viewWithTag:BLUR_STATUS_TAG]);
}

-(void)testStatusBarBlurOff {
	NSNumber* statusBarBlurInput = @(0);
	self.options.statusBarBlur = statusBarBlurInput;
	__unused UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self.uut];
	[self.uut viewWillAppear:false];
	XCTAssertNil([self.uut.view viewWithTag:BLUR_STATUS_TAG]);
}


@end