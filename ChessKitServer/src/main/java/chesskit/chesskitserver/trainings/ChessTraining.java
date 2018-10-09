/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package chesskit.chesskitserver.trainings;

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
@Table(name = "bgsc_trainings")
public class ChessTraining {
    
    @Id
    @GeneratedValue(strategy=GenerationType.AUTO)
    private int id;
    
    private String trainer_name;
    private String trainer_email;
    private String training_description;
    private String training_place;
    private String training_coordinates;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTrainer_name() {
        return trainer_name;
    }

    public void setTrainer_name(String trainer_name) {
        this.trainer_name = trainer_name;
    }

    public String getTrainer_email() {
        return trainer_email;
    }

    public void setTrainer_email(String trainer_email) {
        this.trainer_email = trainer_email;
    }

    public String getTraining_description() {
        return training_description;
    }

    public void setTraining_description(String training_description) {
        this.training_description = training_description;
    }

    public String getTraining_place() {
        return training_place;
    }

    public void setTraining_place(String training_place) {
        this.training_place = training_place;
    }

    public String getTraining_coordinates() {
        return training_coordinates;
    }

    public void setTraining_coordinates(String training_coordinates) {
        this.training_coordinates = training_coordinates;
    }
    
    
}
