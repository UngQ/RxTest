//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa


class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")

	let phoneNumber = BehaviorSubject(value: 010)

	let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()

		bind()

        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }

    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }


	func bind() {
		phoneNumber.map { "0" + String($0) }
			.bind(to: phoneTextField.rx.text)
			.disposed(by: bag)

		let validation = phoneTextField.rx.text.orEmpty.map { $0.count >= 10 }

		validation
			.bind(to: nextButton.rx.isEnabled)
			.disposed(by: bag)

		validation.bind(with: self) { owner, value in
			let color: UIColor = value ? UIColor.systemPink : UIColor.black
			owner.nextButton.backgroundColor = color
		}
		.disposed(by: bag)


	}

}
