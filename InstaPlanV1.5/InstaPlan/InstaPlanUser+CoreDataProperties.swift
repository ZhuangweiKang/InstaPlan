//
//  InstaPlanUser+CoreDataProperties.swift
//  InstaPlan
//
//  Created by 康壮伟 on 4/28/17.
//  Copyright © 2017 Zhuangwei Kang. All rights reserved.
//

import Foundation
import CoreData


extension InstaPlanUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InstaPlanUser> {
        return NSFetchRequest<InstaPlanUser>(entityName: "InstaPlanUser")
    }

    @NSManaged public var email_address: String?
    @NSManaged public var login_status: Bool
    @NSManaged public var password: String?
    @NSManaged public var user_name: String?
    @NSManaged public var assignment: NSSet?
    @NSManaged public var course: NSSet?
    @NSManaged public var custom_notes: NSSet?

}

// MARK: Generated accessors for assignment
extension InstaPlanUser {

    @objc(addAssignmentObject:)
    @NSManaged public func addToAssignment(_ value: Assignment)

    @objc(removeAssignmentObject:)
    @NSManaged public func removeFromAssignment(_ value: Assignment)

    @objc(addAssignment:)
    @NSManaged public func addToAssignment(_ values: NSSet)

    @objc(removeAssignment:)
    @NSManaged public func removeFromAssignment(_ values: NSSet)

}

// MARK: Generated accessors for course
extension InstaPlanUser {

    @objc(addCourseObject:)
    @NSManaged public func addToCourse(_ value: Course)

    @objc(removeCourseObject:)
    @NSManaged public func removeFromCourse(_ value: Course)

    @objc(addCourse:)
    @NSManaged public func addToCourse(_ values: NSSet)

    @objc(removeCourse:)
    @NSManaged public func removeFromCourse(_ values: NSSet)

}

// MARK: Generated accessors for custom_notes
extension InstaPlanUser {

    @objc(addCustom_notesObject:)
    @NSManaged public func addToCustom_notes(_ value: CustomNotes)

    @objc(removeCustom_notesObject:)
    @NSManaged public func removeFromCustom_notes(_ value: CustomNotes)

    @objc(addCustom_notes:)
    @NSManaged public func addToCustom_notes(_ values: NSSet)

    @objc(removeCustom_notes:)
    @NSManaged public func removeFromCustom_notes(_ values: NSSet)

}
