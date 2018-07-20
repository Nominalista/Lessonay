//
// Created by Nominalista on 02.05.2018.
// Copyright (c) 2018 Nominalista. All rights reserved.
//

import DesignExtensions
import UIKit
import RxCocoa
import RxSwift

private let convexityImageViewAlpha: CGFloat = 0.5
private let convexityImageViewSize = CGSize(width: 250, height: 250)
private let playButtonSize = CGSize(width: 48, height: 48)
private let topComponentsContainerHeightMultiplier: CGFloat = 0.33
private let bottomComponentsContainerHeightMultiplier: CGFloat = 0.66

class HomeViewController: UIViewController {

    private lazy var topComponentsContainer = UIView()

    private lazy var labelContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = .margin
        stackView.alignment = .center
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title".localized()
        label.textColor = .primary
        label.font = .display
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "subtitle".localized()
        label.textColor = .primary
        label.font = .subhead
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var bottomComponentsContainer = UIView()

    private lazy var convexityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.convexity
        imageView.alpha = convexityImageViewAlpha
        return imageView
    }()

    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.tintColor = .primary
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: .marginExtraSmall)
        button.layer.shadowRadius = .marginExtraSmall
        button.layer.shadowOpacity = 0.5
        return button
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.primary.withAlphaComponent(0.5)
        label.font = .body
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let navigator: ApplicationNavigator
    private let automaton: ApplicationAutomaton
    private let disposeBag = DisposeBag()

    init(navigator: ApplicationNavigator, automaton: ApplicationAutomaton) {
        self.navigator = navigator
        self.automaton = automaton
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundColor()
        setupTopComponentsContainer()
        setupLabelContainer()
        setupTitleLabel()
        setupSubtitleLabel()
        setupBottomComponentsContainer()
        setupMessageLabel()
        setupConvexityImageView()
        setupIndicatorView()
        setupActionButton()
        bindToAutomaton()
        requestLesson()
    }

    private func setupBackgroundColor() {
        view.backgroundColor = .background
    }

    private func setupTopComponentsContainer() {
        view.addSubview(topComponentsContainer)
        topComponentsContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                leading: view.leadingAnchor,
                trailing: view.trailingAnchor)
        topComponentsContainer.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                multiplier: topComponentsContainerHeightMultiplier).isActive = true
    }

    private func setupLabelContainer() {
        topComponentsContainer.addSubview(labelContainer)
        labelContainer.anchor(leading: topComponentsContainer.leadingAnchor,
                trailing: topComponentsContainer.trailingAnchor,
                leadingConstant: .marginLarge,
                trailingConstant: .marginLarge)
        labelContainer.anchorCenterYToSuperview()
    }

    private func setupTitleLabel() {
        labelContainer.addArrangedSubview(titleLabel)
    }

    private func setupSubtitleLabel() {
        labelContainer.addArrangedSubview(subtitleLabel)
    }

    private func setupBottomComponentsContainer() {
        view.addSubview(bottomComponentsContainer)
        bottomComponentsContainer.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                leading: view.leadingAnchor,
                trailing: view.trailingAnchor)
        bottomComponentsContainer.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                multiplier: bottomComponentsContainerHeightMultiplier).isActive = true
    }

    private func setupMessageLabel() {
        bottomComponentsContainer.addSubview(messageLabel)
        messageLabel.anchor(bottom: bottomComponentsContainer.bottomAnchor,
                leading: bottomComponentsContainer.leadingAnchor,
                trailing: bottomComponentsContainer.trailingAnchor,
                bottomConstant: .marginLarge,
                leadingConstant: .marginLarge,
                trailingConstant: .marginLarge)
    }

    private func setupConvexityImageView() {
        bottomComponentsContainer.addSubview(convexityImageView)
        convexityImageView.anchorCenterToSuperview()
        convexityImageView.size(with: convexityImageViewSize)
    }

    private func setupIndicatorView() {
        bottomComponentsContainer.addSubview(indicatorView)
        indicatorView.anchorCenter(to: convexityImageView)
    }

    private func setupActionButton() {
        bottomComponentsContainer.addSubview(actionButton)
        actionButton.anchorCenter(to: convexityImageView)
        actionButton.size(with: playButtonSize)
        actionButton.rx.tap
                .bind { [weak self] in self?.actionButtonTapped() }
                .disposed(by: disposeBag)
    }

    private func actionButtonTapped() {
        switch automaton.state.value.homeState.lessonState {
        case .failed:
            requestLesson()
        case .lesson(let lesson):
            automaton.send(input: SetLessonInput(lesson: lesson))
            navigator.toLesson()
        default:
            return
        }
    }

    private func bindToAutomaton() {
        automaton.state
                .map { $0.homeState }
                .distinctUntilChanged()
                .bind { [weak self] in self?.stateChanged(to: $0) }
                .disposed(by: disposeBag)
    }

    private func stateChanged(to state: HomeState) {
        switch state.lessonState {
        case .none:
            configureIndicatorView(isAnimating: false)
            configureActionButton(isHidden: true, image: nil)
            configureMessageLabel(text: "")
        case .loading:
            configureIndicatorView(isAnimating: true)
            configureActionButton(isHidden: true, image: nil)
            configureMessageLabel(text: "message_loading".localized())
        case .failed:
            configureIndicatorView(isAnimating: false)
            configureActionButton(isHidden: false, image: UIImage.refreshLarge)
            configureMessageLabel(text: "message_failure".localized())
        case .lesson(_):
            configureIndicatorView(isAnimating: false)
            configureActionButton(isHidden: false, image: UIImage.playLarge)
            configureMessageLabel(text: "")
        }
    }

    private func configureIndicatorView(isAnimating: Bool) {
        if isAnimating {
            indicatorView.startAnimating()
        } else {
            indicatorView.stopAnimating()
        }
    }

    private func configureActionButton(isHidden: Bool, image: UIImage?) {
        actionButton.isHidden = isHidden
        actionButton.setImage(image?.asTemplate(), for: .normal)
    }

    private func configureMessageLabel(text: String) {
        messageLabel.text = text
    }

    private func requestLesson() {
        automaton.send(input: SetLessonStateInput(lessonState: .loading))
    }
}
