<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%-- conexion.jsp debe declarar una variable java.sql.Connection llamada conexion. --%>
<%@ include file="conexion.jsp" %>
<%
    List<String[]> estudiantes = new ArrayList<>();
    List<String[]> libros = new ArrayList<>();
    String errorConsulta = null;

    try (PreparedStatement consultaEstudiantes = conexion.prepareStatement(
                "SELECT id_estudiante, carnet, nombre_estudiante FROM estudiantes ORDER BY nombre_estudiante");
         ResultSet resultadoEstudiantes = consultaEstudiantes.executeQuery()) {
        while (resultadoEstudiantes.next()) {
            estudiantes.add(new String[]{resultadoEstudiantes.getString("id_estudiante"),
                resultadoEstudiantes.getString("carnet"), resultadoEstudiantes.getString("nombre_estudiante")});
        }

        try (PreparedStatement consultaLibros = conexion.prepareStatement(
                    "SELECT id_libro, titulo FROM libros WHERE cantidad_disponible > 0 ORDER BY titulo");
             ResultSet resultadoLibros = consultaLibros.executeQuery()) {
            while (resultadoLibros.next()) {
                libros.add(new String[]{resultadoLibros.getString("id_libro"), resultadoLibros.getString("titulo")});
            }
        }
    } catch (SQLException e) {
        errorConsulta = "No se pudieron cargar estudiantes y libros. Revisa la conexión a la base de datos.";
    } finally {
        if (conexion != null) {
            try {
                conexion.close();
            } catch (SQLException e) {
                // La conexión ya no se utilizará en esta página.
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Registro de préstamo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <main class="container py-5" style="max-width: 720px;">
        <h1 class="mb-4">Registro de préstamo</h1>
        <% if (errorConsulta != null) { %>
            <div class="alert alert-danger"><%= errorConsulta %></div>
        <% } else if (estudiantes.isEmpty() || libros.isEmpty()) { %>
            <div class="alert alert-info">
                Se necesita al menos un estudiante y un libro disponible para registrar un préstamo.
            </div>
        <% } else { %>
            <form action="controllerPrestamo.jsp" method="post" class="card card-body gap-3">
                <div>
                    <label for="idEstudiante" class="form-label">Estudiante</label>
                    <select id="idEstudiante" name="idEstudiante" class="form-select" required>
                        <option value="">Selecciona un estudiante</option>
                        <% for (String[] estudiante : estudiantes) { %>
                            <option value="<%= estudiante[0] %>"><%= estudiante[1] %> - <%= estudiante[2] %></option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label for="idLibro" class="form-label">Libro disponible</label>
                    <select id="idLibro" name="idLibro" class="form-select" required>
                        <option value="">Selecciona un libro</option>
                        <% for (String[] libro : libros) { %>
                            <option value="<%= libro[0] %>"><%= libro[1] %></option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label for="fechaPrestamo" class="form-label">Fecha del préstamo</label>
                    <input type="date" class="form-control" id="fechaPrestamo" name="fechaPrestamo" required>
                </div>
                <div>
                    <label for="fechaDevolucion" class="form-label">Fecha de devolución</label>
                    <input type="date" class="form-control" id="fechaDevolucion" name="fechaDevolucion" required>
                </div>
                <button type="submit" class="btn btn-primary">Guardar préstamo</button>
            </form>
        <% } %>
        <a href="index.jsp" class="btn btn-link mt-3">Volver</a>
    </main>
</body>
</html>
