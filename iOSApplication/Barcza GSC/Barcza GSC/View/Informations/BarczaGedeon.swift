//
//  BarczaGedeon.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 11. 15..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class BarczaGedeon: UIViewController {

    @IBOutlet weak var historyTextView: UITextView!
    @IBOutlet weak var barczaImageView: UIImageView!
    
    let text = """
    Barcza Gedeon a magyar és az egyetemes sakkozás legnagyobb egyéniségei közé tartozik, hiszen kiemelkedő versenyeredményei mellett, szakírói és sakkpedagógusi munkássága is egyedülálló volt. Nemzedékek nőttek fel a "Tanár Úr", később "Gida Bácsi" tanításain! Az ő sikerekben gazdag életpályáját szeretnénk most röviden összefoglalni, és ezzel is emléket állítani egyesületünk névadójának.
    
    Barcza Gedeon nemzetközi nagymester 1911. augusztus 11.-én született Kisújszálláson.
    Valamennyi tanulmányát Debrecenben végezte, s itt tanult meg sakkozni is 15(!) éves korában, de a város bajnokságán már 1931-ben első lett, és ezt még négyszer egymás után megismételte.
    1934-ben megszerezte a matematika-fizika szakos középiskolai tanári oklevelet.
    Két évvel később, a magyar mesteri cím elnyerését követően Budapestre költözött. 1941-ben megházasodott, amiből négy gyermeke született. 1949-ben a nemzetközi mesteri cím birtokosa lett, de előtte számtalan mesterversenyen diadalmaskodott. 1951-től 1972-ig a Magyar Sakkélet főmunkatársa volt. Írásai, cikksorozatai és több nyelvre lefordított könyvei a magyar sakkirodalom klasszikus alapműveinek számítanak ma is! A nemzetközi nagymesteri címet 1954-ben kapta meg, de a levelezési sakkozásban is nemzetközi mesteri lett!
    Nyolc olimpián (1936-1968) és három Európa-bajnokságon (1961-1970) szerepelt, s a magyar válogatottban összesen 297 partit játszott. Kétszer játszott zónaközi döntőben (1952 és 1962). Nyolcszor nyert magyar bajnokságot 1942 és 1966 között.
    Mint sakkoktató, elsősorban szeretett klubjában, a Tipográfiában (és jogelődjében, a Szikrában) tevékenykedett, de a Magyar Rádióban és Televízióban is felejthetetlen előadásokat tartott. 1952-ben mesteredzői kitüntetést kapott.
    Nevéhez fűződik az 1. Hf3, d5 2. g3-as rendszer kidolgozása, amelyben Szmiszlovot és Kereszt is legyőzte. Finom, pozíciós sakkozó volt, játszmáiban különösen a huszárokkal bánt kiválóan. Tréfás ars poeticája így hangzott: "A sakkjátszma célja nem a mattadás, hanem a huszárvégjáték...!?"
    1986. február 27.-én hunyt el Budapesten.

    """
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ColorTheme.barczaLightGray
        self.historyTextView.backgroundColor = ColorTheme.barczaLightGray
        self.historyTextView.text = text
        self.navigationItem.title = "Barcza Gedeon"
    }
    
}
