<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="conexion.jsp" %>
<jsp:useBean id="prestamo" class="udb.biblioteca.PrestamoBean" scope="request" />
<% String mensaje;
try (java.sql.Connection con=conexion) {
    if (!"POST".equals(request.getMethod())) { response.sendError(405); return; }
    prestamo.setIdPrestamo(Integer.parseInt(request.getParameter("idPrestamo")));
    mensaje=prestamo.devolver(con) ? "Devolución registrada." : "El préstamo no existe o ya fue devuelto.";
} catch(Exception e) { mensaje="No se pudo registrar la devolución."; }
%><!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><title>Devolución</title></head><body><p><%= mensaje %></p><a href="listaPrestamos.jsp">Volver al listado</a></body></html>