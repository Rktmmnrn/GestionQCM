package com.examen.dao;

import com.examen.model.Examen;
import com.examen.util.DBConnexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour la gestion des examens
 * NB : La table EXAMEN n'a PAS de colonne date_examen
 */
public class ExamenDAO {

    private Connection connection;

    public ExamenDAO() {
        this.connection = DBConnexion.getInstance().getConnection();
    }

    /**
     * Crée un nouvel examen
     */
    public boolean create(Examen examen) {
        String sql = "INSERT INTO EXAMEN (num_etudiant, annee_univ, note) VALUES (?, ?, ?)";

        try (PreparedStatement pstmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, examen.getNumEtudiant());
            pstmt.setString(2, examen.getAnneeUniv());
            pstmt.setInt(3, examen.getNote());

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
     * Récupère tous les examens avec les infos étudiant (JOIN)
     */
    public List<Examen> findAll() {
        List<Examen> examens = new ArrayList<>();
        String sql = "SELECT e.*, et.nom, et.prenoms FROM EXAMEN e " +
                     "JOIN ETUDIANT et ON e.num_etudiant = et.num_etudiant " +
                     "ORDER BY e.note DESC";

        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                examens.add(extractExamenFromResultSet(rs, true));
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération des examens : " + e.getMessage());
        }
        return examens;
    }

    /**
     * Récupère les examens d'un étudiant
     */
    public List<Examen> findByEtudiant(String numEtudiant) {
        List<Examen> examens = new ArrayList<>();
        String sql = "SELECT * FROM EXAMEN WHERE num_etudiant = ? ORDER BY num_exam DESC";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, numEtudiant);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                examens.add(extractExamenFromResultSet(rs, false));
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la recherche des examens : " + e.getMessage());
        }
        return examens;
    }

    /**
     * Classement général (JOIN ETUDIANT, ORDER BY note DESC)
     */
    public List<Examen> getClassement() {
        List<Examen> examens = new ArrayList<>();
        String sql = "SELECT e.*, et.nom, et.prenoms FROM EXAMEN e " +
                     "JOIN ETUDIANT et ON e.num_etudiant = et.num_etudiant " +
                     "ORDER BY e.note DESC, e.num_exam ASC";

        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                examens.add(extractExamenFromResultSet(rs, true));
            }
        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération du classement : " + e.getMessage());
        }
        return examens;
    }

    private Examen extractExamenFromResultSet(ResultSet rs, boolean withEtudiant) throws SQLException {
        Examen examen = new Examen();
        examen.setNumExam(rs.getInt("num_exam"));
        examen.setNumEtudiant(rs.getString("num_etudiant"));
        examen.setAnneeUniv(rs.getString("annee_univ"));
        examen.setNote(rs.getInt("note"));
        if (withEtudiant) {
            try { examen.setNom(rs.getString("nom")); } catch (SQLException ignored) {}
            try { examen.setPrenoms(rs.getString("prenoms")); } catch (SQLException ignored) {}
        }
        return examen;
    }
}
