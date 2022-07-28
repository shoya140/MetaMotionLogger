//
//  RMWeakSet.swift
//  MetaMotionLogger
//
//  Created by Shoya Ishimaru on 2022/07/28.
//  Copyright © 2022 shoya140. All rights reserved.
//

import Foundation

public class RMWeakSet<T> {

    // =========================================== //
    // MARK: - Properties -

    public var all: [T] { objects }

    private var _objects = NSHashTable<AnyObject>.weakObjects()
    private var objects: [T] { _objects.allObjects.compactMap{$0 as? T}}

    // =========================================== //
    // MARK: - Methods -

    public func contains(object: T) -> Bool {
        return _objects.contains(object as AnyObject)
    }

    public func append(_ object: T) {

        self._objects.add(object as AnyObject)
    }

    public func append(objects: [T]) {
        for object in objects {
            _objects.add(object as AnyObject)
        }
    }

    public func remove(_ object: T)  {
        _objects.remove(object as AnyObject)
    }

    // =========================================== //
    // MARK: - Constructor -
    public init() {}

    public init(_ objects: [T]) {
        for object in objects {
            _objects.add(object as AnyObject)
        }
    }
}

extension RMWeakSet : Sequence {
    public typealias Iterator = Array<T>.Iterator

    public func makeIterator() -> Iterator {
        return self.objects.makeIterator()
    }
}
