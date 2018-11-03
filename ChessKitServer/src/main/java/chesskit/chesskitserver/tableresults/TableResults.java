/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package chesskit.chesskitserver.tableresults;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 *
 * @author grimmdaniel
 */


@Entity
@Table(name = "championship_team_results")
public class TableResults {
    
    @Id
    @GeneratedValue(strategy=GenerationType.AUTO)
    private int id;
    
    private int round;
    private int table_number;
    private int home_team_id;
    private int away_team_id;
    private String home_player_name;
    private int homeelo;
    private String away_player_name;
    private int awayelo;
    private double home_result;
    private double away_result;
    private String home_title;
    private String away_title;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getRound() {
        return round;
    }

    public void setRound(int round) {
        this.round = round;
    }

    public int getTableNumber() {
        return table_number;
    }

    public void setTableNumber(int tableNumber) {
        this.table_number = tableNumber;
    }

    public int getHomeTeamID() {
        return home_team_id;
    }

    public void setHomeTeamID(int homeTeamID) {
        this.home_team_id = homeTeamID;
    }

    public int getAwayTeamID() {
        return away_team_id;
    }

    public void setAwayTeamID(int awayTeamID) {
        this.away_team_id = awayTeamID;
    }

    public String getHomePlayerName() {
        return home_player_name;
    }

    public void setHomePlayerName(String homePlayerName) {
        this.home_player_name = homePlayerName;
    }

    public int getHomeElo() {
        return homeelo;
    }

    public void setHomeElo(int homeElo) {
        this.homeelo = homeElo;
    }

    public String getAwayPlayerName() {
        return away_player_name;
    }

    public void setAwayPlayerName(String awayPlayerName) {
        this.away_player_name = awayPlayerName;
    }

    public int getAwayElo() {
        return awayelo;
    }

    public void setAwayElo(int awayElo) {
        this.awayelo = awayElo;
    }

    public double getHomeResult() {
        return home_result;
    }

    public void setHomeResult(double homeResult) {
        this.home_result = homeResult;
    }

    public double getAwayResult() {
        return away_result;
    }

    public void setAwayResult(double awayResult) {
        this.away_result = awayResult;
    }

    public String getHomeTitle() {
        return home_title;
    }

    public void setHomeTitle(String homeTitle) {
        this.home_title = homeTitle;
    }

    public String getAwayTitle() {
        return away_title;
    }

    public void setAwayTitle(String awayTitle) {
        this.away_title = awayTitle;
    }
    
    
}
