//
//  ViewController.swift
//  RxLoginProject
//
//  Created by Seryun Chun on 2024/03/28.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PasswordViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let validText = Observable.just("비밀번호는 8자 이상 입력해주세요")
    
    // MARK: - UI Properties
    
    private let passwordTextField = {
        let tf = UITextField()
        tf.placeholder = " 비밀번호를 입력해주세요"
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
        let isValid = passwordTextField.rx.text
            .orEmpty
            .map { $0.count >= 8 }
        
        isValid.bind(to: nextButton.rx.isEnabled,
                     validLabel.rx.isHidden)
        .disposed(by: disposeBag)
        
        isValid.bind(with: self) { owner, value in
            let buttonColor: UIColor = value ? .systemPink : .lightGray
            owner.nextButton.backgroundColor = buttonColor
        }
        .disposed(by: disposeBag)
        
        validText
            .bind(to: validLabel.rx.text)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureLayout() {
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(50)
        }
        
        view.addSubview(validLabel)
        validLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(passwordTextField)
            make.height.equalTo(20)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(validLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(passwordTextField)
            make.height.equalTo(50)
        }
    }
}

