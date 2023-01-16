//
//  NotificationViewController.swift
//  GapoChallenge
//
//  Created by Chu Hung on 15/01/2023.
//

import UIKit
import RxSwift
import RxCocoa

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var headerSearchView: UIView!
    @IBOutlet weak var closeSearchButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: NotificationViewModel!
    
    let disposeBag = DisposeBag()
    
    init(viewModel: NotificationViewModel) {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    private
    func setupUI() {
        notificationTableView.register(UINib(nibName: String(describing: NotificationCell.self), bundle: nil),
                                       forCellReuseIdentifier: String(describing: NotificationCell.self))
        setSearchUI()
    }
    
    private
    func setSearchUI() {
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .clear
        searchBar.searchTextField.font = .systemFont(ofSize: 16)
        searchBar.searchTextField.backgroundColor = .clear
    }
    
    private
    func bind() {
        bindSearchView()
        bindTableView()
    }
    
    private
    func bindTableView() {
        viewModel.notifications.drive(notificationTableView.rx.items(cellIdentifier: String(describing: NotificationCell.self),
                                                                     cellType: NotificationCell.self)) {
            (index, item, cell) in
            cell.setData(item)
        }.disposed(by: disposeBag)
        
        notificationTableView.rx.modelSelected(NotificationData.self).subscribe { [weak self] notificationData in
            guard let self = self else { return }
            self.viewModel.doReadNotification(notificationData)
        }.disposed(by: disposeBag)
    }
    
    private
    func bindSearchView() {
        searchButton.rx.tap.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.searchView.isHidden = false
            self.headerSearchView.isHidden = true
        }.disposed(by: disposeBag)
        
        closeSearchButton.rx.tap.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.searchView.isHidden = true
            self.headerSearchView.isHidden = false
            self.searchBar.text = nil
            self.searchBar.searchTextField.sendActions(for: .editingChanged)
        }.disposed(by: disposeBag)
        
        searchBar.rx.text
            .orEmpty
            .bind(to: self.viewModel.searchObserver)
            .disposed(by: disposeBag)
    }
}
