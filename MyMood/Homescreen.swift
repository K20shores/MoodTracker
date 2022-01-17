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

    private static var now = Date()
    
    init(calendar: Calendar) {
        self.calendar = calendar
        self.monthFormatter = DateFormatter(dateFormat: "MMMM", calendar: calendar)
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
                        feelings: feelingsForDate(date: selectedDate)
                    )
                        .environment(\.managedObjectContext, self.viewContext),
                    isActive: $isShowingDetailView) { EmptyView() }
                
                Text("Selected date: ")
                    .bold()
                    .foregroundColor(.black) +
                Text("\(fullFormatter.string(from: selectedDate))")
                    .bold()
                    .foregroundColor(.accentColor)
                CalendarView(
                    calendar: calendar,
                    date: $selectedDate,
                    content: { date in
                        Button(action: {
                            isShowingDetailView = true
                            selectedDate = date
                        }) {
                            Rectangle()
                                .padding(10)
                                .foregroundColor(.clear)
                                .background(
                                    calendar.isDate(date, inSameDayAs: selectedDate) ? Color.red
                                    : calendar.isDateInToday(date) ? .green
                                    : .blue
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
                                                    .foregroundColor(dateHasRecordedFeelings(date: date) ? .green : .clear)
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
                                    icon: { Image(systemName: "chevron.left") }
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
                                    icon: { Image(systemName: "chevron.right") }
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
                Spacer()
            }
            .padding()
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