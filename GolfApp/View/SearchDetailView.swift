import SwiftUI
import AlertToast

struct SearchDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var msgViewModel: MessageViewModel
    @Binding var searchText: String
    @State private var filteredUsers: [OtherUser]?
    @State var isAddFriendSelected: Bool = false
    @Binding var isAddFriendView: Bool
    @ObservedObject var notificationViewModel: NotificationViewModel
    @State var selectedUser: OtherUser?
    @State var isUserSelected: Bool = false
    @State var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Users")
                    .fontWeight(.semibold)
                    .font(.title3)
                    .kerning(1.2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                Divider()
                
                LazyVStack {
                    ForEach(filteredUsers ?? authViewModel.otherUsers ?? [], id: \.id) { otherUser in
                        UserRow(otherUser: otherUser,
                                authViewModel: authViewModel,
                                notificationViewModel: notificationViewModel,
                                isAddFriendView: isAddFriendView,
                                isAddFriendSelected: $isAddFriendSelected,
                                onUserSelect: {
                                    selectedUser = otherUser
                                    isUserSelected = true
                                })
                    }
                    Spacer()
                        .frame(maxHeight: .infinity)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .backButtonToolbar()
        .navigationDestination(isPresented: $isUserSelected) {
            if let selectedUser = selectedUser, let user = authViewModel.user {
                OtherUserProfileView(authViewModel: authViewModel,
                                     notificationViewModel: notificationViewModel,
                                     otherUser: selectedUser,
                                     user: user,
                                     msgViewModel: msgViewModel)
            }
        }
        .toast(isPresenting: $isAddFriendSelected) {
            AlertToast(displayMode: .banner(.pop), type: .complete(.mint), title: "Request sent")
        }
        .onChange(of: searchText) { _ in
            filterUsers()
        }
    }
    
    private func filterUsers() {
        if !searchText.isEmpty, let allUsers = authViewModel.otherUsers {
            filteredUsers = allUsers.filter { $0.firstName.lowercased().contains(searchText.lowercased()) }
        } else {
            filteredUsers = authViewModel.otherUsers
        }
    }
}

struct UserRow: View {
    var otherUser: OtherUser
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var notificationViewModel: NotificationViewModel
    var isAddFriendView: Bool
    @Binding var isAddFriendSelected: Bool
    var onUserSelect: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onUserSelect) {
                PersonCellView(otherUser: otherUser, authViewModel: authViewModel, isPostView: .constant(false))
            }
            .buttonStyle(.plain)
            
            if isAddFriendView {
                FriendButtonView(authViewModel: authViewModel,
                                 otherUser: otherUser,
                                 isAddFriendSelected: $isAddFriendSelected,
                                 notificationViewModel: notificationViewModel)
            } else {
                Spacer()
            }
        }
    }
}

struct FriendButtonView: View {
    @ObservedObject var authViewModel: AuthViewModel
    var otherUser: OtherUser
    @Binding var isAddFriendSelected: Bool
    @ObservedObject var notificationViewModel: NotificationViewModel
    
    var body: some View {
        if let user = authViewModel.user {
            if user.sentRequests?.contains(where: { $0.user == otherUser.id }) == true ||
               user.receivedRequests?.contains(where: { $0.user == otherUser.id }) == true {
                Button("Pending approval") {}.disabled(true)
            } else if user.friendsList?.contains(otherUser.id) == true {
                Button("Friends") {}.disabled(true)
            } else {
                Button("Add") {
                    Task {
                        notificationViewModel.sendRequest(userId: otherUser.id)
                        isAddFriendSelected = true
                        authViewModel.user?.sentRequests?.append(Request(user: otherUser.id))
                    }
                }
                .tint(Color.green)
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
