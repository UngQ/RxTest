//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class PasswordViewController: UIViewController {
   
	let viewModel = PasswordViewModel()

    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
	let descriptionLabel = UILabel()


	let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()

		bind()

    }

    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
		view.addSubview(descriptionLabel)

        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

		descriptionLabel.snp.makeConstraints { make in
			make.height.equalTo(20)
			make.top.equalTo(passwordTextField.snp.bottom)
			make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
		}

        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

	func bind() {
		viewModel.validText
			.bind(to: descriptionLabel.rx.text)
			.disposed(by: bag)

		let validation = passwordTextField.rx.text.orEmpty.map { $0.count >= 8 }

		validation
			.bind(to: nextButton.rx.isEnabled, descriptionLabel.rx.isHidden)
			.disposed(by: bag)

		validation
			.bind(with: self) { owner, value in
				let color: UIColor = value ? .systemPink : .lightGray
				owner.nextButton.backgroundColor = color
			}
			.disposed(by: bag)

		nextButton.rx
			.tap
			.bind(with: self) { owner, _ in
				print("show alert")
				owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
			}
			.disposed(by: bag)
	}

}
