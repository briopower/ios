//
//  PhasesListViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 20/03/17.
//  Copyright © 2017 Finoit Technologies. All rights reserved.
//

import UIKit
class PhaseListCell:UICollectionViewCell{
    //MARK:- Outlets
    @IBOutlet weak var txtLbel: UILabel!

    //MARK:- Additonal methods
    func configCell(model:PhasesModel) {
        txtLbel.text = model.phaseName
    }

}
class PhasesListViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    //MARK:- Variables
    var currentTemplate:TemplatesModel?
    var sourceType = TrackDetailsSourceType.Templates
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateTemplate()
        setNavigationBarWithTitle("Phases", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- UICollectionViewDataSource
extension PhasesListViewController:UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentTemplate?.phases.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(PhaseListCell), forIndexPath: indexPath) as? PhaseListCell, let phase = currentTemplate?.phases[indexPath.row] as? PhasesModel {
            cell.configCell(phase)
            return cell
        }
        return UICollectionViewCell()
    }

}

//MARK:- UICollectionViewDelegateFlowLayout
extension PhasesListViewController:UICollectionViewDelegateFlowLayout{

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let dimension = (UIDevice.width() - 30)/2
        return CGSize(width: dimension, height: dimension)
    }
}

//MARK:- UITableViewDelegate
extension PhasesListViewController:UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let phasesView = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.phasesView) as? PhasesViewController, let phase = currentTemplate?.phases[indexPath.row] as? PhasesModel {
            phasesView.currentPhase = phase
            phasesView.sourceType = sourceType
            getNavigationController()?.pushViewController(phasesView, animated: true)
        }
    }
}

//MARK:- Network methods
extension PhasesListViewController{

    func updateTemplate() {
        if NetworkClass.isConnected(true) {
            if let id = sourceType == .Templates ? currentTemplate?.templateId : currentTemplate?.trackId  {
                let url = sourceType == .Templates ? "\(Constants.URLs.templateDetails)\(id)" : "\(Constants.URLs.trackDetails)\(id)"
                NetworkClass.sendRequest(URL: url, RequestType: .GET, CompletionHandler: {
                    (status, responseObj, error, statusCode) in
                    if status{
                        self.processResponse(responseObj)
                    }else{
                        self.processError(error)
                    }
                })
            }
        }
    }

    func processResponse(responseObj:AnyObject?) {
        if let dict = responseObj, let temp = currentTemplate {
            switch sourceType {
            case .Templates:
                TemplatesModel.addPhases(dict, toModel: temp)
            case .Tracks:
                TemplatesModel.updateTrackObj(temp, dict: dict)
            default:
                break
            }
        }
        collectionView.reloadData()
    }

    func processError(error:NSError?) {
        UIView.showToast("Something went wrong", theme: Theme.Error)
    }
}

