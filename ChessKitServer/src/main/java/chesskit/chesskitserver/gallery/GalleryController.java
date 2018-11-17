/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package chesskit.chesskitserver;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 *
 * @author grimmdaniel
 */

@Controller
@RequestMapping(path="/gallery")
public class GalleryController {
    
    @Autowired
    private GalleryRepository galleryRepository;
    
    @GetMapping("/all")
    public @ResponseBody Iterable<BgscGallery> getAllPictures(){
        return galleryRepository.findAll();
    }
 }
