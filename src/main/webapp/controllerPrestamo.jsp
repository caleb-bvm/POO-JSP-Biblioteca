<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.SQLException" %>
<%-- La conexión compartida se incluye antes de ejecutar el Bean. --%>
<% request.setCharacterEncoding("UTF-8");
if (!"POST".equals(request.getMethod())) { response.sendError(405); return; }
try { Integer.parseInt(request.getParameter("idLibro")); } catch(Exception e) { response.sendError(400,"Valor numérico no válido"); return; }
try { Integer.parseInt(request.getParameter("idEstudiante")); } catch(Exception e) { response.sendError(400,"Valor numérico no válido"); return; }
%>
<%@ include file="conexion.jsp" %>
<jsp:useBean id="prestamo" class="udb.biblioteca.PrestamoBean" scope="request" />
<jsp:setProperty name="prestamo" property="*" />
<%
    String mensaje;

    try (java.sql.Connection con = conexion) {
        prestamo.registrar(con);
        mensaje = "Préstamo registrado correctamente.";
    } catch (IllegalArgumentException e) {
        mensaje = e.getMessage();
    } catch (RuntimeException e) {
        mensaje = "Revisa los datos y las fechas. El libro debe tener ejemplares disponibles.";
    } catch (SQLException e) {
        mensaje = "No se pudo guardar el préstamo. Revisa los datos y la conexión.";
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
            <a href="index.jsp" class="btn btn-outline-secondary align-self-start mt-2">Volver al menú</a>
        </div>
    </main>
</body>
</html>
