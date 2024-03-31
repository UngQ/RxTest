//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")

	var email = BehaviorSubject(value: "leevwe@naver.com")
	let buttonColor = Observable.just(UIColor.systemGreen)

	let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()

		bind()



    }
    

    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

	func bind() {
		email.bind(to: emailTextField.rx.text)
			.disposed(by: bag)

		buttonColor.bind(to: nextButton.rx.backgroundColor,
						 emailTextField.rx.tintColor,
						 emailTextField.rx.textColor)
		.disposed(by: bag)

		buttonColor.map { $0.cgColor }
			.bind(to: emailTextField.layer.rx.borderColor)
			.disposed(by: bag)

		validationButton.rx
			.tap.bind(with: self) { owner, _ in
				owner.email.onNext("whalsrud4607@naver.com")
			}
			.disposed(by: bag)

		nextButton.rx
			.tap.bind(with: self) { owner, _ in
				owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
			}
			.disposed(by: bag)

	}


}
