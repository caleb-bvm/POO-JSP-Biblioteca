<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.SQLException" %>
<%@ include file="conexion.jsp" %>

<%
    String mensaje = "";

    try {
        // Obtener datos directamente del formulario
        String estudianteParam = request.getParameter("idEstudiante");
        String libroParam = request.getParameter("idLibro");
        String fechaPrestamoParam = request.getParameter("fechaPrestamo");
        String fechaDevolucionParam = request.getParameter("fechaDevolucion");

        // Validar que todos los datos existan
        if (estudianteParam == null || estudianteParam.trim().isEmpty()
                || libroParam == null || libroParam.trim().isEmpty()
                || fechaPrestamoParam == null || fechaPrestamoParam.trim().isEmpty()
                || fechaDevolucionParam == null || fechaDevolucionParam.trim().isEmpty()) {

            throw new IllegalArgumentException();
        }

        // Convertir IDs
        int idEstudiante = Integer.parseInt(estudianteParam);
        int idLibro = Integer.parseInt(libroParam);

        // Convertir fechas
        Date fechaPrestamo = Date.valueOf(fechaPrestamoParam);
        Date fechaDevolucion = Date.valueOf(fechaDevolucionParam);

        // Validar fechas
        if (fechaDevolucion.before(fechaPrestamo)) {
            mensaje = "La fecha de devolución debe ser igual o posterior a la fecha del préstamo.";
        } else {

            conexion.setAutoCommit(false);

            // Reducir cantidad disponible del libro
            String actualizarLibro =
                    "UPDATE libros SET cantidad_disponible = cantidad_disponible - 1 "
                    + "WHERE id_libro = ? AND cantidad_disponible > 0";

            try (PreparedStatement consultaLibro =
                    conexion.prepareStatement(actualizarLibro)) {

                consultaLibro.setInt(1, idLibro);

                int filas = consultaLibro.executeUpdate();

                if (filas == 0) {

                    conexion.rollback();

                    mensaje = "No se pudo registrar: el libro ya no está disponible.";

                } else {

                    // Registrar préstamo
                    String insertar =
                            "INSERT INTO prestamos "
                            + "(id_estudiante, id_libro, fecha_prestamo, fecha_devolucion, estado) "
                            + "VALUES (?, ?, ?, ?, 'Activo')";

                    try (PreparedStatement consulta =
                            conexion.prepareStatement(insertar)) {

                        consulta.setInt(1, idEstudiante);
                        consulta.setInt(2, idLibro);
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
        }

    } catch (SQLException e) {

        mensaje = "No se pudo registrar el préstamo. Revisa el estudiante, el libro y la conexión a la base de datos.";

        try {
            conexion.rollback();
        } catch (SQLException ignorada) {
        }

    } finally {

        try {
            conexion.setAutoCommit(true);
            conexion.close();
        } catch (SQLException ignorada) {
        }
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Resultado del préstamo</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">
</head>

<body class="bg-light">

<main class="container py-5" style="max-width: 720px;">

    <div class="card card-body">

        <h1 class="h3">
            <%= mensaje %>
        </h1>

        <% if (mensaje.equals("Préstamo registrado correctamente.")) { %>

            <div class="mt-3">

                <p>
                    <strong>ID del estudiante:</strong>
                    <%= request.getParameter("idEstudiante") %>
                </p>

                <p>
                    <strong>ID del libro:</strong>
                    <%= request.getParameter("idLibro") %>
                </p>

                <p>
                    <strong>Fecha del préstamo:</strong>
                    <%= request.getParameter("fechaPrestamo") %>
                </p>

                <p>
                    <strong>Fecha de devolución:</strong>
                    <%= request.getParameter("fechaDevolucion") %>
                </p>

            </div>

        <% } %>

        <a href="registroPrestamo.jsp"
           class="btn btn-primary align-self-start">
            Registrar otro préstamo
        </a>

    </div>

</main>

</body>
</html>