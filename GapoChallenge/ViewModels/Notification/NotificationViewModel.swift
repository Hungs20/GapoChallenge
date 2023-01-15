//
//  NotificationViewModel.swift
//  GapoChallenge
//
//  Created by Chu Hung on 15/01/2023.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class NotificationViewModel {
    // MARK: Variables
    private var originNotifications = [NotificationData]()
    private var filterNotifications = [NotificationData]()
    
    private let notificationRelay = BehaviorRelay<[NotificationData]>.init(value: [])
    var notifications : Driver<[NotificationData]> {
        return notificationRelay.asDriver(onErrorJustReturn: [])
    }
    
    // Search
    private let searchSubject = PublishSubject<String>()
    var searchObserver: AnyObserver<String> {
        return searchSubject.asObserver()
    }
    
    private let disposeBag = DisposeBag()
    
    init() {
        
        fetchNotification()
        
        searchSubject.asObserver()
            .distinctUntilChanged()
            .debounce(RxTimeInterval.milliseconds(200), scheduler: MainScheduler.instance)
            .flatMapLatest { [unowned self] searchValue -> Observable<[NotificationData]> in
                return self.doSearch(searchValue)
            }
            .subscribe { [weak self] notifications in
                guard let self = self else { return }
                self.notificationRelay.accept(notifications)
            }
            .disposed(by: disposeBag)
    }
}

extension NotificationViewModel {
    // MARK: Action
    
    func fetchNotification() {
        NotificationAPIService.shared.fetchNotifications().subscribe { [weak self] notifications in
            guard let self = self else { return }
            self.originNotifications = notifications
            self.notificationRelay.accept(notifications)
        }.disposed(by: disposeBag)
    }
    
    func doSearch(_ searchValue: String) -> Observable<[NotificationData]> {
        var filterNotifications = originNotifications
        if !searchValue.isEmpty {
            filterNotifications = originNotifications.filter {
                return ($0.message?.text ?? "").lowercased().range(of: searchValue.lowercased(), options: .diacriticInsensitive) != nil
            }
        }
        return Observable.create { (observer) -> Disposable in
            observer.onNext(filterNotifications)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func doReadNotification(_ notificationData: NotificationData) {
        notificationData.updateReadStatus()
        notificationRelay.accept(notificationRelay.value)
    }
}
