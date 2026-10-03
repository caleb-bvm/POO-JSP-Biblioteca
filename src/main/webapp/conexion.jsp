<%@ page import="java.sql.Connection" %>
<%@ page import="com.mycompany.poo.jsp.biblioteca.util.Conexion" %>

<%
    Connection conexion = null;

    try {
        conexion = Conexion.getConexion();
    } catch (Exception e) {
        out.println("Error de conexión: " + e.getMessage());
    }
%>-