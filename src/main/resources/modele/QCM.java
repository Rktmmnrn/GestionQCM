package com.examen.model;

/**
 * Modèle représentant une question QCM
 */
public class QCM {
    private int numQuest;
    private String question;
    private String reponse1;
    private String reponse2;
    private String reponse3;
    private String reponse4;
    private int bonneRep;
    
    // Constructeur par défaut
    public QCM() {}
    
    // Constructeur avec paramètres
    public QCM(int numQuest, String question, String reponse1, String reponse2, 
               String reponse3, String reponse4, int bonneRep) {
        this.numQuest = numQuest;
        this.question = question;
        this.reponse1 = reponse1;
        this.reponse2 = reponse2;
        this.reponse3 = reponse3;
        this.reponse4 = reponse4;
        this.bonneRep = bonneRep;
    }
    
    // Getters et Setters
    public int getNumQuest() { return numQuest; }
    public void setNumQuest(int numQuest) { this.numQuest = numQuest; }
    
    public String getQuestion() { return question; }
    public void setQuestion(String question) { this.question = question; }
    
    public String getReponse1() { return reponse1; }
    public void setReponse1(String reponse1) { this.reponse1 = reponse1; }
    
    public String getReponse2() { return reponse2; }
    public void setReponse2(String reponse2) { this.reponse2 = reponse2; }
    
    public String getReponse3() { return reponse3; }
    public void setReponse3(String reponse3) { this.reponse3 = reponse3; }
    
    public String getReponse4() { return reponse4; }
    public void setReponse4(String reponse4) { this.reponse4 = reponse4; }
    
    public int getBonneRep() { return bonneRep; }
    public void setBonneRep(int bonneRep) { this.bonneRep = bonneRep; }
    
    /**
     * Récupère une réponse spécifique par son numéro
     * @param num numéro de la réponse (1-4)
     * @return le texte de la réponse
     */
    public String getReponseByNum(int num) {
        switch(num) {
            case 1: return reponse1;
            case 2: return reponse2;
            case 3: return reponse3;
            case 4: return reponse4;
            default: return "";
        }
    }
}