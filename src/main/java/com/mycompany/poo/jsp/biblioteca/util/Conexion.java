package com.mycompany.poo.jsp.biblioteca.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Clase utilitaria para obtener la conexión JDBC a la base de datos bibliotecaudb.
 * Se usa desde los JavaBeans: Connection con = Conexion.getConexion();
 */
public class Conexion {

    // Datos de conexión (ajustar según tu MySQL)
    private static final String URL = "jdbc:mysql://localhost:3306/bibliotecaudb?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USUARIO = "root";
    private static final String CLAVE = "";

    // Retorna una conexión nueva a la base de datos
    public static Connection getConexion() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USUARIO, CLAVE);
    }
}