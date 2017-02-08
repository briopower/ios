//
//  TrackDetailsViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

enum TrackDetailsMemberFilesCellTypes:Int {
    case Members, Files, Count
}

enum TrackDetailsAboutPhaseCellTypes:Int {
    case About, Phases, Count
}

enum TrackDetailsSectionTypes:Int {
    case MemberFiles, AboutPhase, Count
}

class TrackDetailsViewController: CommonViewController, UINavigationControllerDelegate {

    //MARK:- Outlets
    @IBOutlet weak var trackDetailsTblView: UITableView!

    //MARK:- Variables
    var currentTemplate:TemplatesModel?
    var sourceType = TrackDetailsSourceType.Templates
    var alertController:UIAlertController?
    var trackName:String?
    var imageUploadURL:String?
    var selectedImage:UIImage?

    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateHeader()
        updateTemplate()
        setNavigationBarWithTitle(currentTemplate?.name ?? "Details", LeftButtonType: BarButtontype.Back, RightButtonType: BarButtontype.None)

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let headerView = trackDetailsTblView.tableHeaderView as? TrackDetailsHeaderView {
            headerView.setupFrame(sourceType)
            trackDetailsTblView.tableHeaderView = headerView
            headerView.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- TrackDetailsHeaderViewDelegate
extension TrackDetailsViewController:TrackDetailsHeaderViewDelegate{
    func commentsTapped(type: TrackDetailsSourceType) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.commentsView) as? CommentsViewController, let key = self.currentTemplate?.key {
            dispatch_async(dispatch_get_main_queue(), {
                viewCont.delegate = self
                viewCont.commentSourceKey = key
                self.getNavigationController()?.pushViewController(viewCont, animated: true)
            })
        }
    }

    func requestButtonTapped(type: TrackDetailsSourceType) {
        switch type {
        case .Templates:
            getTrackName()
        case .Tracks:
            if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.inviteTracksView) as? InviteForTrackViewController {
                viewCont.sourceType = .Tracks
                viewCont.currentTemplate = currentTemplate
                getNavigationController()?.pushViewController(viewCont, animated: true)
            }
        default:
            break
        }

    }
    func showImagePicker() {
        UIImagePickerController.showPickerWithDelegate(self)
    }
}

//MARK:- CommentsViewControllerDelegate
extension TrackDetailsViewController:CommentsViewControllerDelegate{
    func updatedCommentCount(count: Int) {
        currentTemplate?.commentsCount = count
    }
}

//MARK:- Additional methods
extension TrackDetailsViewController{
    func setupView() {
        if let headerView = TrackDetailsHeaderView.getView(sourceType) {
            trackDetailsTblView.tableHeaderView = headerView
        }

        trackDetailsTblView.rowHeight = UITableViewAutomaticDimension
        trackDetailsTblView.estimatedRowHeight = 80
        trackDetailsTblView.registerNib(UINib(nibName: String(TrackFilesCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(TrackFilesCell))
        createImageUploadUrl(false)
    }

    func updateHeader() {
        if let headerView = trackDetailsTblView.tableHeaderView as? TrackDetailsHeaderView {
            headerView.setupForType(sourceType, template: currentTemplate)
        }
    }
}

//MARK:- UITableViewDataSource
extension TrackDetailsViewController:UITableViewDataSource{

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TrackDetailsSectionTypes.Count.rawValue
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let sectionType = TrackDetailsSectionTypes(rawValue: section) {
            switch sectionType {
            case .MemberFiles:
                var numberOfCells = 0
                if sourceType == .Tracks {
                    numberOfCells += 1
                }
                if currentTemplate?.blobKey != nil {
                    numberOfCells += 1
                }
                return numberOfCells
            case .AboutPhase:
                return TrackDetailsAboutPhaseCellTypes.Count.rawValue
            default:
                break
            }
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if let sectionType = TrackDetailsSectionTypes(rawValue: indexPath.section), let cell = trackDetailsTblView.dequeueReusableCellWithIdentifier(String(TrackFilesCell)) as? TrackFilesCell {
            switch sectionType {
            case .MemberFiles:
                switch sourceType {
                case .Tracks:
                    if let cellType = TrackDetailsMemberFilesCellTypes(rawValue: indexPath.row) {
                        switch cellType {
                        case .Members, .Files:
                            cell.configCell(cellType)
                            return cell
                        default:
                            break
                        }
                    }
                default:
                    cell.configCell(TrackDetailsMemberFilesCellTypes.Files)
                    return cell
                }
            case .AboutPhase:
                if let cellType = TrackDetailsAboutPhaseCellTypes(rawValue: indexPath.row) {
                    switch cellType {
                    case .About, .Phases:
                        cell.configCell(cellType)
                        return cell
                    default:
                        break
                    }
                }
            default:
                break
            }
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension TrackDetailsViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let sectionType = TrackDetailsSectionTypes(rawValue: indexPath.section) {
            switch sectionType {
            case .MemberFiles:
                if let cellType = TrackDetailsMemberFilesCellTypes(rawValue: indexPath.row) {
                    switch sourceType {
                    case .Tracks:
                        switch cellType {
                        case .Members:
                            if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.trackMemberListView) as? TrackMemberListViewController{
                                viewCont.currentTemplate = currentTemplate
                                getNavigationController()?.pushViewController(viewCont, animated: true)
                            }
                        case .Files:
                            if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.trackFileView) as? TrackFilesViewController {
                                viewCont.blobKey = currentTemplate?.blobKey
                                viewCont.navigationTitle = "Track Files"
                                getNavigationController()?.pushViewController(viewCont, animated: true)
                            }
                        default:
                            break
                        }
                    default:
                        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.trackFileView) as? TrackFilesViewController {
                            viewCont.blobKey = currentTemplate?.blobKey
                            viewCont.navigationTitle = "Track Files"
                            getNavigationController()?.pushViewController(viewCont, animated: true)
                        }
                    }

                }
            case .AboutPhase:
                if let cellType = TrackDetailsAboutPhaseCellTypes(rawValue: indexPath.row) {
                    switch cellType {
                    case .About:
                        if let showTextView = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.showTextView) as? ShowTextViewController {
                            showTextView.text = currentTemplate?.details ?? ""
                            showTextView.navigationTitle = currentTemplate?.name ?? ""
                            getNavigationController()?.pushViewController(showTextView, animated: true)
                        }
                    case .Phases:
                        if let phasesView = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.phasesView) as? PhasesViewController {
                            phasesView.currentTemplate = currentTemplate
                            phasesView.sourceType = sourceType
                            getNavigationController()?.pushViewController(phasesView, animated: true)
                        }
                    default:
                        break
                    }
                }
            default:
                break
            }
        }
    }
}

//MARK:- Get Track Name methods
extension TrackDetailsViewController{
    func getTrackName() {
        alertController = UIAlertController.getAlertController(.Alert, Title: "Enter Track Name", Message: nil,OtherButtonTitles: ["Done"], CancelButtonTitle: "Cancel", completion: { (tappedAtIndex) in
            if tappedAtIndex == 0{
                if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.inviteTracksView) as? InviteForTrackViewController {
                    viewCont.sourceType = .Templates
                    viewCont.currentTemplate = self.currentTemplate
                    viewCont.trackName = self.trackName
                    self.getNavigationController()?.pushViewController(viewCont, animated: true)
                }
            }
        })

        alertController?.addTextFieldWithConfigurationHandler({ (textField:UITextField) in
            textField.placeholder = "Name"
            textField.text = nil
            textField.font = UIFont.getAppRegularFontWithSize(16)?.getDynamicSizeFont()
            textField.addTarget(self, action: #selector(TrackDetailsViewController.textDidChange(_:)), forControlEvents: .EditingChanged)
        })

        UIViewController.getTopMostViewController()?.presentViewController(alertController!, animated: true, completion: nil)

        alertController?.view.tintColor = UIColor.getAppThemeColor()
        alertController?.actions[0].enabled = false

    }

    func textDidChange(textField:UITextField) {
        trackName = textField.text?.getValidObject()
        alertController?.actions[0].enabled = !(trackName?.isEmpty ?? true)
    }
}

//MARK:- UIImagePickerControllerDelegate
extension TrackDetailsViewController:UIImagePickerControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.selectedImage = image
            self.uploadImage()
        }
        imagePickerControllerDidCancel(picker)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK:- Network methods
extension TrackDetailsViewController{
    func uploadImage() {
        if NetworkClass.isConnected(true) {
            if let url = imageUploadURL{
                if let image = selectedImage {
                    showProgressLoader()
                    NetworkClass.sendImageRequest(URL: url, RequestType: .POST, ResponseType: .NONE, ImageData: UIImagePNGRepresentation(image), ProgressHandler: { (totalBytesSent, totalBytesExpectedToSend) in

                        let progress = CGFloat(totalBytesSent)/CGFloat(totalBytesExpectedToSend)
                        self.loader?.progress = progress

                        }, CompletionHandler: { (status, responseObj, error, statusCode) in
                            if status{
                                self.loader?.progress = 1
                                self.updateTemplate()
                            }
                            self.hideLoader()
                    })
                }
            }else{
                createImageUploadUrl(true)
            }
        }
    }

    func createImageUploadUrl(shouldUploadImage:Bool = true){
        if NetworkClass.isConnected(true) {
            NetworkClass.sendRequest(URL: "\(Constants.URLs.createTrackUploadURL)\(currentTemplate?.trackId ?? "")", RequestType: .GET, ResponseType: .STRING,CompletionHandler: { (status, responseObj, error, statusCode) in
                if let str = responseObj as? String{
                    self.imageUploadURL = str
                    if shouldUploadImage{
                        self.uploadImage()
                    }
                }
            })
        }
    }


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
        updateHeader()
    }
    
    func processError(error:NSError?) {
        UIView.showToast(error?.localizedDescription ?? "", theme: Theme.Error)
    }
}
