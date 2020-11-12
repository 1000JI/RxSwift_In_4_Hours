//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by 천지운 on 2020/11/12.
//  Copyright © 2020 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift

class MenuListViewModel {
    var menus: [Menu] = [
        Menu(name: "테스트1", price: 100, count: 0),
        Menu(name: "테스트2", price: 100, count: 0),
        Menu(name: "테스트3", price: 100, count: 0),
        Menu(name: "테스트4", price: 100, count: 0),
        Menu(name: "테스트5", price: 100, count: 0)
    ]
    
    var itemsCount: Int = 5
    var totalPrice: PublishSubject<Int> = PublishSubject()
}

/*
 Observable.just로 했을 경우 단순히 입력해놓은 값만 전달해주기 때문에,
 값을 컨트롤 할 순 없을까? 했던 것이 Subject이다.
 
 Subject => Obervable 밖에서 컨트롤 할 수 있게 해주는 것
 */
