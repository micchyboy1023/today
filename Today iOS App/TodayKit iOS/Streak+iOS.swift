//
//  Streak+iOS.swift
//  Today
//
//  Created by UetaMasamichi on 4/19/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import CoreData

extension Streak {
    public static func insertIntoContext(moc: NSManagedObjectContext, from: NSDate, to: NSDate) -> Streak {
        let streak: Streak = moc.insertObject()
        streak.from = from
        streak.to = to
        return streak
    }
    
    public static func currentStreak(moc: NSManagedObjectContext) -> Streak? {
        let streaks = Streak.fetchInContext(moc, configurationBlock: {
            request in
            request.sortDescriptors = Streak.defaultSortDescriptors
        })
        
        if streaks.count == 0 {
            return nil
        }
        
        if NSCalendar.currentCalendar().isDateInYesterday(streaks[0].to) ||  NSCalendar.currentCalendar().isDateInToday(streaks[0].to) {
            return streaks[0]
        }
        
        return nil
    }
    
    public static func longestStreak(moc: NSManagedObjectContext) -> Streak? {
        let streaks = Streak.fetchInContext(moc, configurationBlock: {
            request in
            let numberSortDescriptor = NSSortDescriptor(key: "streakNumber", ascending: false)
            let toSortDescriptor = NSSortDescriptor(key: "to", ascending: false)
            request.sortDescriptors = [numberSortDescriptor, toSortDescriptor]
        })
        
        if streaks.count == 0 {
            return nil
        }
        
        return streaks[0]
    }
    
    public static func deleteDateFromStreak(moc: NSManagedObjectContext, date: NSDate) {
        
        let comp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: date)
        let nextDateComp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: date)
        let previousDateComp = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: date)
        nextDateComp.day = nextDateComp.day + 1
        previousDateComp.day = previousDateComp.day - 1
        guard let noTimeDate = NSCalendar.currentCalendar().dateFromComponents(comp),
            let nextDate = NSCalendar.currentCalendar().dateFromComponents(nextDateComp),
            let previousDate = NSCalendar.currentCalendar().dateFromComponents(previousDateComp) else {
                fatalError("Wrong component")
        }
        
        if let targetStreak = Streak.findOrFetchInContext(moc, matchingPredicate: NSPredicate(format: "from <= %@ AND to >= %@", noTimeDate, noTimeDate)) {
            
            //delete streak when from and to equal
            if NSCalendar.currentCalendar().isDate(targetStreak.from, inSameDayAsDate: targetStreak.to) {
                moc.deleteObject(targetStreak)
                return
            }
            
            //update from when date equals to nextDate
            if NSCalendar.currentCalendar().isDate(targetStreak.from, inSameDayAsDate: date) {
                targetStreak.from = nextDate
                return
            }
            
            //update to when date equals to previousDate
            if NSCalendar.currentCalendar().isDate(targetStreak.to, inSameDayAsDate: date) {
                
                targetStreak.to = previousDate
                return
            }
            
            //separate streak into two new streak
            // | from - previousDate | | nextDate - to |
            Streak.insertIntoContext(moc, from: nextDate, to: targetStreak.to)
            targetStreak.to = previousDate
            
        }
    }
    
    public static func updateOrCreateCurrentStreak(moc: NSManagedObjectContext, date: NSDate) -> Streak {
        //Update current streak or create a new streak
        if let currentStreak = Streak.currentStreak(moc) {
            currentStreak.to = date
            return currentStreak
        } else {
            let newCurrentStreak = Streak.insertIntoContext(moc, from: date, to: date)
            return newCurrentStreak
        }
    }
}