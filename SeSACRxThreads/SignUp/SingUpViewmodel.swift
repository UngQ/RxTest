//
//  SingUpViewmodel.swift
//  SeSACRxThreads
//
//  Created by ungQ on 4/4/24.
//

import Foundation
import RxSwift
import RxCocoa

class SingUpViewmodel {

	let inputEmail = BehaviorSubject(value: "leevwe@naver.com")

	let inputValidationButtonTap = PublishRelay<Void>()

	let bag = DisposeBag()

	init() {

		inputValidationButtonTap.bind(with: self) { owner, _ in
			owner.inputEmail.onNext("whalsrud4607@naver.com")
		}
		.disposed(by: bag)

	}

	
}
