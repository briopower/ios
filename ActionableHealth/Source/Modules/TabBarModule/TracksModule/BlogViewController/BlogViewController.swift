//
//  BlogViewController.swift
//  ActionableHealth
//
//  Created by Vaibhav Singla on 8/6/18.
//  Copyright © 2018 Finoit Technologies. All rights reserved.
//

import UIKit

class BlogViewController: CommonViewController {

    // MARK: - Outlets
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var commentButtonBgView: UIView!
    
    
    // MARK: - Variables
    
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarWithTitle("", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Button Actions
    @IBAction func viewCommentsButtonTapped(_ sender: UIButton) {
        print("Comments")
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.blogCommentListView) as? BlogCommentsViewController{
            // TODO pass necessary thing to next controller
            //viewCont.currentTemplate = currentTemplate
            self.getNavigationController()?.pushViewController(viewCont, animated: true)
        }
        
    }
    
}
