//
//  SNSViewController.swift
//  ShaperInstagram
//
//  Created by 上山　俊佑 on 2018/05/01.
//  Copyright © 2018年 Shunsuke Ueyama. All rights reserved.
//

import UIKit
import Social

class SNSViewController: UIViewController {

    var endImage:UIImage = UIImage()
    
    // SNSシェア用
    var myComposeView : SLComposeViewController!
    
    @IBOutlet var endImageView: UIImageView!
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endImageView.image = endImage
        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(textView.isFirstResponder){
            textView.resignFirstResponder()
        }
    }
    
    @IBAction func shareButton(_ sender: Any) {
        // SNSへ投稿する絵メニュー画面を立ち上げる
        // アラートで選択させる
        let alertController = UIAlertController(title: "SNSへ投稿",
                                                message: "投稿する場所を選択してください。",
                                                preferredStyle: .actionSheet)
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
                                                       style: UIAlertActionStyle.cancel,
                                                       handler:{
                                                        (action:UIAlertAction!) -> Void in
                                                        
                                                        //キャンセルボタンの処理
        })
        
        let defaultAction1:UIAlertAction = UIAlertAction(title: "Facebook",
                                                         style: UIAlertActionStyle.default,
                                                         handler:{
                                                            (action:UIAlertAction!) -> Void in
                                                            self.postFacebook()
        })

        let defaultAction2:UIAlertAction = UIAlertAction(title: "Twitter",
                                                         style: UIAlertActionStyle.default,
                                                         handler:{
                                                            (action:UIAlertAction!) -> Void in
                                                            self.postTwitter()
        })

        let defaultAction3:UIAlertAction = UIAlertAction(title: "Line",
                                                         style: UIAlertActionStyle.default,
                                                         handler:{
                                                            (action:UIAlertAction!) -> Void in
                                                            self.postLine()
                                                            
        })

        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction1)
        alertController.addAction(defaultAction2)
        alertController.addAction(defaultAction3)
        present(alertController, animated: true, completion: nil)

    }
    
    // Twitterに投稿するメソッド
    func postTwitter(){
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        myComposeView.setInitialText(textView.text)
        myComposeView.add(endImageView.image)
        
        self.present(myComposeView, animated: true, completion: nil)
    
    }
    // FaceBookに投稿するメソッド
    func postFacebook(){
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        myComposeView.add(endImageView.image)
        
        self.present(myComposeView, animated: true, completion: nil)

    }
    
    // LINEに投稿するメソッド
    func postLine(){
        let pastBoard: UIPasteboard = UIPasteboard.general
        
        pastBoard.setData(UIImageJPEGRepresentation(endImageView.image!, 0.75)!, forPasteboardType: "public.png")
        
        let lineUrlString: String = String(format: "line://msg/image/%@", pastBoard.name as CVarArg)
        
        
        UIApplication.shared.open(NSURL(string: lineUrlString)! as URL)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
