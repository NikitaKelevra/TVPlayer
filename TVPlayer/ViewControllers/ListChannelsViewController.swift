//
//  ListChannelsViewController.swift
//  TVPlayer
//
//  Created by Сперанский Никита on 15.09.2022.
//

import UIKit
import AVKit

class ListChannelViewController: UIViewController {

    // MARK: - Propherties
    
    typealias DataSource = UICollectionViewDiffableDataSource<ChannelsListSection, Channel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ChannelsListSection, Channel>
    
    private var collectionView: UICollectionView!
    private let segmentedControl = UISegmentedControl()
    private var dataSource: DataSource?
    
    private var channels: [Channel] = []
    private var favoriteChannels : [Channel] {
        DataManager.shared.fetchChannels()
    }
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        createDataSource()
        fetchChannels()
        reloadData()
    }
    
    
    // MARK: - Настройка элементов экрана
    private func setupElements() {
        view.backgroundColor = .darkGray
        
        /// Настройка  `SegmentedControl`

        /// скрываем тень navigationBar
//        guard let appearance = navigationController?.navigationBar.standardAppearance else { return }
//        appearance.shadowImage = UIImage()
//        appearance.shadowColor = .clear
//        navigationController?.navigationBar.standardAppearance = appearance
//
        let segmentedControl = UISegmentedControl(items: ["Все","Избранные"])
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.tintColor = .gray.withAlphaComponent(0.2)
        segmentedControl.layer.cornerRadius = 5.0
        
        /// Тень к Segmented Control
        segmentedControl.layer.shadowColor = UIColor.systemGray6.cgColor
        segmentedControl.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        segmentedControl.layer.shadowRadius = CGFloat(0.5)
        
        /// Настройка  ` CollectionView `
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        
        
        //                collectionView.dataSource = self
//        collectionView.backgroundColor = .black
        
        
        /// регистрация ячейки  и заголовка
        collectionView.register(UINib(nibName: String(describing: ChannelCell.self), bundle: nil),
                                forCellWithReuseIdentifier: ChannelCell.reuseId)

        
        
        /// добавляем collectionView первым (либо любой другой элемент с scrollView, для того, что бы searchBar корректно скрывался при скролле)
        view.addSubview(collectionView)  /// добавление collectionView на экран
        view.addSubview(segmentedControl) /// добавление Segmented Control на экран
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeAreaGuide = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            segmentedControl.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: 0),
            segmentedControl.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 0),
            segmentedControl.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
    }
    
    /// Действия при выборе закладок в segmentedControl
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
         switch (segmentedControl.selectedSegmentIndex) {
         case 1: getFavoriteChannels()
         default: fetchChannels()
         }
     }
    // MARK: - Загрузка данных в массив 'channels'
    /// Загрузка данных в массив 'channels'
    private func fetchChannels() {
        NetworkManager.shared.fetchChannelsData(completion: { channels, _ in
            guard let channelsData = channels else { return }
            self.channels = channelsData.channels
            self.reloadData()
        })
    }
    
    private func getFavoriteChannels() {
        self.channels = favoriteChannels
        self.reloadData()
    }

    // MARK: - Настройка DataSource и Snapshot
    private func createDataSource() {
        dataSource = DataSource(collectionView: collectionView,
                                cellProvider: { (collectionView, indexPath, channel) -> UICollectionViewCell? in
            
            let isFavorite = self.favoriteChannels.contains(channel)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelCell.reuseId,
                                                          for: indexPath) as? ChannelCell
            cell?.configure(with: channel, isFavorite: isFavorite)
            return cell
        })
    }
    
    private func reloadData() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(channels, toSection: .main)
        dataSource?.apply(snapshot)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(86))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(1))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets.init(top: 20, leading: 8, bottom: 0, trailing: 8)
            
            return section
        }
        return layout
    }
}

extension ListChannelViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let channel = channels[indexPath.row]
        
        let channelUrl = URL(string: channel.url)
        let player = AVPlayer(url: channelUrl!)
        
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        
        present(playerVC, animated: true) {
            player.play()
        }
    }
}
