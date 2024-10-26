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
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    VStack {
                        HStack {
                            Image(systemName: "figure.golf")
                                .resizable().aspectRatio(contentMode: .fit)
                                .frame(width: 14, height: 14)
                                .foregroundColor(.green)
                            Spacer()
                            EmptyView()
                        }
                        .padding(.horizontal, 10)
                        
                        VStack {
                            HStack {
                                Image(systemName: "building.columns.fill")
                                    .resizable().aspectRatio(contentMode: .fit)
                                    .frame(width: 44, height: 44)
                                    .foregroundColor(.green)
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("\(context.state.courseName)")
                                            .font(.system(size: 20))
                                            .bold()
                                        Spacer()
                                    }
                                    HStack {
                                        Button(action: {}, label: {
                                            HStack {
                                                Image(systemName: "phone.fill")
                                                    .resizable().aspectRatio(contentMode: .fit)
                                                    .frame(width: 14, height: 14)
                                                    .foregroundColor(.white)
                                                
                                                Text("Call")
                                                    .font(.system(size: 10))
                                                    .foregroundStyle(.white)
                                            }
                                        })
                                        .buttonBorderShape(.capsule)
                                        Spacer()
                                    }
                                    
                                }
                            }.padding(.horizontal, 30)
                        }
                        
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Score")
                                .font(.system(size: 8))
                            Text("\(context.state.currentScore)")
                                .font(.system(size: 14))
                                .bold()
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Current Hole")
                                .font(.system(size: 8))
                            Text("\(context.state.currentHole)")
                                .font(.system(size: 14))
                                .bold()
                        }
                    }
                    .frame(height: 20)
                    .padding(.horizontal, 10)
                }
            } compactLeading: {
                Image(systemName: "figure.golf")
                    .foregroundStyle(.green)
            } compactTrailing: {
                Text("Score: \(context.state.currentScore)")
            } minimal: {
                Text("\(context.state.currentScore)")
            }
        }
    }
}

struct LiveRoundActivityView: View {
    
    var currentScore: Int
    var currentHole: Int
    var courseName: String
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Image(systemName: "figure.golf")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                        .foregroundColor(.green)
                    Spacer()
                    EmptyView()
                }
                .padding(.horizontal, 10)
                
                VStack {
                    HStack {
                        Image(systemName: "building.columns.fill")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 44)
                            .foregroundColor(.green)
                        VStack(spacing: 0) {
                            HStack {
                                Text("\(courseName)")
                                    .font(.system(size: 20))
                                    .bold()
                                Spacer()
                            }
                            HStack {
                                Button(action: {}, label: {
                                    HStack {
                                        Image(systemName: "phone.fill")
                                            .resizable().aspectRatio(contentMode: .fit)
                                            .frame(width: 14, height: 14)
                                            .foregroundColor(.white)
                                        
                                        Text("Call")
                                            .font(.system(size: 10))
                                            .foregroundStyle(.white)
                                    }
                                })
                                .buttonBorderShape(.capsule)
                                Spacer()
                            }
                            
                        }
                    }.padding(.horizontal, 30)
                }
                
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("Score")
                        .font(.system(size: 8))
                    Text("\(currentScore)")
                        .font(.system(size: 14))
                        .bold()
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Current Hole")
                        .font(.system(size: 8))
                    Text("\(currentHole)")
                        .font(.system(size: 14))
                        .bold()
                }
            }
            .frame(height: 20)
            .padding(.horizontal, 10)
        }
        .padding(10)
    }
}
