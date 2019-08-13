//
//  MenuViewModelTest.swift
//  RxSwift+MVVMTests
//
//  Created by iamchiwon on 13/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxBlocking
import RxSwift
import XCTest

class TestStore: MenuFetchable {
    func fetchMenus() -> Observable<[MenuItem]> {
        let menus = [
            MenuItem(name: "A", price: 100),
            MenuItem(name: "B", price: 200),
        ]
        return Observable.just(menus)
    }
}

class MenuViewModelTest: XCTestCase {
    var viewModel: MenuViewModel!

    override func setUp() {
        viewModel = MenuViewModel()
        viewModel.domain = TestStore()
    }

    func testFetching() {
        viewModel.viewDidLoad()
        
        let viewMenus = [
            ViewMenu(name: "A", price: 100, count: 0),
            ViewMenu(name: "B", price: 200, count: 0),
        ]
        let fetched = try! viewModel.allMenus().toBlocking().first()!
        XCTAssertEqual(viewMenus, fetched)
    }
    
    func testTotalPrice() {
        viewModel.viewDidLoad()
        
        viewModel.increaseMenuCount(index: 0, increasement: 1) // 100 * 1
        viewModel.increaseMenuCount(index: 1, increasement: 2) // 200 * 2
        
        let totalPrice = try! viewModel.totalPrice().toBlocking().first()!
        XCTAssertEqual(totalPrice, 500.currencyKR())
    }
}
