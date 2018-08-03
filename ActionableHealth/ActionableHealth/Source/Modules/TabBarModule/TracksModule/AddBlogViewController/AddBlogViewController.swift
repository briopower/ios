//
//  AddBlogViewController.swift
//  ActionableHealth
//
//  Created by Vaibhav Singla on 8/3/18.
//  Copyright © 2018 Finoit Technologies. All rights reserved.
//

import UIKit

class AddBlogViewController: CommonViewController {

    // MARK: - Outlets
    
    
    // MARK: - variables
    
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarWithTitle("New Blog", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
        
        let saveBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "tick").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(saveBarButtonTapped))
        getNavigationItem()?.rightBarButtonItem = saveBarButton
    }
    
    
    // MARK: - BarButtonActions
    
    @objc func saveBarButtonTapped(){
        // TODO call post api to save the blog
        print("saved")
        getNavigationController()?.popViewController(animated: true)
    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}





