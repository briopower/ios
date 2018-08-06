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
    func configCell(_ model:PhasesModel) {
        txtLbel.text = model.phaseName
    }

}
class PhasesListViewController: CommonViewController {

    //MARK:- Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    //MARK:- Variables
    var currentTemplate:TemplatesModel?
    var sourceType = TrackDetailsSourceType.templates
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTemplate()
        setNavigationBarWithTitle("Getting Started", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- UICollectionViewDataSource
extension PhasesListViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentTemplate?.phases.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhaseListCell.self), for: indexPath) as? PhaseListCell, let phase = currentTemplate?.phases[indexPath.row] as? PhasesModel {
            cell.configCell(phase)
            return cell
        }
        return UICollectionViewCell()
    }

}

//MARK:- UICollectionViewDelegateFlowLayout
extension PhasesListViewController:UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = (UIDevice.width() - 30)/2
        return CGSize(width: dimension, height: dimension)
    }
}

//MARK:- UITableViewDelegate
extension PhasesListViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let phasesView = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.phasesView) as? PhasesViewController, let phase = currentTemplate?.phases[indexPath.row] as? PhasesModel {
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
            if let id = sourceType == .templates ? currentTemplate?.templateId : currentTemplate?.trackId  {
                let url = sourceType == .templates ? "\(Constants.URLs.templateDetails)\(id)" : "\(Constants.URLs.trackDetails)\(id)"
                NetworkClass.sendRequest(URL: url, RequestType: .get, CompletionHandler: {
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

    func processResponse(_ responseObj:AnyObject?) {
        if let dict = responseObj, let temp = currentTemplate {
            switch sourceType {
            case .templates:
                TemplatesModel.addPhases(dict, toModel: temp)
            case .tracks:
                TemplatesModel.updateTrackObj(temp, dict: dict)
            default:
                break
            }
        }
        collectionView.reloadData()
    }

    func processError(_ error:NSError?) {
        UIView.showToast("Something went wrong", theme: Theme.error)
    }
}

