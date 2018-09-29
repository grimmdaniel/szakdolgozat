/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package chesskit.chesskitserver.championship;

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
@RequestMapping(path="/championship/teams")
public class ChampionshipTeamsController {
    
    @Autowired
    private ChampionshipTeamsRepository repository;
    
    @GetMapping("/{id}")
    public ResponseEntity<ChampionshipTeams> getOne(@PathVariable Integer id) {
        ChampionshipTeams news = repository.findOne(id);
        return ResponseEntity.ok(news);
    }
    
    @GetMapping("all")
    public @ResponseBody Iterable<ChampionshipTeams> getAllTeams(){
        return repository.findAll();
    }
    
}
