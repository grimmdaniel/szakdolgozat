/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package chesskit.chesskitserver.tableresults;

import chesskit.chesskitserver.news.BgscNews;
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
@RequestMapping(path="/tableresults")
public class TableResultsController {
    
    @Autowired
    private TableResultsRepository repository;
    
    @GetMapping("/{id}")
    public ResponseEntity<TableResults> getOne(@PathVariable Integer id) {
        TableResults result = repository.findOne(id);
        return ResponseEntity.ok(result);
    }
    
    @GetMapping("/all")
    public @ResponseBody Iterable<TableResults> getAllTableResults(){
        return repository.findAll();
    }
    
    @GetMapping("/result/{home}/{away}")
    public @ResponseBody Iterable<TableResults> getFilteredMatchResults(@PathVariable Integer home, @PathVariable Integer away){
        return repository.find(home, away);
    }
    
}
