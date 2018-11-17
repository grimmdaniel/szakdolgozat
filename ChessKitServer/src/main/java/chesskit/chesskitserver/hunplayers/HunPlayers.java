/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package chesskit.chesskitserver.hunplayers;


import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;


@Entity
public class HunPlayers{
    
    
    @Id
    @GeneratedValue(strategy=GenerationType.AUTO)
    private int fide_id;
    
   
    private String name;
    
    
    private String federation;
    
    
    private String gender;
    
    
    private String title;
    
   
    private int fide_rating;
    
    
    private int games_played;
    
   
    private int k_factor;
    
    
    private int date_of_birth;
    
  
    private String flag;

    public int getFide_id() {
        return fide_id;
    }

    public void setFide_id(int fide_id) {
        this.fide_id = fide_id;
    }

    public String getName() {
        return name;
    }

    public String getFederation() {
        return federation;
    }

    public String getGender() {
        return gender;
    }

    public String getTitle() {
        return title;
    }

    public int getFide_rating() {
        return fide_rating;
    }

    public int getGames_played() {
        return games_played;
    }

    public int getK_factor() {
        return k_factor;
    }

    public int getDate_of_birth() {
        return date_of_birth;
    }

    public String getFlag() {
        return flag;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setFederation(String federation) {
        this.federation = federation;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setFide_rating(int fide_rating) {
        this.fide_rating = fide_rating;
    }

    public void setGames_played(int games_played) {
        this.games_played = games_played;
    }

    public void setK_factor(int k_factor) {
        this.k_factor = k_factor;
    }

    public void setDate_of_birth(int date_of_birth) {
        this.date_of_birth = date_of_birth;
    }

    public void setFlag(String flag) {
        this.flag = flag;
    }
    
    
}
