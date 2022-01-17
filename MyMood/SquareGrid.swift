//
//  SquareGrid.swift
//  MyMood
//
//  Created by Kyle Shores on 1/8/22.
//

import SwiftUI

// We can make the square's size a constant and use that
let squareSize: CGFloat = 50

// Our square
struct Square: View {
  var color: Color
  
  var body: some View {
    Rectangle()
      .foregroundColor(color)
      .frame(width: squareSize, height: squareSize, alignment: .center)
      .border(.gray, width:1)
    }
}


struct SquareGrid: View {
    private var rows: [GridItem] = []
    private var spacing: CGFloat = 1
    
    public init()
    {
        self.makeRows()
    }
    
    mutating func makeRows(){
        for _ in 0..<21 {
            self.rows.append(GridItem(.fixed(squareSize), spacing: self.spacing, alignment: .center))
        }
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7), alignment: .center, spacing: self.spacing, pinnedViews: [], content: {
            ForEach(0 ..< self.rows.count) { colorIndex in
                Square(color: .red)
            }
        })
            .padding()
    }
}

struct SquareGrid_Previews: PreviewProvider {
    static var previews: some View {
        SquareGrid()
    }
}
