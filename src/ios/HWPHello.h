#import <Cordova/CDV.h>

@interface HWPHello : CDVPlugin

- (void)greet : (CDVInvokedUrlCommand*)command;

@end

@interface UIPrintPageRenderer(PDF)
- (NSData*)createPDF;
@end

@implementation UIPrintPageRenderer(PDF)
- (NSData*)createPDF
{
	NSMutableData *pdfData = [NSMutableData data];
	UIGraphicsBeginPDFContextToData(pdfData, self.paperRect, nil);
	//    UIPrintInfo
	//    UIGraphicsBeginPDFContextToData(pdfData, CGRectMake(0, 20, 595, 842), nil);
	[self prepareForDrawingPages : NSMakeRange(0, self.numberOfPages)];
	CGRect bounds = UIGraphicsGetPDFContextBounds();
	for (int i = 0; i < self.numberOfPages; i++)
	{
		UIGraphicsBeginPDFPage();
		[self drawPageAtIndex : i inRect : bounds];
		CGContextRef currentContext = UIGraphicsGetCurrentContext();
		CGContextSetRGBFillColor(currentContext, 99 / 255.f, 100 / 255.f, 99 / 255.f, 1.0f);

	}
	UIGraphicsEndPDFContext();
	return pdfData;
}
@end