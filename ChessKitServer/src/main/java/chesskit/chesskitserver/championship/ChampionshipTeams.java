/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package chesskit.chesskitserver.championship;

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
@Table(name = "championship_teams")
public class ChampionshipTeams {
    
    @Id
    @GeneratedValue(strategy=GenerationType.AUTO)
    private int id;
    
    private String name;
    
    private String logo;
    
    private int points;
    
    private int penalty_points;
    
    private int games_played;
    
    private double table_points;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public int getPoints() {
        return points;
    }

    public void setPoints(int points) {
        this.points = points;
    }

    public int getPenalty_points() {
        return penalty_points;
    }

    public void setPenalty_points(int penalty_points) {
        this.penalty_points = penalty_points;
    }

    public int getGames_played() {
        return games_played;
    }

    public void setGames_played(int games_played) {
        this.games_played = games_played;
    }

    public double getTable_points() {
        return table_points;
    }

    public void setTable_points(int table_points) {
        this.table_points = table_points;
    }

    
}
