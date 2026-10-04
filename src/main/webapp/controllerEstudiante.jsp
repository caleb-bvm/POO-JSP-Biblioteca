<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.SQLException" %>
<%-- La conexión compartida se incluye antes de ejecutar el Bean. --%>
<% request.setCharacterEncoding("UTF-8");
if (!"POST".equals(request.getMethod())) { response.sendError(405); return; }
%>
<%@ include file="conexion.jsp" %>
<jsp:useBean id="estudiante" class="udb.biblioteca.EstudianteBean" scope="request" />
<jsp:setProperty name="estudiante" property="*" />
<%
    String mensaje;
    boolean registrado = false;
    try (java.sql.Connection con = conexion) {
        estudiante.registrar(con);
        registrado = true;
        mensaje = "Estudiante registrado correctamente.";
    } catch (IllegalArgumentException e) {
        mensaje = "Completa los campos obligatorios y revisa las longitudes de los datos.";
    } catch (SQLException e) {
        mensaje = "No se pudo registrar. Revisa los datos duplicados y la conexión a MySQL.";
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
            <% if (registrado) { %>
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
