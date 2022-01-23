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
    
    private let radialOffset = -1 * CGFloat.pi / 2
    
    var angles : [CGFloat] {
        var _angles: [CGFloat] = []
        for index in 1...data.count {
            _angles.append(2 * .pi * CGFloat(index) / CGFloat(data.count) + radialOffset)
        }
        return _angles
    }
    
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
            let vertices = calculateVertices(rect: context.clipBoundingRect)
            let radarCharGridPath = radarChartGridPath(in: context.clipBoundingRect, categories: data.count)
            let dataPath = radarChartPath(in: context.clipBoundingRect)
            let imageEdgeSize = 20.0
            
            context.stroke(radarCharGridPath, with: .color(gridColor), lineWidth: 0.5)
            context.fill(dataPath, with: .color(fillColor.opacity(0.3)))
            context.stroke(dataPath, with: .color(strokeColor), lineWidth: 2.0)
            
            for (var vertex, imageName) in zip(vertices, edgeImageNames) {
                vertex.x -= imageEdgeSize / 2
                vertex.y -= imageEdgeSize / 2
                let rect = CGRect(origin: vertex, size: CGSize(width:imageEdgeSize, height:imageEdgeSize))
                context.draw(Image(imageName), in: rect)
            }
        }.navigationBarTitle("Radar Chart")
    }
    
    private func calculateVertices(rect: CGRect) -> [CGPoint] {
        var vertices: [CGPoint] = []
        
        let radius = min(rect.maxX - rect.midX, rect.maxY - rect.midY) - radiusBuffer
        for angle in angles {
            vertices.append(CGPoint(x: rect.midX + CGFloat(cos(angle)) * radius,
                                   y: rect.midY + CGFloat(sin(angle)) * radius))
        }
        
        return vertices
    }
    
    func radarChartGridPath(in rect: CGRect, categories: Int) -> Path {
        let radius = min(rect.maxX - rect.midX, rect.maxY - rect.midY) - radiusBuffer
        let stride = radius / CGFloat(divisions)
        var path = Path()
        
        for vertex in calculateVertices(rect: rect) {
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addLine(to: vertex)
        }
        
        for step in 1 ... divisions {
            let rad = CGFloat(step) * stride
            path.move(to: CGPoint(x: rect.midX + CGFloat(cos(radialOffset)) * rad,
                                  y: rect.midY + CGFloat(sin(radialOffset)) * rad))
            
            for angle in angles {
                path.addLine(to: CGPoint(x: rect.midX + CGFloat(cos(angle)) * rad,
                                         y: rect.midY + CGFloat(sin(angle)) * rad))
            }
        }
        
        return path
    }
    
    func radarChartPath(in rect: CGRect) -> Path {
        var maximum : Double = data.max()!
        if maximum == 0 {
            // there is no data to display, but we still want to draw the inner circle
            // maximum must be any value so that we don't get a divide by zero error
            maximum = 1
        }
        
        let outterRadius = min(rect.maxX - rect.midX, rect.maxY - rect.midY) - radiusBuffer
        let innerRadius = 0.1 * outterRadius
        var path = Path()
        let a = rect.midX
        let b = rect.midY
        
        for (index, (entry, angle)) in zip(data, angles).enumerated() {
            let scale = CGFloat(entry / maximum) * (outterRadius - innerRadius)
            let x = a + (innerRadius + scale) * CGFloat(cos(angle))
            let y = b + (innerRadius + scale) * CGFloat(sin(angle))
            switch index {
            case 0:
                path.move(to: CGPoint(x: x, y: y))
            default:
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
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
