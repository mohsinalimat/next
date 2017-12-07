//
//  Rx+Util.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType where E == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }

}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension ObservableType {

    func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { error in
            return Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }

}

protocol OptionalType {
    associatedtype Wrapped
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    var optional: Wrapped? { return self }
}

extension Observable where Element: OptionalType {
    func skipNil() -> Observable<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Observable<Element.Wrapped>.just($0) } ?? Observable<Element.Wrapped>.empty()
        }
    }
}

extension SharedSequenceConvertibleType where E: OptionalType {
    func skipNil() -> Driver<E.Wrapped> {
        return flatMap { value in
            value.optional.map { Driver<E.Wrapped>.just($0) } ?? Driver<E.Wrapped>.empty()
        }
    }
}
