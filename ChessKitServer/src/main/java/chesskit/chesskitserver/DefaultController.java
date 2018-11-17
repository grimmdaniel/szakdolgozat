/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package chesskit.chesskitserver;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 *
 * @author grimmdaniel
 */
@RestController
public class DefaultController {
    @RequestMapping("/")
    public String index() {
        return "Official server for Barcza GSC application. All rights reserved. 2018.";
    }
    //@GetMapping("")
    //public String player()
}
