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

let componentFlags:NSCalendarUnit = [.Era, .Year, .Month, .Day, .Hour, .Minute, .Second, .Weekday, .WeekdayOrdinal, .Quarter, .WeekOfMonth, .WeekOfYear, .YearForWeekOfYear, .Nanosecond, .Calendar, .TimeZone]

//MARK:- Current calendar
extension NSDate{
    class func currentCalendar() -> NSCalendar {
        return NSCalendar.autoupdatingCurrentCalendar()
    }
}
//MARK:- String Methods
extension String {
    var dateFromISO8601: NSDate? {
        return NSDate.Formatter.iso8601.dateFromString(self)
    }

    var dateFromShort: NSDate? {
        return NSDate.Formatter.short.dateFromString(self)
    }

    var dateFromMedium: NSDate? {
        return NSDate.Formatter.medium.dateFromString(self)
    }

    var dateFromLong: NSDate? {
        return NSDate.Formatter.long.dateFromString(self)
    }

    var dateFromFull: NSDate? {
        return NSDate.Formatter.full.dateFromString(self)
    }
}
extension NSDate {
    struct Formatter {
        static let iso8601: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.calendar = NSCalendar(identifier: NSCalendarIdentifierISO8601)
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            return formatter
        }()

        //Complete date & time
        static let short: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .ShortStyle
            formatter.timeStyle = .ShortStyle
            return formatter
        }()

        static let medium: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .MediumStyle
            return formatter
        }()

        static let long: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .LongStyle
            formatter.timeStyle = .LongStyle
            return formatter
        }()

        static let full: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .FullStyle
            formatter.timeStyle = .FullStyle
            return formatter
        }()

        // Only Date
        static let shortDate: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .ShortStyle
            return formatter
        }()

        static let mediumDate: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            return formatter
        }()

        static let longDate: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .LongStyle
            return formatter
        }()

        static let fullDate: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .FullStyle
            return formatter
        }()

        //Only time
        static let shortTime: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.timeStyle = .ShortStyle
            return formatter
        }()

        static let mediumTime: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.timeStyle = .MediumStyle
            return formatter
        }()

        static let longTime: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.timeStyle = .LongStyle
            return formatter
        }()

        static let fullTime: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.timeStyle = .FullStyle
            return formatter
        }()
    }

    var iso8601: String {
        return Formatter.iso8601.stringFromDate(self)
    }

    var shortString: String{
        return Formatter.short.stringFromDate(self)
    }

    var mediumString: String{
        return Formatter.medium.stringFromDate(self)
    }

    var longString: String{
        return Formatter.long.stringFromDate(self)
    }

    var fullString: String{
        return Formatter.full.stringFromDate(self)
    }

    var shortDateString: String{
        return Formatter.shortDate.stringFromDate(self)
    }

    var mediumDateString: String{
        return Formatter.mediumDate.stringFromDate(self)
    }

    var longDateString: String{
        return Formatter.longDate.stringFromDate(self)
    }

    var fullDateString: String{
        return Formatter.fullDate.stringFromDate(self)
    }

    var shortTimeString: String{
        return Formatter.shortTime.stringFromDate(self)
    }

    var mediumTimeString: String{
        return Formatter.mediumTime.stringFromDate(self)
    }

    var longTimeString: String{
        return Formatter.longTime.stringFromDate(self)
    }

    var fullTimeString: String{
        return Formatter.fullTime.stringFromDate(self)
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

        let numberOfSecs = floor(NSDate().timeIntervalSinceDate(self))
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

        let numberOfSecs = floor(NSDate().timeIntervalSinceDate(self))

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

        let numberOfSecs = floor(self.timeIntervalSinceDate(NSDate()))
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
extension NSDate{

    func nearestHour() -> Int{
        let interval = NSDate().timeIntervalSinceReferenceDate + D_MINUTE * 30
        let newDate = NSDate.init(timeIntervalSinceReferenceDate: interval)
        let components = NSDate.currentCalendar().components(NSCalendarUnit.Hour, fromDate: newDate)
        return components.hour
    }

    func era() -> Int{
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        return components.era
    }

    func year() -> Int{
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        return components.year
    }

    func month() -> Int{
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        return components.month
    }

    func day() -> Int{
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        return components.day
    }

    func hour() -> Int{
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        return components.hour
    }

    func minute() -> Int{
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        return components.minute
    }

    func second() -> Int{
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        return components.second
    }

    func weekday() -> Int{
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        return components.weekday
    }

    func weekdayOrdinal() -> Int{    // e.g. 2nd Tuesday of the month is 2
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        return components.weekdayOrdinal
    }

    func quarter() -> Int{
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        return components.quarter
    }

    func weekOfMonth() -> Int{
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        return components.weekOfMonth
    }

    func weekOfYear() -> Int{
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        return components.weekOfYear
    }

    func yearForWeekOfYear() -> Int{
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        return components.yearForWeekOfYear
    }

    func nanosecond() -> Int{
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        return components.nanosecond
    }

    func calendar() -> NSCalendar?{
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        return components.calendar
    }

    func timeZone() -> NSTimeZone?{
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        return components.timeZone
    }

    func isLeapMonth() -> Bool{
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        return components.leapMonth
    }

}

//MARK:- Extremes
extension NSDate{

    func startOfDay() -> NSDate {
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.nanosecond = 0
        return NSDate.currentCalendar().dateFromComponents(components)!
    }

    func endOfDay() -> NSDate {
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        components.hour = 23
        components.minute = 59
        components.second = 59
        return NSDate.currentCalendar().dateFromComponents(components)!
    }

    func resetSeconds() -> NSDate {
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        components.second = 0
        components.nanosecond = 0
        return NSDate.currentCalendar().dateFromComponents(components)!
    }

    func resetMinutes() -> NSDate {
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        components.minute = 0
        components.second = 0
        return NSDate.currentCalendar().dateFromComponents(components)!
    }
}

//MARK:- Roles
extension NSDate{

    func isWeekend() -> Bool {
        let components = NSDate.currentCalendar().components(componentFlags, fromDate: self)
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
extension NSDate{

    func isEqualToDateIgnoringTime(aDate:NSDate) -> Bool {
        let components1 = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        let components2 = NSDate.currentCalendar().components(componentFlags, fromDate: aDate)
        return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day))
    }

    func isToday() -> Bool {
        return self.isEqualToDateIgnoringTime(NSDate())
    }

    func isTommorow() -> Bool {
        return self.isEqualToDateIgnoringTime(NSDate.dateTommorow()!)
    }

    func isYesterday() -> Bool {
        return self.isEqualToDateIgnoringTime(NSDate.dateYesterday()!)
    }

    func isSameWeekAsDate(aDate:NSDate) -> Bool {
        let components1 = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        let components2 = NSDate.currentCalendar().components(componentFlags, fromDate: aDate)
        if components1.weekOfYear != components2.weekOfYear {
            // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
            return false
        }
        // Must have a time interval under 1 week.
        return fabs(self.timeIntervalSinceDate(aDate)) < D_WEEK
    }

    func isThisWeek() -> Bool {
        return self.isSameWeekAsDate(NSDate())
    }

    func isNextWeek() -> Bool {
        let interval = NSDate().timeIntervalSinceReferenceDate + D_WEEK
        let date = NSDate(timeIntervalSinceReferenceDate: interval)
        return self.isSameWeekAsDate(date)
    }

    func isLastWeek() -> Bool {
        let interval = NSDate().timeIntervalSinceReferenceDate - D_WEEK
        let date = NSDate(timeIntervalSinceReferenceDate: interval)
        return self.isSameWeekAsDate(date)
    }

    func isSameMonthAsDate(aDate:NSDate) -> Bool {
        let components1 = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        let components2 = NSDate.currentCalendar().components(componentFlags, fromDate: aDate)
        return ((components1.year == components2.year) &&
            (components1.month == components2.month))
    }

    func isThisMonth() -> Bool {
        return self.isSameMonthAsDate(NSDate())
    }

    func isLastMonth() -> Bool {
        return self.isSameMonthAsDate(NSDate().dateBySubtractingMonths(1)!)
    }

    func isNextMonth() -> Bool {
        return self.isSameMonthAsDate(NSDate().dateByAddingMonths(1)!)
    }

    func isSameYearAsDate(aDate:NSDate) -> Bool {
        let components1 = NSDate.currentCalendar().components(componentFlags, fromDate: self)
        let components2 = NSDate.currentCalendar().components(componentFlags, fromDate: aDate)
        return (components1.year == components2.year)
    }

    func isThisYear() -> Bool {
        return self.isSameYearAsDate(NSDate())
    }

    func isLastYear() -> Bool {
        return self.isSameYearAsDate(NSDate().dateBySubtractingYears(1)!)
    }

    func isNextYear() -> Bool {
        return self.isSameYearAsDate(NSDate().dateByAddingYears(1)!)
    }

    func isEarlierThanDate(aDate:NSDate) -> Bool {
        return self.compare(aDate) == .OrderedAscending
    }

    func isLaterThanDate(aDate:NSDate) -> Bool {
        return self.compare(aDate) == .OrderedDescending
    }

    func isInFuture() -> Bool {
        return self.isLaterThanDate(NSDate())
    }

    func isInPast() -> Bool {
        return self.isEarlierThanDate(NSDate())
    }
}

//MARK:- Retrieving intervals
extension NSDate{

    func timeIntervalInMilliSecs() -> NSTimeInterval {
        return timeIntervalSince1970 * MILLI_SECOND
    }

    func minutesAfterDate(aDate:NSDate) -> Int {
        let interval = self.timeIntervalSinceDate(aDate)
        return Int(interval/D_MINUTE)
    }

    func minutesBeforeDate(aDate:NSDate) -> Int {
        let interval = self.timeIntervalSinceDate(aDate)
        return Int(interval/D_MINUTE)
    }

    func hoursAfterDate(aDate:NSDate) -> Int {
        let interval = self.timeIntervalSinceDate(aDate)
        return Int(interval/D_HOUR)
    }

    func hoursBeforeDate(aDate:NSDate) -> Int {
        let interval = self.timeIntervalSinceDate(aDate)
        return Int(interval/D_HOUR)
    }

    func daysAfterDate(aDate:NSDate) -> Int {
        let interval = self.timeIntervalSinceDate(aDate)
        return Int(interval/D_DAY)
    }

    func daysBeforeDate(aDate:NSDate) -> Int {
        let interval = self.timeIntervalSinceDate(aDate)
        return Int(interval/D_DAY)
    }

    func distanceInDaysToDate(aDate:NSDate) -> Int? {
        let calendar = NSCalendar(identifier:NSCalendarIdentifierGregorian)
        let components = calendar?.components(.Day, fromDate: self, toDate: aDate, options: .MatchStrictly)
        return components?.day
    }
}

//MARK:- Adjusting Dates

extension NSDate{

    func dateByAddingYears(dYears:Int) -> NSDate? {
        let components = NSDateComponents()
        components.year = dYears
        return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self, options: NSCalendarOptions(rawValue: 0))
    }

    func dateBySubtractingYears(dYears:Int) -> NSDate? {
        return dateByAddingYears(-dYears)
    }

    func dateByAddingMonths(dMonths:Int) -> NSDate? {
        let components = NSDateComponents()
        components.month = dMonths
        return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self, options: NSCalendarOptions(rawValue: 0))
    }

    func dateBySubtractingMonths(dMonths:Int) -> NSDate? {
        return dateByAddingMonths(-dMonths)
    }

    func dateByAddingDays(dDays:Int) -> NSDate? {
        let components = NSDateComponents()
        components.day = dDays
        return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self, options: NSCalendarOptions(rawValue: 0))
    }

    func dateBySubtractingDays(dDays:Int) -> NSDate? {
        return dateByAddingDays(-dDays)
    }

    func dateByAddingHours(dHours:Double) -> NSDate? {
        let interval = self.timeIntervalSinceReferenceDate + D_HOUR * dHours
        return NSDate(timeIntervalSinceReferenceDate: interval)
    }

    func dateBySubtractingHours(dHours:Double) -> NSDate? {
        return dateByAddingHours(-dHours)
    }

    func dateByAddingMinutes(dMinutes:Double) -> NSDate? {
        let interval = self.timeIntervalSinceReferenceDate + D_MINUTE * dMinutes
        return NSDate(timeIntervalSinceReferenceDate: interval)
    }

    func dateBySubtractingMinutes(dMinutes:Double) -> NSDate? {
        return dateByAddingMinutes(-dMinutes)
    }

    func componentsWithOffsetFromDate(aDate:NSDate) -> NSDateComponents {
        let component = NSDate.currentCalendar().components(componentFlags, fromDate: aDate, toDate: self, options: NSCalendarOptions(rawValue: 0))
        return component
    }
}


//MARK:- Relative Dates
extension NSDate{

    class func dateWithTimeIntervalInMilliSecs(interval:NSTimeInterval) -> NSDate {
        return NSDate(timeIntervalSince1970: interval/MILLI_SECOND)
    }
    class func dateWithDaysFromNow(days:Int) -> NSDate? {
        return NSDate().dateByAddingDays(days)
    }

    class func dateWithDaysBeforeNow(days:Int) -> NSDate? {
        return NSDate().dateBySubtractingDays(days)
    }

    class func dateTommorow() -> NSDate? {
        return NSDate.dateWithDaysFromNow(1)
    }
    
    class func dateYesterday() -> NSDate? {
        return NSDate.dateWithDaysBeforeNow(1)
    }
    
    class func dateWithHoursFromNow(days:Double) -> NSDate? {
        return NSDate().dateByAddingHours(days)
    }
    
    class func dateWithHoursBeforeNow(days:Double) -> NSDate? {
        return NSDate().dateBySubtractingHours(days)
    }
    
    class func dateWithMinutesFromNow(minutes:Double) -> NSDate? {
        return NSDate().dateByAddingMinutes(minutes)
    }
    
    class func dateWithMinutesBeforeNow(minutes:Double) -> NSDate? {
        return NSDate().dateBySubtractingMinutes(minutes)
    }
}
