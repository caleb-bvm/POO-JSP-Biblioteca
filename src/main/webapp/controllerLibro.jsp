<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.SQLException" %>
<%-- La conexión compartida se incluye antes de ejecutar el Bean. --%>
<% request.setCharacterEncoding("UTF-8");
if (!"POST".equals(request.getMethod())) { response.sendError(405); return; }
try { Integer.parseInt(request.getParameter("idCategoria")); } catch(Exception e) { response.sendError(400,"Valor numérico no válido"); return; }
try { Integer.parseInt(request.getParameter("cantidadDisponible")); } catch(Exception e) { response.sendError(400,"Valor numérico no válido"); return; }
%>
<%@ include file="conexion.jsp" %>

<jsp:useBean id="libro" class="udb.biblioteca.LibroBean" scope="request" />
<jsp:setProperty name="libro" property="*" />
<%
    String mensaje;
    boolean registrado = false;
    try (java.sql.Connection con = conexion) {
        libro.registrar(con);
        registrado = true;
        mensaje = "Libro registrado correctamente.";
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
            <h1 class="h3<%= registrado ? "" : " text-danger" %>"><%= mensaje %></h1>
            <% if (registrado) { %>
                <dl class="row mt-3">
                    <dt class="col-sm-4">ID</dt><dd class="col-sm-8"><jsp:getProperty name="libro" property="idLibro" /></dd>
                    <dt class="col-sm-4">Título</dt><dd class="col-sm-8"><jsp:getProperty name="libro" property="titulo" /></dd>
                    <dt class="col-sm-4">Autor</dt><dd class="col-sm-8"><jsp:getProperty name="libro" property="autor" /></dd>
                    <dt class="col-sm-4">ISBN</dt>
                    <dd class="col-sm-8">
                        <% if (libro.getIsbn().isEmpty()) { %>
                            <span class="text-muted">Sin ISBN</span>
                        <% } else { %>
                            <jsp:getProperty name="libro" property="isbn" />
                        <% } %>
                    </dd>
                    <dt class="col-sm-4">Categoría</dt><dd class="col-sm-8"><jsp:getProperty name="libro" property="nombreCategoria" /></dd>
                    <dt class="col-sm-4">Disponibles</dt><dd class="col-sm-8"><jsp:getProperty name="libro" property="cantidadDisponible" /></dd>
                </dl>
            <% } %>
            <a href="registroLibro.jsp" class="btn btn-primary align-self-start"><%= registrado ? "Registrar otro libro" : "Volver al formulario" %></a>
            <a href="index.jsp" class="btn btn-outline-secondary align-self-start mt-2">Volver al menú</a>
        </div>
    </main>
</body>
</html>
