//
//  PhoneViewController.swift
//  RxLoginProject
//
//  Created by Seryun Chun on 2024/03/28.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PhoneViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let defaultNumber = Observable.just("010")
    private let validText = Observable.just("전화번호는 10자 이상 숫자만 입력해주세요")

    // MARK: - UI Properties
    
    private let phoneNumberTextField = {
        let tf = UITextField()
        tf.placeholder = "전화번호를 입력해주세요"
        tf.backgroundColor = .darkGray
        tf.clipsToBounds = true
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    private let nextButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("다음", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let validLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemRed
        return label
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        bind()
    }
    
    // MARK: - Methods
    
    private func bind() {
        defaultNumber
            .bind(to: phoneNumberTextField.rx.text)
            .disposed(by: disposeBag)
        
        let isValid = phoneNumberTextField.rx.text
            .orEmpty
            .map { $0.count >= 10 && Int($0) != nil }
            
        isValid.bind(to: nextButton.rx.isEnabled,
                     validLabel.rx.isHidden)
        .disposed(by: disposeBag)
        
        isValid.bind(with: self) { owner, value in
            let color: UIColor = value ? .systemPink : .lightGray
            owner.nextButton.backgroundColor = color
        }
        .disposed(by: disposeBag)
        
        validText
            .bind(to: validLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func configureLayout() {
        view.addSubview(phoneNumberTextField)
        phoneNumberTextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(50)
        }
        
        view.addSubview(validLabel)
        validLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(phoneNumberTextField)
            make.height.equalTo(20)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(validLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(phoneNumberTextField)
            make.height.equalTo(50)
        }
    }

}
