#import "Settings.h"

%hook RedditService
- (id)parseFeedElementData:(id)arg1 parseSubreddits:(_Bool)arg2 parseCrosspostSubreddits:(_Bool)arg3 isPartialSubredditData:(_Bool)arg4 deferSubredditInsertion:(_Bool)arg5{
    if(g_shouldBlockFeedAD && [arg1[@"__typename"] isEqualToString:@"AdPost"]){
        return nil;
    }
    return %orig;
}
- (id)parseFeedElementData:(id)arg1 parseSubreddits:(_Bool)arg2 parseCrosspostSubreddits:(_Bool)arg3 isPartialSubredditData:(_Bool)arg4 deferSubredditInsertion:(_Bool)arg5 isFeedHiddenRecommendationsEnabled:(_Bool)arg6{
    if(g_shouldBlockFeedAD && [arg1[@"__typename"] isEqualToString:@"AdPost"]){
        return nil;
    }
    return %orig;
}
- (id)postWithGraphQLData:(id)arg1 parseSubreddit:(BOOL)arg2 parseCrosspostSubreddit:(BOOL)arg3 isPartialSubredditData:(BOOL)arg4 deferSubredditInsertion:(BOOL)arg5 configureWithBlock:(id)arg6{
    if(g_shouldBlockFeedAD && [arg1[@"__typename"] isEqualToString:@"AdPost"]){
        return nil;
    }
    return %orig;
}
- (id)postWithData:(id)arg1{
    if(g_shouldBlockFeedAD && [arg1[@"promoted"] boolValue]){
        return nil;
    }
    return %orig;
}
%end //RedditService

%hook RedditServiceListingHelper
+ (id)parseFeedElementData:(id)arg1 parseSubreddits:(BOOL)arg2 parseCrosspostSubreddits:(BOOL)arg3 isPartialSubredditData:(BOOL)arg4 deferSubredditInsertion:(BOOL)arg5 isFeedHiddenRecommendationsEnabled:(BOOL)arg6 redditService:(id)arg7{
    if(g_shouldBlockFeedAD && [arg1[@"__typename"] isEqualToString:@"AdPost"]){
        return nil;
    }
    return %orig;
}
+ (id)parseFeedElementData:(id)arg1 parseSubreddits:(BOOL)arg2 parseCrosspostSubreddits:(BOOL)arg3 isPartialSubredditData:(BOOL)arg4 deferSubredditInsertion:(BOOL)arg5 redditService:(id)arg6{
    if(g_shouldBlockFeedAD && [arg1[@"__typename"] isEqualToString:@"AdPost"]){
        return nil;
    }
    return %orig;
}
%end //RedditServiceListingHelper

%hook RedditServicePostHelperObjC
+ (id)postWithData:(id)arg1 redditService:(id)arg2{
    if(g_shouldBlockFeedAD && [arg1[@"promoted"] boolValue]){
        return nil;
    }
    return %orig;
}
%end //RedditServicePostHelperObjC

%hook PostDetailPresenter
-(BOOL)shouldFetchCommentAdPost{
    if(g_shouldBlockCommentAD){
        return NO;
    }
    return %orig;
}
-(void)showTrendingToasterIfNeeded{
    if(!g_shouldBlockTrendingToaster){
        %orig;
    }
}
%end //PostDetailPresenter

%hook SubredditPagePresenter
-(void)showRecommendationToasterIfNeeded{
    if(!g_shouldBlockTrendingToaster){
        %orig;
    }
}
%end //SubredditPagePresenter

%ctor{
    NSLog(@"ctor: RedditNoAD");
    %init(RedditServicePostHelperObjC = objc_getClass("PostService_PostServiceLegacy.RedditServicePostHelperObjC"));
}
