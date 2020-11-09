//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxSwift
import UIKit

class ViewController: UITableViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func exJust1() {
//        Observable.just("Hello World")
//            .subscribe(onNext: { str in // str == "Hello World"
//                print(str) // "Hello World"
//            })
//            .disposed(by: disposeBag)
        
        // subscribe: 최종적으로 그 데이터를 받아서 사용 할 때
//        Observable.from(["RxSwift", "In", "4", "Hours"])
//            .single() // 하나만 들어와야 함
//            .subscribe { event in
//                switch event {
//                case .next(let str): // 데이터 전달
//                    print("next: \(str)")
//                case .error(let err): // 에러 발생
//                    print("error: \(err.localizedDescription)")
//                case .completed:
//                    print("completed")
//                }
//            }
//            .disposed(by: disposeBag)
        
//        Observable.from(["RxSwift", "In", "4", "Hours"])
////            .single()
//            .subscribe { str in
//                print(str)
//            } onError: { error in
//                print(error.localizedDescription)
//            } onCompleted: {
//                print("completed")
//            } onDisposed: {
//                print("disposed")
//            }
//            .disposed(by: disposeBag)
        
        Observable.from(["RxSwift", "In", "4", "Hours"])
            .subscribe(onNext: output(_:))
            .disposed(by: disposeBag)
    }
    
    func output(_ str: Any) -> Void {
        print(str)
    }

    @IBAction func exJust2() {
        Observable.just(["Hello", "World"])
            .subscribe(onNext: { arr in
                print(arr) // "Hello", "World"
            })
            .disposed(by: disposeBag)
    }
    
    /*
     from
     
     */

    @IBAction func exFrom1() {
        Observable.from(["RxSwift", "In", "4", "Hours"])
            .subscribe(onNext: { str in
                print(str)
                /*
                 RxSwift
                 In
                 4
                 Hours
                 */
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap1() {
        Observable.just("Hello") // "Hello" 그대로 내려가기 때문에
            .map { str in "\(str) RxSwift" }
            .subscribe(onNext: { str in
                print(str) // "Hello RxSwift"
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap2() {
        Observable.from(["with", "곰튀김"])
            .map { $0.count }
            .subscribe(onNext: { str in
                print(str)
                /*
                 4
                 3
                 */
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exFilter() {
        Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
            .filter { $0 % 2 == 0 }
            .subscribe(onNext: { n in
                print(n)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap3() {
        // Main Thread -> Concurrency Thread
        // observeOn을 건 다음줄 부터 영향을 받게 됨
//        Observable.just("800x600")
//            .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .default)) // Concurrent Thread
//            .map { $0.replacingOccurrences(of: "x", with: "/") } // "800/600"
//            .map { "https://picsum.photos/\($0)/?random" } // "https://picsum.photos/800/600/?random"
//            .map { URL(string: $0) } // URL
//            .filter { $0 != nil } // nil인지 Check
//            .map { $0! } // 강제 언래핑
//            .map { try Data(contentsOf: $0) }
//            .map { UIImage(data: $0) }
//            .observeOn(MainScheduler.instance) // image를 setting 하는 곳이기에 Main Thread
//            .subscribe(onNext: { image in
//                self.imageView.image = image
//            })
//            .disposed(by: disposeBag)
        
        Observable.just("800x600")
            .map { $0.replacingOccurrences(of: "x", with: "/") }
            .map { "https://picsum.photos/\($0)/?random" }
            .map { URL(string: $0) }
            .filter { $0 != nil }
            .map { $0! }
            .map { try Data(contentsOf: $0) }
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .default))
            .map { UIImage(data: $0) }
            .observeOn(MainScheduler.instance)
            .do(onNext: { image in
                print(image?.size)
            })
            .subscribe(onNext: { image in
                self.imageView.image = image // side-effect
            })
            .disposed(by: disposeBag)
    }
}
