//
//  CustomNotesCell.swift
//  InstaPlan
//
//  Created by 康壮伟 on 4/29/17.
//  Copyright © 2017 Zhuangwei Kang. All rights reserved.
//

import UIKit

class CustomNotesCell: UITableViewCell {

    @IBOutlet weak var note_name: UILabel!

    @IBOutlet weak var custom_note: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
