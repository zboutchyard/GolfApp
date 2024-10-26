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
            LiveRoundActivityView(
                currentScore: context.state.currentScore,
                currentHole: context.state.currentHole,
                courseName: context.state.courseName)
            .activityBackgroundTint(Color.green)
            .activitySystemActionForegroundColor(Color.black)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Current Hole: \(context.state.currentHole)")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Score: \(context.state.currentScore)")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("\(context.state.courseName)")
                }
            } compactLeading: {
                Image("AppIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            } compactTrailing: {
                Text("Score: \(context.state.currentScore)")
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
                Spacer()
                Text("Current hole: \(currentHole)")
            }
            Text("Playing at \(courseName)")
        }
    }
}
