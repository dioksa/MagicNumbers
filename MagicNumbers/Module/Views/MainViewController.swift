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
    
    @IBOutlet var activity: UIActivityIndicatorView!
    private var viewModel: MainViewModel?
    var context: NSManagedObjectContext?
    
    @IBAction private func getFactButtonDidTap(_ sender: Any) {
        view.endEditing(true)
        let input = numberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !input.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Введите любое число", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        activity.startAnimating()
        Task {
            do {
                let _ = try await viewModel?.getFact(for: input)
                DispatchQueue.main.async {
                    self.activity.stopAnimating()
                    self.tableView.reloadData()
                }
            } catch {
                DispatchQueue.main.async {
                    self.activity.stopAnimating()
                    self.showError(error)
                }
            }
        }
    }
    
    @IBAction private func getRandomNumberButtonDidTap(_ sender: Any) {
        view.endEditing(true)
        activity.startAnimating()
        Task {
            do {
                let _ = try await viewModel?.getRandomFact()
                DispatchQueue.main.async {
                    self.activity.stopAnimating()
                    self.viewModel?.refresh()
                    self.tableView.reloadData()
                }
            } catch {
                DispatchQueue.main.async {
                    self.activity.stopAnimating()
                    self.showError(error)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let context = context {
            viewModel = MainViewModel(repository: FactRepository(context: context))
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
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfItems() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = viewModel!.item(at: indexPath.row) // fix
        var content = cell.defaultContentConfiguration()
        content.text = item.numberText
        content.secondaryText = item.factText
        content.secondaryTextProperties.numberOfLines = 1
        cell.contentConfiguration = content
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel!.item(at: indexPath.row) // fix
        let detail = DetailViewController(number: item.numberText ?? "", fact: item.factText ?? "")
        navigationController?.pushViewController(detail, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try viewModel!.delete(at: indexPath.row) // fix
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                showError(error)
            }
        }
    }
}
