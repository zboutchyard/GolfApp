//
//  LiveRoundManager.swift
//  LiveRoundExtension
//
//  Created by Zack Boutchyard on 10/24/24.
//

import ActivityKit
import Combine
import Foundation

final class LiveRoundManager: ObservableObject {
    @MainActor @Published private(set) var activityID: String?
    @MainActor @Published private(set) var activityToken: String?
    
    static let shared = LiveRoundManager()
    
    func start(courseName: String) async {
        await endActivity()
        await startNewLiveActivity(courseName: courseName)
    }
    
    private func startNewLiveActivity(courseName: String) async {
        let attributes = LiveRoundAttributes()
        
        let initialContentState = ActivityContent(state: LiveRoundAttributes.ContentState(
            currentScore: 1,
            currentHole: 1,
            courseName: courseName),
            staleDate: nil)
        
        let activity = try? Activity.request(
            attributes: attributes,
            content: initialContentState,
            pushType: .token
        )
        
        guard let activity = activity else {
            return
        }
        await MainActor.run { activityID = activity.id }
        
        for await data in activity.pushTokenUpdates {
            let token = data.map {String(format: "%02x", $0)}.joined()
            print("Activity token: \(token)")
            await MainActor.run { activityToken = token }
            // HERE SEND THE TOKEN TO THE SERVER
        }
    }
    
    func endActivity() async {
        guard let activityID = await activityID,
              let runningActivity = Activity<LiveRoundAttributes>.activities.first(where: { $0.id == activityID }) else {
            return
        }
        let initialContentState = LiveRoundAttributes.ContentState(currentScore: 0,
                                                                   currentHole: 0,
                                                                   courseName: "")

        await runningActivity.end(
            ActivityContent(state: initialContentState, staleDate: Date.distantFuture),
            dismissalPolicy: .immediate
        )
        
        await MainActor.run {
            self.activityID = nil
            self.activityToken = nil
        }
    }
    
    func cancelAllRunningActivities() async {
        for activity in Activity<LiveRoundAttributes>.activities {
            let initialContentState = LiveRoundAttributes.ContentState(currentScore: 0,
                                                                       currentHole: 0,
                                                                       courseName: "")
            
            await activity.end(
                ActivityContent(state: initialContentState, staleDate: Date()),
                dismissalPolicy: .immediate
            )
        }
        
        await MainActor.run {
            activityID = nil
            activityToken = nil
        }
    }
    
}
