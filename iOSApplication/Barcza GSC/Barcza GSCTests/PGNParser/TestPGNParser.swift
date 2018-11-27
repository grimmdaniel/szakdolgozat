//
//  TestPGNParser.swift
//  Barcza GSCTests
//
//  Created by Grimm Dániel on 2018. 11. 27..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import XCTest
@testable import Barcza_GSC

class TestPGNParser: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testParser(){
        let pgn = """
        

[Event "Vugar Gashimov Mem 2016"]
[Site "Shamkir AZE"]
[Date "2016.06.01"]
[Round "6.4"]
[White "Mamedov,Rau"]
[Black "Karjakin,Sergey"]
[Result "1/2-1/2"]
[WhiteTitle "GM"]
[BlackTitle "GM"]
[WhiteElo "2655"]
[BlackElo "2779"]
[ECO "B90"]
[Opening "Sicilian"]
[Variation "Najdorf, Adams attack"]
[WhiteFideId "13401653"]
[BlackFideId "14109603"]
[EventDate "2016.05.26"]

1. e4 c5 2. Nf3 d6 3. d4 cxd4 4. Nxd4 Nf6 5. Nc3 a6 6. h3 e5 7. Nb3 Be6 8. Be3
Be7 9. f4 Nc6 10. f5 Bxb3 11. axb3 Nb4 12. g3 d5 13. exd5 Qc7 14. d6 Bxd6 15.
Nb5 Nxc2+ 16. Ke2 Qc6 17. Nxd6+ Ke7 18. Rc1 Nxe3 19. Rxc6 Nxd1 20. Nxb7 Rhb8 21.
Rc7+ Kf8 22. Kxd1 Ra7 23. Bc4 Raxb7 24. Rxb7 Rxb7 25. Re1 Nd7 26. Kc2 Rb6 27.
Ra1 Nb8 28. Kd3 Nc6 29. Ra4 Ke7 30. Ke4 f6 31. h4 Nb8 32. Kd5 Rd6+ 33. Ke4 Rb6
34. Kd5 Rd6+ 35. Ke4 Rb6 1/2-1/2

"""
        let parser = PGNParser.parser
        let result = parser.parsePGN(pgn)
        XCTAssertTrue(result.first!.white == "Mamedov,Rau")
        XCTAssertTrue(result.first!.black == "Karjakin,Sergey")
        XCTAssertTrue(result.first!.eco == "B90")
        XCTAssertTrue(result.first!.result == "1/2-1/2")
        XCTAssertTrue(result.first!.round == "6.4")
        XCTAssertTrue(result.first!.site == "Shamkir AZE")
    }

}
