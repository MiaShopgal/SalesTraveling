//
//  DataManagerTests.swift
//  SalesTravelingTests
//
//  Created by Mia Yu on 2024/1/23.
//  Copyright © 2024 Hanyu. All rights reserved.
//

import MapKit
@testable import Shoto
import XCTest

class DataManagerTests: XCTestCase {

    func test_fetchDirections_succeedsWhenAllRequestSucceeds() {

        let new = HYCPlacemark(name: "new")

        let currnetToNew = DirectionModel(source: HYCPlacemark(name: "current"), destination: new, routes: [MKRoute()])
        let oldToNew1 = DirectionModel(source: HYCPlacemark(name: "old 1"), destination: new, routes: [MKRoute()])
        let newToOld1 = DirectionModel(source: oldToNew1.source, destination: new, routes: [MKRoute()])
        let oldToNew2 = DirectionModel(source: HYCPlacemark(name: "old 2"), destination: new, routes: [MKRoute()])
        let newToOld2 = DirectionModel(source: oldToNew2.source, destination: new, routes: [MKRoute()])

        let sut = DataManager(directionsFetcher: { source, destination, completion in
            completion(.success([MKRoute()]))
        })

        let exp = expectation(description: "wait for fetch completion")

        sut.fetchDirections(ofNew: new, toOld: [oldToNew1.source, oldToNew2.source], current: currnetToNew.source) { result in
            switch result {
                case let .success(directions):
//                    XCTAssertEqual(directions, [currnetToNew,
//                                                oldToNew1,
//                                                newToOld1,
//                                                oldToNew2,
//                                                newToOld2])
                    
                    XCTAssertEqual(directions.count, 5)
                    XCTAssertTrue(directions.contains(currnetToNew), "missing currnetToNew")
                    XCTAssertTrue(directions.contains(oldToNew1), "missing oldToNew1")
                    XCTAssertTrue(directions.contains(newToOld1), "missing newToOld1")
                    XCTAssertTrue(directions.contains(oldToNew2), "missing oldToNew2")
                    XCTAssertTrue(directions.contains(newToOld2), "missing newToOld2")
                    
                case let .failure(error):
                    XCTFail("failed with error :\(error)")
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 0.1)

    }
}
