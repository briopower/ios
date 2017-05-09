//
//  FilesCell.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 13/02/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit

class FilesCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var fileNameLabel: UILabel!

    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


//MARK:- Additional Methods
extension FilesCell{
    func configCell(obj:Resources) {
        let fileNameSeperated = obj.fileName?.componentsSeparatedByString(".")
        var fileName = ""
        if let fileWords = fileNameSeperated{
            for (index, element) in fileWords.enumerate() {
                if index != fileWords.count - 1{
                    fileName = fileName + element
                }
                
            }
        }
        
        
        fileNameLabel.text = fileName
    }
}
