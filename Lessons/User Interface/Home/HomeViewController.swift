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

    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.playLarge?.asTemplate(), for: .normal)
        button.tintColor = .primary
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: .marginExtraSmall)
        button.layer.shadowRadius = .marginExtraSmall
        button.layer.shadowOpacity = 0.5
        return button
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
        setupConvexityImageView()
        setupIndicatorView()
        setupPlayButton()
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

    private func setupConvexityImageView() {
        bottomComponentsContainer.addSubview(convexityImageView)
        convexityImageView.anchorCenterToSuperview()
        convexityImageView.size(with: convexityImageViewSize)
    }

    private func setupIndicatorView() {
        bottomComponentsContainer.addSubview(indicatorView)
        indicatorView.anchorCenterToSuperview()
    }

    private func setupPlayButton() {
        bottomComponentsContainer.addSubview(playButton)
        playButton.anchorCenterToSuperview()
        playButton.size(with: playButtonSize)
        playButton.rx.tap
                .bind { [weak self] in
                    if let lessonState = self?.automaton.state.value.homeState.lessonState,
                       case .lesson(let lesson) = lessonState {
                        self?.automaton.send(input: SetLessonInput(lesson: lesson))
                        self?.navigator.toLesson()
                    }
                }
                .disposed(by: disposeBag)
    }

    private func bindToAutomaton() {
        automaton.state
                .map { $0.homeState }
                .distinctUntilChanged()
                .bind { [weak self] in self?.stateChanged(to: $0) }
                .disposed(by: disposeBag)
    }

    private func stateChanged(to state: HomeState) {
        configureIndicatorView(isAnimating: state.lessonState == .loading)

        if case .lesson(_) = state.lessonState {
            configurePlayButton(isHidden: false)
        } else {
            configurePlayButton(isHidden: true)
        }
    }

    private func configureIndicatorView(isAnimating: Bool) {
        if isAnimating {
            indicatorView.startAnimating()
        } else {
            indicatorView.stopAnimating()
        }
    }

    private func configurePlayButton(isHidden: Bool) {
        playButton.isHidden = isHidden
    }

    private func requestLesson() {
        automaton.send(input: UpdateLessonStateInput(lessonState: .loading))
    }
}
