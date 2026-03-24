//
//  ExerciseDetailsViewController.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 22.02.2026.
//

import UIKit
import SnapKit
import Kingfisher
import SafariServices

protocol IExerciseDetailsView: AnyObject {

    func configureVideo(url: URL?)
    func fetchData(data: ExerciseDetailsResponse)
}


final class ExerciseDetailsViewController: UIViewController, IExerciseDetailsView {

    var presenter: IExerciseDetailsPresenter?

    private lazy var videoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(videoTapped)))
        return view
    }()
    private let previewImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    private let playIconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "play.circle.fill"))
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowOpacity = 0.25
        iv.layer.shadowRadius = 10
        iv.layer.shadowOffset = .zero
        return iv
    }()
    private let hintLabel: UILabel = {
        let l = UILabel()
        l.text = "Watch on YouTube"
        l.font = .systemFont(ofSize: 13, weight: .semibold)
        l.textColor = .white
        l.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        l.textAlignment = .center
        l.layer.cornerRadius = 10
        l.clipsToBounds = true
        return l
    }()
    private let durationImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "clock"))
        iv.tintColor = .systemBlue
        iv.contentMode = .scaleAspectFit
        iv.snp.makeConstraints { $0.size.equalTo(24) }
        return iv
    }()
    private let durationLabel: UILabel = {
        let l = UILabel()
        l.text = "Duration"
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 13, weight: .medium)
        l.textColor = .label
        return l
    }()
    private let durationValueLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .bold)
        l.textColor = .label
        l.textAlignment = .center
        return l
    }()
    private let caloriesImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "flame"))
        iv.tintColor = .systemBlue
        iv.contentMode = .scaleAspectFit
        iv.snp.makeConstraints { $0.size.equalTo(24) }
        return iv
    }()
    private let caloriesLabel: UILabel = {
        let l = UILabel()
        l.text = "Calories"
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 13, weight: .medium)
        l.textColor = .label
        return l
    }()
    private let caloriesValueLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 13, weight: .bold)
        l.textColor = .label
        return l
    }()
    private let setsImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "dumbbell"))
        iv.tintColor = .systemBlue
        iv.contentMode = .scaleAspectFit
        iv.snp.makeConstraints { $0.size.equalTo(24) }
        return iv
    }()
    private let setsLabel: UILabel = {
        let l = UILabel()
        l.text = "Sets x Reps"
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 13, weight: .medium)
        l.textColor = .label
        return l
    }()
    private let setsValueLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 13, weight: .bold)
        l.textColor = .label
        return l
    }()
    private lazy var horizontalImagesStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.addArrangedSubview(durationImageView)
        sv.addArrangedSubview(caloriesImageView)
        sv.addArrangedSubview(setsImageView)
        return sv
    }()
    private lazy var horizontalLabelsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .center
        sv.addArrangedSubview(durationLabel)
        sv.addArrangedSubview(caloriesLabel)
        sv.addArrangedSubview(setsLabel)
        return sv
    }()
    private lazy var horizontalValuesStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .center
        sv.addArrangedSubview(durationValueLabel)
        sv.addArrangedSubview(caloriesValueLabel)
        sv.addArrangedSubview(setsValueLabel)
        return sv
    }()
    private let descriptionLabel: UILabel = {
        let l = UILabel()
        l.text = "Benefits of this exercise"
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 16, weight: .bold)
        l.textColor = .label
        return l
    }()
    private let informationStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        return sv
    }()
    private lazy var descriptionView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.12
        view.layer.shadowRadius = 24
        view.layer.shadowOffset = CGSize(width: 0, height: 12)
        view.layer.masksToBounds = false
        view.layer.transform = CATransform3DMakeTranslation(0, -1, 0)
        view.backgroundColor = .systemBackground
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(informationStackView)
        informationStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
        return view
    }()

    private var videoURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        presenter?.viewDidLoad()
    }

    private func setupViews() {
        view.addSubview(videoContainer)
        videoContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(230)
        }
        
        videoContainer.addSubview(previewImageView)
        previewImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        videoContainer.addSubview(playIconView)
        playIconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 64, height: 64))
        }
        
        videoContainer.addSubview(hintLabel)
        hintLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(28)
            make.width.greaterThanOrEqualTo(150)
        }
        
        view.addSubview(horizontalImagesStackView)
        horizontalImagesStackView.snp.makeConstraints { make in
            make.top.equalTo(videoContainer.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(horizontalLabelsStackView)
        horizontalLabelsStackView.snp.makeConstraints { make in
            make.top.equalTo(horizontalImagesStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(horizontalValuesStackView)
        horizontalValuesStackView.snp.makeConstraints { make in
            make.top.equalTo(horizontalLabelsStackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(descriptionView)
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(horizontalValuesStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    func configureVideo(url: URL?) {
        self.videoURL = url

        guard let url else {
            previewImageView.image = nil
            hintLabel.text = "Video unavailable"
            videoContainer.alpha = 0.6
            return
        }

        videoContainer.alpha = 1.0
        hintLabel.text = "Watch on YouTube"

        if let thumb = YouTubeHelper.thumbnailURL(from: url) {
            previewImageView.kf.setImage(
                with: thumb,
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        } else {
            previewImageView.image = nil
        }
    }
    
    func fetchData(data: ExerciseDetailsResponse) {
        durationValueLabel.text = data.duration + " min"
        caloriesValueLabel.text = data.calories + " kcal"
        setsValueLabel.text = data.sets + " x " + data.reps
        
        data.benefits.forEach { benefit in
            let view = UIView()
            let label = UILabel()
            label.font = .systemFont(ofSize: 15, weight: .light)
            label.numberOfLines = 0
            label.text = benefit
            
            let image = UIImageView(image: UIImage(systemName: "smallcircle.filled.circle"))
            image.tintColor = .label
            
            view.addSubview(image)
            image.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(16)
                make.size.equalTo(20)
            }
            
            view.addSubview(label)
            label.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.leading.equalTo(image.snp.trailing).offset(12)
                make.trailing.equalToSuperview().inset(16)
            }
            
            informationStackView.addArrangedSubview(view)
        }
    }

    @objc private func videoTapped() {
        guard let url = videoURL else { return }
        openYouTubePreferAppElseSafari(url)
    }

    private func openYouTubePreferAppElseSafari(_ url: URL) {
        if let appURL = YouTubeHelper.youtubeAppURL(from: url) {
            UIApplication.shared.open(appURL, options: [:]) { [weak self] success in
                guard let self else { return }
                if !success {
                    self.openInSafari(url)
                }
            }
        } else {
            openInSafari(url)
        }
    }

    private func openInSafari(_ url: URL) {
        let safari = SFSafariViewController(url: url)
        safari.preferredControlTintColor = .label
        present(safari, animated: true)
    }

    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            let image = data.flatMap(UIImage.init(data:))
            DispatchQueue.main.async { completion(image) }
        }.resume()
    }
}


enum YouTubeHelper {

    static func extractVideoID(from url: URL) -> String? {
        let host = (url.host ?? "").lowercased()

        if host.contains("youtu.be") {
            let id = url.pathComponents.dropFirst().first
            return (id?.isEmpty == false) ? id : nil
        }

        if host.contains("youtube.com") {
            if url.path == "/watch" {
                let comps = URLComponents(url: url, resolvingAgainstBaseURL: false)
                return comps?.queryItems?.first(where: { $0.name == "v" })?.value
            }

            if url.pathComponents.contains("shorts"),
               let idx = url.pathComponents.firstIndex(of: "shorts"),
               url.pathComponents.count > idx + 1 {
                return url.pathComponents[idx + 1]
            }

            if url.pathComponents.contains("embed"),
               let idx = url.pathComponents.firstIndex(of: "embed"),
               url.pathComponents.count > idx + 1 {
                return url.pathComponents[idx + 1]
            }
        }

        return nil
    }

    static func youtubeAppURL(from webURL: URL) -> URL? {
        guard let id = extractVideoID(from: webURL) else { return nil }
        return URL(string: "youtube://watch?v=\(id)")
    }

    static func thumbnailURL(from url: URL) -> URL? {
        guard let id = extractVideoID(from: url) else { return nil }
        return URL(string: "https://img.youtube.com/vi/\(id)/hqdefault.jpg")
    }
}
