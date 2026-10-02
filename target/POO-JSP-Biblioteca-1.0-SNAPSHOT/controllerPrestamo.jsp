<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%-- conexion.jsp debe declarar una variable java.sql.Connection llamada conexion. --%>
<%@ include file="conexion.jsp" %>
<jsp:useBean id="prestamo" class="com.mycompany.poo.jsp.biblioteca.beans.PrestamoBean" scope="request" />
<jsp:setProperty name="prestamo" property="*" />
<%
    String mensaje;

    try {
        if (prestamo.getFechaPrestamo() == null || prestamo.getFechaDevolucion() == null) {
            throw new IllegalArgumentException();
        }

        Date fechaPrestamo = Date.valueOf(prestamo.getFechaPrestamo());
        Date fechaDevolucion = Date.valueOf(prestamo.getFechaDevolucion());
        if (fechaDevolucion.before(fechaPrestamo)) {
            mensaje = "La fecha de devolución debe ser igual o posterior a la fecha del préstamo.";
        } else {
            conexion.setAutoCommit(false);

            String actualizarLibro = "UPDATE libros SET cantidad_disponible = cantidad_disponible - 1 "
                    + "WHERE id_libro = ? AND cantidad_disponible > 0";
            try (PreparedStatement consultaLibro = conexion.prepareStatement(actualizarLibro)) {
                consultaLibro.setInt(1, prestamo.getIdLibro());
                if (consultaLibro.executeUpdate() == 0) {
                    mensaje = "No se pudo registrar: el libro ya no está disponible.";
                    conexion.rollback();
                } else {
                    String insertar = "INSERT INTO prestamos "
                            + "(id_estudiante, id_libro, fecha_prestamo, fecha_devolucion) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement consulta = conexion.prepareStatement(insertar)) {
                        consulta.setInt(1, prestamo.getIdEstudiante());
                        consulta.setInt(2, prestamo.getIdLibro());
                        consulta.setDate(3, fechaPrestamo);
                        consulta.setDate(4, fechaDevolucion);
                        consulta.executeUpdate();
                    }
                    conexion.commit();
                    mensaje = "Préstamo registrado correctamente.";
                }
            }
        }
    } catch (IllegalArgumentException e) {
        mensaje = "Ingresa fechas válidas y completa todos los datos del préstamo.";
        try {
            conexion.rollback();
        } catch (SQLException ignorada) {
            // No había una transacción activa.
        }
    } catch (SQLException e) {
        mensaje = "No se pudo registrar el préstamo. Revisa el estudiante, el libro y la conexión a la base de datos.";
        try {
            conexion.rollback();
        } catch (SQLException ignorada) {
            // La transacción puede haber finalizado.
        }
    } finally {
        try {
            conexion.setAutoCommit(true);
            conexion.close();
        } catch (SQLException ignorada) {
            // La conexión ya no se utilizará en esta página.
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Resultado del préstamo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <main class="container py-5" style="max-width: 720px;">
        <div class="card card-body">
            <h1 class="h3"><%= mensaje %></h1>
            <% if (mensaje.startsWith("Préstamo registrado")) { %>
                <dl class="row mt-3">
                    <dt class="col-sm-5">ID del estudiante</dt><dd class="col-sm-7"><jsp:getProperty name="prestamo" property="idEstudiante" /></dd>
                    <dt class="col-sm-5">ID del libro</dt><dd class="col-sm-7"><jsp:getProperty name="prestamo" property="idLibro" /></dd>
                    <dt class="col-sm-5">Fecha del préstamo</dt><dd class="col-sm-7"><jsp:getProperty name="prestamo" property="fechaPrestamo" /></dd>
                    <dt class="col-sm-5">Fecha de devolución</dt><dd class="col-sm-7"><jsp:getProperty name="prestamo" property="fechaDevolucion" /></dd>
                </dl>
            <% } %>
            <a href="registroPrestamo.jsp" class="btn btn-primary align-self-start">Registrar otro préstamo</a>
        </div>
    </main>
</body>
</html>
