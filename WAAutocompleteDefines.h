//
//  WAAutocompleteDefines.h
//  Copyright 2011 Jan Winter. All rights reserved.
//
//  Licensed under the BSD License <http://www.opensource.org/licenses/bsd-license>
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


//WAAutocompleteHandler defines
#define kAutocompleteItemPlistKey @"String"               //key for object in plist dictionary
#define kAutocompleteItemCoreDataAttributeKey @"String"   //key for attribute in CoreData entity
#define kAutocompleteItemCoreDataEntityName @"CDAutocompleteItem" //name of CoreData entity
#define kAutocompletePlistFileName @"autocompleteData"      //name of plist file with autocomplete data

//adjust popoverView
#define kNumberOfItemsVisible 5
#define kAutocompletePopoverContentSizeWidth 180
#define kAutocompletePopoverContentSize CGSizeMake(kAutocompletePopoverContentSizeWidth, (kNumberOfItemsVisible * kTableViewRowHeight))
#define kPermittedArrowDirections (UIPopoverArrowDirectionDown | UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight)

//WAAutocompleteTableViewController defines
#define kTableViewRowHeight 30
#define kTableViewFont [UIFont systemFontOfSize:12]
#define kTableViewTextColor [UIColor darkGrayColor]