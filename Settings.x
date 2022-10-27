@protocol _TtP11DeeplinkKit29DeeplinkViewControllerFactory_
- (UIViewController *)viewControllerWithUrl:(NSURL *)arg1;
@end
@interface _TtC13RedditContext14AccountContext : NSObject <NSCopying>
@property(nonatomic, readonly) id <_TtP11DeeplinkKit29DeeplinkViewControllerFactory_> deeplinkViewControllerFactory;
@end

@interface UIViewController (Economy)
- (void)navigateToViewController:(id)arg1 animated:(_Bool)arg2;
@end
@interface DeprecatedBaseViewController : UIViewController
@end
@interface BaseTableViewController : DeprecatedBaseViewController <UITableViewDelegate, UITableViewDataSource>
@property(retain, nonatomic) id tableView; // @synthesize tableView=_tableView;
@end
@interface AppSettingsViewController : BaseTableViewController
@property(readonly, nonatomic) _TtC13RedditContext14AccountContext *accountContext; // @synthesize accountContext=_accountContext;
- (id)dequeueSettingsCellForTableView:(id)arg1 indexPath:(id)arg2 leadingImage:(id)arg3 text:(id)arg4;
@end

@interface _TtC8RedditUI22ViewLabelTableViewCell
@property(nonatomic, readonly) id mainLabel; // @synthesize mainLabel;
@end
@interface _TtC8RedditUI23ImageLabelTableViewCell : _TtC8RedditUI22ViewLabelTableViewCell
@property(nonatomic, retain) UIImage *displayImage; // @synthesize displayImage;
@end
@interface _TtC8RedditUI24ToggleImageTableViewCell : _TtC8RedditUI23ImageLabelTableViewCell
@property(nonatomic, readonly) id accessorySwitch; // @synthesize accessorySwitch;
@end

@interface _TtC15RedditAppAssets15RedditAppImages
@property(nonatomic, readonly) id iconSafari20; // @synthesize iconSafari20;
@property(nonatomic, readonly) id iconSettings20; // @synthesize iconSettings20;
@end
@interface _TtC15RedditAppAssets12RedditAssets : NSObject
@property(nonatomic, readonly) _TtC15RedditAppAssets15RedditAppImages *images; // @synthesize images;
@end
@interface _TtC19Assets_RedditAssets6Assets : NSObject
+ (_TtC15RedditAppAssets12RedditAssets *)reddit;
@end
@interface UIImage (GIDAdditions_Private)
- (id)initWithResource:(id)arg1;
@end

BOOL g_shouldBlockFeedAD;
BOOL g_shouldBlockCommentAD;
BOOL g_shouldBlockTrendingToaster;

BOOL *options[]={&g_shouldBlockFeedAD, &g_shouldBlockCommentAD, &g_shouldBlockTrendingToaster};

%hook AppSettingsViewController
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return %orig+1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==[self numberOfSectionsInTableView:tableView]-1){
        return sizeof(options)/sizeof(BOOL *)+1;
    }
    return %orig;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath section]==[self numberOfSectionsInTableView:tableView]-1){
        NSInteger row = indexPath.row;
        id cell;
        switch(row){
        case 0:
            cell = [[self tableView] dequeueReusableCellWithIdentifier:@"kToggleCellID" forIndexPath:indexPath];
            [[cell accessorySwitch] setOn:g_shouldBlockFeedAD];
            [[cell accessorySwitch] addTarget:self action:@selector(bd_didToggleBlockFeedAD:) forControlEvents:UIControlEventValueChanged];
            [cell setDisplayImage:[[UIImage alloc] initWithResource:[[[objc_getClass("Assets_RedditAssets.Assets") reddit] images] iconSettings20]]];
            [[cell mainLabel] setText:@"No Feed AD"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            break;
        case 1:
            cell = [[self tableView] dequeueReusableCellWithIdentifier:@"kToggleCellID" forIndexPath:indexPath];
            [[cell accessorySwitch] setOn:g_shouldBlockCommentAD];
            [[cell accessorySwitch] addTarget:self action:@selector(bd_didToggleBlockCommentAD:) forControlEvents:UIControlEventValueChanged];
            [cell setDisplayImage:[[UIImage alloc] initWithResource:[[[objc_getClass("Assets_RedditAssets.Assets") reddit] images] iconSettings20]]];
            [[cell mainLabel] setText:@"No Comment AD"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            break;
        case 2:
            cell = [[self tableView] dequeueReusableCellWithIdentifier:@"kToggleCellID" forIndexPath:indexPath];
            [[cell accessorySwitch] setOn:g_shouldBlockTrendingToaster];
            [[cell accessorySwitch] addTarget:self action:@selector(bd_didToggleBlockTrendingToaster:) forControlEvents:UIControlEventValueChanged];
            [cell setDisplayImage:[[UIImage alloc] initWithResource:[[[objc_getClass("Assets_RedditAssets.Assets") reddit] images] iconSettings20]]];
            [[cell mainLabel] setText:@"No \"Interested in r/XX?\""];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            break;
        case 3:
            cell = [self dequeueSettingsCellForTableView:tableView indexPath:indexPath leadingImage:[[UIImage alloc] initWithResource:[[[objc_getClass("Assets_RedditAssets.Assets") reddit] images] iconSafari20]] text:@"Source Code"];
            break;
        }
        return cell;
    }
    return %orig;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath section]==[self numberOfSectionsInTableView:tableView]-1){
        if(indexPath.row==[self tableView:tableView numberOfRowsInSection:[indexPath section]]-1){
            id vc = [[[self accountContext] deeplinkViewControllerFactory] viewControllerWithUrl:[NSURL URLWithString:@"https://github.com/brendonjkding/RedditNoAD"]];
            [vc setTitle:@"RedditNoAD"];
            [self navigateToViewController:vc animated:YES];
        }
    }
    else{
        %orig;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    id orig = %orig;
    if(section==[self numberOfSectionsInTableView:tableView]-1){
        [[[[orig contentView] subviews] lastObject] setText:@"REDDIT NO AD"];
    }
    return orig;
}
%new
- (void)bd_didToggleBlockFeedAD:(id)sender{
    g_shouldBlockFeedAD = [sender isOn];
    [[NSUserDefaults standardUserDefaults] setObject:@(g_shouldBlockFeedAD) forKey:@"bd_shouldBlockFeedAD"];
}
%new
- (void)bd_didToggleBlockCommentAD:(id)sender{
    g_shouldBlockCommentAD = [sender isOn];
    [[NSUserDefaults standardUserDefaults] setObject:@(g_shouldBlockCommentAD) forKey:@"bd_shouldBlockCommentAD"];
}
%new
- (void)bd_didToggleBlockTrendingToaster:(id)sender{
    g_shouldBlockTrendingToaster = [sender isOn];
    [[NSUserDefaults standardUserDefaults] setObject:@(g_shouldBlockTrendingToaster) forKey:@"bd_shouldBlockTrendingToaster"];
}
%end //AppSettingsViewController

%ctor{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    g_shouldBlockFeedAD = [defaults objectForKey:@"bd_shouldBlockFeedAD"]?[defaults boolForKey:@"bd_shouldBlockFeedAD"]:YES;
    g_shouldBlockCommentAD = [defaults objectForKey:@"bd_shouldBlockCommentAD"]?[defaults boolForKey:@"bd_shouldBlockCommentAD"]:YES;
    g_shouldBlockTrendingToaster = [defaults objectForKey:@"bd_shouldBlockTrendingToaster"]?[defaults boolForKey:@"bd_shouldBlockTrendingToaster"]:YES;
}