<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="conexion.jsp" %>
<jsp:useBean id="prestamo" class="udb.biblioteca.PrestamoBean" scope="request" />
<% String mensaje;
try (java.sql.Connection con=conexion) {
    if (!"POST".equals(request.getMethod())) { response.sendError(405); return; }
    prestamo.setIdPrestamo(Integer.parseInt(request.getParameter("idPrestamo")));
    mensaje=prestamo.devolver(con) ? "Devolución registrada." : "El préstamo no existe o ya fue devuelto.";
} catch(Exception e) { mensaje="No se pudo registrar la devolución."; }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Devolución</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <main class="container py-5" style="max-width: 720px;">
        <div class="card card-body">
            <h1 class="h3"><%= mensaje %></h1>
            <a href="listaPrestamos.jsp" class="btn btn-primary align-self-start">Volver al listado</a>
            <a href="index.jsp" class="btn btn-outline-secondary align-self-start mt-2">Volver al menú</a>
        </div>
    </main>
</body>
</html>
