//
//  FirebaseDatabase+Rx.swift
//  Next
//
//  Created by Guilherme Souza on 14/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseDatabase

extension Reactive where Base: DatabaseReference {
    func updateChildValues(_ values: [AnyHashable: Any]) -> Observable<DatabaseReference> {
        return Observable.create { observer in
            self.base.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(ref)
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        }
    }

    func setValue(_ value: Any?) -> Observable<DatabaseReference> {
        return Observable.create { observer in
            self.base.setValue(value, withCompletionBlock: { (error, ref) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(ref)
                    observer.onCompleted()
                }
            })
            return Disposables.create()
        }
    }
}

extension Reactive where Base: DatabaseQuery {
    func observe(_ eventType: DataEventType) -> Observable<DataSnapshot> {
        return Observable.create { observer in
            let handle = self.base.observe(eventType, with: { snapshot in
                observer.onNext(snapshot)
            }, withCancel: { error in
                observer.onError(error)
            })

            return Disposables.create {
                self.base.removeObserver(withHandle: handle)
            }
        }
    }

    func observeSingleEvent(of eventType: DataEventType) -> Observable<DataSnapshot> {
        return Observable.create { observer in
            self.base.observeSingleEvent(of: eventType, with: { snapshot in
                observer.onNext(snapshot)
                observer.onCompleted()
            }, withCancel: { error in
                observer.onError(error)
            })

            return Disposables.create()
        }
    }
}
