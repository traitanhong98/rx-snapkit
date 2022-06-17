//
//  UIView+Extension.swift
//  OSEIOS (iOS)
//
//  Created by ECO0542-HoangNM on 27/11/2021.
//

import UIKit
import CoreGraphics



// MARK: - Finding view
extension UIView {
    /// Find a view
    /// This func will go from root view to it's hierarchy
    func findingViewFromRoot<T: UIView> (_ viewType: T.Type) -> T? {
        var rootView: UIView = self
        while true {
            if let superView = rootView.superview {
                rootView = superView
            } else {
                break
            }
        }
        if let result = getView(fromView: rootView, withType: T.self) {
            return result
        }
        return nil
    }
    /// Find a view
    /// This func will go from this view to it's superviews
    func enclosingView<T: UIView>(_ viewType: T.Type) -> T? {
        var next: UIView? = self
        repeat {
            next = next?.superview
            if let view = next as? T {
                return view
            }
        } while next != nil
        return nil
    }
    /// Find a view
    /// This func will go from this view to it's subviews i
    func getView<T: UIView>(fromView view: UIView, withType: T.Type) -> T? {
        if let result = view as? T {
            return result
        }
        if view.subviews.isEmpty {
            return nil
        }
        for subView in view.subviews {
            if let editingView = getView(fromView: subView, withType: T.self) {
                return editingView
            }
        }
        return nil
    }
    /// Find current view that is editing from view hierarchy
    static func getEdittingView(fromView view: UIView) -> UIView? {
        if view.isFirstResponder {
            return view
        }
        if view.subviews.isEmpty {
            return nil
        }
        for subView in view.subviews {
            if let editingView = getEdittingView(fromView: subView) {
                return editingView
            }
        }
        return nil
    }
    /// Get frame of view in entire screen
    var globalFrame :CGRect? {
        var parentController = self.parentViewController
        while parentController?.parent != nil {
            parentController = parentController?.parent
        }
        return self.superview?.convert(self.frame, to: nil)
    }
}
// MARK: - Loadviews
extension UIView {
    /*
     This func usually use for views like UITableViewCell, UICollectionViewCell
     */
    /// Load view from xib file only
    /// (Class must be set on xib)
    public class func fromNib() -> Self {
        return fromNib(nibName: nil)
    }
    
    @objc public class func fromNib(nibName: String?) -> Self {
        func fromNibHelper<T>(nibName: String?) -> T where T : UIView {
            let bundle = Bundle(for: T.self)
            let name = nibName ?? String(describing: T.self)
            return bundle.loadNibNamed(name, owner: nil, options: nil)?.first as? T ?? T()
        }
        return fromNibHelper(nibName: nibName)
    }
    /*
     This func usually use for custom uiview with init?(coder aDecoder: NSCoder)
     */
    /// Load view from file owner
    @discardableResult
    func loadViewFromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            // xib not loaded, or its top view is of the wrong type
            return nil
        }
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        constraintAll(to: contentView)
        return contentView
    }
  
    func constraintAll(to view: UIView) {
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
// MARK: - Localize
protocol Localizable {
    func displayLocalized()
}

extension UIView {
    struct PropertyKeys {
        static var LocalizeKey = "LocalizeKey"
    }
    
    @IBInspectable var localizedString: String? {
        get {
            return objc_getAssociatedObject(self, &PropertyKeys.LocalizeKey) as? String
        }
        
        set {
            objc_setAssociatedObject(self, &PropertyKeys.LocalizeKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            if let view = self as? Localizable {
                view.displayLocalized()
            }
        }
    }
    
    func updateLocalize() {
        if let view = self as? Localizable {
            view.displayLocalized()
        }
        subviews.forEach({$0.updateLocalize()})
    }
}

extension UILabel: Localizable {
    func displayLocalized() {
        guard let localizedString = localizedString,
              !localizedString.isEmpty else { return }
        self.text = localizedString.localized
    }
}

extension UIButton: Localizable {
    func displayLocalized() {
        guard let localizedString = localizedString,
              !localizedString.isEmpty else { return }
        let components = localizedString.components(separatedBy: ";")
        if let normalTitle = components[safe: 0] {
            setTitle(normalTitle.localized, for: .normal)
        }
        
        if let selectedTitle = components[safe: 1] {
            setTitle(selectedTitle.localized, for: .selected)
        }
    }
}

extension UITextField: Localizable {
    func displayLocalized() {
        guard let localizedString = localizedString,
              !localizedString.isEmpty else { return }
        self.attributedPlaceholder = AttributedStringBuilder(string: localizedString.localized)
            .addColor(color: .lightGray, forSubString: localizedString.localized)
            .build()
    }
}
// MARK: - Action
class ClickListener: UITapGestureRecognizer {
    var onClick : (() -> Void)? = nil
}

extension UIView {
    func onClick(action :@escaping () -> Void){
        let tapRecogniser = ClickListener(target: self, action: #selector(onViewClicked(sender:)))
        tapRecogniser.onClick = action
        tapRecogniser.cancelsTouchesInView = false
        self.addGestureRecognizer(tapRecogniser)
    }
    @objc func onViewClicked(sender: ClickListener) {
        if let onClick = sender.onClick {
            onClick()
        }
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        let rect = self.bounds
        mask.frame = rect
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func setBackgroundImage(named: String) {
        let backgroundImage = UIImageView(frame: self.frame)
        backgroundImage.image = UIImage(named: named)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.center = self.center
        backgroundImage.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        self.addSubview(backgroundImage)
        self.sendSubviewToBack(backgroundImage)
    }
}
