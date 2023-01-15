//
//  NotificationAPIService.swift
//  GapoChallenge
//
//  Created by Chu Hung on 15/01/2023.
//

import Foundation
import RxSwift

class NotificationAPIService {
    
    static let shared = NotificationAPIService()
    
    private var notificationsCache = [NotificationData]()

    func fetchNotifications() -> Observable<[NotificationData]> {
        if let url = Bundle.main.url(forResource: "noti", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let notificationResponse = try decoder.decode(NotificationResponse.self, from: data)
                notificationsCache = notificationResponse.data
                return Observable.create { observer -> Disposable in
                    observer.onNext(notificationResponse.data)
                    observer.onCompleted()
                    return Disposables.create()
                }
            } catch {
                return Observable.create { [unowned self] observer -> Disposable in
                    observer.onNext(self.notificationsCache)
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
        } else {
            return Observable.create { [unowned self] observer -> Disposable in
                observer.onNext(self.notificationsCache)
                observer.onCompleted()
                return Disposables.create()
            }
        }
    }
}
