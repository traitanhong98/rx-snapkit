//
//  H_MultiTableView.swift
//  CustomViews
//
//  Created by ECO0542-HoangNM on 19/05/2022.
//

import UIKit

var keyScrollViewTag: Int = 500
var keyTableViewTag: Int {
    keyScrollViewTag + 500
}
var keyTableHeaderViewTag: Int {
    keyTableViewTag + 500
}

@objc protocol HMultiTableViewDataSource: AnyObject {
    func numberOfColumn(inTableView tableView: HMultiTableView) -> Int
    @objc optional func numberOfSection(inTableView tableView: HMultiTableView) -> Int
    func multiTableView(_ multiTableView: HMultiTableView, numberOfRowAt column: Int) -> Int
    func multiTableView(_ multiTableView: HMultiTableView, cellForRowAt indexPath: IndexPath, withColumn column: Int) -> UITableViewCell
}

@objc protocol HMultiTableViewDelegate: AnyObject {
    func multiTableView(_ tableView: HMultiTableView, widthForColumn column: Int) -> CGFloat
    func multiTableView(widthOfContent width: CGFloat, forColumn column: Int) -> CGFloat
    // Big header
    @objc optional func multiTableView(_ tableView: HMultiTableView, heightForHeaderAt column: Int) -> CGFloat
    @objc optional func multiTableView(_ tableView: HMultiTableView, viewForHeaderAt column: Int) -> UIView
    // SectionHeader
    @objc optional func multiTableView(_ tableView: HMultiTableView, heightForHeaderInSection section: Int) -> CGFloat
    @objc optional func multiTableView(_ tableView: HMultiTableView, viewForHeaderInSection section: Int, withColumn column: Int) -> UIView
    // SectionFooter
    @objc optional func multiTableView(_ tableView: HMultiTableView, heightForFooterInSection section: Int) -> CGFloat
    @objc optional func multiTableView(_ tableView: HMultiTableView, viewForFooterInSection section: Int, withColumn column: Int) -> UIView
    // For Row
    @objc optional func multiTableView(_ tableView: HMultiTableView, heighForRowAt indexPath: IndexPath) -> CGFloat
    @objc optional func multiTableView(_ tableView: HMultiTableView, didSelectRowAt indexPath: IndexPath, withColumn column: Int)
    // For scroll
    @objc optional func scrollViewDidScroll(_ scrollView: UIScrollView, contentOffset: CGPoint)
}

class HMultiTableView: UIView {
    
    weak var dataSource: HMultiTableViewDataSource? {
        didSet {
            self.initBaseView()
        }
    }
    weak var delegate: HMultiTableViewDelegate? {
        didSet {
            
        }
    }
    // MARK: - LifeCycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initBaseView() {
        guard let dataSource = dataSource else {
            return
        }
        subviews.forEach({$0.removeFromSuperview()})
        let numberOfColumn = dataSource.numberOfColumn(inTableView: self)
        for i in 0..<numberOfColumn {
            let scrollView = UIScrollView()
            scrollView.tag = keyScrollViewTag + i
            scrollView.backgroundColor = .clear
            scrollView.isDirectionalLockEnabled = true
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.contentSize = CGSize(width: 0, height: scrollView.contentSize.height)
            scrollView.bounces = false
            scrollView.delegate = self
            
            // Table
            let tableView = UITableView()
            tableView.backgroundColor = .clear
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
            tableView.tag = keyTableViewTag + i
            tableView.delegate = self
            tableView.dataSource = self
            tableView.keyboardDismissMode = .onDrag
            tableView.autoresizesSubviews = true
            tableView.separatorStyle = .none
            tableView.backgroundColor = .clear
            tableView.tableFooterView = UIView(frame: .zero)
            tableView.bounces = false
            scrollView.addSubview(tableView)
            
            self.addSubview(scrollView)
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
        }
    }
    
    private func reframeBaseView() {
        guard let delegate = delegate,
              let dataSource = dataSource else {
            return
        }
        let numberOfColumn = dataSource.numberOfColumn(inTableView: self)
        var offsetX: CGFloat = 0
        for column in 0..<numberOfColumn {
            if let scrollView = viewWithTag(keyScrollViewTag + column) as? UIScrollView {
                
                let widthForColumn = delegate.multiTableView(self, widthForColumn: column)
                let contentWidth = delegate.multiTableView(widthOfContent: widthForColumn, forColumn: column)
                let headerHeight = delegate.multiTableView?(self, heightForHeaderAt: column) ?? 0
                
                scrollView.frame = .init(x: offsetX,
                                         y: headerHeight,
                                         width: widthForColumn,
                                         height: frame.height)
                scrollView.contentSize = .init(width: contentWidth, height: scrollView.frame.height)
                var headerView = viewWithTag(keyTableHeaderViewTag + column)
                if headerView == nil,
                   let newHeaderView = delegate.multiTableView?(self, viewForHeaderAt: column) {
                    headerView = newHeaderView
                    scrollView.addSubview(newHeaderView)
                }
                if let headerView = headerView {
                    var frame = headerView.frame
                    frame.size.height = headerHeight
                    frame.size.width = contentWidth
                    headerView.frame = frame
                }
                
                if let tableView = viewWithTag(keyTableViewTag + column) {
                    
                    tableView.frame = .init(x: tableView.frame.origin.x,
                                            y: tableView.frame.origin.y,
                                            width: contentWidth,
                                            height: scrollView.frame.height)
                }
                offsetX += widthForColumn
            }
        }
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reframeBaseView()
    }
    
    // MARK: - Catagory Instances methods
    func tableForColumn(_ column: Int) -> UITableView? {
        return viewWithTag(keyScrollViewTag + column)?.viewWithTag(keyTableViewTag + column) as? UITableView
    }
    func scrollViewForColumn(_ column: Int) -> UIScrollView? {
        return viewWithTag(keyScrollViewTag + column) as? UIScrollView
    }
    
    // MARK: - InstanceMethod
    func reuseHeaderForColumn(_ column: Int) -> UIView? {
        let scrollview = viewWithTag(keyScrollViewTag + column)
        return scrollview?.viewWithTag(keyTableHeaderViewTag + column)
    }
    
    func getVisibleCellsForColumn(_ column: Int) -> [UITableViewCell]? {
        return tableForColumn(column)?.visibleCells
    }
    
    func reloadBaseView() {
        initBaseView()
        reframeBaseView()
        reloadData()
    }
    
    func reloadData() {
        if let numberOfColumn = dataSource?.numberOfColumn(inTableView: self) {
            for column in 0..<numberOfColumn {
                self.tableForColumn(column)?.reloadData()
            }
        }
    }
    
    func scrollToRowAtIndexPath(_ indexPath: IndexPath, atScrollPosition position: UITableView.ScrollPosition, animated: Bool) {
        if let numberOfColumn = dataSource?.numberOfColumn(inTableView: self) {
            for column in 0..<numberOfColumn {
                self.tableForColumn(column)?.scrollToRow(at: indexPath, at: position, animated: animated)
            }
        }
    }
}
// MARK: - UITableViewDataSource
extension HMultiTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSection?(inTableView: self) ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let column = tableView.tag - keyTableViewTag
        return dataSource?.multiTableView(self, numberOfRowAt: column) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let column = tableView.tag - keyTableViewTag
        return dataSource?.multiTableView(self, cellForRowAt: indexPath, withColumn: column) ?? UITableViewCell()
    }
}
// MARK: - UITableViewDelegate
extension HMultiTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let column = tableView.tag - keyTableViewTag
        delegate?.multiTableView?(self, didSelectRowAt: indexPath, withColumn: column)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        delegate?.multiTableView?(self, heighForRowAt: indexPath) ?? UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        delegate?.multiTableView?(self, heightForHeaderInSection: section) ?? 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let column = tableView.tag - keyTableViewTag
        return delegate?.multiTableView?(self, viewForHeaderInSection: section, withColumn: column)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        delegate?.multiTableView?(self, heightForFooterInSection: section) ?? 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let column = tableView.tag - keyTableViewTag
        return delegate?.multiTableView?(self, viewForFooterInSection: section, withColumn: column)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let column = tableView.tag - keyTableViewTag
        delegate?.multiTableView?(self, didSelectRowAt: indexPath, withColumn: column)
    }
}

extension HMultiTableView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let dataSource = dataSource else {
            return
        }
        let contentOffset = scrollView.contentOffset
        let numberOfColumn = dataSource.numberOfColumn(inTableView: self)
        for i in 0..<numberOfColumn {
            if let tableView = tableForColumn(i) {
                tableView.contentOffset.y = contentOffset.y
            }
            if scrollView.tag == keyScrollViewTag + i {
                delegate?.scrollViewDidScroll?(scrollView, contentOffset: contentOffset)
            }
        }
    }
}
