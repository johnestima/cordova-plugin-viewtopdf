#import "HWPHello.h"
#define PDFSize CGSizeMake(595.2,841.8)

@implementation HWPHello

- (void)greet:(CDVInvokedUrlCommand*)command
{

    NSString* callbackId = [command callbackId];
    NSString* name = [[command arguments] objectAtIndex:0];

//    NSLog(@"web view did finish loading");
    
    // webViewDidFinishLoad() could get called multiple times before
    // the page is 100% loaded. That's why we check if the page is still loading
    UIWebView *webViewIn = self.webView;
    webViewIn.scalesPageToFit = YES;
    
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    [render addPrintFormatter:webViewIn.viewPrintFormatter startingAtPageAtIndex:0];
    
    // Padding is desirable, but optional
    float padding = 10.0f;
    
    // Define the printableRect and paperRect
    // If the printableRect defines the printable area of the page
    CGRect paperRect = CGRectMake(0, 0, PDFSize.width, PDFSize.height);
    CGRect printableRect = CGRectMake(padding, padding, PDFSize.width-(padding * 2), PDFSize.height-(padding * 2));
    
    [render setValue:[NSValue valueWithCGRect:paperRect] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
    
    // Call the printToPDF helper method that will do the actual PDF creation using values set above
    NSData *pdfData = [render createPDF];
    
    // Save the PDF to a file, if creating one is successful
    if (pdfData) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        
		NSFileManager  *manager = [NSFileManager defaultManager];

		// grab all the files in the documents dir
		NSArray *allFiles = [manager contentsOfDirectoryAtPath:path error:nil];

		// filter the array for only sqlite files
		NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.pdf'"];
		NSArray *pdfFiles = [allFiles filteredArrayUsingPredicate:fltr];

		// use fast enumeration to iterate the array and delete the files
		for (NSString *pdfFile in pdfFiles)
		{
		   NSError *error = nil;
		   [manager removeItemAtPath:[path stringByAppendingPathComponent:pdfFile] error:&error];
		   NSAssert(!error, @"Assertion: PDF file deletion shall never throw an error.");
		}

        NSString *pdfPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", name]];
        
        [pdfData writeToFile:pdfPath atomically:YES];
        
		CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:name];
		[self success:result callbackId:callbackId];
    }
    else
    {
        NSLog(@"error creating PDF");
    }
}

@end