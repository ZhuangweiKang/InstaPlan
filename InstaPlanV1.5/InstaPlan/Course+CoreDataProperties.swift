//
//  Course+CoreDataProperties.swift
//  InstaPlan
//
//  Created by 康壮伟 on 4/28/17.
//  Copyright © 2017 Zhuangwei Kang. All rights reserved.
//

import Foundation
import CoreData


extension Course {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged public var aditional_info: String?
    @NSManaged public var class_color: String?
    @NSManaged public var class_day: String?
    @NSManaged public var class_end_date: NSDate?
    @NSManaged public var class_name: String?
    @NSManaged public var class_time: String?
    @NSManaged public var instructor_ta_info: String?
    @NSManaged public var user: InstaPlanUser?

}
