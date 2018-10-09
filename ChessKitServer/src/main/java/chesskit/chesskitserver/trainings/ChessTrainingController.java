/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package chesskit.chesskitserver.trainings;

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
@RequestMapping(path="/trainings")
public class ChessTrainingController {
    
    @Autowired
    private ChessTrainingRepository repository;
    
    @GetMapping("/{id}")
    public ResponseEntity<ChessTraining> getOne(@PathVariable Integer id) {
        ChessTraining training = repository.findOne(id);
        return ResponseEntity.ok(training);
    }
    
    @GetMapping("/all")
    public @ResponseBody Iterable<ChessTraining> getAllTrainings(){
        return repository.findAll();
    }
    
}
