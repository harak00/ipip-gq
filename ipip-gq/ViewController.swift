//
//  ViewController.swift
//  ipip-gq
//
//  Created by INSU BYEON on 2017. 7. 6..
//  Copyright © 2017년 kokonoe. All rights reserved.
//
import Alamofire
import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var lblIP: UILabel!
    
    // 외부아이피를 내뱉을 서버 주소
    fileprivate let url = "http://ipip.gq"
    
    // 정규식 패턴
    fileprivate let pattern = "#ff0000'>(.*)</span>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblIP.text = "불러오는 중..."
        GetIP()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnReload(_ sender: Any) {
        GetIP()
    }

}
//- MARK : String RegularExpression
extension String {
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map { result.rangeAt($0).location != NSNotFound
                ? nsString.substring(with: result.rangeAt($0))
                : ""
            }
        }
    }
}
//- MARK : GetIP 함수 정의
extension ViewController {
    func GetIP() {
        Alamofire.request(self.url)
            .responseString { response in
                if response.result.isSuccess {
                    let ip = response.result.value!.matchingStrings(regex: self.pattern)[0][1]
                    self.lblIP.text = "My ip is '\(ip)'"
                } else {
                    let alertError = UIAlertController(title: "오류",
                                                       message: "네트워크 연결이 불가능합니다.",
                                                       preferredStyle: UIAlertControllerStyle.alert)
                    alertError.addAction(UIAlertAction(title: "확인",
                                                       style: UIAlertActionStyle.default,
                                                       handler: nil))
                    self.present(alertError, animated: true, completion: nil)
                }
        }
    }
}

