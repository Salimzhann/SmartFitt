//
//  ChatViewController.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 14.02.2026.
//

import UIKit
import SnapKit

protocol IChatView: AnyObject {
    
    var presenter: IChatPresenter? { get set }
    
    func updateMessages(_ messages: [ChatMessageViewModel])
}


final class ChatViewController: UIViewController {

    var presenter: IChatPresenter?

    private var messages: [ChatMessageViewModel] = []
    private var inputBottomConstraint: Constraint?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    private let inputViewContainer = ChatInputView()
    private lazy var profileView: TrainerNavigationBar = {
        let profile = TrainerNavigationBar()
        profile.onDeleteHistory = { [weak presenter] in
            presenter?.deleteHistory()
        }
        return profile
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardObservers()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        if profileView.superview == nil {
            view.addSubview(profileView)
        }
        profileView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(inputViewContainer)
        inputViewContainer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            inputBottomConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8).constraint
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(inputViewContainer.snp.top).offset(-8)
        }

        inputViewContainer.sendButton.addTarget(
            self,
            action: #selector(sendTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func sendTapped() {
        guard let text = inputViewContainer.textField.text, !text.isEmpty else { return }
        presenter?.sendMessage(text)
        inputViewContainer.textField.text = nil
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }

        inputBottomConstraint?.update(inset: 8)

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }

        let keyboardHeight = frame.height
        let bottomInset = keyboardHeight - view.safeAreaInsets.bottom

        inputBottomConstraint?.update(inset: bottomInset + 8)

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
            self.scrollToBottom()
        }
    }
    
    private func scrollToBottom() {
        guard !messages.isEmpty else { return }
        tableView.scrollToRow(
            at: IndexPath(row: messages.count - 1, section: 0),
            at: .bottom,
            animated: false
        )
    }
}


extension ChatViewController: IChatView {
    
    func updateMessages(_ messages: [ChatMessageViewModel]) {
        self.messages = messages
        tableView.reloadData()
        
        guard !messages.isEmpty else { return }
        tableView.scrollToRow(
            at: IndexPath(row: messages.count - 1, section: 0),
            at: .bottom,
            animated: true
        )
    }
}


extension ChatViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatMessageCell.reuseId,
            for: indexPath
        ) as! ChatMessageCell

        cell.configure(with: messages[indexPath.row])
        return cell
    }
}
