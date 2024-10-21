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
    
    @State var data: [Double]
    var profit: Bool = false
    var showModelOnly: Bool = false
    
    // View Properties
    @State private var currentPlot = ""
    @State private var offset: CGSize = .zero
    @State private var showPlot: Bool = false
    @State private var translation: CGFloat = 0
    @GestureState private var isDrag: Bool = false
    
    @State private var graphProgress: CGFloat = 0
    
    
    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width / CGFloat(data.count - 1)
            
            let maxPoint = (data.max() ?? 0)
            let minPoint = data.min() ?? 0
            
            let points = data.enumerated().compactMap  { (index, value) in
                // getting progress and multiplyinh with height..
                
                let progress = (value - minPoint) / (maxPoint - minPoint)
                
                let pathHeight = (height) * progress
                
                // width
                let pathWidth = width * CGFloat(index)
                
                return CGPoint(x: pathWidth, y: -pathHeight + height)
            }
            ZStack {
                
                AnimatedGraphPath(progress: graphProgress, points: points)
                .fill(
                    LinearGradient(gradient: Gradient(colors: [profit ? .green : .red]), startPoint: .leading, endPoint: .trailing)
                    
                )
                
                if !showModelOnly {
                    LinearGradient(colors: [profit ? .green.opacity(0.3) : .red.opacity(0.3), .clear], startPoint: .top, endPoint: .bottom)
                    
                
                        .clipShape(Path{ path in
                            path.move(to: .init(x: 0, y: 0))
                            path.addLines(points)
                            
                            path.addLine(to: CGPoint(x: geometry.size.width, y: height))
                            
                            path.addLine(to: CGPoint(x: 0, y: height))
                            
                        })
                        .opacity(graphProgress)
                }
               
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
                        .offset(x: translation > geometry.size.width - 30 ? -30 : 0)

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
                .frame(width: 100, height: 170)
                // 170/2 = 85 -22 => cirle ring size
                .offset(y: 63)
                .offset(offset)
                .opacity(showPlot ? 1 : 0)
            }
            .contentShape(.rect)
            .gesture( showModelOnly ? nil :  DragGesture().onChanged({ value in
                withAnimation {
                    showPlot = true
                }
                
                let transalation = value.location.x
                
                // getindex
                let index = max(min(Int((transalation / width).rounded() + 1), data.count - 1), 0)
                
                currentPlot = data[index].convertDoubleToCurrency()
                
                self.translation = transalation
                offset = CGSize(width: points[index].x - 50, height: points[index].y - height)
            }).onEnded({ value in
                withAnimation {
                    showPlot = false
                }
            }).updating($isDrag) { value , out, _ in
                out = true
            }
            )
            
        }
        .overlay {
            if !showModelOnly {
                VStack(alignment: .leading) {
                    let max = data.max() ?? 0
                    let min = data.min() ?? 0
                    Text(max.convertDoubleToCurrency())
                        .font(.caption.bold())
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(min.convertDoubleToCurrency())
                            .font(.caption.bold())

                        Text("Last 7 days")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
           
        }
        .onChange(of: isDrag) { oldValue, newValue in
            if !newValue && !showModelOnly {
                showPlot = false
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 1)) {
                    graphProgress = 1
                }
            }
        }
        .onChange(of: data) { _, _ in
//            graphProgress = 0
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                withAnimation(.easeInOut(duration: 1)) {
//                    graphProgress = 1
//                }
//            }
        }
    }
    
}

#Preview {
    LineGraph(data: [10, 20, 30, 40, 50])
}


struct AnimatedGraphPath: Shape {
    
    var progress: CGFloat
    var points: [CGPoint]
    
    var animatableData: CGFloat {
        get { progress } set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path{ path in
            path.move(to: .init(x: 0, y: 0))
            path.addLines(points)
        }
        .trimmedPath(from: 0, to: progress)
        .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
        
    }
}
