<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Types" %>
<%-- conexion.jsp debe declarar una variable java.sql.Connection llamada conexion. --%>
<%@ include file="conexion.jsp" %>
<jsp:useBean id="estudiante" class="com.mycompany.poo.jsp.biblioteca.beans.EstudianteBean" scope="request" />
<jsp:setProperty name="estudiante" property="*" />
<%
    String mensaje;

    if (estudiante.getCarnet() == null || estudiante.getCarnet().trim().isEmpty()
            || estudiante.getNombreEstudiante() == null || estudiante.getNombreEstudiante().trim().isEmpty()
            || estudiante.getCarrera() == null || estudiante.getCarrera().trim().isEmpty()) {
        mensaje = "Completa los campos obligatorios: carné, nombre y carrera.";
        if (conexion != null) {
            try {
                conexion.close();
            } catch (SQLException e) {
                // La conexión ya no se utilizará en esta página.
            }
        }
    } else {
        String sql = "INSERT INTO estudiantes (carnet, nombre_estudiante, carrera, telefono) VALUES (?, ?, ?, ?)";
        try (PreparedStatement consulta = conexion.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            consulta.setString(1, estudiante.getCarnet().trim());
            consulta.setString(2, estudiante.getNombreEstudiante().trim());
            consulta.setString(3, estudiante.getCarrera().trim());
            if (estudiante.getTelefono() == null || estudiante.getTelefono().trim().isEmpty()) {
                consulta.setNull(4, Types.VARCHAR);
            } else {
                consulta.setString(4, estudiante.getTelefono().trim());
            }

            consulta.executeUpdate();
            try (ResultSet ids = consulta.getGeneratedKeys()) {
                if (ids.next()) {
                    estudiante.setIdEstudiante(ids.getInt(1));
                }
            }
            mensaje = "Estudiante registrado correctamente.";
        } catch (SQLException e) {
            mensaje = "No se pudo registrar el estudiante. Revisa que el carné no esté repetido y que la base de datos esté disponible.";
        } finally {
            if (conexion != null) {
                try {
                    conexion.close();
                } catch (SQLException e) {
                    // La conexión ya no se utilizará en esta página.
                }
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Resultado del registro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <main class="container py-5" style="max-width: 720px;">
        <div class="card card-body">
            <h1 class="h3"><%= mensaje %></h1>
            <% if (mensaje.startsWith("Estudiante registrado")) { %>
                <dl class="row mt-3">
                    <dt class="col-sm-4">ID</dt><dd class="col-sm-8"><jsp:getProperty name="estudiante" property="idEstudiante" /></dd>
                    <dt class="col-sm-4">Carné</dt><dd class="col-sm-8"><jsp:getProperty name="estudiante" property="carnet" /></dd>
                    <dt class="col-sm-4">Nombre</dt><dd class="col-sm-8"><jsp:getProperty name="estudiante" property="nombreEstudiante" /></dd>
                    <dt class="col-sm-4">Carrera</dt><dd class="col-sm-8"><jsp:getProperty name="estudiante" property="carrera" /></dd>
                    <dt class="col-sm-4">Teléfono</dt><dd class="col-sm-8"><jsp:getProperty name="estudiante" property="telefono" /></dd>
                </dl>
            <% } %>
            <a href="registroEstudiante.jsp" class="btn btn-primary align-self-start">Registrar otro estudiante</a>
        </div>
    </main>
</body>
</html>
