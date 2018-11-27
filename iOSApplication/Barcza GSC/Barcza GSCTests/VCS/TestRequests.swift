//
//  TestRequests.swift
//  Barcza GSCTests
//
//  Created by Grimm Dániel on 2018. 11. 27..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import XCTest
import PromiseKit
@testable import Barcza_GSC

class TestRequests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInitRequest(){
        let urlExpectation = expectation(description: "INIT TEST")
        let initVC = StarterVC()
        initVC.getNextMatchData().then { (completed) -> () in
            urlExpectation.fulfill()
        }
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testChampionshipRequest(){
        let urlExpectation = expectation(description: "CHAMPIONSHIP TEST")
        let championshipVC = ResultsVC()
        championshipVC.getAllTeams().then { (completed) -> () in
            urlExpectation.fulfill()
        }
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testTrainingsRequest(){
        let urlExpectation = expectation(description: "TRAININGS TEST")
        let trainingsVC = StarterVC()
        trainingsVC.getTrainingsData().then { (completed) -> () in
            urlExpectation.fulfill()
        }
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testNewsResuest(){
        let urlExpectation = expectation(description: "NEWS TEST")
        let newsVC = NewsVC()
        newsVC.getAllNews().then { (completed) -> () in
            urlExpectation.fulfill()
        }
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testGalleryRequest(){
        let urlExpectation = expectation(description: "GALLERY TEST")
        let galleryVC = GalleryVC()
        galleryVC.getGalleryPhotos().then { (completed) -> () in
            urlExpectation.fulfill()
        }
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testStandingsRequest(){
        let urlExpectation = expectation(description: "Standings TEST")
        let standingsVC = StandingsVC()
        standingsVC.getStandings().then { (completed) -> () in
            urlExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
