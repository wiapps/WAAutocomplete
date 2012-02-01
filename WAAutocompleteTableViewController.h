//
//  AutoCompleteTableViewController.h
//  Copyright 2011 Jan Winter. All rights reserved.
//
//  Licensed under the BSD License <http://www.opensource.org/licenses/bsd-license>
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface WAAutocompleteTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    NSString *cdEntity;
    NSManagedObjectContext *moc;
    BOOL showAll;
    id delegate;
    
@private
    NSFetchedResultsController *fetchedResultsController;
    NSString *currentStringOfInterest;
}

@property (nonatomic, retain) NSManagedObjectContext *moc;
@property (nonatomic, retain) NSString *cdEntity;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController; 
@property (nonatomic, assign) BOOL showAll;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSString *currentStringOfInterest;

- (void)checkForMatchWithString:(NSString*)searchString;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end
