//
//  WAAutocompletionHandler.m
//  Copyright 2011 Jan Winter. All rights reserved.
//
//  Licensed under the BSD License <http://www.opensource.org/licenses/bsd-license>
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "WAAutocompleteHandler.h"
#import "WAAutocompleteDefines.h"


@implementation WAAutocompleteHandler
@synthesize moc;
@synthesize cdEntity;
@synthesize autocompletePopoverController;
@synthesize showAll;
@synthesize textView;
@synthesize currentCursorPosition;
@synthesize currentTextOfInterest;

- (id)initWithMOC:(NSManagedObjectContext*)initMOC andEntity:(NSString*)autocompletionEntity
{
    NSAssert(initMOC, @"You need to call initWithMOC");
    NSAssert(autocompletionEntity, @"You need to call initWithMOC");
    if ((self = [super init])) {
        self.moc = initMOC;
        self.cdEntity = autocompletionEntity;
        showAll = YES;
    }
    return self;
}

- (void)dealloc
{
    [moc release];
    [cdEntity release];
    [autocompletePopoverController release];
    [textView release];
    [currentTextOfInterest release];
    [super dealloc];
}

#pragma mark -
#pragma mark @"create / extend autocompletion database"
- (void)importAutocompleteDataFromPlistFile:(NSString*)plistName
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSAssert(plistPath, @"Plist file not found");

	//read data and create CoreData ManagedObjects
	NSArray *rawData = [[NSArray alloc] initWithContentsOfFile:plistPath];    
	for(NSDictionary *dict in rawData)
	{
        id autocompleteEntity = [NSEntityDescription insertNewObjectForEntityForName:self.cdEntity inManagedObjectContext:self.moc];
        NSString *string = [dict objectForKey:kAutocompleteItemPlistKey];
		[autocompleteEntity setValue:string forKey:kAutocompleteItemCoreDataAttributeKey];
        
        NSString *iconString = [dict objectForKey:kAutocompleteItemPlistKeyIcon];
        if (iconString) {
            [autocompleteEntity setValue:iconString forKey:kAutocompleteItemCoreDataAttributeKeyIcon];
        }
		
	}
	[rawData release];
    
	NSError *error = nil;
	if (![self.moc save:&error]) {
		// Update to handle the error appropriately.
		DLog(@"Core Data Unresolved error %@, %@ in HistoryInterface", error, [error userInfo]);
#ifndef DEBUG
		exit(-1);  // Fail
#endif
	}

}

- (void)addStringToAutocompleteData:(NSString*)newAutocompleteString withIcon:(UIImage*)icon
{
    id autocompleteEntity = [NSEntityDescription insertNewObjectForEntityForName:self.cdEntity inManagedObjectContext:self.moc];
    [autocompleteEntity setValue:newAutocompleteString forKey:kAutocompleteItemCoreDataAttributeKey];
	    
    if (icon) {
        [autocompleteEntity setValue:icon forKey:kAutocompleteItemCoreDataAttributeKeyIcon];
    }
    
	NSError *error = nil;
	if (![self.moc save:&error]) {
		// Update to handle the error appropriately.
		DLog(@"Core Data Unresolved error %@, %@ in HistoryInterface", error, [error userInfo]);
#ifndef DEBUG
		exit(-1);  // Fail
#endif
	}
}

#pragma mark -
#pragma mark @"the main work is done here"
- (void)textViewDidChange:(UITextView*)aTextView
{
    BOOL showAutocomplete = NO;
    self.currentTextOfInterest = @"";
    
#pragma mark adjust logic to your needs
    //###################################
    //BEGIN OF CUSTOMIZATION
    //###################################
    //this examples looks for a single word with more than 2 letters in the text separated by white space from the rest of the text
    
    //get current string of interest
    NSString *completeTextOfTextView = aTextView.text;
    NSRange currentCursorPositionOfTextView = aTextView.selectedRange;
    
#define kSearchStringOnLeftSideSpace @" "
#define kSearchStringOnLeftSideLinebreak @"\n"
    NSString *leftPartOfText = [completeTextOfTextView substringToIndex:currentCursorPositionOfTextView.location];
    NSRange beginningPositionSpace = [leftPartOfText rangeOfString:kSearchStringOnLeftSideSpace options:NSBackwardsSearch];
    NSRange beginningPositionLinebreak = [leftPartOfText rangeOfString:kSearchStringOnLeftSideLinebreak options:NSBackwardsSearch];
    NSRange beginningPosition;
    if ((beginningPositionSpace.location != NSNotFound) && (beginningPositionLinebreak.location != NSNotFound)) {
        if (beginningPositionSpace.location >= beginningPositionLinebreak.location) {
            beginningPosition = beginningPositionSpace;
        }
        else
        {
            beginningPosition = beginningPositionLinebreak;
        }
    }
    else
    {
        beginningPosition = beginningPositionSpace;
    }
        
    if ((beginningPosition.location != NSNotFound) || ((currentCursorPositionOfTextView.location - [leftPartOfText length]) == 0)) {
        if ([leftPartOfText length] > 1) {
            if ((beginningPosition.location != NSNotFound)) {
                self.currentTextOfInterest = [leftPartOfText substringFromIndex:(beginningPosition.location + 1)];
            }
            else
            {
                self.currentTextOfInterest = [leftPartOfText substringFromIndex:0];
            }
            
        }                
        if ([self.currentTextOfInterest length] > 2) {
            showAutocomplete = YES;
        }        
    }
    
    //###################################
    //END OF CUSTOMIZATION
    //###################################
    
    //check if we have to show the popoverView
    if (showAutocomplete) {
        self.textView = aTextView;  
        self.currentCursorPosition = currentCursorPositionOfTextView.location;
        [(WAAutocompleteTableViewController*)self.autocompletePopoverController.contentViewController checkForMatchWithString:currentTextOfInterest];
    }
    else
    {
        if (autocompletePopoverController.popoverVisible) {
            [autocompletePopoverController dismissPopoverAnimated:YES];
        }        
    }
}

#pragma mark -
#pragma mark @"UIPopoverControllerDelegate"
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return YES;
}

#pragma mark -
#pragma mark @"WAAutocompletTableViewControllerDelegate"
- (void) tableViewController:(WAAutocompleteTableViewController *)controller hasFoundMatch:(BOOL)match
{
    //if (!self.autocompletePopoverController.popoverVisible) 
    if (match)
    {
        
        CGRect textViewRect = self.textView.frame;
        
        UIFont *font = self.textView.font;
        CGFloat width = textViewRect.size.width;
        UILineBreakMode lineBreakMode = UILineBreakModeWordWrap;
        NSString *text = self.textView.text;
        CGSize totalTextSize = [text sizeWithFont:font constrainedToSize:textViewRect.size lineBreakMode:lineBreakMode];
       //TODO: adjust to width of last line of text only
        //TODO: add scrollview offset...
        // CGFloat textWidthOfLastLine = ;
        CGSize textOfInterestSize = [self.currentTextOfInterest sizeWithFont:font forWidth:width lineBreakMode:lineBreakMode];
        
        CGRect rect = CGRectMake(totalTextSize.width - floor(textOfInterestSize.width / 2), totalTextSize.height, textOfInterestSize.width, textOfInterestSize.height);
        
        [autocompletePopoverController presentPopoverFromRect:rect inView:self.textView permittedArrowDirections:kPermittedArrowDirections animated:YES];
    }
    else
    {
        if (autocompletePopoverController.popoverVisible) {
            [autocompletePopoverController dismissPopoverAnimated:YES];
        }
    }
}

- (void)tableViewController:(WAAutocompleteTableViewController *)controller didSelectString:(NSString*)autocompleteString
{
    //replace current text
    NSString *completeTextOfTextView = self.textView.text;
    NSUInteger cursorPosition = self.currentCursorPosition;
    NSString *leftPartOfText = [completeTextOfTextView substringToIndex:cursorPosition];
    NSRange beginningPosition = [leftPartOfText rangeOfString:self.currentTextOfInterest options:NSBackwardsSearch];
    if (beginningPosition.location != NSNotFound) {
        NSRange autocompleteRange = NSMakeRange(beginningPosition.location, self.currentCursorPosition - beginningPosition.location);
        
        NSString *newCompleteTextOfTextView = [completeTextOfTextView stringByReplacingCharactersInRange:autocompleteRange withString:autocompleteString];
        self.textView.text = newCompleteTextOfTextView;
        self.textView.selectedRange = NSMakeRange(beginningPosition.location + [autocompleteString length], 0);
    }
    [autocompletePopoverController dismissPopoverAnimated:YES];
}

#pragma mark -
#pragma mark @"custom accessors"
- (UIPopoverController*)autocompletePopoverController
{
    if (autocompletePopoverController) {
        return autocompletePopoverController;
    }
    
    WAAutocompleteTableViewController *contentViewController;
    contentViewController = [[WAAutocompleteTableViewController alloc] initWithNibName:@"WAAutoCompleteTableView" bundle:nil];
    contentViewController.moc = self.moc;
    contentViewController.cdEntity = self.cdEntity;
    contentViewController.showAll = self.showAll;
    contentViewController.delegate = self;
    
    autocompletePopoverController = [[UIPopoverController alloc] initWithContentViewController:contentViewController];
    autocompletePopoverController.popoverContentSize = kAutocompletePopoverContentSize;
    
    return autocompletePopoverController;
}

@end
