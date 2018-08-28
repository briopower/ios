//
//  TrackDetailsViewController.swift
//  ActionableHealth
//
//  Created by Vidhan Nandi on 19/10/16.
//  Copyright © 2016 Finoit Technologies. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


enum TrackSectionTypes:Int {
    case phases, resources, teamMembers, blogs, journals, about, count
}

enum TemplateSectionTypes:Int {
    case about, resources, phases, count
}

class TrackDetailsViewController: CommonViewController, UINavigationControllerDelegate {

    //MARK:- Outlets
    @IBOutlet weak var trackDetailsTblView: UITableView!
    @IBOutlet var ratingView: UIView!
    @IBOutlet weak var starRatingView: HCSStarRatingView!
    
    //MARK:- Variables
    var currentTemplate:TemplatesModel?
    var sourceType = TrackDetailsSourceType.templates
    var alertController:UIAlertController?
    var trackName:String?
    var imageUploadURL:String?
    var selectedImage:UIImage?

    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHeader()
        updateTemplate()
        setNavigationBarWithTitle(currentTemplate?.name ?? "Details", LeftButtonType: BarButtontype.back, RightButtonType: BarButtontype.none)
        if sourceType == .tracks{
            let deleteButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "delete"), style: .plain, target: self, action: #selector(deleteButtonTapped))
            getNavigationItem()?.rightBarButtonItem = deleteButton
        }

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

//MARK:- Bar Button Actions
extension TrackDetailsViewController{
    @objc func deleteButtonTapped(){
        print("delete tapped")
        showLoader()
        guard let trackID = self.currentTemplate?.trackId else{
            // this means there is no track id
            hideLoader()
            UIView.showToast("Something went wrong", theme: Theme.error)
            return
        }
        //let parameter = ["trackId":trackID]
        print(trackID)
        print(Constants.URLs.deleteTrack+"\(trackID)")
        NetworkClass.sendRequest(URL: Constants.URLs.deleteTrack+"\(trackID)", RequestType: .get, ResponseType: ExpectedResponseType.json, Parameters: nil, Headers: nil) { (status: Bool, responseObj, error :NSError?, statusCode: Int?) in
            
            self.hideLoader()
            if let code = statusCode{
                print(String(code))
            }
        }
        
    }
}

//MARK:- Button Actions
extension TrackDetailsViewController{
    @IBAction func rateTaskAction(_ sender: AnyObject) {
        submitRating()
    }
    @IBAction func hideRatingAction(_ sender: AnyObject) {
        hideRatingView()
    }
}
//MARK:- TrackDetailsHeaderViewDelegate
extension TrackDetailsViewController:TrackDetailsHeaderViewDelegate{
    func commentsTapped(_ type: TrackDetailsSourceType) {
        if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.commentsView) as? CommentsViewController, let key = self.currentTemplate?.key {
            DispatchQueue.main.async(execute: {
                viewCont.delegate = self
                viewCont.commentSourceKey = key
                self.getNavigationController()?.pushViewController(viewCont, animated: true)
            })
        }
    }

    func requestButtonTapped(_ type: TrackDetailsSourceType) {
        switch type {
        case .templates:
            getTrackName()
        case .tracks:
            if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.inviteTracksView) as? InviteForTrackViewController {
                viewCont.sourceType = .tracks
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
    func updatedCommentCount(_ count: Int) {
        currentTemplate?.commentsCount = count
    }
}

//MARK:- Additional methods
extension TrackDetailsViewController{
    func setupView() {
        if let headerView = TrackDetailsHeaderView.getView(sourceType) {
            trackDetailsTblView.tableHeaderView = headerView
        }

//        trackDetailsTblView.rowHeight = UITableViewAutomaticDimension
        trackDetailsTblView.estimatedRowHeight = 80
        trackDetailsTblView.register(UINib(nibName: String(describing: TrackFilesCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: TrackFilesCell.self))
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
            ratingView.isUserInteractionEnabled = false

            starRatingView.value = CGFloat(currentTemplate?.rating ?? 0)
            view.addSubview(ratingView)
            UIView.animate(withDuration: 0.3, animations: {
                self.ratingView.alpha = 1
                }, completion: { (completed:Bool) in
                    self.ratingView.isUserInteractionEnabled = true
            })
        }
    }

    func hideRatingView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.ratingView.alpha = 0
            self.ratingView.isUserInteractionEnabled = false
        }, completion: { (completed:Bool) in
            self.ratingView.isUserInteractionEnabled = false
            self.ratingView.removeFromSuperview()
        }) 
    }
}

//MARK:- UITableViewDataSource
extension TrackDetailsViewController:UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        if sourceType == .templates {
            return TemplateSectionTypes.count.rawValue
        }else{
            return TrackSectionTypes.count.rawValue
            
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let cell = trackDetailsTblView.dequeueReusableCell(withIdentifier: String(describing: TrackFilesCell.self)) as? TrackFilesCell {
            switch sourceType {
            case .templates:
                if let sectionType = TemplateSectionTypes(rawValue: indexPath.section) {
                    switch sectionType {
                    case .about, .phases, .resources:
                        cell.configCell(sectionType)
                        return cell
                    default:
                        break
                    }
                }
            case .tracks:
                if let sectionType = TrackSectionTypes(rawValue: indexPath.section) {
                    switch sectionType {
                    case .about, .phases, .resources, .teamMembers, .blogs , .journals:
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        switch sourceType {
        case .templates:
            if let sectionType = TemplateSectionTypes(rawValue: indexPath.section) {
                switch sectionType {
                case .resources:
                    if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.filesListView) as? FilesListViewController {
                        viewCont.resources = currentTemplate?.resources ?? NSMutableArray()
                        getNavigationController()?.pushViewController(viewCont, animated: true)
                    }
                case .about:
                    if let showTextView = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.showTextView) as? ShowTextViewController {
                        showTextView.html = currentTemplate?.htmldetails
                        showTextView.navigationTitle = currentTemplate?.name ?? ""
                        getNavigationController()?.pushViewController(showTextView, animated: true)
                    }
                case .phases:
                    if let phasesView = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.phasesListView) as? PhasesListViewController {
                        phasesView.currentTemplate = currentTemplate
                        phasesView.sourceType = sourceType
                        getNavigationController()?.pushViewController(phasesView, animated: true)
                    }
                default:
                    break
                }
            }
        case .tracks:
            if let sectionType = TrackSectionTypes(rawValue: indexPath.section) {
                switch sectionType {
                case .teamMembers:
                    if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.trackMemberListView) as? TrackMemberListViewController{
                        viewCont.currentTemplate = currentTemplate
                        getNavigationController()?.pushViewController(viewCont, animated: true)
                    }
                case .resources:
                    if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.filesListView) as? FilesListViewController {
                        viewCont.resources = currentTemplate?.resources ?? NSMutableArray()
                        getNavigationController()?.pushViewController(viewCont, animated: true)
                    }
                case .about:
                    if let showTextView = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.showTextView) as? ShowTextViewController {
                        showTextView.html = currentTemplate?.htmldetails
                        showTextView.navigationTitle = currentTemplate?.name ?? ""
                        getNavigationController()?.pushViewController(showTextView, animated: true)
                    }
                case .phases:
                    if let phasesView = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.phasesListView) as? PhasesListViewController {
                        phasesView.currentTemplate = currentTemplate
                        phasesView.sourceType = sourceType
                        getNavigationController()?.pushViewController(phasesView, animated: true)
                    }
                case .blogs:
                    if let blogView = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.blogsListView) as? BlogsListViewController {
                        blogView.currentTemplate = currentTemplate
                        blogView.sourceType = sourceType
                        getNavigationController()?.pushViewController(blogView, animated: true)
                    }
                case .journals:
                    if let blogView = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.journalListView) as? JournalListViewController {
                        blogView.currentTemplate = currentTemplate
                        blogView.sourceType = sourceType
                        getNavigationController()?.pushViewController(blogView, animated: true)
                    }
                    
                default:
                    break
                }
            }
        default:
            break
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sourceType {
        case .templates:
            if let sectionType = TemplateSectionTypes(rawValue: indexPath.section) {
                switch sectionType {
                case .resources:
                    if currentTemplate?.resources.count > 0{
                        return UITableViewAutomaticDimension
                    }else{
                        return 0
                    }
                    
                default:
                    return UITableViewAutomaticDimension;
                }
            }
        case .tracks:
            if let sectionType = TrackSectionTypes(rawValue: indexPath.section) {
                switch sectionType {
                case .resources:
                    if currentTemplate?.resources.count > 0{
                        return UITableViewAutomaticDimension
                    }else{
                        return 0
                    }
                default:
                    return UITableViewAutomaticDimension;
                }
            }
        default:
            break
        }
        return UITableViewAutomaticDimension
    }
}

//MARK:- Get Track Name methods
extension TrackDetailsViewController{
    func getTrackName() {
        alertController = UIAlertController.getAlertController(.alert, Title: "Enter Group Name", Message: nil,OtherButtonTitles: ["Done"], CancelButtonTitle: "Cancel", completion: { (tappedAtIndex) in
            if tappedAtIndex == 0{
                if let viewCont = UIStoryboard(name: Constants.Storyboard.TracksStoryboard.storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.Storyboard.TracksStoryboard.inviteTracksView) as? InviteForTrackViewController {
                    viewCont.sourceType = .templates
                    viewCont.currentTemplate = self.currentTemplate
                    viewCont.trackName = self.trackName
                    self.getNavigationController()?.pushViewController(viewCont, animated: true)
                }
            }
        })

        alertController?.addTextField(configurationHandler: { (textField:UITextField) in
            textField.placeholder = "Name"
            textField.text = nil
            textField.font = UIFont.getAppRegularFontWithSize(16)?.getDynamicSizeFont()
            textField.addTarget(self, action: #selector(TrackDetailsViewController.textDidChange(_:)), for: .editingChanged)
        })

        UIViewController.getTopMostViewController()?.present(alertController!, animated: true, completion: nil)

        alertController?.view.tintColor = UIColor.getAppThemeColor()
        alertController?.actions[0].isEnabled = false

    }

    @objc func textDidChange(_ textField:UITextField) {
        trackName = textField.text?.getValidObject()
        alertController?.actions[0].isEnabled = !(trackName?.isEmpty ?? true)
    }
}

//MARK:- UIImagePickerControllerDelegate
extension TrackDetailsViewController:UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.selectedImage = image
            self.uploadImage()
        }
        imagePickerControllerDidCancel(picker)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK:- Network methods
extension TrackDetailsViewController{
    func uploadImage() {
        if NetworkClass.isConnected(true) {
            if let url = imageUploadURL{
                if let image = selectedImage {
                    showProgressLoader()
                    NetworkClass.sendImageRequest(URL: url, RequestType: .post, ResponseType: .none, ImageData: UIImagePNGRepresentation(image), ProgressHandler: { (totalBytesSent, totalBytesExpectedToSend) in

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

    func createImageUploadUrl(_ shouldUploadImage:Bool = true){
        if NetworkClass.isConnected(true) {
            NetworkClass.sendRequest(URL: "\(Constants.URLs.createTrackUploadURL)\(currentTemplate?.trackId ?? "")", RequestType: .get, ResponseType: .string,CompletionHandler: { (status, responseObj, error, statusCode) in
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
        updateHeader()
    }
    
    func processError(_ error:NSError?) {
        UIView.showToast("Something went wrong", theme: Theme.error)
    }

    func submitRating() {
        if NetworkClass.isConnected(true), let key = currentTemplate?.key?.getValidObject(){
            showLoaderOnWindow()
            NetworkClass.sendRequest(URL: Constants.URLs.rating, RequestType: .post, Parameters: TasksModel.getDictForRating(key, rating: starRatingView.value) as AnyObject, Headers: nil, CompletionHandler: {
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

    func updateRating(_ response:AnyObject?) {
        DispatchQueue.main.async { 
            self.currentTemplate?.updateRating(response)
            self.updateHeader()
            self.hideRatingView()
        }
    }
}
