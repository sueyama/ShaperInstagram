//
//  ViewController.swift
//  ShaperInstagram
//
//  Created by 上山　俊佑 on 2018/05/01.
//  Copyright © 2018年 Shunsuke Ueyama. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var dailyTableView: UITableView!
    
    // スクロールバーの定義
    // ここにアルバムに保存されている写真の一覧を表示する
    @IBOutlet var scrollPhotos: UIScrollView!
    
    //ローカルに保存されているデータ用の配列
    var resultArray = [String]()
    //アプリインストールから何日経過したか格納する
    var dayCount: Int = 0
    
    var photoAssets = [PHAsset]()
    var photosImg:[UIImage] = []
    
    var uv = UIView()
    
    var urlInstagram: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // アルバムの使用許可を取る
        libraryRequestAuthorization()
        
        //アプリ起動時に基準日を取得する
        //登録されてない場合は初めて開いたということなので、基準日保存
        if UserDefaults.standard.object(forKey: "kjnYmd") != nil{
            dayCount = Int(getIntervalDays(date: UserDefaults.standard.object(forKey: "kjnYmd") as? Date))
            
            resultArray = UserDefaults.standard.object(forKey: "1-1") as! [String]
        }else{
            //基準日
            UserDefaults.standard.set(getToday(format:"yyyy/MM/dd"), forKey: "kjnYmd")
        }

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // アルバムから写真を取得する　photoImgに格納
        setConfigure()
        
        // uiscrollviewの中でアルバムから取得した写真の位置とサイズを決定
        uv.frame = CGRect(x: 0, y: 0, width: photosImg.count*80, height: 80)
        
        // 写真それぞれにuiボタンを作成する
        for i in 0..<photosImg.count{
            let button:UIButton = UIButton()
            button.frame = CGRect(x: (i*80), y: 0, width: 80, height: 80)
            button.tag = i
            button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
            let buttonImage:UIImage = photosImg[i]
            button.setImage(buttonImage, for: UIControlState.normal)
            uv.addSubview(button)
        }
        // scにuvを貼る
        scrollPhotos.addSubview(uv)
        
        scrollPhotos.contentSize = uv.bounds.size
        
        
        //アプリ内に保存された写真を取得する
        if UserDefaults.standard.object(forKey: "1-1") != nil{
            resultArray = UserDefaults.standard.object(forKey: "1-1") as! [String]
        }
        dailyTableView.reloadData()
    }
    
    /**　本日を書式指定して文字列で取得
     - parameter format: 書式（オプション）。未指定時は"yyyy/MM/dd HH:mm:ss"
     - returns: 本日の日付
     */
    func getToday(format:String = "yyyy/MM/dd HH:mm:ss") -> String {
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: now as Date)
    }

    /** ２つの日付の差(n日)を取得
     - parameter date: 日付
     - parameter anotherDay: 日付（オプション）。未指定時は当日が適用される
     - returns: 算出後の日付
     */
    func getIntervalDays(date:Date?,anotherDay:Date? = nil) -> Double {
        
        var retInterval:Double!
        
        if anotherDay == nil {
            retInterval = date?.timeIntervalSinceNow
        } else {
            retInterval = date?.timeIntervalSince(anotherDay!)
        }
        
        let ret = retInterval/86400
        
        return floor(ret)  // n日
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        //tableViewのセクションの数
        //動的に変動させる
        return dayCountｄ
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //セクション内のcellの数
        //動的に変動させる
        return 1
    }

    func add(_sender: Any){
        //ドラック＆ドロップした際の保存処理
        let imageUrl = "url";
        //画像のURLを保存する
        UserDefaults.standard.set(imageUrl, forKey: "1-1")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //CellというIdentifierをつける
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //日付
        //Tagに「0」を振っている
        let dayLabel = cell.contentView.viewWithTag(0) as! UILabel
        dayLabel.text = "Day"+String(indexPath.row)
        
        //朝の写真
        //Tagに「1」を振っている
        var morningImageView = cell.contentView.viewWithTag(1) as! UIImageView
        let beautifulImage1 = UIImage(named: "1.jpg")
        morningImageView.image = beautifulImage1

        //朝のアイコン
        //Tagに「2」を振っている
        var morningImageViewSub = cell.contentView.viewWithTag(2) as! UIImageView
        let beautifulImage2 = UIImage(named: "2.jpg")
        morningImageView.image = beautifulImage2

        //昼の写真
        //Tagに「3」を振っている
        var lunchImageView = cell.contentView.viewWithTag(3) as! UIImageView
        let beautifulImage3 = UIImage(named: "3.jpg")
        lunchImageView.image = beautifulImage3
        
        //昼のアイコン
        //Tagに「4」を振っている
        var lunchImageViewSub = cell.contentView.viewWithTag(4) as! UIImageView
        let beautifulImage4 = UIImage(named: "4.jpg")
        lunchImageViewSub.image = beautifulImage4

        //よるの写真
        //Tagに「5」を振っている
        var dinnerImageView = cell.contentView.viewWithTag(5) as! UIImageView
        let beautifulImage5 = UIImage(named: "5.jpg")
        dinnerImageView.image = beautifulImage5
        
        //よるのアイコン
        //Tagに「6」を振っている
        var dinnerImageViewSub = cell.contentView.viewWithTag(6) as! UIImageView
        let beautifulImage6 = UIImage(named: "6.jpg")
        dinnerImageViewSub.image = beautifulImage6

        
        return cell
    }
    
    @objc func buttonTap(sender:UIButton){
        // uiscrollviewの中に配置したアルバムから取得した写真
        // をtapしたときのactionを定義
        // ドラッグ＆ドロップのためのアクションを定義する予定
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        // カメラボタンを押したときのアクション
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // cameraでとったあとに動く関数
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = pickedImage
            // 拡張子は .igo を指定
            let fileURL = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/image.igo")

            urlInstagram = fileURL

            // 画面遷移
            performSegue(withIdentifier: "next",sender: nil)
            // 値を渡す
            
        }
        
        //カメラ画面(アルバム画面)を閉じる処理
        picker.dismiss(animated: true, completion: nil)
        
    }

    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "next") {
            let editVC: EditViewController = segue.destination as! EditViewController
            
            //UIImage型の画像を入れる
            editVC.willEditImege = imageView.image!
            
            //画像のURLを入れる
            editVC.editUrl = urlInstagram
            
            
        }
    }

    // カメラロールへのアクセス許可
    fileprivate func libraryRequestAuthorization() {
        PHPhotoLibrary.requestAuthorization({ [weak self] status in
            guard let wself = self else {
                return
            }
            switch status {
            case .authorized:
                wself.getAllPhotosInfo()
            case .denied:
                wself.showDeniedAlert()
            case .notDetermined:
                print("NotDetermined")
            case .restricted:
                print("Restricted")
            }
        })
    }
    
    // カメラロールから全て取得する
    fileprivate func getAllPhotosInfo() {
        let assets: PHFetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        assets.enumerateObjects({ [weak self] (asset, index, stop) -> Void in
            guard let wself = self else {
                return
            }
            wself.photoAssets.append(asset as PHAsset)
        })
    }

    // カメラロールへのアクセスが拒否されている場合のアラート
    fileprivate func showDeniedAlert() {
        let alert: UIAlertController = UIAlertController(title: "エラー",
                                                         message: "「写真」へのアクセスが拒否されています。設定より変更してください。",
                                                         preferredStyle: .alert)
        let cancel: UIAlertAction = UIAlertAction(title: "キャンセル",
                                                  style: .cancel,
                                                  handler: nil)
        let ok: UIAlertAction = UIAlertAction(title: "設定画面へ",
                                              style: .default,
                                              handler: { [weak self] (action) -> Void in
                                                guard let wself = self else {
                                                    return
                                                }
                                                wself.transitionToSettingsApplition()
        })
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func transitionToSettingsApplition() {
        let url = URL(string: UIApplicationOpenSettingsURLString)
        if let url = url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssets.count
    }
    
    // 画像を表示する
    func setConfigure() {
        let photoAssets: PHFetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        let imageManager = PHCachingImageManager()

        photoAssets.enumerateObjects({(object: AnyObject!,
            count: Int,
            stop: UnsafeMutablePointer<ObjCBool>) in
            
            if object is PHAsset{
                let asset = object as! PHAsset
                let options = PHImageRequestOptions()
                options.deliveryMode = .fastFormat
                options.isSynchronous = true
                
                imageManager.requestImage(
                    for: asset,
                    targetSize: CGSize(width: 80,height: 80),
                    contentMode: .aspectFill,
                    options: options,
                    resultHandler: {(image, info) -> Void in
                        //CollectionView用に配列に入れる！
                        self.photosImg.append(image!)
                    }
                )
                
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

