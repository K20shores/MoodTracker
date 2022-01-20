//
//  RadarChart.swift
//  MyMood
//
//  Created by Kyle Shores on 1/17/22.
//
//  Built off of this: https://betterprogramming.pub/data-visualization-with-swiftui-radar-charts-64124aa2ac0b

import SwiftUI

struct RadarChart: View {
    var data: [Double]
    let gridColor: Color
    let fillColor: Color
    let strokeColor: Color
    let divisions: Int
    let radiusBuffer: Double
    let edgeImageNames: [String]
    
    init(data: [Double], gridColor: Color = .gray, fillColor: Color = .blue, strokeColor: Color = .blue, divisions: Int = 10, radiusBuffer: Double = 0.0, edgeImageNames: [String] = []) {
        self.data = data
        self.gridColor = gridColor
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.divisions = divisions
        self.radiusBuffer = radiusBuffer
        self.edgeImageNames = edgeImageNames
    }
    
    var body: some View {
        Canvas { context, size in
            let edges = calculateEdgePoints(rect: context.clipBoundingRect, categories: data.count)
            let radarCharGridPath = radarChartGridPath(in: context.clipBoundingRect, categories: data.count)
            let dataPath = radarChartPath(in: context.clipBoundingRect)
            
            context.stroke(radarCharGridPath, with: .color(gridColor), lineWidth: 0.5)
            context.fill(dataPath, with: .color(fillColor.opacity(0.3)))
            context.stroke(dataPath, with: .color(strokeColor), lineWidth: 2.0)
            
            if edgeImageNames.count > 0{
                for idx in 0...data.count-1 {
                    var edge = edges[idx]
                    let image = Image(edgeImageNames[idx])
                    let imageEdgeSize = 20.0
                    edge.x -= imageEdgeSize / 2
                    edge.y -= imageEdgeSize / 2
                    let rect = CGRect(origin: edge, size: CGSize(width:imageEdgeSize, height:imageEdgeSize))
                    context.draw(image, in: rect)
                }
            }
        }.navigationBarTitle("Radar Chart")
    }
    
    private func calculateEdgePoints(rect: CGRect, categories: Int) -> [CGPoint] {
        var edgeVertices: [CGPoint] = []
        
        let radius = min(rect.maxX - rect.midX, rect.maxY - rect.midY) - radiusBuffer
        for category in 1 ... categories {
            let edgePoint = CGPoint(x: rect.midX + cos(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * radius,
                                    y: rect.midY + sin(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * radius)
            edgeVertices.append(edgePoint)
        }
        
        return edgeVertices
    }
    
    func radarChartGridPath(in rect: CGRect, categories: Int) -> Path {
        let radius = min(rect.maxX - rect.midX, rect.maxY - rect.midY) - radiusBuffer
        let stride = radius / CGFloat(divisions)
        var path = Path()
        
        for category in 1 ... categories {
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX + cos(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * radius,
                                     y: rect.midY + sin(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * radius))
        }
        
        for step in 1 ... divisions {
            let rad = CGFloat(step) * stride
            path.move(to: CGPoint(x: rect.midX + cos(-.pi / 2) * rad,
                                  y: rect.midY + sin(-.pi / 2) * rad))
            
            for category in 1 ... categories {
                path.addLine(to: CGPoint(x: rect.midX + cos(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * rad,
                                         y: rect.midY + sin(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * rad))
            }
        }
        
        return path
    }
    
    func radarChartPath(in rect: CGRect) -> Path {
        guard
            3 <= data.count,
            let minimum = data.min(),
            0 <= minimum,
            let maximum = data.max()
        else { return Path() }
        
        let radius = min(rect.maxX - rect.midX, rect.maxY - rect.midY) - radiusBuffer
        var path = Path()
        
        for (index, entry) in data.enumerated() {
            switch index {
            case 0:
                path.move(to: CGPoint(x: rect.midX + CGFloat(entry / maximum) * cos(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius,
                                      y: rect.midY + CGFloat(entry / maximum) * sin(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius))
                
            default:
                path.addLine(to: CGPoint(x: rect.midX + CGFloat(entry / maximum) * cos(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius,
                                         y: rect.midY + CGFloat(entry / maximum) * sin(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius))
            }
        }
        path.closeSubpath()
        return path
    }
}

func makeList(_ n: Int) -> [Double] {
    return (0..<n).map{ _ in Double.random(in: 1 ... 20) }
}

struct RadarChart_Previews: PreviewProvider {
    static var previews: some View {
        RadarChart(
            data: makeList(Mood.moods.count),
            gridColor: Theme.color2,
            fillColor: Theme.color1,
            strokeColor: Theme.color1,
            divisions: 5,
            radiusBuffer: 10,
            edgeImageNames: Array(Mood.moods.keys)
        )
            .padding()
    }
}
