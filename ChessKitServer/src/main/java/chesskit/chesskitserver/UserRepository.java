/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package chesskit.chesskitserver;

import chesskit.chesskitserver.User;
import org.springframework.data.repository.CrudRepository;

/**
 *
 * @author grimmdaniel
 */
public interface UserRepository extends CrudRepository<User, Long> {

}