//
//  WaiverViewController.swift
//  ActionableHealth
//
//  Created by Abhishek Sharma on 30/06/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit

enum CellsWaiverController : Int{
    case textView = 0
    case button
    case count
}

class WaiverViewController: CommonViewController {

    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        self.showLoginModule = false;
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("General Disclosures/Waivers", LeftButtonType: BarButtontype.None, RightButtonType: BarButtontype.None)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension WaiverViewController {
    func setUpTableView(){
        tblView.registerNib(UINib(nibName: String(TextViewTableViewCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(TextViewTableViewCell))
        tblView.registerNib(UINib(nibName: String(NextButtonCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(NextButtonCell))
    }
}

extension WaiverViewController : UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellsWaiverController.count.rawValue
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellsWaiverController : CellsWaiverController = CellsWaiverController.init(rawValue: indexPath.row)!
        switch cellsWaiverController {
        case .textView:
            if let cell = tblView.dequeueReusableCellWithIdentifier(String(TextViewTableViewCell)) as? TextViewTableViewCell{
                print(cell)
                return cell
                
            }
            break
        case .button:
            if let cell = tblView.dequeueReusableCellWithIdentifier(String(NextButtonCell)) as? NextButtonCell{
                cell.setButtonTitle("OK");
                cell.delegate = self
                return cell
            }
            break
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
}

extension WaiverViewController : UITableViewDelegate{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellsWaiverController : CellsWaiverController = CellsWaiverController.init(rawValue: indexPath.row)!
        switch cellsWaiverController {
        case .textView:
            return 560
        
        default:
            return 100
        }
    }
    
}

extension WaiverViewController : NextButtonCellDelegate{
    func nextButtonClicked() {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}
