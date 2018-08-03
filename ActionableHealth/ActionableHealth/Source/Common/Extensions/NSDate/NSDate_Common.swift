//
//  NSDate_Common.swift
//  Common
//
//  Created by Vidhan Nandi on 20/09/16.
//  Copyright © 2016 CommonCodes. All rights reserved.
//

import Foundation
let D_MINUTE = 60.0
let D_HOUR = 3600.0
let D_DAY = 86400.0
let D_WEEK = 604800.0
let D_MONTH = 2629743.83
let D_YEAR = 31556926.0
let MILLI_SECOND = 1000.0

let componentFlags:NSCalendar.Unit = [.era, .year, .month, .day, .hour, .minute, .second, .weekday, .weekdayOrdinal, .quarter, .weekOfMonth, .weekOfYear, .yearForWeekOfYear, .nanosecond, .calendar, .timeZone]

//MARK:- Current calendar
extension Date{
    static func currentCalendar() -> Calendar {
        return Calendar.autoupdatingCurrent
    }
}
//MARK:- String Methods
extension String {
    var dateFromISO8601: Date? {
        return Date.Formatter.iso8601.date(from: self)
    }

    var dateFromShort: Date? {
        return Date.Formatter.short.date(from: self)
    }

    var dateFromMedium: Date? {
        return Date.Formatter.medium.date(from: self)
    }

    var dateFromLong: Date? {
        return Date.Formatter.long.date(from: self)
    }

    var dateFromFull: Date? {
        return Date.Formatter.full.date(from: self)
    }
}
extension Date {
    struct Formatter {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            return formatter
        }()

        //Complete date & time
        static let short: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter
        }()

        static let medium: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            return formatter
        }()

        static let long: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .long
            return formatter
        }()

        static let full: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            formatter.timeStyle = .full
            return formatter
        }()

        // Only Date
        static let shortDate: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter
        }()

        static let mediumDate: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter
        }()

        static let longDate: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter
        }()

        static let fullDate: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            return formatter
        }()

        //Only time
        static let shortTime: DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter
        }()

        static let mediumTime: DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            return formatter
        }()

        static let longTime: DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeStyle = .long
            return formatter
        }()

        static let fullTime: DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeStyle = .full
            return formatter
        }()
    }

    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }

    var shortString: String{
        return Formatter.short.string(from: self)
    }

    var mediumString: String{
        return Formatter.medium.string(from: self)
    }

    var longString: String{
        return Formatter.long.string(from: self)
    }

    var fullString: String{
        return Formatter.full.string(from: self)
    }

    var shortDateString: String{
        return Formatter.shortDate.string(from: self)
    }

    var mediumDateString: String{
        return Formatter.mediumDate.string(from: self)
    }

    var longDateString: String{
        return Formatter.longDate.string(from: self)
    }

    var fullDateString: String{
        return Formatter.fullDate.string(from: self)
    }

    var shortTimeString: String{
        return Formatter.shortTime.string(from: self)
    }

    var mediumTimeString: String{
        return Formatter.mediumTime.string(from: self)
    }

    var longTimeString: String{
        return Formatter.longTime.string(from: self)
    }

    var fullTimeString: String{
        return Formatter.fullTime.string(from: self)
    }

    var shortWeekdayString: String{
        switch self.weekday() {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tues"
        case 4:
            return "Wed"
        case 5:
            return "Thurs"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            return "Sun"
        }
    }

    var longWeekdayString: String{
        switch self.weekday() {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return "Sunday"
        }
    }

    var shortMonthString: String{
        switch self.month() {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sept"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return "Dec"
        }
    }

    var longMonthString: String{
        switch self.month() {
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
        default:
            return "December"
        }
    }

    var shortTimeAgoString:String {

        let numberOfSecs = floor(Date().timeIntervalSince(self))
        //Years
        let numberOfYears = floor(numberOfSecs/D_YEAR)
        if numberOfYears > 0 {
            if numberOfYears == 1 {
                return "1 yr ago"
            }else{
                return "\(Int(numberOfYears)) yrs ago"
            }
        }

        //Months
        let numberOfMonths = floor(numberOfSecs/D_MONTH)
        if numberOfMonths > 0 {
            if numberOfMonths == 1 {
                return "1 mo ago"
            }else{
                return "\(Int(numberOfMonths)) mos ago"
            }
        }

        //Weeks
        let numberOfWeeks = floor(numberOfSecs/D_WEEK)
        if numberOfWeeks > 0 {
            if numberOfWeeks == 1 {
                return "1 wk ago"
            }else{
                return "\(Int(numberOfWeeks)) wks ago"
            }
        }

        //Days
        let numberOfDays = floor(numberOfSecs/D_DAY)
        if numberOfDays > 0 {
            if numberOfDays == 1 {
                return "1 day ago"
            }else{
                return "\(Int(numberOfDays)) days ago"
            }
        }

        //Hours
        let numberOfHours = floor(numberOfSecs/D_HOUR)
        if numberOfHours > 0 {
            if numberOfHours == 1 {
                return "1 hr ago"
            }else{
                return "\(Int(numberOfHours)) hrs ago"
            }
        }

        //Minutes
        let numberOfMins = floor(numberOfSecs/D_MINUTE)
        if numberOfMins > 0 {
            if numberOfMins == 1 {
                return "1 min ago"
            }else{
                return "\(Int(numberOfMins)) mins ago"
            }
        }

        //Seconds
        if numberOfSecs > 59 {
            if numberOfSecs == 1 {
                return "1 sec ago"
            }else{
                return "\(Int(numberOfSecs)) secs ago"
            }
        }
        return "Just Now"
    }

    var longTimeAgoString:String {

        let numberOfSecs = floor(Date().timeIntervalSince(self))

        //Years
        let numberOfYears = floor(numberOfSecs/D_YEAR)
        if numberOfYears > 0 {
            if numberOfYears == 1 {
                return "1 year ago"
            }else{
                return "\(Int(numberOfYears)) years ago"
            }
        }

        //Months
        let numberOfMonths = floor(numberOfSecs/D_MONTH)
        if numberOfMonths > 0 {
            if numberOfMonths == 1 {
                return "1 month ago"
            }else{
                return "\(Int(numberOfMonths)) months ago"
            }
        }

        //Weeks
        let numberOfWeeks = floor(numberOfSecs/D_WEEK)
        if numberOfWeeks > 0 {
            if numberOfWeeks == 1 {
                return "1 week ago"
            }else{
                return "\(Int(numberOfWeeks)) weeks ago"
            }
        }

        //Days
        let numberOfDays = floor(numberOfSecs/D_DAY)
        if numberOfDays > 0 {
            if numberOfDays == 1 {
                return "1 day ago"
            }else{
                return "\(Int(numberOfDays)) days ago"
            }
        }

        //Hours
        let numberOfHours = floor(numberOfSecs/D_HOUR)
        if numberOfHours > 0 {
            if numberOfHours == 1 {
                return "1 hour ago"
            }else{
                return "\(Int(numberOfHours)) hours ago"
            }
        }

        //Minutes
        let numberOfMins = floor(numberOfSecs/D_MINUTE)
        if numberOfMins > 0 {
            if numberOfMins == 1 {
                return "1 minute ago"
            }else{
                return "\(Int(numberOfMins)) minutes ago"
            }
        }

        //Seconds
        if numberOfSecs > 0 {
            if numberOfSecs == 1 {
                return "1 second ago"
            }else{
                return "\(Int(numberOfSecs)) seconds ago"
            }
        }
        return "Just Now"
    }


    var shortTimeLeftString:String {

        let numberOfSecs = floor(self.timeIntervalSince(Date()))
        //Years
        let numberOfYears = floor(numberOfSecs/D_YEAR)
        if numberOfYears > 0 {
            if numberOfYears == 1 {
                return "1 yr left"
            }else{
                return "\(Int(numberOfYears)) yrs left"
            }
        }


        //Days
        let numberOfDays = floor(numberOfSecs/D_DAY)
        if numberOfDays > 0 {
            if numberOfDays == 1 {
                return "1 day left"
            }else{
                return "\(Int(numberOfDays)) days left"
            }
        }

        //Hours
        let numberOfHours = floor(numberOfSecs/D_HOUR)
        if numberOfHours > 0 {
            if numberOfHours == 1 {
                return "1 hr left"
            }else{
                return "\(Int(numberOfHours)) hrs left"
            }
        }

        //Minutes
        let numberOfMins = floor(numberOfSecs/D_MINUTE)
        if numberOfMins > 0 {
            if numberOfMins == 1 {
                return "1 min left"
            }else{
                return "\(Int(numberOfMins)) mins left"
            }
        }

        //Seconds
        if numberOfSecs > 0 {
            if numberOfSecs == 1 {
                return "1 sec left"
            }else{
                return "\(Int(numberOfSecs)) secs left"
            }
        }

        return "You are late"
    }
}


//MARK:- Decomposing dates
extension Date{

    func nearestHour() -> Int{
        let interval = Date().timeIntervalSinceReferenceDate + D_MINUTE * 30
        let newDate = Date.init(timeIntervalSinceReferenceDate: interval)
        let components = (Date.currentCalendar() as NSCalendar).components(NSCalendar.Unit.hour, from: newDate)
        return components.hour!
    }

    func era() -> Int{
        let components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        return components.era!
    }

    func year() -> Int{
        let components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        return components.year!
    }

    func month() -> Int{
        let components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        return components.month!
    }

    func day() -> Int{
        let components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        return components.day!
    }

    func hour() -> Int{
        let components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        return components.hour!
    }

    func minute() -> Int{
        let components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        return components.minute!
    }

    func second() -> Int{
        let components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        return components.second!
    }

    func weekday() -> Int{
        let components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        return components.weekday!
    }

    func weekdayOrdinal() -> Int{    // e.g. 2nd Tuesday of the month is 2
        let components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        return components.weekdayOrdinal!
    }

    func quarter() -> Int{
        let components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        return components.quarter!
    }

    func weekOfMonth() -> Int{
        let components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        return components.weekOfMonth!
    }

    func weekOfYear() -> Int{
        let components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        return components.weekOfYear!
    }

    func yearForWeekOfYear() -> Int{
        let components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        return components.yearForWeekOfYear!
    }

    func nanosecond() -> Int{
        let components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        return components.nanosecond!
    }

    func calendar() -> Calendar?{
        let components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        return (components as NSDateComponents).calendar
    }

    func timeZone() -> TimeZone?{
        let components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        return (components as NSDateComponents).timeZone
    }

    func isLeapMonth() -> Bool{
        let components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        return components.isLeapMonth!
    }

}

//MARK:- Extremes
extension Date{

    func startOfDay() -> Date {
        var components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.nanosecond = 0
        return Date.currentCalendar().date(from: components)!
    }

    func endOfDay() -> Date {
        var components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        components.hour = 23
        components.minute = 59
        components.second = 59
        return Date.currentCalendar().date(from: components)!
    }

    func resetSeconds() -> Date {
        var components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        components.second = 0
        components.nanosecond = 0
        return Date.currentCalendar().date(from: components)!
    }

    func resetMinutes() -> Date {
        var components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        components.minute = 0
        components.second = 0
        return Date.currentCalendar().date(from: components)!
    }
}

//MARK:- Roles
extension Date{

    func isWeekend() -> Bool {
        let components = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        if components.weekday == 1 || components.weekday == 7 {
            return true
        }
        return false
    }

    func isWorkingDay() -> Bool {
        return !self.isWeekend()
    }
}

//MARK:- Comparing Dates
extension Date{

    func isEqualToDateIgnoringTime(_ aDate:Date) -> Bool {
        let components1 = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        let components2 = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: aDate)
        return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day))
    }

    func isToday() -> Bool {
        return self.isEqualToDateIgnoringTime(Date())
    }

    func isTommorow() -> Bool {
        return self.isEqualToDateIgnoringTime(Date.dateTommorow()!)
    }

    func isYesterday() -> Bool {
        return self.isEqualToDateIgnoringTime(Date.dateYesterday()!)
    }

    func isSameWeekAsDate(_ aDate:Date) -> Bool {
        let components1 = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        let components2 = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: aDate)
        if components1.weekOfYear != components2.weekOfYear {
            // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
            return false
        }
        // Must have a time interval under 1 week.
        return fabs(self.timeIntervalSince(aDate)) < D_WEEK
    }

    func isThisWeek() -> Bool {
        return self.isSameWeekAsDate(Date())
    }

    func isNextWeek() -> Bool {
        let interval = Date().timeIntervalSinceReferenceDate + D_WEEK
        let date = Date(timeIntervalSinceReferenceDate: interval)
        return self.isSameWeekAsDate(date)
    }

    func isLastWeek() -> Bool {
        let interval = Date().timeIntervalSinceReferenceDate - D_WEEK
        let date = Date(timeIntervalSinceReferenceDate: interval)
        return self.isSameWeekAsDate(date)
    }

    func isSameMonthAsDate(_ aDate:Date) -> Bool {
        let components1 = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        let components2 = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: aDate)
        return ((components1.year == components2.year) &&
            (components1.month == components2.month))
    }

    func isThisMonth() -> Bool {
        return self.isSameMonthAsDate(Date())
    }

    func isLastMonth() -> Bool {
        return self.isSameMonthAsDate(Date().dateBySubtractingMonths(1)!)
    }

    func isNextMonth() -> Bool {
        return self.isSameMonthAsDate(Date().dateByAddingMonths(1)!)
    }

    func isSameYearAsDate(_ aDate:Date) -> Bool {
        let components1 = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: self)
        let components2 = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: aDate)
        return (components1.year == components2.year)
    }

    func isThisYear() -> Bool {
        return self.isSameYearAsDate(Date())
    }

    func isLastYear() -> Bool {
        return self.isSameYearAsDate(Date().dateBySubtractingYears(1)!)
    }

    func isNextYear() -> Bool {
        return self.isSameYearAsDate(Date().dateByAddingYears(1)!)
    }

    func isEarlierThanDate(_ aDate:Date) -> Bool {
        return self.compare(aDate) == .orderedAscending
    }

    func isLaterThanDate(_ aDate:Date) -> Bool {
        return self.compare(aDate) == .orderedDescending
    }

    func isInFuture() -> Bool {
        return self.isLaterThanDate(Date())
    }

    func isInPast() -> Bool {
        return self.isEarlierThanDate(Date())
    }
}

//MARK:- Retrieving intervals
extension Date{

    func timeIntervalInMilliSecs() -> TimeInterval {
        return timeIntervalSince1970 * MILLI_SECOND
    }

    func minutesAfterDate(_ aDate:Date) -> Int {
        let interval = self.timeIntervalSince(aDate)
        return Int(interval/D_MINUTE)
    }

    func minutesBeforeDate(_ aDate:Date) -> Int {
        let interval = self.timeIntervalSince(aDate)
        return Int(interval/D_MINUTE)
    }

    func hoursAfterDate(_ aDate:Date) -> Int {
        let interval = self.timeIntervalSince(aDate)
        return Int(interval/D_HOUR)
    }

    func hoursBeforeDate(_ aDate:Date) -> Int {
        let interval = self.timeIntervalSince(aDate)
        return Int(interval/D_HOUR)
    }

    func daysAfterDate(_ aDate:Date) -> Int {
        let interval = self.timeIntervalSince(aDate)
        return Int(interval/D_DAY)
    }

    func daysBeforeDate(_ aDate:Date) -> Int {
        let interval = self.timeIntervalSince(aDate)
        return Int(interval/D_DAY)
    }

    func distanceInDaysToDate(_ aDate:Date) -> Int? {
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        let components = (calendar as NSCalendar?)?.components(.day, from: self, to: aDate, options: .matchStrictly)
        return components?.day
    }
}

//MARK:- Adjusting Dates

extension Date{

    func dateByAddingYears(_ dYears:Int) -> Date? {
        var components = DateComponents()
        components.year = dYears
        return (Calendar.current as NSCalendar).date(byAdding: components, to: self, options: NSCalendar.Options(rawValue: 0))
    }

    func dateBySubtractingYears(_ dYears:Int) -> Date? {
        return dateByAddingYears(-dYears)
    }

    func dateByAddingMonths(_ dMonths:Int) -> Date? {
        var components = DateComponents()
        components.month = dMonths
        return (Calendar.current as NSCalendar).date(byAdding: components, to: self, options: NSCalendar.Options(rawValue: 0))
    }

    func dateBySubtractingMonths(_ dMonths:Int) -> Date? {
        return dateByAddingMonths(-dMonths)
    }

    func dateByAddingDays(_ dDays:Int) -> Date? {
        var components = DateComponents()
        components.day = dDays
        return (Calendar.current as NSCalendar).date(byAdding: components, to: self, options: NSCalendar.Options(rawValue: 0))
    }

    func dateBySubtractingDays(_ dDays:Int) -> Date? {
        return dateByAddingDays(-dDays)
    }

    func dateByAddingHours(_ dHours:Double) -> Date? {
        let interval = self.timeIntervalSinceReferenceDate + D_HOUR * dHours
        return Date(timeIntervalSinceReferenceDate: interval)
    }

    func dateBySubtractingHours(_ dHours:Double) -> Date? {
        return dateByAddingHours(-dHours)
    }

    func dateByAddingMinutes(_ dMinutes:Double) -> Date? {
        let interval = self.timeIntervalSinceReferenceDate + D_MINUTE * dMinutes
        return Date(timeIntervalSinceReferenceDate: interval)
    }

    func dateBySubtractingMinutes(_ dMinutes:Double) -> Date? {
        return dateByAddingMinutes(-dMinutes)
    }

    func componentsWithOffsetFromDate(_ aDate:Date) -> DateComponents {
        let component = (Date.currentCalendar() as NSCalendar).components(componentFlags, from: aDate, to: self, options: NSCalendar.Options(rawValue: 0))
        return component
    }
}


//MARK:- Relative Dates
extension Date{

    static func dateWithTimeIntervalInMilliSecs(_ interval:TimeInterval) -> Date {
        return Date(timeIntervalSince1970: interval/MILLI_SECOND)
    }
    static func dateWithDaysFromNow(_ days:Int) -> Date? {
        return Date().dateByAddingDays(days)
    }

    static func dateWithDaysBeforeNow(_ days:Int) -> Date? {
        return Date().dateBySubtractingDays(days)
    }

    static func dateTommorow() -> Date? {
        return Date.dateWithDaysFromNow(1)
    }
    
    static func dateYesterday() -> Date? {
        return Date.dateWithDaysBeforeNow(1)
    }
    
    static func dateWithHoursFromNow(_ days:Double) -> Date? {
        return Date().dateByAddingHours(days)
    }
    
    static func dateWithHoursBeforeNow(_ days:Double) -> Date? {
        return Date().dateBySubtractingHours(days)
    }
    
    static func dateWithMinutesFromNow(_ minutes:Double) -> Date? {
        return Date().dateByAddingMinutes(minutes)
    }
    
    static func dateWithMinutesBeforeNow(_ minutes:Double) -> Date? {
        return Date().dateBySubtractingMinutes(minutes)
    }
}
