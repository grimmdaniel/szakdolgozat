/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package chesskit.chesskitserver.news;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 *
 * @author grimmdaniel
 */

@Controller
@RequestMapping(path="/news")
public class NewsController {
    
    
    @Autowired
    private NewsRepository newsRepository;
    
    @GetMapping("/{id}")
    public ResponseEntity<BgscNews> getOne(@PathVariable Integer id) {
        BgscNews news = newsRepository.findOne(id);
        return ResponseEntity.ok(news);
    }
    
    @GetMapping("/all")
    public @ResponseBody Iterable<BgscNews> getAllNews(){
        return newsRepository.findAll();
    }
}
