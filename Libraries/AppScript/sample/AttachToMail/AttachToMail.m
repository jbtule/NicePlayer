#import <Foundation/Foundation.h>
#import "MLGlue/MLGlue.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSError *error;
	int err = 0;
	
	/*
	 * The data to insert. Hardcoded here for demonstration purposes; modify the image path
	 * to suit before running the demo.
	 */
	NSString *subjectText = @"Hello!";
	NSString *contentText = @"My favourite photo:\n\n";
	NSString *attachmentPath = @"/PATH/TO/IMAGE.jpg";
    
	/*
	 * Create a new application object for Mail.
	 *
	 * Note: this operation shouldn't fail unless [e.g.] the user has deleted Mail from their system;
	 * if this is a possibility, check that the result is not nil before proceeding.
	 */
    MLApplication *mail = [[MLApplication alloc] initWithBundleID: @"com.apple.mail"];
	
	
	/*
	 * Create a new outgoing message, setting the subject line to the given text. 
	 *
	 * For demonstration purposes, the message is made visible while content is being added;
	 * in practical use it may it may be preferable to hide it from view while the content is 
	 * being added so as not to distract the user, making it visible once this is done.
	 *
	 * The resulting outgoing message reference is retained for use in subsequent commands.
	 * BTW, this command shouldn't fail, so we don't bother to check if the -send message
	 * returns nil.
	 */
	MLMakeCommand *makeCmd = [[[mail make] new_: [MLConstant outgoingMessage]] 
								 withProperties: [NSDictionary dictionaryWithObjectsAndKeys: 
																subjectText, [MLConstant subject],
																AEMTrue,	 [MLConstant visible],
																nil]];
	MLReference *msg = [makeCmd send];
	
	/*
	 * Set the message content.
	 *
	 * Note: setting the content property will replace any existing text such as a default signature.
	 * To add new text without replacing existing text, use:
	 *
	 *	makeCmd = [[[[mail make] new_: [MLConstant paragraph]]
	 *							   at: [[[msg content] paragraphs] beginning]]
	 *						 withData: contentText];
	 *	[makeCmd send];
	 */
	[[[[msg content] set] to: contentText] send];
	
	/*
	 * Add the image attachment. 
	 *
	 * Note that Mail's dictionary indicates a POSIX path string (NSString) to the image file
	 * is required, rather than the more common alias (AEMAlias) or file URL (NSURL).
	 *
	 * Because [in theory] this command will fail if an invalid path is given, the -sendWithError:
	 * method is used to obtain detailed error information to provide additional feedback.
	 * (In practice, the command fails silently due to a bug in Mail; a report will be filed on this.)
	 */
	makeCmd = [[[[mail make] new_: [MLConstant attachment]]
							   at: [[[msg content] paragraphs] end]]
				   withProperties: [NSDictionary dictionaryWithObject: attachmentPath
															   forKey: [MLConstant fileName]]];
	if (![makeCmd sendWithError: &error]) {
		NSLog(@"Couldn't attach attachment: %@", [error localizedDescription]);
		err = [error code];
	}
	
	/*
	 * Bring Mail to front and show the message if its visibility was previously set to false.
	 */ 
	[[mail activate] send];
	[[[[msg visible] set] to: AEMTrue] send];
	
	/*
	 * Clean up and return.
	 */
	[mail release];
    [pool release];
    return err;
}
