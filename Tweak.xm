#import <UIKit/UIKit.h>
#define CGRectSetY(rect, y) CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height)
@interface CSQuickActionsView : UIView
- (UIEdgeInsets)_buttonOutsets;
@property (nonatomic, retain) UIControl *flashlightButton;
@property (nonatomic, retain) UIControl *cameraButton;
@end
int applicationDidFinishLaunching;
// Enable Gestures
%hook BSPlatform
- (NSInteger)homeButtonType {
    return 2;
}
%end
// No Home Bar
%hook MTLumaDodgePillSettings
- (void)setHeight:(double)arg1 {
    arg1 = 0; %orig;
}
%end
//ModernDock
%hook UITraitCollection
- (CGFloat)displayCornerRadius {
    return 6;
}
%end
//NoBreacum
%hook _UIStatusBarData
-(void)setBackNavigationEntry:(id)arg1 {
    return;
}
%end
//LS Shortcuts
%hook CSQuickActionsView
- (BOOL)_prototypingAllowsButtons {
	return YES;
}
- (void)_layoutQuickActionButtons {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    int const y = screenBounds.size.height - 70 - [self _buttonOutsets].top;
    [self flashlightButton].frame = CGRectMake(46, y, 45, 45);
	[self cameraButton].frame = CGRectMake(screenBounds.size.width - 96, y, 45, 45);
}
%end
//Default Keyboard
%hook UIKeyboardImpl
+(UIEdgeInsets)deviceSpecificPaddingForInterfaceOrientation:(NSInteger)arg1 inputMode:(id)arg2 {
	UIEdgeInsets orig = %orig;
    orig.bottom = 0;
    if (orig.left == 75) {
        orig.left = 0;
        orig.right = 0;
	}
    return orig;
}
%end
//OriginalButtons
%hook SBLockHardwareButtonActions
-(id)initWithHomeButtonType:(long long)arg1 proximitySensorManager:(id)arg2 {
    return %orig(1, arg2);
}
%end

%hook SBHomeHardwareButtonActions
-(id)initWitHomeButtonType:(long long)arg1 {
    return %orig(1);
}
%end

%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)application{
    applicationDidFinishLaunching = 2;
    %orig;
}
%end

%hook SBPressGestureRecognizer
- (void)setAllowedPressTypes:(NSArray *)arg1 {
    NSArray * lockHome = @[@104, @101];
    NSArray * lockVol = @[@104, @102, @103];
    if ([arg1 isEqual:lockVol] && applicationDidFinishLaunching == 2) {
        %orig(lockHome);
        applicationDidFinishLaunching--;
        return;
    }
    %orig;
}
%end

%hook SBClickGestureRecognizer
- (void)addShortcutWithPressTypes:(id)arg1 {
    if (applicationDidFinishLaunching == 1) {
        applicationDidFinishLaunching--;
        return;
    }
    %orig;
}
%end

%hook SBHomeHardwareButton
- (id)initWithScreenshotGestureRecognizer:(id)arg1 homeButtonType:(long long)arg2 {
    return %orig(arg1, 1);
}
%end

//iPhone 11 zoom UI
%hook CAMCaptureCapabilities 
-(BOOL)deviceSupportsCTM {
    return YES;
}
%end
%hook CAMFlipButton
-(BOOL)_useCTMAppearance {
    return YES;
}
%end
%hook CAMViewfinderViewController
-(BOOL)_shouldUseZoomControlInsteadOfSlider {
    return YES;
}
%end

//StatusBar X Mini
%hook _UIStatusBarVisualProvider_iOS
+ (Class)class {
    return NSClassFromString(@"_UIStatusBarVisualProvider_Split58");
}
%end
%hook _UIStatusBarVisualProvider_Split58
+(double)height{
    return 20;
}
+(CGSize)notchSize{
    CGSize notSize = %orig;
    notSize.height = 18;
    return notSize;
}
+(CGSize)pillSize {
    CGSize pilSize = %orig;
    pilSize.height = 18;
    pilSize.width = 48;
    return pilSize;
}
%end
%hook CCUIHeaderPocketView
- (void)setFrame:(CGRect)frame {
        %orig(CGRectSetY(frame, -24));
}
%end