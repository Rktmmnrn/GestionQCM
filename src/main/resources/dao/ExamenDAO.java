package com.examen.dao;

import com.examen.model.Examen;
import com.examen.util.DBConnexion;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour la gestion des examens
 */
public class ExamenDAO {
    
    private Connection connection;
    
    public ExamenDAO() {
        this.connection = DBConnexion.getInstance().getConnection();
    }
    
    /**
     * Crée un nouvel examen
     * @param examen l'examen à créer
     * @return true si création réussie, false sinon
     */
    public boolean create(Examen examen) {
        String sql = "INSERT INTO examens (num_etudiant, annee_univ, note, date_examen) " +
                     "VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, examen.getNumEtudiant());
            pstmt.setString(2, examen.getAnneeUniv());
            pstmt.setInt(3, examen.getNote());
            pstmt.setTimestamp(4, Timestamp.valueOf(examen.getDateExamen()));
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet generatedKeys = pstmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    examen.setNumExam(generatedKeys.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            System.err.println("Erreur lors de la création de l'examen : " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Récupère tous les examens
     * @return liste de tous les examens
     */
    public List<Examen> findAll() {
        List<Examen> examens = new ArrayList<>();
        String sql = "SELECT * FROM examens ORDER BY date_examen DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                examens.add(extractExamenFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération des examens : " + e.getMessage());
        }
        return examens;
    }
    
    /**
     * Récupère tous les examens d'un étudiant spécifique
     * @param numEtudiant numéro de l'étudiant
     * @return liste des examens de l'étudiant
     */
    public List<Examen> findByEtudiant(String numEtudiant) {
        List<Examen> examens = new ArrayList<>();
        String sql = "SELECT * FROM examens WHERE num_etudiant = ? ORDER BY date_examen DESC";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, numEtudiant);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                examens.add(extractExamenFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la recherche des examens par étudiant : " + e.getMessage());
        }
        return examens;
    }
    
    /**
     * Récupère le classement des étudiants par note décroissante
     * @return liste des examens triés par note
     */
    public List<Examen> getClassement() {
        List<Examen> examens = new ArrayList<>();
        String sql = "SELECT e.*, et.nom, et.prenoms FROM examens e " +
                     "JOIN etudiants et ON e.num_etudiant = et.num_etudiant " +
                     "ORDER BY e.note DESC";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                examens.add(extractExamenFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération du classement : " + e.getMessage());
        }
        return examens;
    }
    
    /**
     * Extrait un objet Examen d'un ResultSet
     */
    private Examen extractExamenFromResultSet(ResultSet rs) throws SQLException {
        Examen examen = new Examen();
        examen.setNumExam(rs.getInt("num_exam"));
        examen.setNumEtudiant(rs.getString("num_etudiant"));
        examen.setAnneeUniv(rs.getString("annee_univ"));
        examen.setNote(rs.getInt("note"));
        
        Timestamp timestamp = rs.getTimestamp("date_examen");
        if (timestamp != null) {
            examen.setDateExamen(timestamp.toLocalDateTime());
        }
        
        return examen;
    }
}