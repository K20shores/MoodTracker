//
//  Homescreen.swift
//  MyMood
//
//  Created by many people from github: https://gist.github.com/mecid/f8859ea4bdbd02cf5d440d58e936faec#gistcomment-3737649
//
//  Modified by Kyle Shores

import SwiftUI

struct Homescreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Feeling.timestamp, ascending: true)],
        animation: .default)
    private var feelings: FetchedResults<Feeling>
    
    private let calendar: Calendar
    private let monthFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private let fullFormatter: DateFormatter
    
    @State private var selectedDate = Self.now
    @State private var isShowingDetailView = false
    @State private var theId = 0
    @State private var showAbout = false
    
    private static var now = Date()
    
    init(calendar: Calendar) {
        self.calendar = calendar
        self.monthFormatter = DateFormatter(dateFormat: "MMMM, yyyy", calendar: calendar)
        self.dayFormatter = DateFormatter(dateFormat: "d", calendar: calendar)
        self.weekDayFormatter = DateFormatter(dateFormat: "EEEEE", calendar: calendar)
        self.fullFormatter = DateFormatter(dateFormat: "MMMM dd, yyyy", calendar: calendar)
    }
    
    private let iconSize: CGFloat = 12
    
    var body: some View {
        
        NavigationView {
            VStack {
                NavigationLink(
                    destination: ListOfDates(
                        feelings: feelingsForDate(date: selectedDate),
                        date: selectedDate
                    )
                        .environment(\.managedObjectContext, self.viewContext),
                    isActive: $isShowingDetailView) { EmptyView() }
                
                CalendarView(
                    calendar: calendar,
                    date: $selectedDate,
                    content: { date in
                        Button(action: {
                            isShowingDetailView = true
                            let now = Date()
                            
                            var selectedDateComponents = calendar.dateComponents(
                                [.year, .month, .day, .hour, .minute, .second], from: date)
                            let components = calendar.dateComponents(
                                [.year, .month, .day, .hour, .minute, .second], from: now)
                            
                            selectedDateComponents.hour = components.hour
                            selectedDateComponents.minute = components.minute
                            selectedDateComponents.second = components.second
                            
                            selectedDate = calendar.date(from: selectedDateComponents)!
                            
                        }) {
                            Rectangle()
                                .padding(10)
                                .foregroundColor(.clear)
                                .background(
                                    calendar.isDateInToday(date) ? Theme.color4
                                    : Theme.color2
                                )
                                .cornerRadius(8)
                                .accessibilityHidden(true)
                                .overlay(
                                    alignment: .topLeading,
                                    content: {
                                        VStack(alignment: .leading, spacing: 0) {
                                            Text(dayFormatter.string(from: date))
                                                .foregroundColor(.white)
                                                .padding(EdgeInsets(top: 2, leading: 5, bottom: 0, trailing: 0))
                                            HStack {
                                                Spacer()
                                                Image(systemName: "heart.fill")
                                                    .resizable()
                                                    .foregroundColor(dateHasRecordedFeelings(date: date) ? Theme.color1 : .clear)
                                                    .frame(width: iconSize, height: iconSize)
                                                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 4, trailing: 5))
                                            }
                                        }
                                    }
                                )
                        }
                        .frame(minHeight: 44, maxHeight: .infinity)
                    },
                    trailing: { date in
                        Text(dayFormatter.string(from: date))
                            .foregroundColor(.secondary)
                    },
                    header: { date in
                        Text(weekDayFormatter.string(from: date))
                    },
                    title: { date in
                        HStack {
                            Text(monthFormatter.string(from: date))
                                .font(.headline)
                                .padding()
                            Spacer()
                            Button {
                                withAnimation {
                                    guard let newDate = calendar.date(
                                        byAdding: .month,
                                        value: -1,
                                        to: selectedDate
                                    ) else {
                                        return
                                    }
                                    
                                    selectedDate = newDate
                                }
                            } label: {
                                Label(
                                    title: { Text("Previous") },
                                    icon: {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(Theme.color4)
                                    }
                                )
                                    .labelStyle(IconOnlyLabelStyle())
                                    .padding(.horizontal)
                                    .frame(maxHeight: .infinity)
                            }
                            Button {
                                withAnimation {
                                    guard let newDate = calendar.date(
                                        byAdding: .month,
                                        value: 1,
                                        to: selectedDate
                                    ) else {
                                        return
                                    }
                                    
                                    selectedDate = newDate
                                }
                            } label: {
                                Label(
                                    title: { Text("Next") },
                                    icon: {
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Theme.color4)
                                    }
                                )
                                    .labelStyle(IconOnlyLabelStyle())
                                    .padding(.horizontal)
                                    .frame(maxHeight: .infinity)
                            }
                        }
                        .padding(.bottom, 6)
                    }
                )
                    .equatable()
                    .id(theId)
                    .onAppear {
                        // forces the view to refresh
                        // If the user selected a day and added a feeling, navigating back to this screen will
                        // cause the view to redraw itself since the id changed and then the little heart on the day
                        // will appear
                        theId += 1
                    }
                
                NavigationLink(
                    destination:
                        RadarChart(
                            data: makeList(Mood.moods.count),
                            fillColor: Theme.color1,
                            strokeColor: Theme.color1,
                            divisions: 5,
                            radiusBuffer: 10,
                            edgeImageNames: Array(Mood.moods.keys))
                        )
                {
                    Text("Radar Chart")
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Theme.color2, lineWidth:1)
                        )
                        .foregroundColor(Theme.color2)
                }
                Spacer()
            }
            .padding()
            .toolbar{
                ToolbarItem{
                    Button("About") {
                        showAbout = true
                    }
                    .foregroundColor(.accentColor)
                    .sheet(isPresented: $showAbout, content: {
                        AboutView(showSheetView: $showAbout)
                    })
                }
            }
        }
    }
    
    private func feelingsForDate(date: Date) -> [Feeling] {
        return self.feelings.filter{ feeling in
            return self.calendar.isDate(feeling.timestamp!, equalTo:date, toGranularity:Calendar.Component.day)
        }
    }
    
    private func dateHasRecordedFeelings(date: Date) -> Bool {
        let feelingsOnDate = self.feelings.filter{ feeling in
            return self.calendar.isDate(feeling.timestamp!, equalTo:date, toGranularity:Calendar.Component.day)
        }
        
        return feelingsOnDate.count > 0
    }
}

public struct CalendarView<Day: View, Header: View, Title: View, Trailing: View>: View {
    private var calendar: Calendar
    @Binding private var date: Date
    private let content: (Date) -> Day
    private let trailing: (Date) -> Trailing
    private let header: (Date) -> Header
    private let title: (Date) -> Title
    
    private let daysInWeek = 7
    
    public init(
        calendar: Calendar,
        date: Binding<Date>,
        @ViewBuilder content: @escaping (Date) -> Day,
        @ViewBuilder trailing: @escaping (Date) -> Trailing,
        @ViewBuilder header: @escaping (Date) -> Header,
        @ViewBuilder title: @escaping (Date) -> Title
    ) {
        self.calendar = calendar
        self._date = date
        self.content = content
        self.trailing = trailing
        self.header = header
        self.title = title
    }
    
    public var body: some View {
        let month = date.startOfMonth(using: calendar)
        let days = makeDays()
        
        return LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
            Section(header: title(month)) {
                ForEach(days.prefix(daysInWeek), id: \.self, content: header)
                ForEach(days, id: \.self) { date in
                    if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                        content(date)
                    } else {
                        trailing(date)
                    }
                }
            }
        }
    }
}

extension CalendarView: Equatable {
    public static func == (lhs: CalendarView<Day, Header, Title, Trailing>, rhs: CalendarView<Day, Header, Title, Trailing>) -> Bool {
        lhs.calendar == rhs.calendar && lhs.date == rhs.date
    }
}

private extension CalendarView {
    func makeDays() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else {
            return []
        }
        
        let dateInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        return calendar.generateDays(for: dateInterval)
    }
}

private extension Calendar {
    func generateDates(
        for dateInterval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates = [dateInterval.start]
        
        enumerateDates(
            startingAfter: dateInterval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            guard let date = date else { return }
            
            guard date < dateInterval.end else {
                stop = true
                return
            }
            
            dates.append(date)
        }
        
        return dates
    }
    
    func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDates(
            for: dateInterval,
               matching: dateComponents([.hour, .minute, .second], from: dateInterval.start)
        )
    }
}

private extension Date {
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year, .month], from: self)
        ) ?? self
    }
}

private extension DateFormatter {
    convenience init(dateFormat: String, calendar: Calendar) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar = calendar
    }
}

struct Homescreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Homescreen(calendar: Calendar(identifier: .gregorian))
                .previewInterfaceOrientation(.portrait)
        }
    }
}
