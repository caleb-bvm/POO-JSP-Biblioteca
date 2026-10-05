<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="udb.biblioteca.EstudianteBean,java.util.List,java.util.ArrayList,java.sql.SQLException" %>
<jsp:useBean id="estudianteBean" class="udb.biblioteca.EstudianteBean" scope="page" />
<%!
    // Los datos se muestran como texto, sin interpretar etiquetas HTML.
    private String escapar(String texto) {
        return texto == null ? "" : texto.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    List<EstudianteBean> estudiantes = new ArrayList<>();
    String errorConsulta = null;
    try {
        estudiantes = estudianteBean.getListaEstudiantes();
    } catch (SQLException | ClassNotFoundException e) {
        errorConsulta = "No se pudo cargar el listado de estudiantes. Revisa la conexión a la base de datos.";
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Registro de estudiante</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <main class="container py-5" style="max-width: 720px;">
        <h1 class="mb-4">Registro de estudiante</h1>
        <form action="controllerEstudiante.jsp" method="post" class="card card-body gap-3">
            <div>
                <label for="carnet" class="form-label">Carnet</label>
                <input type="text" class="form-control" id="carnet" name="carnet" maxlength="10" required>
            </div>
            <div>
                <label for="nombreEstudiante" class="form-label">Nombre completo</label>
                <input type="text" class="form-control" id="nombreEstudiante" name="nombreEstudiante" maxlength="100" required>
            </div>
            <div>
                <label for="carrera" class="form-label">Carrera</label>
                <input type="text" class="form-control" id="carrera" name="carrera" maxlength="80" required>
            </div>
            <div>
                <label for="telefono" class="form-label">Teléfono</label>
                <input type="tel" class="form-control" id="telefono" name="telefono" maxlength="9" pattern="[0-9]{4}-?[0-9]{4}" placeholder="1234-5678">
            </div>
            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-primary">Guardar estudiante</button>
                <a href="index.jsp" class="btn btn-outline-secondary">Volver</a>
            </div>
        </form>
        <h2 class="h4 mt-5 mb-3">Estudiantes registrados</h2>
        <% if (errorConsulta != null) { %>
            <div class="alert alert-danger"><%= errorConsulta %></div>
        <% } else if (estudiantes.isEmpty()) { %>
            <p class="text-muted">Todavía no hay estudiantes registrados.</p>
        <% } else { %>
            <div class="table-responsive">
                <table class="table table-sm table-striped align-middle">
                    <thead>
                        <tr><th>Carné</th><th>Nombre</th><th>Carrera</th><th>Teléfono</th></tr>
                    </thead>
                    <tbody>
                        <% for (EstudianteBean estudiante : estudiantes) { %>
                            <tr>
                                <td><%= escapar(estudiante.getCarnet()) %></td>
                                <td><%= escapar(estudiante.getNombreEstudiante()) %></td>
                                <td><%= escapar(estudiante.getCarrera()) %></td>
                                <td><%= estudiante.getTelefono() == null || estudiante.getTelefono().isBlank()
                                        ? "Sin teléfono" : escapar(estudiante.getTelefono()) %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </main>
</body>
</html>
