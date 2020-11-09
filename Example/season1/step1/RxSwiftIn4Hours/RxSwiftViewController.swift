//
//  RxSwiftViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxSwift
import UIKit

class RxSwiftViewController: UIViewController {
    // MARK: - Field

    var counter: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.counter += 1
            self.countLabel.text = "\(self.counter)"
        }
    }

    // MARK: - IBOutlet

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var countLabel: UILabel!

    // MARK: - IBAction
    
//    var disposable: Disposable?
    var disposeBag: DisposeBag = DisposeBag()

    @IBAction func onLoadImage(_ sender: Any) {
        imageView.image = nil

        let disposable = rxswiftLoadImage(from: LARGER_IMAGE_URL)
            .observeOn(MainScheduler.instance) // MainScheduler == DispatchQueue.main
            .subscribe({ result in  // Disposable
                switch result {
                case let .next(image):
                    self.imageView.image = image

                case let .error(err):
                    print(err.localizedDescription)

                case .completed:
                    break
                }
            })
//        disposeBag.insert(disposable)     // bag에 넣는 1번째 방법
        disposable.disposed(by: disposeBag) // bag에 넣는 2번째 방법
    }

    @IBAction func onCancel(_ sender: Any) {
        // TODO: cancel image loading
//        disposable?.dispose()
        disposeBag = DisposeBag() // dispose 해줌
    }

    // MARK: - RxSwift

    func rxswiftLoadImage(from imageUrl: String) -> Observable<UIImage?> {
        return Observable.create { seal in
            asyncLoadImage(from: imageUrl) { image in
                seal.onNext(image)
                seal.onCompleted()
            }
            return Disposables.create()
        }
    }
}
