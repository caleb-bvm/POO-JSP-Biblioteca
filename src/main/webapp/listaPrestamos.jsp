<%@ page import="udb.biblioteca.PrestamoBean,java.util.List" %>
<jsp:useBean id="consulta" class="udb.biblioteca.PrestamoBean" scope="page" />
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Biblioteca universitaria</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"></head><body class="bg-light"><main class="container py-5"><h1>Préstamos registrados</h1><a href="index.jsp" class="btn btn-outline-secondary">Volver al menú</a>
<% try { List<PrestamoBean> lista=consulta.getListaPrestamos(); %>
<div class="table-responsive mt-3"><table class="table table-striped"><thead><tr><th>Carné</th><th>Estudiante</th><th>Libro</th><th>Préstamo</th><th>Devolución</th><th>Estado</th><th>Acción</th></tr></thead><tbody>
<% for(PrestamoBean elemento:lista) { request.setAttribute("fila",elemento); %>
<jsp:useBean id="fila" class="udb.biblioteca.PrestamoBean" scope="request" />
<tr><td><%= fila.getEstudiante().getCarnet() %></td><td><%= fila.getEstudiante().getNombreEstudiante() %></td><td><%= fila.getLibro().getTitulo() %></td><td><jsp:getProperty name="fila" property="fechaPrestamo" /></td><td><jsp:getProperty name="fila" property="fechaDevolucion" /></td><td><jsp:getProperty name="fila" property="estadoPrestamo" /></td><td>
<% if(!"Devuelto".equals(fila.getEstado())) { %><form action="devolverPrestamo.jsp" method="post"><input type="hidden" name="idPrestamo" value="<%= fila.getIdPrestamo() %>"><button class="btn btn-sm btn-primary">Devolver</button></form><% } %>
</td></tr><% } %></tbody></table></div>
<% } catch(Exception e) { %><p class="alert alert-danger">No se pudo cargar el listado. Revisa MySQL.</p><% } %>
</main></body></html>
