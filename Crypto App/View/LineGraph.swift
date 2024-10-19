//
//  LineGraph.swift
//  Crypto App
//
//  Created by Phat Vuong Vinh on 19/10/24.
//

import SwiftUI
import Charts


//
struct LineGraph: View {
    
    // number of plots..
    
    var data: [CGFloat]
    
    // View Properties
    @State private var currentPlot = ""
    @State private var offset: CGSize = .zero
    @State private var showPlot: Bool = false
    @State private var translation: CGFloat = 0
    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width / CGFloat(data.count - 1)
            
            let maxPoint = (data.max() ?? 0) + 100
            let minPoint = data.min() ?? 0
            
            let points = data.enumerated().compactMap  { (index, value) in
                // getting progress and multiplyinh with height..
                
                let progress = value / maxPoint
                
                let pathHeight = height * progress
                
                // width
                let pathWidth = width * CGFloat(index)
                
                return CGPoint(x: pathWidth, y: -pathHeight + height)
            }
            ZStack {
                
                Path{ path in
                    path.move(to: .init(x: 0, y: 0))
                    path.addLines(points)
                }
                .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                
                .fill(
                    LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .leading, endPoint: .trailing)
                    
                )
                
                LinearGradient(colors: [.purple.opacity(0.3), .clear], startPoint: .top, endPoint: .bottom)
                
            
                    .clipShape(Path{ path in
                        path.move(to: .init(x: 0, y: 0))
                        path.addLines(points)
                        
                        path.addLine(to: CGPoint(x: geometry.size.width, y: height))
                        
                        path.addLine(to: CGPoint(x: 0, y: height))
                        
                    })
            }
            .overlay(alignment: .bottomLeading) {
                VStack(spacing: 0) {
                    Text(currentPlot)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical,6)
                        .padding(.horizontal,10)
                        .background(.purple, in: .capsule)
                        .offset(x: translation < 10 ? 30 : 0)
                        .offset(x: translation > geometry.size.width - 60 ? -30 : 0)

                    Rectangle()
                        .fill(.purple)
                        .frame(width: 1,height: 55)
                        .padding(.top)
                    Circle()
                        .fill(.purple)
                        .frame(width: 22,height: 22)
                        .overlay( Circle().fill(.white).frame(width: 10, height: 10))
                    Rectangle()
                        .fill(.purple)
                        .frame(width: 1,height: 45)
                }
                .frame(width: 80, height: 170)
                // 170/2 = 85 -22 => cirle ring size
                .offset(y: 63)
                .offset(offset)
                .opacity(showPlot ? 1 : 0)
            }
            .contentShape(.rect)
            .gesture(DragGesture().onChanged({ value in
                withAnimation {
                    showPlot = true
                }
                
                let transalation = value.location.x - 40
                
                // getindex
                let index = max(min(Int((transalation / width).rounded() + 1), data.count - 1), 0)
                
                currentPlot = "$ \(data[index])"
                
                self.translation = transalation
                offset = CGSize(width: points[index].x - 40, height: points[index].y - height)
            }).onEnded({ value in
                withAnimation {
                    showPlot = false
                }
            }))
            
        }
        .overlay {
            VStack(alignment: .leading) {
                let max = data.max() ?? 0
                
                Text("$ \(max)")
                    .font(.caption.bold())
                
                Spacer()
                
                Text("$0")
                    .font(.caption.bold())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 10)
    }
    
    
    
}

#Preview {
    LineGraph(data: samplePlots)
        .frame(height: 500)
}


var samplePlots: [CGFloat] = [100, 250, 340, 143, 451, 26, 147, 48, 49, 110]


