//
//  BbLoadingView.swift
//  BigBossIOS
//
//  Created by ECO0542-HoangNM on 28/02/2022.
//

import UIKit

let loadingViewTag = 1200
let activityIndicatorTag = 1201
class LoadingView {
    // MARK: - Singleton
    static var shared = LoadingView()
    private init() {}
    // MARK: - Properties
    
    // MARK: - Func
    func showLoading(loadingText: String = "") {
        guard let mainView = UIApplication.shared.windows[safe: 0] else { return }
        let existingView = mainView.viewWithTag(loadingViewTag)
        if existingView != nil {
            return
        }
        let loadingView = self.makeLoadingView( loadingText: loadingText)
        loadingView?.tag = loadingViewTag
        mainView.addSubview(loadingView!)
        NSLayoutConstraint.activate([
            loadingView?.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            loadingView?.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            loadingView?.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            loadingView?.topAnchor.constraint(equalTo: mainView.topAnchor)
        ].compactMap({$0}))
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            let existingView = UIApplication.shared.windows[0].viewWithTag(loadingViewTag)
            existingView?.removeFromSuperview()
        }
    }
    
    private func makeLoadingView(loadingText text: String?) -> UIView? {
        let loadingView = UIView(frame: .zero)
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.center = loadingView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        activityIndicator.style = .medium
        activityIndicator.startAnimating()
        activityIndicator.tag = activityIndicatorTag
        loadingView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100)
        ])
        if !text!.isEmpty {
            let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
            let cpoint = CGPoint(x: activityIndicator.frame.origin.x + activityIndicator.frame.size.width / 2, y: activityIndicator.frame.origin.y + 80)
            lbl.center = cpoint
            lbl.textColor = UIColor.white
            lbl.textAlignment = .center
            lbl.text = text
            lbl.tag = 1234
            loadingView.addSubview(lbl)
        }
        return loadingView
    }
}
