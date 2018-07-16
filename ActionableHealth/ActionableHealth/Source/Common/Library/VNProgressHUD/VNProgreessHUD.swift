//
//  VNProgreessHUD.swift
//  VNProgressHUD
//
//  Created by Vidhan Nandi on 28/05/16.
//  Copyright © 2016 Vidhan Nandi. All rights reserved.
//

import UIKit

//MARK:- ----------VNProgressHUD Class----------

protocol VNProgressHUDDelegate: NSObjectProtocol{
    func hudWasHidden(_ hud:VNProgreessHUD)
}

//MARK:- Enums
enum VNProgressHUDMode:Int {
    /** Progress is shown using an UIActivityIndicatorView. This is the default. */
    case indeterminate
    /** Progress is shown using a round, pie-chart like, progress view. */
    case determinate
    /** Progress is shown using a horizontal progress bar */
    case horizontalBar
    /** Progress is shown using a ring-shaped progress view. */
    case annularDeterminate
    /** Shows a custom view */
    case customView
    /** Shows only labels */
    case text
}

enum VNProgressHUDAnimation {
    /** Opacity animation */
    case fade
    /** Opacity + scale animation */
    case zoomOut
    case zoomIn
}

//MARK:- Constants
let kHUDPadding:CGFloat = 4.0
let kHUDLabelFontSize:CGFloat = 14.0
let kHUDDetailsLabelFontSize:CGFloat = 11.0

//MARK:- Properties
class VNProgreessHUD: UIView {

    //MARK: Public Properties
    /**
     * VNProgreessHUD operation mode. The default is VNProgressHUDMode.Indeterminate.
     *
     * @see VNProgreessHUDMode
     */
    var mode:VNProgressHUDMode = .indeterminate{
        didSet {
            DispatchQueue.main.async {
                self.updateIndicator()
                self.setNeedsLayout()
                self.setNeedsDisplay()
            }
        }
    }

    /**
     * The animation type that should be used when the HUD is shown and hidden. The default is VNProgressHUDAnimation.Fade
     *
     * @see VNProgressHUDAnimation
     */
    var animationType:VNProgressHUDAnimation = .fade

    /**
     * The UIView (e.g., a UIImageView) to be shown when the HUD is in VNProgressHUDMode.CustomView.
     * For best results use a 37 by 37 pixel view (so the bounds match the built in indicator bounds).
     */
    var customView:UIView?{
        didSet {
            DispatchQueue.main.async {
                self.updateIndicator()
                self.setNeedsLayout()
                self.setNeedsDisplay()
            }
        }
    }

    /**
     * The HUD delegate object.
     *
     * @see VNProgressHUDDelegate
     */
    var delegate:VNProgressHUDDelegate?

    /**
     * An optional short message to be displayed below the activity indicator. The HUD is automatically resized to fit
     * the entire text. If the text is too long it will get clipped by displaying "..." at the end. If left unchanged or
     * set to @"", then no message is displayed.
     */
    var labelText:String? = "Please Wait..."{
        didSet {
            DispatchQueue.main.async {
                self.label?.text = self.labelText
                self.setNeedsLayout()
                self.setNeedsDisplay()
            }
        }
    }

    /**
     * An optional details message displayed below the labelText message. This message is displayed only if the labelText
     * property is also set and is different from an empty string (@""). The details text can span multiple lines.
     */
    var detailsLabelText:String = ""{
        didSet {
            DispatchQueue.main.async {
                self.detailsLabel?.text = self.detailsLabelText
                self.setNeedsLayout()
                self.setNeedsDisplay()
            }
        }
    }

    /**
     * The opacity of the HUD window. Defaults to 0.8 (80% opacity).
     */
    var opacity:CGFloat = 0.8{
        didSet {
            DispatchQueue.main.async {
                self.setNeedsLayout()
                self.setNeedsDisplay()
            }
        }
    }


    /**
     * The color of the HUD window. If this property is set, color is set using
     * this UIColor and the opacity property is not used.
     */
    //MARK:- Changed
    var color:UIColor?{
        didSet {
            DispatchQueue.main.async {
                self.setNeedsLayout()
                self.setNeedsDisplay()
            }
        }
    }


    /**
     * The x-axis offset of the HUD relative to the centre of the superview.
     */
    var xOffset:CGFloat = 0.0{
        didSet {
            DispatchQueue.main.async {
                self.setNeedsLayout()
                self.setNeedsDisplay()
            }
        }
    }

    /**
     * The y-axis offset of the HUD relative to the centre of the superview.
     */
    var yOffset:CGFloat = 0.0{
        didSet {
            DispatchQueue.main.async {
                self.setNeedsLayout()
                self.setNeedsDisplay()
            }
        }
    }

    /**
     * The amount of space between the HUD edge and the HUD elements (labels, indicators or custom views).
     * Defaults to 20.0
     */
    var margin:CGFloat = 20.0{
        didSet {
            DispatchQueue.main.async {
                self.setNeedsLayout()
                self.setNeedsDisplay()
            }
        }
    }

    /**
     * The corner radius for the HUD
     * Defaults to 10.0
     */
    var cornerRadius:CGFloat = 10.0{
        didSet {
            DispatchQueue.main.async {
                self.setNeedsLayout()
                self.setNeedsDisplay()
            }
        }
    }

    /**
     * Cover the HUD background view with a radial gradient.
     */
    var dimBackground:Bool = false{
        didSet {
            DispatchQueue.main.async {
                self.setNeedsLayout()
                self.setNeedsDisplay()
            }
        }
    }

    /*
     * Grace period is the time (in seconds) that the invoked method may be run without
     * showing the HUD. If the task finishes before the grace time runs out, the HUD will
     * not be shown at all.
     * This may be used to prevent HUD display for very short tasks.
     * Defaults to 0 (no grace time).
     * Grace time functionality is only supported when the task status is known!
     * @see taskInProgress
     */
    var graceTime:Double = 0.0

    /**
     * The minimum time (in seconds) that the HUD is shown.
     * This avoids the problem of the HUD being shown and than instantly hidden.
     * Defaults to 0 (no minimum show time).
     */
    var minShowTime:Double = 0.0

    /**
     * Indicates that the executed operation is in progress. Needed for correct graceTime operation.
     * If you don't set a graceTime (different than 0.0) this does nothing.
     * you need to set this property when your task starts and completes in order to have normal graceTime
     * functionality.
     */
    var taskInProgress:Bool = false

    /**
     * Removes the HUD from its parent view when hidden.
     * Defaults to True.
     */
    var removeFromSuperViewOnHide:Bool = true

    /**
     * Font to be used for the main label. Set this property if the default is not adequate.
     */
    var labelFont:UIFont = UIFont.boldSystemFont(ofSize: kHUDLabelFontSize){
        didSet {
            DispatchQueue.main.async {
                self.label?.font = self.labelFont
                self.setNeedsLayout()
                self.setNeedsDisplay()
            }
        }
    }


    /**
     * Color to be used for the main label. Set this property if the default is not adequate.
     */
    var labelColor:UIColor = UIColor.white{
        didSet {
            DispatchQueue.main.async {
                self.label?.textColor = self.labelColor
                self.setNeedsLayout()
                self.setNeedsDisplay()
            }
        }
    }

    /**
     * Font to be used for the details label. Set this property if the default is not adequate.
     */
    var detailsLabelFont:UIFont = UIFont.boldSystemFont(ofSize: kHUDDetailsLabelFontSize){
        didSet {
            DispatchQueue.main.async {
                self.detailsLabel?.font = self.detailsLabelFont
                self.setNeedsLayout()
                self.setNeedsDisplay()
            }
        }
    }

    /**
     * Color to be used for the details label. Set this property if the default is not adequate.
     */
    var detailsLabelColor:UIColor = UIColor.white{
        didSet {
            DispatchQueue.main.async {
                self.detailsLabel?.textColor = self.detailsLabelColor
                self.setNeedsLayout()
                self.setNeedsDisplay()
            }
        }
    }

    /**
     * The color of the activity indicator. Defaults to [UIColor whiteColor]
     * Does nothing on pre iOS 5.
     */
    var activityIndicatorColor:UIColor = UIColor.white{
        didSet {
            DispatchQueue.main.async {
                self.updateIndicator()
                self.setNeedsLayout()
                self.setNeedsDisplay()
            }
        }
    }

    /**
     * The progress of the progress indicator, from 0.0 to 1.0. Defaults to 0.0.
     */
    var progress:CGFloat = 0.0{
        didSet {
            DispatchQueue.main.async {
                let activityInd1 = self.indicator as? VNBarProgressView
                if (activityInd1 != nil) {
                    self.indicator?.setValue(self.progress, forKey: "progress")
                }else{
                    let activityInd2 = self.indicator as? VNRoundProgressView
                    if (activityInd2 != nil) {
                        self.indicator?.setValue(self.progress, forKey: "progress")
                    }
                }
            }
        }
    }



    /**
     * The minimum size of the HUD bezel. Defaults to CGSizeZero (no minimum size).
     */
    var minSize:CGSize = CGSize.zero

    /**
     * The actual size of the HUD bezel.
     * You can use this to limit touch handling on the bezel area only.
     */
    var size:CGSize?

    /**
     * Force the HUD dimensions to be equal if possible. Default is True
     */
    var square:Bool = false



    //MARK: Private Properties
    fileprivate var indicator:UIView?
    fileprivate var graceTimer:Timer?
    fileprivate var minShowTimer:Timer?
    fileprivate var showStarted:Date?

    fileprivate var useAnimation:Bool = false
    fileprivate var label:UILabel?
    fileprivate var detailsLabel:UILabel?
    fileprivate var isFinished:Bool = false
    fileprivate var rotationTransform:CGAffineTransform = CGAffineTransform.identity

    //MARK:- LifeCycle

    override func didMoveToSuperview() {
        updateForCurrentOrientation(Animated: false)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .center
        self.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        self.isOpaque = false
        self.backgroundColor = UIColor.black.withAlphaComponent(0.2)

        self.alpha = 0.0
        setupLabels()
        updateIndicator()
        registerForNotifications()
    }

    convenience init(View view:UIView) {
        self.init(frame: view.bounds)
    }

    convenience init(Window window: UIWindow) {
        self.init(View: window)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit{
        unregisterFromNotifications()
    }
}
//MARK:- Additional methods
extension VNProgreessHUD{
    func getTextSize(_ text:String?, Font font:UIFont?) -> CGSize {
        if text == nil || font == nil || (text?.isEmpty)! {
            return CGSize.zero
        }else{
            return (text! as NSString).size(attributes: [NSFontAttributeName : font!])
        }
    }
    func getMultipleLineTextSize(_ text:String?, Font font:UIFont?, MaxSize maxSize:CGSize?, LineBreakMode lineBreak:NSLineBreakMode?) -> CGSize {
        if text == nil || font == nil || maxSize == nil || lineBreak == nil  || (text?.isEmpty)!{
            return CGSize.zero
        }else{
            return (text! as NSString).boundingRect(with: maxSize!, options: NSStringDrawingOptions.usesLineFragmentOrigin , attributes: [NSFontAttributeName : font!], context: nil).size
        }
    }
}

//MARK:- Drawing methods
extension VNProgreessHUD{

    override func layoutSubviews() {
        super.layoutSubviews()
        // Entirely cover the parent view
        if let parent = self.superview {
            self.frame = parent.bounds
        }
        let bounds:CGRect = self.bounds

        // Determine the total width and height needed
        let maxWidth:CGFloat = bounds.size.width - 4 * self.margin
        var totalSize:CGSize = CGSize.zero

        var indicatorF = self.indicator?.bounds
        indicatorF?.size.width = min(indicatorF!.size.width, maxWidth)
        totalSize.width = max(totalSize.width, indicatorF!.size.width)
        totalSize.height += indicatorF!.size.height

        var labelSize = self.getTextSize(label!.text , Font: label!.font)
        labelSize.width = min(labelSize.width, maxWidth)
        totalSize.width = max(totalSize.width, labelSize.width)
        totalSize.height += labelSize.height
        if labelSize.height > 0.0 && indicatorF!.size.height > 0.0 {
            totalSize.height += kHUDPadding
        }

        let remainingHeight = bounds.size.height - totalSize.height - kHUDPadding - 4 * margin
        let maxSize = CGSize(width: maxWidth, height: remainingHeight)
        let detailsLabelSize = self.getMultipleLineTextSize(detailsLabel?.text, Font: detailsLabel?.font, MaxSize: maxSize, LineBreakMode: detailsLabel?.lineBreakMode)
        totalSize.width = max(totalSize.width, detailsLabelSize.width)
        totalSize.height += detailsLabelSize.height
        if (detailsLabelSize.height > 0 && (indicatorF!.size.height > 0 || labelSize.height > 0)) {
            totalSize.height += kHUDPadding
        }

        totalSize.width += 2 * margin
        totalSize.height += 2 * margin

        // Position elements
        var yPos = round(((bounds.size.height - totalSize.height) / 2)) + margin + yOffset
        let xPos = xOffset
        indicatorF!.origin.y = yPos
        indicatorF!.origin.x = round((bounds.size.width - indicatorF!.size.width) / 2) + xPos
        indicator!.frame = indicatorF!
        yPos += indicatorF!.size.height

        if labelSize.height > 0 && indicatorF!.size.height > 0  {
            yPos += kHUDPadding * 2
        }

        var labelF = CGRect.zero
        labelF.origin.y = yPos
        labelF.origin.x = round((bounds.size.width - labelSize.width) / 2) + xPos
        labelF.size = labelSize
        label!.frame = labelF
        yPos += labelF.size.height

        if detailsLabelSize.height > 0 && (indicatorF!.size.height > 0 || labelSize.height > 0) {
            yPos += kHUDPadding
        }

        var detailsLabelF: CGRect = CGRect.zero
        detailsLabelF.origin.y = yPos
        detailsLabelF.origin.x = round((bounds.size.width - detailsLabelSize.width) / 2) + xPos
        detailsLabelF.size = detailsLabelSize
        detailsLabel!.frame = detailsLabelF

        // Enforce minsize and quare rules
        if square {
            let maxD = max(totalSize.width, totalSize.height)
            if maxD <= bounds.size.width - 2 * margin{
                totalSize.width = maxD
            }
            if maxD <= bounds.size.height - 2 * margin {
                totalSize.height = maxD
            }
        }
        if (totalSize.width < minSize.width) {
            totalSize.width = minSize.width
        }
        if (totalSize.height < minSize.height) {
            totalSize.height = minSize.height
        }
        size = totalSize
    }

    override func draw(_ rect: CGRect) {
//        let context:CGContext = UIGraphicsGetCurrentContext()!
//        UIGraphicsPushContext(context)
//        if dimBackground {
//
//            //Gradient colours
//            let gradLocationsNum:size_t = 2
//            let gradLocations:[CGFloat] = [0.0, 1.0]
//            let gradColors:[CGFloat] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.75]
//            let colorSpace = CGColorSpaceCreateDeviceRGB()
//            let gradient = CGGradient(colorSpace: colorSpace, colorComponents: gradColors, locations: gradLocations, count: gradLocationsNum)!
//
//            //Gradient center
//            let gradCenter = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
//
//            //Gradient radius
//            let gradRadius = min(self.bounds.size.width , self.bounds.size.height)
//
//            //Gradient draw
//            context.drawRadialGradient (gradient, startCenter: gradCenter,
//                                         startRadius: 0, endCenter: gradCenter, endRadius: gradRadius,
//                                         options: CGGradientDrawingOptions.drawsAfterEndLocation)
//        }
//
//        // Set background rect color
//        if self.color != nil {
//            context.setFillColor(self.color!.cgColor)
//        }else {
//            context.setFillColor(gray: 0.0, alpha: self.opacity)
//        }
//
//        // Center HUD
//        let allRect = self.bounds
//
//        // Draw rounded HUD backgroud rect
//        let boxRect = CGRect(x: round((allRect.size.width - (size?.width ?? 0)) / 2) + self.xOffset,
//                                 y: round((allRect.size.height - (size?.height ?? 0)) / 2) + self.yOffset, width: (size?.width ?? 0), height: (size?.height ?? 0))
//        let radius = self.cornerRadius
//        context.beginPath()
//        context.move(to: CGPoint(x: boxRect.minX + radius, y: boxRect.minY))
//        CGContextAddArc(context, boxRect.maxX - radius, boxRect.minY + radius, radius, 3 * CGFloat(M_PI / 2), 0, 0)
//        CGContextAddArc(context, boxRect.maxX - radius, boxRect.maxY - radius, radius, 0, CGFloat(M_PI / 2), 0)
//        CGContextAddArc(context, boxRect.minX + radius, boxRect.maxY - radius, radius, CGFloat(M_PI / 2), CGFloat(M_PI), 0)
//        CGContextAddArc(context, boxRect.minX + radius, boxRect.minY + radius, radius, CGFloat(M_PI), 3 * CGFloat(M_PI / 2), 0)
//        context.closePath()
//        context.fillPath()
//
//        UIGraphicsPopContext()
    }
}

//MARK:- UI methods
extension VNProgreessHUD{

    func setupLabels() {
        label = UILabel(frame: self.bounds)
        label!.adjustsFontSizeToFitWidth = false
        label!.textAlignment = .center
        label!.isOpaque = false
        label!.backgroundColor = UIColor.clear
        label!.textColor = self.labelColor
        label!.font = self.labelFont
        label!.text = self.labelText
        self.addSubview(label!)

        detailsLabel = UILabel(frame: self.bounds)
        detailsLabel!.font = self.detailsLabelFont
        detailsLabel!.adjustsFontSizeToFitWidth = false
        detailsLabel!.textAlignment = .center
        detailsLabel!.isOpaque = false
        detailsLabel!.backgroundColor = UIColor.clear
        detailsLabel!.textColor = self.detailsLabelColor
        detailsLabel!.numberOfLines = 0
        detailsLabel!.text = self.detailsLabelText
        self.addSubview(detailsLabel!)
    }

    func updateIndicator(){
        var isActivityIndicator:Bool = false
        var isRoundIndicator:Bool = false
        if indicator != nil {
            isActivityIndicator = indicator!.isKind(of: UIActivityIndicatorView.self)
            isRoundIndicator = indicator!.isKind(of: VNRoundProgressView.self)
        }
        switch mode {
        case .indeterminate:
            if !isActivityIndicator {
                //update to Indeterminate indicator
                indicator?.removeFromSuperview()
                self.indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
                (indicator as! UIActivityIndicatorView).startAnimating()
                self.addSubview(indicator!)

            }
            (indicator as! UIActivityIndicatorView).color = self.activityIndicatorColor
        case .horizontalBar:
            // Update to bar HorizontalBar indicator
            indicator?.removeFromSuperview()
            self.indicator = VNBarProgressView()
            (indicator as! VNBarProgressView).progressColor  = self.activityIndicatorColor
            self.addSubview(indicator!)
        case .determinate, .annularDeterminate:
            if !isRoundIndicator {
                // Update to determinante indicator
                indicator?.removeFromSuperview()
                self.indicator = VNRoundProgressView()
                self.addSubview(indicator!)
            }
            if mode == .annularDeterminate {
                (indicator as! VNRoundProgressView).annular = true
                (indicator as! VNRoundProgressView).progressTintColor  = self.activityIndicatorColor
                (indicator as! VNRoundProgressView).backgroundTintColor = self.activityIndicatorColor.withAlphaComponent(0.1)
            }else{
                (indicator as! VNRoundProgressView).progressTintColor  = self.activityIndicatorColor
            }

        case .customView:
            if customView != indicator {
                indicator?.removeFromSuperview()
                self.indicator = customView
                if indicator != nil {
                    self.addSubview(indicator!)
                }
            }
        case .text:
            indicator?.removeFromSuperview()
            self.indicator = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }
    }

    func statusBarOrientationDidChange(_ notification:NotificationCenter) {
        #if !TARGET_OS_TV
            if self.superview != nil {
                updateForCurrentOrientation(Animated: true)
            }
        #endif
    }

    func updateForCurrentOrientation(Animated animated:Bool){
        if self.superview != nil {
            self.bounds = (self.superview?.bounds)!
            self.setNeedsDisplay()
        }
    }

}

//MARK:- Notification methods
extension VNProgreessHUD{

    func registerForNotifications() {
        #if !TARGET_OS_TV
            let notificationCenter:NotificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(self.statusBarOrientationDidChange(_:)), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
        #endif
    }

    func unregisterFromNotifications() {
        #if !TARGET_OS_TV
            let notificationCenter:NotificationCenter = NotificationCenter.default
            notificationCenter.removeObserver(self, name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
        #endif
    }
}

//MARK:- Private show hide methods methods
extension VNProgreessHUD{

    func showUsingAnimation(_ animated:Bool){
        // Cancel any scheduled hideDelayed: calls
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.setNeedsDisplay()

        if animated && animationType == .zoomIn{
            self.transform = rotationTransform.concatenating(CGAffineTransform(scaleX: 0.5, y: 0.5))
        }else if animated && animationType == .zoomOut{
            self.transform = rotationTransform.concatenating(CGAffineTransform(scaleX: 1.5, y: 1.5))
        }
        self.showStarted = Date()

        //Fade in
        if animated {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.30)
            self.alpha = 1.0

            if animationType == .zoomIn || animationType == .zoomOut {
                self.transform = rotationTransform
            }

            UIView.commitAnimations()
        }
        else{
            self.alpha = 1.0
        }
    }

    func hideUsingAnimation(_ animaed:Bool){

        //Fade Out
        if  animaed && showStarted != nil {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.30)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStop(#selector(self.animationFinished))
            if animationType == .zoomIn{
                self.transform = rotationTransform.concatenating(CGAffineTransform(scaleX: 1.5, y: 1.5))
            }else if animationType == .zoomOut{
                self.transform = rotationTransform.concatenating(CGAffineTransform(scaleX: 0.5, y: 0.5))
            }
            // 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden
            // in the animation finished method
            self.alpha = 0.02
            UIView.commitAnimations()
        }
    }

    func animationFinished() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        isFinished = true
        self.alpha = 0.0
        if removeFromSuperViewOnHide {
            self.removeFromSuperview()
        }
        delegate?.hudWasHidden(self)
    }
}

//MARK:- Timer callback methods
extension VNProgreessHUD{

    func handleGraceTimer(_ theTimer:Timer) {
        // Show the HUD only if the task is still running
        if taskInProgress {
            self.showUsingAnimation(useAnimation)
        }
    }

    func handleMinShowTimer(_ theTimer:Timer) {
        self.hideUsingAnimation(useAnimation)
    }
}

//MARK:- Public show hide methods methods
extension VNProgreessHUD{

    func show(_ animated:Bool){
        DispatchQueue.main.async {
            self.useAnimation = animated
            // If the grace time is set postpone the HUD display
            if self.graceTime > 0.0{
                let newGraceTimer:Timer = Timer(timeInterval: self.graceTime, target: self, selector: #selector(self.handleGraceTimer(_:)), userInfo: nil , repeats: false)
                RunLoop.current.add(newGraceTimer, forMode: RunLoopMode.commonModes)
                self.graceTimer = newGraceTimer
            }
                // ... otherwise show the HUD imediately
            else{
                self.showUsingAnimation(self.useAnimation)
            }
        }
    }

    func hide(_ animated:Bool){
        DispatchQueue.main.async {
            self.useAnimation = animated
            // If the minShow time is set, calculate how long the hud was shown,
            // and pospone the hiding operation if necessary
            if self.minShowTime > 0.0 && self.showStarted != nil{
                let inter = Date().timeIntervalSince(self.showStarted!)
                if inter < self.minShowTime{
                    self.minShowTimer = Timer.scheduledTimer(timeInterval: self.minShowTime - inter, target: self, selector: #selector(self.handleMinShowTimer(_:)), userInfo: nil, repeats: false)
                    return
                }
            }
            // ... otherwise hide the HUD immediately
            self.hideUsingAnimation(self.useAnimation)
        }
    }

    func hide(_ animated:Bool, AfterDelay delay:TimeInterval){
        self.perform(#selector(self.hideDelayed(_:)), with: animated, afterDelay: delay)
    }

    func hideDelayed(_ animated:Bool) {
        self.hide(animated)
    }
}

//MARK:- Class Methods
extension VNProgreessHUD{

    class func showHUDAddedToView(_ view:UIView, Animated animated:Bool) -> VNProgreessHUD {
        if let hud = allHUDsForView(view).firstObject as? VNProgreessHUD {
            return hud

        }else{
            let hud:VNProgreessHUD = VNProgreessHUD(View: view)
            hud.removeFromSuperViewOnHide = true
            view.addSubview(hud)
            hud.show(animated)
            return hud
        }
    }

    class func hideHUDForView(_ view:UIView, Animated animated:Bool) -> Bool {
        let hud = self.hudForView(view)

        if hud != nil {
            (hud as! VNProgreessHUD).removeFromSuperViewOnHide = true
            (hud as! VNProgreessHUD).hide(animated)
            return true
        }
        return false
    }

    class func hideAllHudsFromView(_ view:UIView, Animated animated:Bool) -> Int {

        let huds = self.allHUDsForView(view)

        for hud in huds {
            (hud as! VNProgreessHUD).removeFromSuperViewOnHide = true
            (hud as! VNProgreessHUD).hide(animated)
        }
        return huds.count
    }

    class func hudForView(_ view:UIView) -> AnyObject? {
        let subViewEnum = (view.subviews as NSArray).reverseObjectEnumerator()
        for view in subViewEnum {
            if (view as AnyObject).isKind(of: self) {
                return view as! VNProgreessHUD
            }
        }
        return nil
    }

    class func allHUDsForView(_ view:UIView)-> NSArray {
        let huds:NSMutableArray = []
        let subViews = view.subviews
        for view in subViews {
            if view.isKind(of: self) {
                huds.add(view)
            }
        }
        return huds
    }
}

//MARK:- ----------VNRoundProgressView Class----------
class VNRoundProgressView: UIView {

    //MARK:- Properties

    /**
     * Progress (0.0 to 1.0)
     */
    var progress:CGFloat = 0.0{
        didSet {
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }

    /**
     * Indicator progress color.
     * Defaults to white [UIColor whiteColor]
     */
    var progressTintColor:UIColor = UIColor.white{
        didSet {
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }

    /**
     * Indicator background (non-progress) color.
     * Defaults to translucent white (alpha 0.1)
     */
    var backgroundTintColor:UIColor = UIColor(white: 1.0, alpha: 0.1){
        didSet {
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }

    /*
     * Display mode - NO = round or YES = annular. Defaults to round.
     */
    var annular:Bool = false{
        didSet {
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }

    //MARK:- Life cycle
    convenience init(){
        self.init(frame: CGRect(x: 0, y: 0, width: 37, height: 37))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK:- Drawing Methods
extension VNRoundProgressView{
    override func draw(_ rect: CGRect) {
//        let allRect = self.bounds
//        let circleRect = allRect.insetBy(dx: 2.0, dy: 2.0)
//        let context = UIGraphicsGetCurrentContext()!
//
//        if self.annular {
//            // Draw background
//            let lineWidth:CGFloat = 2.0
//            let processBackgroundPath = UIBezierPath()
//            processBackgroundPath.lineWidth = lineWidth
//            processBackgroundPath.lineCapStyle = .butt
//            let center:CGPoint = CGPoint(x: self.bounds.size.width/2 , y: self.bounds.size.height/2)
//            let radius:CGFloat = (self.bounds.size.width - lineWidth)/2
//            let startAngle:CGFloat = -CGFloat(M_PI/2) // 90 degrees
//            var endAngle = (2 * CGFloat(M_PI)) + startAngle
//            processBackgroundPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
//            self.backgroundTintColor.set()
//            processBackgroundPath.stroke()
//
//            //Draw progress
//            let processPath = UIBezierPath()
//            processPath.lineCapStyle = .square
//            processPath.lineWidth = lineWidth
//            endAngle = (self.progress * 2 * CGFloat(M_PI)) + startAngle
//            processPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
//            self.progressTintColor.set()
//            processPath.stroke()
//        }else{
//            // Draw background
//            self.progressTintColor.setStroke()
//            self.backgroundTintColor.setFill()
//            context.setLineWidth(2.0)
//            context.fillEllipse(in: circleRect)
//            context.strokeEllipse(in: circleRect)
//
//            //Draw progress
//            let center = CGPoint(x: allRect.size.width/2, y: allRect.size.height/2)
//            let radius:CGFloat = (allRect.size.width - 4)/2
//            let startAngle:CGFloat = -CGFloat(M_PI/2) // 90 degrees
//            let endAngle = (self.progress * 2 * CGFloat(M_PI)) + startAngle
//            self.progressTintColor.setFill()
//            context.move(to: CGPoint(x: center.x, y: center.y))
//            CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0)
//            context.closePath()
//            context.fillPath()
//        }
    }
}

//MARK:- ----------VNBarProgressView Class----------
class VNBarProgressView: UIView {

    //MARK:- Properties

    /**
     * Progress (0.0 to 1.0)
     */
    var progress:CGFloat = 0.0{
        didSet {
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }

    /**
     * Bar border line color.
     * Defaults to white [UIColor whiteColor].
     */
    var lineColor:UIColor = UIColor.white{
        didSet {
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }

    /**
     * Bar background color.
     * Defaults to clear [UIColor clearColor]
     */
    var progressRemainingColor = UIColor.clear{
        didSet {
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }

    /**
     * Bar progress color.
     * Defaults to white [UIColor whiteColor].
     */
    var progressColor = UIColor.white{
        didSet {
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }

    //MARK:- Life cycle
    convenience init(){
        self.init(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK:- Drawing Methods
extension VNBarProgressView{
    override func draw(_ rect: CGRect) {

//        let context = UIGraphicsGetCurrentContext()!
//        context.setLineWidth(2)
//        context.setStrokeColor(self.lineColor.cgColor)
//        context.setFillColor(self.progressRemainingColor.cgColor)
//
//        // Draw background
//        var radius:CGFloat = (rect.size.height / 2) - 2
//        context.move(to: CGPoint(x: 2, y: rect.size.height/2))
//        CGContextAddArcToPoint(context, 2, 2, radius + 2, 2, radius)
//        context.addLine(to: CGPoint(x: rect.size.width - radius - 2, y: 2))
//        CGContextAddArcToPoint(context, rect.size.width - 2, 2, rect.size.width - 2, rect.size.height / 2, radius)
//        CGContextAddArcToPoint(context, rect.size.width - 2, rect.size.height - 2, rect.size.width - radius - 2, rect.size.height - 2, radius)
//        context.addLine(to: CGPoint(x: radius + 2, y: rect.size.height - 2))
//        CGContextAddArcToPoint(context, 2, rect.size.height - 2, 2, rect.size.height/2, radius)
//        context.fillPath()
//
//        // Draw border
//        context.move(to: CGPoint(x: 2, y: rect.size.height/2))
//        CGContextAddArcToPoint(context, 2, 2, radius + 2, 2, radius)
//        context.addLine(to: CGPoint(x: rect.size.width - radius - 2, y: 2))
//        CGContextAddArcToPoint(context, rect.size.width - 2, 2, rect.size.width - 2, rect.size.height / 2, radius)
//        CGContextAddArcToPoint(context, rect.size.width - 2, rect.size.height - 2, rect.size.width - radius - 2, rect.size.height - 2, radius)
//        context.addLine(to: CGPoint(x: radius + 2, y: rect.size.height - 2))
//        CGContextAddArcToPoint(context, 2, rect.size.height - 2, 2, rect.size.height/2, radius)
//        context.strokePath()
//
//        context.setFillColor(self.progressColor.cgColor)
//        radius = radius - 2
//        let amount:CGFloat = self.progress * rect.size.width
//
//        // Progress in the middle area
//        if amount >= radius + 4 && amount <= (rect.size.width - radius - 4) {
//            context.move(to: CGPoint(x: 4, y: rect.size.height/2))
//            CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius)
//            context.addLine(to: CGPoint(x: amount, y: 4))
//            context.addLine(to: CGPoint(x: amount, y: radius + 4))
//
//            context.move(to: CGPoint(x: 4, y: rect.size.height/2))
//            CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius)
//            context.addLine(to: CGPoint(x: amount, y: rect.size.height - 4))
//            context.addLine(to: CGPoint(x: amount, y: radius + 4))
//
//            context.fillPath()
//        }
//            // Progress in the right arc
//        else if amount > radius + 4 {
//            let x:CGFloat = amount - (rect.size.width - radius - 4)
//
//            context.move(to: CGPoint(x: 4, y: rect.size.height/2))
//            CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius)
//            context.addLine(to: CGPoint(x: rect.size.width - radius - 4, y: 4))
//            var angle:CGFloat = -acos(x/radius)
//            if isnan(angle){
//                angle = 0
//            }
//            CGContextAddArc(context, rect.size.width - radius - 4, rect.size.height/2, radius, CGFloat(M_PI), angle, 0)
//            context.addLine(to: CGPoint(x: amount, y: rect.size.height/2))
//
//            context.move(to: CGPoint(x: 4, y: rect.size.height/2))
//            CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius)
//            context.addLine(to: CGPoint(x: rect.size.width - radius - 4, y: rect.size.height - 4))
//            angle = acos(x/radius)
//            if (isnan(angle))
//            {
//                angle = 0
//            }
//            CGContextAddArc(context, rect.size.width - radius - 4, rect.size.height/2, radius, -CGFloat(M_PI), angle, 1)
//            context.addLine(to: CGPoint(x: amount, y: rect.size.height/2))
//
//            context.fillPath()
//        }
//            // Progress is in the left arc
//        else if amount < radius + 4 && amount > 0 {
//            context.move(to: CGPoint(x: 4, y: rect.size.height/2))
//            CGContextAddArcToPoint(context, 4, 4, radius + 4, 4, radius)
//            context.addLine(to: CGPoint(x: radius + 4, y: rect.size.height/2))
//
//            context.move(to: CGPoint(x: 4, y: rect.size.height/2))
//            CGContextAddArcToPoint(context, 4, rect.size.height - 4, radius + 4, rect.size.height - 4, radius)
//            context.addLine(to: CGPoint(x: radius + 4, y: rect.size.height/2))
//
//            context.fillPath()
//        }

    }
}

