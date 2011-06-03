//
//  WAAutocompletionHandler.h
//  Copyright 2011 Jan Winter. All rights reserved.
//
//  Licensed under the BSD License <http://www.opensource.org/licenses/bsd-license>
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WAAutocompleteTableViewController.h"

@interface WAAutocompleteHandler : NSObject <UIPopoverControllerDelegate, WAAutocompleteTableViewControllerDelegate> {
    
    NSManagedObjectContext *moc;
    NSString *cdEntity;
    UIPopoverController *autocompletePopoverController;    
    UITextView *textView;
    BOOL showAll;
    
@private
    NSUInteger currentCursorPosition;
    NSString *currentTextOfInterest;
}

@property(nonatomic, retain) NSManagedObjectContext *moc;
@property(nonatomic, copy) NSString *cdEntity;
@property(nonatomic, retain) UIPopoverController *autocompletePopoverController;
@property(nonatomic, assign) BOOL showAll;
@property(nonatomic, retain) UITextView *textView;
@property(nonatomic, assign) NSUInteger currentCursorPosition;
@property(nonatomic, retain) NSString *currentTextOfInterest;

- (id)initWithMOC:(NSManagedObjectContext*)initMOC andEntity:(NSString*)autocompletionEntity;

- (void)importAutocompleteDataFromPlistFile:(NSString*)plistName;
- (void)addStringToAutocompleteData:(NSString*)newAutocompletionString withIcon:(UIImage*)icon;

- (void)textViewDidChange:(UITextView*)textView;

@end
