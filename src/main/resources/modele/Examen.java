package com.examen.model;

import java.time.LocalDateTime;

/**
 * Modèle représentant un examen passé par un étudiant
 */
public class Examen {
    private int numExam;
    private String numEtudiant;
    private String anneeUniv;
    private int note;
    private LocalDateTime dateExamen;
    
    // Constructeur par défaut
    public Examen() {}
    
    // Constructeur avec paramètres
    public Examen(int numExam, String numEtudiant, String anneeUniv, int note, LocalDateTime dateExamen) {
        this.numExam = numExam;
        this.numEtudiant = numEtudiant;
        this.anneeUniv = anneeUniv;
        this.note = note;
        this.dateExamen = dateExamen;
    }
    
    // Getters et Setters
    public int getNumExam() { return numExam; }
    public void setNumExam(int numExam) { this.numExam = numExam; }
    
    public String getNumEtudiant() { return numEtudiant; }
    public void setNumEtudiant(String numEtudiant) { this.numEtudiant = numEtudiant; }
    
    public String getAnneeUniv() { return anneeUniv; }
    public void setAnneeUniv(String anneeUniv) { this.anneeUniv = anneeUniv; }
    
    public int getNote() { return note; }
    public void setNote(int note) { this.note = note; }
    
    public LocalDateTime getDateExamen() { return dateExamen; }
    public void setDateExamen(LocalDateTime dateExamen) { this.dateExamen = dateExamen; }
}