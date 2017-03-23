//
//  TrackDetailsViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit

enum TrackSectionTypes:Int {
    case Phases, Resources, TeamMembers, About, Count
}

enum TemplateSectionTypes:Int {
    case About, Resources, Phases, Count
}

class TrackDetailsViewController: CommonViewController, UINavigationControllerDelegate {

    //MARK:- Outlets
    @IBOutlet weak var trackDetailsTblView: UITableView!
    @IBOutlet var ratingView: UIView!
    @IBOutlet weak var starRatingView: HCSStarRatingView!
    
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

//MARK:- Button Actions
extension TrackDetailsViewController{
    @IBAction func rateTaskAction(sender: AnyObject) {
        submitRating()
    }
    @IBAction func hideRatingAction(sender: AnyObject) {
        hideRatingView()
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

    func rateGroup() {
        showRatingView()
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
        trackDetailsTblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        createImageUploadUrl(false)
    }

    func updateHeader() {
        if let headerView = trackDetailsTblView.tableHeaderView as? TrackDetailsHeaderView {
            headerView.setupForType(sourceType, template: currentTemplate)
        }
    }

    func showRatingView() {
        if let view = getNavigationController()?.view {
            ratingView.alpha = 0
            ratingView.frame = view.frame
            ratingView.userInteractionEnabled = false

            starRatingView.value = CGFloat(currentTemplate?.rating ?? 0)
            view.addSubview(ratingView)
            UIView.animateWithDuration(0.3, animations: {
                self.ratingView.alpha = 1
                }, completion: { (completed:Bool) in
                    self.ratingView.userInteractionEnabled = true
            })
        }
    }

    func hideRatingView() {
        UIView.animateWithDuration(0.3, animations: {
            self.ratingView.alpha = 0
            self.ratingView.userInteractionEnabled = false
        }) { (completed:Bool) in
            self.ratingView.userInteractionEnabled = false
            self.ratingView.removeFromSuperview()
        }
    }
}

//MARK:- UITableViewDataSource
extension TrackDetailsViewController:UITableViewDataSource{

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if sourceType == .Templates {
            return TemplateSectionTypes.Count.rawValue
        }else{
            return TrackSectionTypes.Count.rawValue
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if let cell = trackDetailsTblView.dequeueReusableCellWithIdentifier(String(TrackFilesCell)) as? TrackFilesCell {
            switch sourceType {
            case .Templates:
                if let sectionType = TemplateSectionTypes(rawValue: indexPath.section) {
                    switch sectionType {
                    case .About, .Phases, .Resources:
                        cell.configCell(sectionType)
                        return cell
                    default:
                        break
                    }
                }
            case .Tracks:
                if let sectionType = TrackSectionTypes(rawValue: indexPath.section) {
                    switch sectionType {
                    case .About, .Phases, .Resources, .TeamMembers:
                        cell.configCell(sectionType)
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


        switch sourceType {
        case .Templates:
            if let sectionType = TemplateSectionTypes(rawValue: indexPath.section) {
                switch sectionType {
                case .Resources:
                    if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.filesListView) as? FilesListViewController {
                        viewCont.resources = currentTemplate?.resources ?? NSMutableArray()
                        getNavigationController()?.pushViewController(viewCont, animated: true)
                    }
                case .About:
                    if let showTextView = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.showTextView) as? ShowTextViewController {
                        showTextView.text = currentTemplate?.details ?? ""
                        showTextView.navigationTitle = currentTemplate?.name ?? ""
                        getNavigationController()?.pushViewController(showTextView, animated: true)
                    }
                case .Phases:
                    if let phasesView = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.phasesListView) as? PhasesListViewController {
                        phasesView.currentTemplate = currentTemplate
                        phasesView.sourceType = sourceType
                        getNavigationController()?.pushViewController(phasesView, animated: true)
                    }
                default:
                    break
                }
            }
        case .Tracks:
            if let sectionType = TrackSectionTypes(rawValue: indexPath.section) {
                switch sectionType {
                case .TeamMembers:
                    if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.trackMemberListView) as? TrackMemberListViewController{
                        viewCont.currentTemplate = currentTemplate
                        getNavigationController()?.pushViewController(viewCont, animated: true)
                    }
                case .Resources:
                    if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.filesListView) as? FilesListViewController {
                        viewCont.resources = currentTemplate?.resources ?? NSMutableArray()
                        getNavigationController()?.pushViewController(viewCont, animated: true)
                    }
                case .About:
                    if let showTextView = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.showTextView) as? ShowTextViewController {
                        showTextView.text = currentTemplate?.details ?? ""
                        showTextView.navigationTitle = currentTemplate?.name ?? ""
                        getNavigationController()?.pushViewController(showTextView, animated: true)
                    }
                case .Phases:
                    if let phasesView = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewControllerWithIdentifier(Constants.Storyboard.TracksStoryboard.phasesListView) as? PhasesListViewController {
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

//MARK:- Get Track Name methods
extension TrackDetailsViewController{
    func getTrackName() {
        alertController = UIAlertController.getAlertController(.Alert, Title: "Enter Group Name", Message: nil,OtherButtonTitles: ["Done"], CancelButtonTitle: "Cancel", completion: { (tappedAtIndex) in
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
        UIView.showToast("Something went wrong", theme: Theme.Error)
    }

    func submitRating() {
        if NetworkClass.isConnected(true), let key = currentTemplate?.key?.getValidObject(){
            showLoaderOnWindow()
            NetworkClass.sendRequest(URL: Constants.URLs.rating, RequestType: .POST, Parameters: TasksModel.getDictForRating(key, rating: starRatingView.value), Headers: nil, CompletionHandler: {
                (status, responseObj, error, statusCode) in
                self.hideLoader()
                if statusCode == 200{
                    self.updateRating(responseObj)
                }else{
                    self.processError(error)
                }
            })
        }
    }

    func updateRating(response:AnyObject?) {
        dispatch_async(dispatch_get_main_queue()) { 
            self.currentTemplate?.updateRating(response)
            self.updateHeader()
            self.hideRatingView()
        }
    }
}
