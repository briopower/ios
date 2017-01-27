//
//  TrackDetailsViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

enum TrackDetailsCellTypes:Int {
    case Details, Members, Files, Count
}
enum TrackDetailsSectionTypes:Int {
    case MemberFiles, InfoPhase, Count
}

class TrackDetailsViewController: CommonViewController, UINavigationControllerDelegate {

    //MARK:- Outlets
    @IBOutlet weak var trackDetailsTblView: UITableView!
    @IBOutlet var sectionHeaderView: UIView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var phaseButton: UIButton!

    //MARK:- Variables
    var currentTemplate:TemplatesModel?
    var isInfoSelected = false
    var sourceType = TrackDetailsSourceType.Home
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
            headerView.setupFrame()
            trackDetailsTblView.tableHeaderView = headerView
            headerView.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
//MARK:- Button Actions
extension TrackDetailsViewController{
    @IBAction func infoButtonAction(sender: UIButton) {
        if !isInfoSelected {
            setSelectedButton(true)
        }
    }
    @IBAction func sectionButtonActions(sender: UIButton) {
        if isInfoSelected {
            setSelectedButton(false)
        }
    }
}
//MARK:- TrackDetailsHeaderViewDelegate
extension TrackDetailsViewController:TrackDetailsHeaderViewDelegate{
    func commentsTapped(type: TrackDetailsSourceType) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.commentsView) as? CommentsViewController {
            dispatch_async(dispatch_get_main_queue(), {
                viewCont.delegate = self
                viewCont.commentSourceKey = self.currentTemplate?.key
                self.getNavigationController()?.pushViewController(viewCont, animated: true)
            })
        }
    }

    func requestButtonTapped(type: TrackDetailsSourceType) {
        switch type {
        case .Home:
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

extension TrackDetailsViewController:CommentsViewControllerDelegate{
    func updatedCommentCount(count: Int) {
        currentTemplate?.commentsCount = count
    }
}
//MARK:- Additional methods
extension TrackDetailsViewController{
    func setupView() {
        infoButtonAction(infoButton)
        if let headerView = TrackDetailsHeaderView.getView() {
            trackDetailsTblView.tableHeaderView = headerView
        }
        updateHeader()

        trackDetailsTblView.rowHeight = UITableViewAutomaticDimension

        trackDetailsTblView.registerNib(UINib(nibName: String(TrackInfoCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(TrackInfoCell))
        trackDetailsTblView.registerNib(UINib(nibName: String(TrackFilesCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(TrackFilesCell))
        trackDetailsTblView.registerNib(UINib(nibName: String(TrackPhasesCell), bundle: NSBundle.mainBundle()), forCellReuseIdentifier: String(TrackPhasesCell))
        createImageUploadUrl(false)
    }

    func updateHeader() {
        if let headerView = trackDetailsTblView.tableHeaderView as? TrackDetailsHeaderView {
            headerView.setupForType(sourceType, template: currentTemplate)
        }
    }

    func setSelectedButton(infoSelected:Bool) {
        infoButton.selected = infoSelected
        phaseButton.selected = !infoSelected
        isInfoSelected = infoSelected
        reloadData(true)
    }

    func getInfoCellForIndexPath(indexPath:NSIndexPath) -> UITableViewCell {
        if let type = TrackDetailsCellTypes(rawValue: indexPath.row) {
            switch type {
            case .Details:
                if let cell = trackDetailsTblView.dequeueReusableCellWithIdentifier(String(TrackInfoCell)) as? TrackInfoCell {
                    cell.configCell(currentTemplate)
                    return cell
                }
            default:
                break
            }
        }
        return UITableViewCell()
    }

    func getPhaseCellForIndexPath(indexPath:NSIndexPath) -> UITableViewCell {
        if let cell = trackDetailsTblView.dequeueReusableCellWithIdentifier(String(TrackPhasesCell)) as? TrackPhasesCell {
            if let phase = currentTemplate?.phases[indexPath.row] as? PhasesModel{
                cell.configCell(phase)
                cell.tag = indexPath.row
                cell.delegate = self
                return cell
            }
        }
        return UITableViewCell()
    }

    func infoCellSelectedAtIndexPath(type:TrackDetailsCellTypes) {
        switch type {
        case .Files:
            if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.trackFileView) as? TrackFilesViewController {
                viewCont.blobKey = currentTemplate?.blobKey
                viewCont.navigationTitle = sourceType == .Home ? "Template Files" : "Track Files"
                getNavigationController()?.pushViewController(viewCont, animated: true)
            }
        case .Members:
            if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.trackMemberListView) as? TrackMemberListViewController{
                viewCont.currentTemplate = currentTemplate
                getNavigationController()?.pushViewController(viewCont, animated: true)
            }
        default:
            break
        }
    }

    func phaseCellSelectedAtIndexPath(indexPath:NSIndexPath) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.phaseDetailsView) as? PhaseDetailsViewController {
            viewCont.currentPhase = currentTemplate?.phases[indexPath.row] as? PhasesModel
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }
    }

    func reloadData(shouldScrollToTop:Bool) {
        trackDetailsTblView.reloadData()
        updateHeader()

        if shouldScrollToTop {
            trackDetailsTblView.scrollToRowAtIndexPath(NSIndexPath(forRow: NSNotFound, inSection: 1), atScrollPosition: .Top, animated: false)
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
                switch sourceType {
                case .Tracks:
                    return currentTemplate?.blobKey == nil ?  TrackDetailsCellTypes.Members.rawValue : TrackDetailsCellTypes.Files.rawValue
                case .Home:
                    return currentTemplate?.blobKey == nil ? TrackDetailsCellTypes.Details.rawValue : TrackDetailsCellTypes.Members.rawValue
                default:
                    break
                }
            case .InfoPhase:
                if isInfoSelected {
                    return TrackDetailsCellTypes.Members.rawValue
                }
                return currentTemplate?.phases.count ?? 0
            default:
                break
            }
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if let sectionType = TrackDetailsSectionTypes(rawValue: indexPath.section) {
            switch sectionType {
            case .MemberFiles:
                if let cell = tableView.dequeueReusableCellWithIdentifier(String(TrackFilesCell)) as? TrackFilesCell {
                    switch sourceType {
                    case .Home:
                        cell.configCell(TrackDetailsCellTypes.Files, sourceType: sourceType)
                    default:
                        cell.configCell(indexPath.row == 0 ? TrackDetailsCellTypes.Members : TrackDetailsCellTypes.Files, sourceType: sourceType)
                    }
                    return cell
                }
            case .InfoPhase:
                if isInfoSelected {
                    return getInfoCellForIndexPath(indexPath)
                }else{
                    return getPhaseCellForIndexPath(indexPath)
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
                switch sourceType {
                case .Home:
                    infoCellSelectedAtIndexPath(TrackDetailsCellTypes.Files)
                default:
                    infoCellSelectedAtIndexPath(indexPath.row == 0 ? TrackDetailsCellTypes.Members : TrackDetailsCellTypes.Files)
                }
            case .InfoPhase:
                if !isInfoSelected {
                    phaseCellSelectedAtIndexPath(indexPath)
                }
            default:
                break
            }
        }
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        return sectionHeaderView
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let sectionType = TrackDetailsSectionTypes(rawValue: section) {
            switch sectionType {
            case .InfoPhase:
                return 44
            default:
                break
            }
        }
        return 0
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let sectionType = TrackDetailsSectionTypes(rawValue: indexPath.section) {
            switch sectionType {
            case .InfoPhase:
                if isInfoSelected {
                    return CGFloat(currentTemplate?.details.getHeight(UIFont.getAppRegularFontWithSize(17)?.getDynamicSizeFont(), maxWidth: Double(UIDevice.width())) ?? 300)
                }
            default:
                break
            }
        }
        return 300
    }
}

//MARK:- Get Track Name methods
extension TrackDetailsViewController{
    func getTrackName() {
        alertController = UIAlertController.getAlertController(.Alert, Title: "Enter Track Name", Message: nil,OtherButtonTitles: ["Done"], CancelButtonTitle: "Cancel", completion: { (tappedAtIndex) in
            if tappedAtIndex == 0{
                if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.inviteTracksView) as? InviteForTrackViewController {
                    viewCont.sourceType = .Home
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

//MARK:- TrackPhasesCellDelegate
extension TrackDetailsViewController:TrackPhasesCellDelegate{
    func readMoreTapped(tag: Int, obj: AnyObject?) {
        if let task = obj as? PhasesModel {
            if let showTextView = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.showTextView) as? ShowTextViewController {
                showTextView.text = task.details
                showTextView.navigationTitle = task.phaseName
                getNavigationController()?.pushViewController(showTextView, animated: true)
            }
        }
    }

    func taskFilesTapped(tag: Int, obj: AnyObject?) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.trackFileView) as? TrackFilesViewController, let blobKey = (obj as? PhasesModel)?.blobKey {
            viewCont.blobKey = blobKey
            viewCont.navigationTitle = "Phase Files"
            getNavigationController()?.pushViewController(viewCont, animated: true)
        }else{
            UIView.showToast("No Files Found.", theme: Theme.Warning)
        }
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
            if let id = sourceType == .Home ? currentTemplate?.templateId : currentTemplate?.trackId  {
                let url = sourceType == .Home ? "\(Constants.URLs.templateDetails)\(id)" : "\(Constants.URLs.trackDetails)\(id)"
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
            case .Home:
                TemplatesModel.updateTemplateObj(temp, dict: dict)
            case .Tracks:
                TemplatesModel.updateTrackObj(temp, dict: dict)
            default:
                break
            }
            reloadData(false)
        }
        
    }
    
    func processError(error:NSError?) {
        
    }
}
