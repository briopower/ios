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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("General Disclosures/Waivers", LeftButtonType: BarButtontype.none, RightButtonType: BarButtontype.none)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate.getAppDelegateObject()?.removeLaunchScreen()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension WaiverViewController {
    func setUpTableView(){
        tblView.register(UINib(nibName: String(describing: TextViewTableViewCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: TextViewTableViewCell.self))
        tblView.register(UINib(nibName: String(describing: NextButtonCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: NextButtonCell.self))
    }
}

extension WaiverViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellsWaiverController.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellsWaiverController : CellsWaiverController = CellsWaiverController.init(rawValue: indexPath.row)!
        switch cellsWaiverController {
        case .textView:
            if let cell = tblView.dequeueReusableCell(withIdentifier: String(describing: TextViewTableViewCell.self)) as? TextViewTableViewCell{
                print(cell)
                return cell
                
            }
            break
        case .button:
            if let cell = tblView.dequeueReusableCell(withIdentifier: String(describing: NextButtonCell.self)) as? NextButtonCell{
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
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
        UserDefaults.setDisclaimerWatched(true)
        self.dismiss(animated: true, completion: nil);
    }
}
