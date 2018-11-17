/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package chesskit.chesskitserver.nextmatches;

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
@Table(name = "bgsc_nextmatches")
public class NextMatch {
    
    @Id
    @GeneratedValue(strategy=GenerationType.AUTO)
    private int id;
    
    private String home_name;
    
    private String away_name;
    
    private String home_logo;
    
    private String away_logo;
    
    private String date;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getHome_name() {
        return home_name;
    }

    public void setHome_name(String home_name) {
        this.home_name = home_name;
    }

    public String getAway_name() {
        return away_name;
    }

    public void setAway_name(String away_name) {
        this.away_name = away_name;
    }

    public String getHome_logo() {
        return home_logo;
    }

    public void setHome_logo(String home_logo) {
        this.home_logo = home_logo;
    }

    public String getAway_logo() {
        return away_logo;
    }

    public void setAway_logo(String away_logo) {
        this.away_logo = away_logo;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }
    
    
}
