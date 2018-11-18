//
//  TermsAndConditions.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 11. 04..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class TermsAndConditions: UIViewController {
    
    @IBOutlet weak var termsTextView: UITextView!
    var termsOrNot: Bool!
    
    let terms = """
    <p>
    Az alkalmazás használata ingyenes. Az alkalmazás által megjelenített adatok csak tájékoztató jellegűek, semmilyen felelősséget nem vállalunk annak hitelességében, és az esetlegesen ebből származó károk esetén sem.
    </p>
    """
    
    let privacy = """
    <p>
    Jelen alkalmazást a Barcza Gedeon SC üzemelteti.
    Szeretnénk tájékoztatni, hogy alkalmazásunk semmilyen adatot nem kezel/tárol a felhasználóiról.
    Ammenyiben visszajelzést küld a fejlesztőknek az alkalmazáson belül, néhány információ megosztásra kerül velük, kivéve ha ön törli az előre generált email sablonból küldés előtt. Többek között az operációs rendszer verziója, a mobil eszköz típusa, a mobil eszköz aktuális nyelve, és jelen alkalmazás verziószámai.

    Ezen adatokat a szolgáltatás javítására használjuk, semmilyen módon nem sem élünk vissza vele.

    Alkalmazásunk tartalmazhat harmadik fél szervereire mutató hivatkozást, ez esetben az adott oldalon, az adott harmadik fél szolgáltatásához tartozó adatvédelmi irányelvek vannak érvényben. Semmilyen felelősséget sem vállalunk az adott oldalon elérhető tartalmakért.

    Amennyiben bármilyen kérdése vagy kérése merülne fel az alkalmazással kapcsolatban, kérem jelezze a következő email címen:
    </p>

    <ul>
        <li>grimmdani3@gmail.com</li>
    </ul>

    """
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if termsOrNot{
            self.navigationItem.title = "terms".localized
            termsTextView.attributedText = terms.htmlToAttributedString
        }else{
            self.navigationItem.title = "privacy".localized
            termsTextView.attributedText = privacy.htmlToAttributedString
        }
    }
    
    
    

}
