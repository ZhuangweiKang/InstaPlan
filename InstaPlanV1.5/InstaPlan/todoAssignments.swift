//
//  todoAssignments.swift
//  InstaPlan
//
//  Created by 康壮伟 on 5/6/17.
//  Copyright © 2017 Zhuangwei Kang. All rights reserved.
//

import UIKit

class todoAssignments: UITableViewCell {

    @IBOutlet weak var due_date: UILabel!
    
    @IBOutlet weak var color: UILabel!
    
    @IBOutlet weak var class_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
