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
//    var menuObservable = PublishSubject<[Menu]>()
    var menuObservable = BehaviorSubject<[Menu]>(value: [])
    
    lazy var itemsCount = menuObservable.map {
        $0.map { $0.count }.reduce(0, +)
    }
    
    lazy var totalPrice = menuObservable.map {
        $0.map { $0.price * $0.count }.reduce(0, +)
    }
    
    init() {
        _ = APIService.fetchAllMenusRx()
            .map { data -> [MenuItem] in
                struct Response: Decodable {
                    let menus: [MenuItem]
                }
                
                let response = try! JSONDecoder().decode(Response.self, from: data)
                
                return response.menus
            }
            .map { menuItems -> [Menu] in
                var menus: [Menu] = []
                menuItems.enumerated().forEach { (index, item) in
                    let menu = Menu.fromMenuItems(id: index, item: item)
                    menus.append(menu)
                }
                return menus
            }
            .take(1)
            .bind(to: menuObservable)
    }
    
    func onOrder() {
        
    }
    
    func clearAllItemSelections() {
        _ = menuObservable
            .map { menus in
                return menus.map { m in
                    Menu(id: m.id, name: m.name, price: m.price, count: 0)
                }
            }
            .take(1)
            .subscribe(onNext: {
                self.menuObservable.onNext($0)
            })
    }
    
    func changeCount(_ item: Menu, _ increase: Int) {
        _ = menuObservable
            .map { menus in
                return menus.map { m in
                    if m.id == item.id {
                        return Menu(id: m.id,
                             name: m.name,
                             price: m.price,
                             count: max(m.count + increase, 0))
                    } else {
                        return Menu(id: m.id,
                             name: m.name,
                             price: m.price,
                             count: m.count)
                    }
                }
            }
            .take(1)
            .subscribe(onNext: {
                self.menuObservable.onNext($0)
            })
    }
}

/*
 Observable.just로 했을 경우 단순히 입력해놓은 값만 전달해주기 때문에,
 값을 컨트롤 할 순 없을까? 했던 것이 Subject이다.
 
 Subject => Obervable 밖에서 컨트롤 할 수 있게 해주는 것
 
 연결 관계를 Stream 이라고 한다.
 
 * MVVM
 
 */
