//
//  SearchByIdHeader.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 04/01/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit
protocol SearchByIdHeaderDelegate:NSObjectProtocol {
    func searchTapped()
}
class SearchByIdHeader: UITableViewHeaderFooterView {

    //MARK:- Variables
    weak var delegate:SearchByIdHeaderDelegate?

    //MARK:- -------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func buttonAction(_ sender: AnyObject) {
        delegate?.searchTapped()
    }
}
