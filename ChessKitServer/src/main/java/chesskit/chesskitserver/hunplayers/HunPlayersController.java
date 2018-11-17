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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller    // This means that this class is a Controller
@RequestMapping(path="/hun") // This means URL's start with /demo (after Application path)
public class HunPlayersController{
	@Autowired // This means to get the bean called userRepository
	           // Which is auto-generated by Spring, we will use it to handle the data
	private HunPlayersRepository playerRepository;

	/*@GetMapping(path="/add") // Map ONLY GET Requests
	public @ResponseBody String addNewUser (@RequestParam String name
			, @RequestParam String email) {
		// @ResponseBody means the returned String is the response, not a view name
		// @RequestParam means it is a parameter from the GET or POST request

		//HunPlayers n = new HunPlayers();
		//n.setName(name);
		//n.setEmail(email);
		//userRepository.save(n);
		return "Saved";
	}
        */
        
        @GetMapping("/{id}")
        public ResponseEntity<HunPlayers> getOne(@PathVariable Integer id) {
             HunPlayers player = playerRepository.findOne(id);
        return ResponseEntity.ok(player);
        }
	@GetMapping(path="/all")
	public @ResponseBody Iterable<HunPlayers> getAllHunPlayers() {
		// This returns a JSON or XML with the users
		return playerRepository.findAll();
	}
        
        @PostMapping("")
        public ResponseEntity<HunPlayers> create(@RequestBody HunPlayers team) {
            HunPlayers saved = playerRepository.save(team);
            return ResponseEntity.ok(saved);
        }
}