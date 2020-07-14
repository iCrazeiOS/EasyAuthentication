// Tell theos what UserAccount is
@interface UserAccount : NSObject
@property(nonatomic, assign, readwrite) NSString *username;
@property(nonatomic, assign, readwrite) NSString *accountName;
@end

// Tell theos what properties AccountTableViewCell has
@interface AccountTableViewCell : UIView
@property(nonatomic, assign, readwrite) NSString *oathCode;
@property(nonatomic, assign, readwrite) UserAccount *account;
@end

%hook AccountTableViewCell
// When the view's frame is set
-(void)setFrame:(CGRect)arg1 {
	// Run the original code first
	%orig;
	// Initialise a UILongPressGestureRecognizer called easyAuthenticationLongPressRecogniser
	UILongPressGestureRecognizer *easyAuthenticationLongPressRecogniser = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(easyAuthenticationHandleLongPress)];
	// Set the required long press duration to 0.5 seconds
	easyAuthenticationLongPressRecogniser.minimumPressDuration = 0.5;
	// Add easyAuthenticationLongPressRecogniser to the AccountTableViewCell
	[self addGestureRecognizer:easyAuthenticationLongPressRecogniser];
}
// Create a new method called easyAuthenticationHandleLongPress
%new
-(void)easyAuthenticationHandleLongPress {
	// Set the clipboard to the authentication code
	[UIPasteboard generalPasteboard].string = self.oathCode;

	// Create an NSString with some data fetch from the AccountTableViewCell
	NSString *messageString = [NSString stringWithFormat:@"Copied: %@\nAccount: %@\nUsername/Email: %@", self.oathCode, self.account.accountName, self.account.username];

	// Initialise a UIAlertController called easyAuthenticationAlert
	UIAlertController* easyAuthenticationAlert = [UIAlertController alertControllerWithTitle:@"EasyAuthentication"
		message:messageString
		preferredStyle:UIAlertControllerStyleAlert];

	// Show the easyAuthenticationAlert
	[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:easyAuthenticationAlert animated:YES completion:nil];

	// Wait for 1.75 seconds
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.75 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		// Dismiss the easyAuthenticationAlert
		[easyAuthenticationAlert dismissViewControllerAnimated:YES completion:^{}];
	});
}
%end
