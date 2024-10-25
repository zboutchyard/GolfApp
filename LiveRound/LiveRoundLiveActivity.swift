//
//  LiveRoundLiveActivity.swift
//  LiveRound
//
//  Created by Zack Boutchyard on 10/24/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LiveRoundLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveRoundAttributes.self) { context in
            LiveRoundActivityView(currentScore: context.state.currentScore, currentHole: context.state.currentHole, courseName: context.state.courseName)
            .activityBackgroundTint(Color.green)
            .activitySystemActionForegroundColor(Color.black)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Current Score: \(context.state.currentScore)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("\(context.state.currentScore)")
            } minimal: {
                Text("\(context.state.currentScore)")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct LiveRoundActivityView: View {
    
    var currentScore: Int
    var currentHole: Int
    var courseName: String
    
    var body: some View {
        VStack {
            HStack {
                Text("Score: \(currentScore)")
                Text("Current hole: \(currentHole)")
            }
            HStack {
                Text("\(courseName)")
            }
        }
    }
}
