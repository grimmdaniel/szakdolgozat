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
@Table(name = "championship_rounds")
public class ChampionshipRounds {
    
    @Id
    @GeneratedValue(strategy=GenerationType.AUTO)
    private int id;
    
    private int round;
    
    private int home;
    
    private int away;
    
    private double home_result;
    
    private double away_result;
    
    private String date;

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

    public int getHome() {
        return home;
    }

    public void setHome(int home) {
        this.home = home;
    }

    public int getAway() {
        return away;
    }

    public void setAway(int away) {
        this.away = away;
    }

    public double getHome_result() {
        return home_result;
    }

    public void setHome_result(double home_result) {
        this.home_result = home_result;
    }

    public double getAway_result() {
        return away_result;
    }

    public void setAway_result(double away_result) {
        this.away_result = away_result;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }
    
    
}
