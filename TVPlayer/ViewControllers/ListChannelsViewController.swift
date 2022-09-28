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
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var dataSource: DataSource?
    
    private var channels: [Channel] = [] {
        didSet{
            reloadData()
        }
    }
    
    private var favoriteChannels: [Channel] {
        DataManager.shared.fetchChannels()
    }
    
    /// Цвета оформления
    private let darkGrayColor = UIColor(white: 0.2, alpha: 1)
    private let lightGrayColor = UIColor(white: 0.5, alpha: 1)

    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        createDataSource()
        fetchChannels()
    }
    
    // MARK: - Настройка элементов экрана
    private func setupElements() {
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        
        /// Настройка  `Search Controller`
        searchController.searchResultsUpdater = self  /// результаты  в основном VC
        searchController.obscuresBackgroundDuringPresentation = false /// доступ к результатам поиска
        searchController.searchBar.placeholder = "Поиск нужного канала"
//        searchController.delegate = self
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        navigationItem.searchController = searchController
        definesPresentationContext = true  /// Позволяет опустить строку поиска при переходе на другой экран
        
        /// Настройка  `Segmented Control`
        let segmentedControl = UISegmentedControl(items: ["Все каналы","Избранные"])
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        segmentedControl.backgroundColor = darkGrayColor
        segmentedControl.tintColor = lightGrayColor
        segmentedControl.layer.cornerRadius = 5.0
        
        /// Настройка характеристик отображения текста
        let selectedTextAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .heavy),
            .foregroundColor: darkGrayColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let normalTextAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 17, weight: .medium),
            .foregroundColor: lightGrayColor
        ]
        
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        
        /// Тень к Segmented Control
        segmentedControl.layer.shadowColor = UIColor.systemGray6.cgColor
        segmentedControl.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        segmentedControl.layer.shadowRadius = CGFloat(0.5)
        
        /// Настройка  `CollectionView`
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        
        /// Регистрация ячейки
        collectionView.register(UINib(nibName: String(describing: ChannelCell.self), bundle: nil),
                                forCellWithReuseIdentifier: ChannelCell.reuseId)

        
        
        /// добавляем collectionView первым (либо любой другой элемент с scrollView, для того, что бы searchBar корректно скрывался при скролле)
        view.addSubview(collectionView)  /// добавление collectionView на экран
        view.addSubview(segmentedControl) /// добавление Segmented Control на экран
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeAreaGuide = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16),
            segmentedControl.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor,constant: 7 ),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        })
    }
    
    private func getFavoriteChannels() {
        self.channels = favoriteChannels
    }

    // MARK: - Настройка DataSource, Snapshot и Layout
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
            section.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 8, bottom: 0, trailing: 8)
            
            return section
        }
        return layout
    }
}

// MARK: - Настройка проигрывателя каналов AVPlayer

extension ListChannelViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let channel = channels[indexPath.row]      /// Понимаем какой канал был выбран
        
        let channelUrl = URL(string: channel.url) /// Извлекаем Url адресс
        let player = AVPlayer(url: channelUrl!)   /// Создаем плеер с данным адресом
        
        let playerVC = AVPlayerViewController()   /// Создаем VC
        playerVC.player = player                  /// Присваиваем плеер - плееру созданного VC
        
        present(playerVC, animated: true) {      /// Показываем VC и запускаем проигрывание
            player.play()
        }
    }
}

extension ListChannelViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        var searchBarIsEmpty: Bool {
            guard let text = searchController.searchBar.text else { return true }
            return text.isEmpty
        }
        var isFiltering: Bool {
            return searchController.isActive && !searchBarIsEmpty
        }
        
        if isFiltering {
            channels = channels.filter({ (channel: Channel) -> Bool in
            return channel.nameRu.lowercased().contains(searchText.lowercased())
        })
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        fetchChannels()
        searchBar.endEditing(true)
    }
}
