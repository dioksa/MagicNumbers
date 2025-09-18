//
//  MainViewController.swift
//  MagicNumbers
//
//  Created by Oksana Dionisieva on 18.09.2025.
//

import UIKit
import CoreData

final class MainViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var numberTextField: UITextField!
    @IBOutlet private var factButton: UIButton!
    @IBOutlet private var historyLabel: UILabel!
    @IBOutlet private var randomFactNumber: UIButton!
    @IBOutlet private var activity: UIActivityIndicatorView!

    // MARK: - Private property
    private var viewModel: MainViewModel?

    // MARK: - Public property
    var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let context = context {
            viewModel = MainViewModel(repository: FactRepository(context: context))
            viewModel?.showError = { [weak self] message in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "An error has occurred",
                                                  message: message,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
        title = "Interesting numbers".uppercased()
        historyLabel.text = "History".uppercased()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.refresh()
        tableView.reloadData()
    }

    // MARK: - Private part
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "An error has occurred",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @IBAction private func getFactButtonDidTap(_ sender: Any) {
        view.endEditing(true)
        let input = numberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !input.isEmpty else {
            let alert = UIAlertController(title: "An error has occurred",
                                          message: "The field cannot be empty. \nPlease enter any number.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        activity.startAnimating()
        Task {
            await viewModel?.getFact(for: input)
            DispatchQueue.main.async {
                self.activity.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }

    @IBAction private func getRandomNumberButtonDidTap(_ sender: Any) {
        view.endEditing(true)
        activity.startAnimating()
        Task {
            await viewModel?.getRandomFact()
            DispatchQueue.main.async {
                self.activity.stopAnimating()
                self.viewModel?.refresh()
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfItems() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = viewModel.item(at: indexPath.row)
        var content = cell.defaultContentConfiguration()
        content.text = item.numberText
        content.secondaryText = item.factText
        content.secondaryTextProperties.numberOfLines = 1
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.item(at: indexPath.row)
        let storyboard = UIStoryboard(name: "DetailsViewController", bundle: nil)
        guard let details = storyboard.instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController else { return }
        details.configure(with: item.numberText, fact: item.factText)
        navigationController?.pushViewController(details, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        if editingStyle == .delete {
            do {
                try viewModel.delete(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                showError(error)
            }
        }
    }
}
