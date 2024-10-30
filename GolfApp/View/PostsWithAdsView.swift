import SwiftUI

struct PostsWithAdsView: View {
    @State private var likeBtnClicked: Bool = false
    @State private var commentBtnClicked: Bool = false
    @State private var userClicked: Bool = false
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var notificationViewModel: NotificationViewModel
    @ObservedObject var msgViewModel: MessageViewModel
    @State var user: User?
    @State var post: Post
    @State var tempPost: Post?
    @State var isPostDetailView: Bool = false
    @FocusState var isTextFieldFocused: Bool
    @State var otherUser: OtherUser?
    @State var otherUserClicked: Bool = false
    @State var index: Int
    @Binding var shouldShowMoreOptionsView: Bool
    @Binding var selectedPost: Post
    
    var body: some View {
        NavigationStack {
                if authViewModel.adPositions.contains(index) {
                    NativeAdView()
                    .background(Color.whiteOrDark)
                } else {
                    if let user = authViewModel.user {
                        PostView(
                            authViewModel: authViewModel,
                            notificationViewModel: notificationViewModel,
                            msgViewModel: msgViewModel,
                            user: user,
                            post: post,
                            otherUser: authViewModel.postOtherUsers?[post.user],
                            shouldShowMoreOptionsView: $shouldShowMoreOptionsView,
                            selectedPost: $selectedPost)
                    }
                }
            }
    }
}
