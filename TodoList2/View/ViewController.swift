//
//  ViewController.swift
//  TodoList2
//
//  Created by Yu Ichikawa on 2020/12/05.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var outputButton: UIButton!
    //Realmから受け取るデータを入れる変数を用意(ジェネリックを使用)
    var itemList: Results<TodoData>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //realmのインスタンス化
        let RealmItem1 = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        table.dataSource = self
        let realmPath = Realm.Configuration.defaultConfiguration.fileURL!
        //let config = Realm.Configuration(fileURL: realmPath, encryptionKey: self.getKey()!.map{String(format: "%.2hhx", //$0)}.joined())
   
        do {
           // let realm1 = try Realm(configuration: config)
           // let encryption = self.getKey().map{String(format: "%.2hhx", $0)}.joined()
          //  let encryption = try Realm(configuration: config)
          //  print("RealmKey:\(encryption)")
           // print(encryKey)
        }catch{
            print("config error")
        }
        //Realmのfunctionでデータを取得。functionを更に追加することで、フィルターもかけれられる
        //realmデータベースに登録されているデータをすべて取得
        //try!はエラーが発生しなかった場合は通常の値が返されるが、エラーの場合クラッシュ
        self.itemList = RealmItem1.objects(TodoData.self)
        //table.reloadData()
    }
    @IBAction func addList(_ sender: UIButton) {
        //モデルクラスをインスタンス化
        let tododData: TodoData = TodoData()
        //テキストフィールドの値を格納
        tododData.Name = self.inputText.text
        //realmデータベースを取得
        let RealmItem2 = try! Realm()
        //addボタンを押すと、データベースにデータを追加
        //text fieldの情報をデータベースに追加
        try! RealmItem2.write {
            RealmItem2.add(tododData)
            inputText.text = ""
        }
        //テーブルリストを読み込み
        self.table.reloadData()
        //inputText.text = textField.text
        inputText.endEditing(true) //ボタンを押すとキーボード閉じる
    }
    func getKey() -> Data{ //Realmのキー
        let key = "1234567890123456789012345678901234567890123456789012345678901231"
        return key.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        //return key
    }
    @IBAction func allDeleteButton(_ sender: UIBarButtonItem) {//修正必要　table cellの表示がすべて消えていない、realm側はデータ削除できている
        //tableViewのデータを全削除
        //realm インスタンス化
        let real = try! Realm()
        try! real.write{
            //table.deleteRows(at: table.indexPathForSelectedRow., with: UITableView.RowAnimation.automatic)
          //  real.deleteAll()
        }
    }
}
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "リスト", for: indexPath)
        //取得したtodolistからn番目を変数に代入
        let item: TodoData = self.itemList[(indexPath as NSIndexPath).row]
        //セルに表示
        cell.textLabel?.text = item.Name
        print("item\(item.Name as Any)")
        return cell
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {// returnを押すとキーボード閉じる
        textField.resignFirstResponder()
       // inputText.text = textField.text
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //tableViewのセルを削除したあとにrealmのデータを削除
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            do{
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(self.itemList[indexPath.row])
                }
                
            }catch{
                print("cell delete error")
            }
            table.reloadData()
        }
    }

}

