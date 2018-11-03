/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package chesskit.chesskitserver.tableresults;

import java.util.List;
import org.springframework.data.repository.query.Param;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

/**
 *
 * @author grimmdaniel
 */

@Repository
public interface TableResultsRepository extends CrudRepository<TableResults,Integer> {
    
    @Query("SELECT t FROM TableResults t WHERE t.home_team_id = :home_id and t.away_team_id = :away_id")
    public List<TableResults> find(@Param("home_id")int homeTeamID,@Param("away_id")int awayTeamID);
}
