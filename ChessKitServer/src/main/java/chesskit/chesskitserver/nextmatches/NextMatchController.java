/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package chesskit.chesskitserver.nextmatches;

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
@RequestMapping(path="/nextmatch")
public class NextMatchController {
    
    @Autowired
    private NextMatchRepository repository;
    
    @GetMapping("/{id}")
    public ResponseEntity<NextMatch> getOne(@PathVariable Integer id) {
        NextMatch match = repository.findOne(id);
        return ResponseEntity.ok(match);
    }
    
    @GetMapping("/all")
    public @ResponseBody Iterable<NextMatch> getAllNews(){
        return repository.findAll();
    }
}
