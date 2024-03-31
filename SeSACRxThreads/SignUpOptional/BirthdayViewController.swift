//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")

	let year = PublishSubject<Int>()
	let month = PublishSubject<Int>()
	let day = PublishSubject<Int>()

	let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()

		bind()

        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    @objc func nextButtonClicked() {
        print("가입완료")
    }

    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

	func bind() {

		year.map { "\($0)년" }
			.bind(to: yearLabel.rx.text)
			.disposed(by: bag)

		month.map { "\($0)월" }
			.bind(to: monthLabel.rx.text)
			.disposed(by: bag)

		day.map { "\($0)일" }
			.bind(to: dayLabel.rx.text)
			.disposed(by: bag)

		birthDayPicker.rx.date
			.bind(with: self) { owner, date in
				let component = Calendar.current.dateComponents([.year, .month, .day], from: date)

				guard let year = component.year, let month = component.month, let day = component.day else { return }

				owner.year.onNext(year)
				owner.month.onNext(month)
				owner.day.onNext(day)

			}
			.disposed(by: bag)

		let validation = birthDayPicker.rx.date.map { date in
			let calendar = Calendar.current
			let currentDate = Date()
			let date17YearsAgo = calendar.date(byAdding: .year, value: -17, to: currentDate)!

			return date <= date17YearsAgo
		}

		validation.bind(to: nextButton.rx.isEnabled)
			.disposed(by: bag)

		validation.bind(with: self) { owner, value in
			let color: UIColor = value ? .blue : .lightGray
			owner.nextButton.backgroundColor = color

			let infoText: String = value ? "가입 가능한 나이입니다." : "만 17세 이상만 가입 가능합니다"
			owner.infoLabel.text = infoText

			let infoTextColor: UIColor = value ? .blue : .red
			owner.infoLabel.textColor = infoTextColor
		}
		.disposed(by: bag)

		nextButton.rx.tap
			.bind(with: self) { owner, _ in
				let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
				let sceneDelegate = windowScene?.delegate as? SceneDelegate

				let vc = SampleViewController()
				let nav = UINavigationController(rootViewController: vc)

				sceneDelegate?.window?.rootViewController = nav
				sceneDelegate?.window?.makeKeyAndVisible()

			}
			.disposed(by: bag)




	}

//	생일 이전
//	(현재 연도)-(출생연도)-1=(나이)
//	예) 2024(현재 연도)-2000(출생연도)-1=23세(나이)
//
//	생일 이후
//	(현재 연도)-(출생연도)=(나이)
//	예) 2024(현재 연도)-2000(출생연도)=24세(나이)

}
