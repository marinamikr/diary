//
//  AddFriendViewController.swift
//  SpeakToMe
//
//  Created by User on 2018/06/05.
//  Copyright © 2018年 Marina Harada. All rights reserved.
//


import UIKit
import AVFoundation
import RealmSwift

class AddFriendViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var previewView: UIView!
    
    var userDefaults:UserDefaults = UserDefaults.standard
    
    let defaults = UserDefaults.standard
    
    // セッションのインスタンス生成
    let captureSession = AVCaptureSession()
    var videoLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // 入力（背面カメラ）
        let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let videoInput = try! AVCaptureDeviceInput.init(device: videoDevice)
        captureSession.addInput(videoInput)
        
        // 出力（メタデータ）
        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)
        
        // QRコードを検出した際のデリゲート設定
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // QRコードの認識を設定
        metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // プレビュー表示
        videoLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        videoLayer?.frame = previewView.bounds
        videoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewView.layer.addSublayer(videoLayer!)
        
        // セッションの開始
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // 複数のメタデータを検出できる
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            // QRコードのデータかどうかの確認
            if metadata.type == AVMetadataObjectTypeQRCode {
                // 検出位置を取得
                let barCode = videoLayer?.transformedMetadataObject(for: metadata) as! AVMetadataMachineReadableCodeObject
                
                if metadata.stringValue != nil {
                    // 検出データを取得
                    let id = metadata.stringValue
                    addFriendID(id: id!)
                    self.captureSession.stopRunning()
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
    }
    
    
    func addFriendID(id: String){
        defaults.register(defaults: ["FriendsIDArray" : Array<String>()])
        var idArray = defaults.array(forKey: "FriendsIDArray") as! Array<String>
        print(idArray)
        print(id)
        print(idArray.contains(id))
        
        if !idArray.contains(id) {
            
            idArray.append(id)
            defaults.set(idArray, forKey: "FriendsIDArray")
            var idArray2 = defaults.array(forKey: "FriendsIDArray")
            print(idArray2)
        }
        
    }
    
}






