
//
//  iOSDropDown.swift
//
//
//  Created by Jishnu Raj T on 26/04/18.
//  Copyright © 2018 JRiOSdev. All rights reserved.
//
import UIKit

extension Notification.Name {
    static let didTouchOutSide = Notification.Name("DID_TOUCH_OUTSIDE")
}

enum TextDropDownType {
    case Text
    case Search
    case Currency
}

@objc(JRDropDown)
open class TextDropDown : UITextField {
    var arrow : Arrow!
    var table : UITableView!
    var shadow : UIView!
    public  var selectedIndex: Int?
    
    //MARK: IBInspectable
    @IBInspectable public var rowHeight: CGFloat = 32
    @IBInspectable public var rowBackgroundColor: UIColor = .white
    @IBInspectable public var selectedRowColor: UIColor = .cyan
    @IBInspectable public var hideOptionsWhenSelect = true
    
    @IBInspectable public var borderColor: UIColor =  UIColor.lightGray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable public var listHeight: CGFloat = 32 * 6 {
        didSet {
            
        }
    }
    @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 5.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var isClearInputOnBeginEditing: Bool = false
    
    @IBInspectable public var arrowSize: CGFloat = 15 {
        didSet{
            let center =  arrow.superview!.center
            arrow.frame = CGRect(x: center.x - arrowSize/2, y: center.y - arrowSize/2, width: arrowSize, height: arrowSize)
        }
    }
    @IBInspectable public var checkMarkEnabled: Bool = true {
        didSet{
            
        }
    }
    
    @IBInspectable public var handleKeyboard: Bool = true {
        didSet{
            
        }
    }
    
    //Variables
    fileprivate var tableheightX: CGFloat = 100
    fileprivate var dataArray = [String]()
    fileprivate var parentController:UIViewController?
    fileprivate var pointToParent = CGPoint(x: 0, y: 0)
    fileprivate var backgroundView = UIView()
    fileprivate var keyboardHeight:CGFloat = 0
    
    public var optionArray = [String]() {
        didSet{
            self.dataArray = self.optionArray
            if let _selectIndex = self.selectedIndex {
                if dropDownType == .Text {
                    self.text = dataArray[safe: _selectIndex]
                }
            }
        }
    }
    
    public var optionIds : [Int]?
    var dropDownType: TextDropDownType = .Text
    
    var arrowImage: UIImage? = UIImage(named: "ic_arrow_down_white") {
        didSet{
            arrow.arrowImage = arrowImage
        }
    }
    
    public var padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    // Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(touchOutSide), name: .didTouchOutSide, object: nil)
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupUI()
    }
    
    //MARK: Closures
    fileprivate var didClose: () -> () = { }
    fileprivate var didSelectIndex: (Int) -> () = {index in }
    fileprivate var TableWillAppearCompletion: () -> () = { }
    fileprivate var TableDidAppearCompletion: () -> () = { }
    fileprivate var TableWillDisappearCompletion: () -> () = { }
    fileprivate var TableDidDisappearCompletion: () -> () = { }
    
    func setupUI () {
        let size = self.frame.height
        let rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: size, height: size))
        self.rightView = rightView
        self.rightViewMode = .always
        let arrowContainerView = UIView(frame: rightView.frame)
        self.rightView?.addSubview(arrowContainerView)
        let center = arrowContainerView.center
        arrow = Arrow(origin: CGPoint(x: center.x - arrowSize - 16, y: center.y - arrowSize/2), size: arrowSize )
        arrowContainerView.addSubview(arrow)
        
        self.backgroundView = UIView(frame: .zero)
        self.backgroundView.backgroundColor = .clear
        addGesture()
        if handleKeyboard{
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (notification) in
                if self.isFirstResponder{
                    let userInfo:NSDictionary = notification.userInfo! as NSDictionary
                    let keyboardFrame:NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    self.keyboardHeight = keyboardRectangle.height
                    if !self.isSelected{
                        self.showList()
                    }
                }
                
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (notification) in
                if self.isFirstResponder{
                    self.keyboardHeight = 0
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func addGesture (){
        let gesture =  UITapGestureRecognizer(target: self, action:  #selector(touchAction))
        self.addGestureRecognizer(gesture)
        
        let gesture2 =  UITapGestureRecognizer(target: self, action:  #selector(touchAction))
        self.backgroundView.addGestureRecognizer(gesture2)
    }
    
    func getConvertedPoint(_ targetView: UIView, baseView: UIView?)->CGPoint{
        var pnt = targetView.frame.origin
        if nil == targetView.superview{
            return pnt
        }
        var superView = targetView.superview
        while superView != baseView{
            pnt = superView!.convert(pnt, to: superView!.superview)
            if nil == superView!.superview{
                break
            }else{
                superView = superView!.superview
            }
        }
        return superView!.convert(pnt, to: baseView)
    }
    
    public func showList() {
        if parentController == nil{
            parentController = self.parentViewController
        }
        backgroundView.frame = parentController?.view.frame ?? backgroundView.frame
        pointToParent = getConvertedPoint(self, baseView: parentController?.view)
        parentController?.view.insertSubview(backgroundView, aboveSubview: self)
        TableWillAppearCompletion()
        if listHeight > rowHeight * CGFloat( dataArray.count) {
            self.tableheightX = rowHeight * CGFloat(dataArray.count)
        }else{
            self.tableheightX = listHeight
        }
        table = UITableView(frame: CGRect(x: pointToParent.x ,
                                          y: pointToParent.y + self.frame.height ,
                                          width: self.frame.width,
                                          height: self.frame.height))
        table.register(UINib(nibName: "TextDropdownCell", bundle: nil),
                       forCellReuseIdentifier: "TextDropdownCell")
        table.register(UINib(nibName: "ResultDropDownCell", bundle: nil),
                       forCellReuseIdentifier: "ResultDropDownCell")
        table.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil),
                       forCellReuseIdentifier: "CurrencyTableViewCell")
        shadow = UIView(frame: table.frame)
        shadow.backgroundColor = .clear
        table.dataSource = self
        table.delegate = self
        table.alpha = 0
        table.separatorStyle = .none
        table.layer.cornerRadius = 3
        table.backgroundColor = rowBackgroundColor
        table.rowHeight = rowHeight
        window?.addSubview(shadow)
        window?.addSubview(table)
        self.isSelected = true
        let height = (self.parentController?.view.frame.height ?? 0) - (self.pointToParent.y + self.frame.height + 5)
        var y = self.pointToParent.y+self.frame.height+5
        if height < (keyboardHeight+tableheightX){
            y = self.pointToParent.y - tableheightX
        }
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        
                        self.table.frame = CGRect(x: self.pointToParent.x,
                                                  y: y,
                                                  width: self.frame.width,
                                                  height: self.tableheightX)
                        self.table.alpha = 1
                        self.shadow.frame = self.table.frame
                        self.shadow.dropShadow()
                        self.arrow.position = .up
                       },
                       completion: { (finish) -> Void in
                        self.layoutIfNeeded()
                       })
    }
    
    public func hideList() {
        TableWillDisappearCompletion()
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        self.table.frame = CGRect(x: self.pointToParent.x,
                                                  y: self.pointToParent.y+self.frame.height,
                                                  width: self.frame.width,
                                                  height: 0)
                        self.shadow.alpha = 0
                        self.shadow.frame = self.table.frame
                        self.arrow.position = .down
                       },
                       completion: { (didFinish) -> Void in
                        
                        self.shadow.removeFromSuperview()
                        self.table.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                        self.isSelected = false
                        self.didClose()
                        self.TableDidDisappearCompletion()
                       })
    }
    
    @objc func touchOutSide() {
        if arrow == nil || table == nil || shadow == nil {
            return
        }
        self.arrow.position = .down
        self.shadow.removeFromSuperview()
        self.table.removeFromSuperview()
        self.backgroundView.removeFromSuperview()
        self.isSelected = false
    }
    
    @objc public func touchAction() {
        isSelected ?  hideList() : showList()
    }
    func reSizeTable() {
        if listHeight > rowHeight * CGFloat( dataArray.count) {
            self.tableheightX = rowHeight * CGFloat(dataArray.count)
        }else{
            self.tableheightX = listHeight
        }
        let height = (self.parentController?.view.frame.height ?? 0) - (self.pointToParent.y + self.frame.height + 5)
        var y = self.pointToParent.y+self.frame.height+5
        if height < (keyboardHeight+tableheightX){
            y = self.pointToParent.y - tableheightX
        }
        UIView.animate(withDuration: 0.2,
                       delay: 0.1,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        self.table.frame = CGRect(x: self.pointToParent.x,
                                                  y: y,
                                                  width: self.frame.width,
                                                  height: self.tableheightX)
                        self.shadow.frame = self.table.frame
                        self.shadow.dropShadow()
                        
                       },
                       completion: { (didFinish) -> Void in
                        //  self.shadow.layer.shadowPath = UIBezierPath(rect: self.table.bounds).cgPath
                        self.layoutIfNeeded()
                       })
    }
    
    //MARK: Actions Methods
    public func didClose(completion: @escaping () -> ()) {
        didClose = completion
    }
    
    public func didSelectIndex(completion: @escaping (_ index: Int ) -> ()) {
        didSelectIndex = completion
    }
    
    public func listWillAppear(completion: @escaping () -> ()) {
        TableWillAppearCompletion = completion
    }
    
    public func listDidAppear(completion: @escaping () -> ()) {
        TableDidAppearCompletion = completion
    }
    
    public func listWillDisappear(completion: @escaping () -> ()) {
        TableWillDisappearCompletion = completion
    }
    
    public func listDidDisappear(completion: @escaping () -> ()) {
        TableDidDisappearCompletion = completion
    }
}

//MARK: - UITableViewDataSource UITableViewDelegate
extension TextDropDown: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let selectedText = self.dataArray[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        cell?.alpha = 0
        UIView.animate(
            withDuration: 0.5,
            animations: { () -> Void in
                cell?.alpha = 1.0
                cell?.backgroundColor = self.selectedRowColor
            } ,
            completion: { (didFinish) -> Void in
                if self.dropDownType == .Text || self.dropDownType == .Currency  {
                    self.text = selectedText
                }
                self.table.reloadData()
            }
        )
        if hideOptionsWhenSelect {
            touchAction()
            self.endEditing(true)
        }
        didSelectIndex(indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dropDownType {
        case .Text:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextDropdownCell", for: indexPath) as? TextDropdownCell else {
                return UITableViewCell()
            }
            
            if indexPath.row != selectedIndex{
                cell.backgroundColor = rowBackgroundColor
            } else {
                cell.backgroundColor = selectedRowColor
            }
            
            cell.configCell(font: font ?? .systemFont(ofSize: 16),
                            textAlignment: textAlignment,
                            textColor: .white)
            cell.bindData(text: dataArray[indexPath.row])
            
            return cell
        case .Currency:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as? CurrencyTableViewCell else {
                return UITableViewCell()
            }
            
            if indexPath.row != selectedIndex{
                cell.backgroundColor = rowBackgroundColor
            } else {
                cell.backgroundColor = selectedRowColor
            }
            
            cell.bindData(currency: dataArray[indexPath.row])
            
            return cell
        case .Search:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as? CurrencyTableViewCell else {
                return UITableViewCell()
            }
            
            return cell
        }
    }
}

//MARK: - Arrow
enum Position {
    case left
    case down
    case right
    case up
}

class Arrow: UIView {
    var arrowImage: UIImage?
    var position: Position = .down {
        didSet{
            switch position {
            case .left:
                self.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
                break
            case .down:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi*2)
                break
            case .right:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                break
            case .up:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                break
            }
        }
    }
    
    init(origin: CGPoint, size: CGFloat ) {
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: size, height: size))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let image = UIImageView(image: arrowImage ?? UIImage(named: "ic_arrow_down_white"))
        image.frame = bounds
        image.contentMode = .scaleAspectFit
        addSubview(image)
    }
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func viewBorder(borderColor : UIColor, borderWidth : CGFloat?) {
        self.layer.borderColor = borderColor.cgColor
        if let borderWidth_ = borderWidth {
            self.layer.borderWidth = borderWidth_
        } else {
            self.layer.borderWidth = 1.0
        }
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}



