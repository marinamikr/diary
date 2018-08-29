//l


import UIKit
import RealmSwift

class DrawerViewController: UIViewController {
    
//    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var userIcon: UIImageView!
    var array:[String] = ["自分の愚痴一覧","友達の愚痴一覧","MyQRコード","QRコード読み取り","設定"]

    var imageArray:[String] = ["MyDiary.png","MyFriendDiary.png","QRcode.png","Camera.png","Setting.png"]
    
    var dalegate : CustomDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.register(UINib(nibName: "CustomDrawerTableViewCell", bundle: nil), forCellReuseIdentifier: "customDrawerTableViewCell")
        
        //テーブルビューのデータソースメソッドはViewControllerクラスに書くよ、という設定
        table.dataSource = self
        
        //テーブルビューのデリゲートメソッドはViewControllerメソッドに書くよ、という設定
        table.delegate = self
        
        let realm = try! Realm()
        let result = realm.objects(UserModel.self).first
        var iconImage = UIImage(data: result?.icon  as! Data)
        userIcon.image = iconImage
//        userName.text = result?.nickName
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension DrawerViewController :UITableViewDataSource, UITableViewDelegate {
    
    //セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    //ID付きのセルを取得して、セル付属のtextLabelに『テスト』と表示させてみる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCell(withIdentifier: "customDrawerTableViewCell") as? CustomDrawerTableViewCell
        cell?.label.text = array[indexPath.row]
        
        cell?.icon.image =  UIImage(named: imageArray[indexPath.row])
        
       return cell!
    }
    
    //セルが押された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(array[indexPath.row])が選ばれました")
        
        // indexPath.rowを使う
        //ここ
        switch indexPath.row {
        case 0:
            //performSegue(withIdentifier: "toAllMyDiaryViewController", sender: nil)
            dalegate.toMyDiary()
            
        case 1:
            //performSegue(withIdentifier: "toAllRecivedDiaryViewController", sender: nil)
            dalegate.toMyFriendDiary()
            
        case 2:
            //performSegue(withIdentifier: "toQRViewController", sender: nil)
            dalegate.toqrcode()
            
        case 3:
            //performSegue(withIdentifier: "toAddFriendViewController", sender: nil)
            dalegate.tocamera()

        case 4:
            //performSegue(withIdentifier: "toSettingViewController", sender: nil)
            dalegate.tosetting()
            
        default: break
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
}


