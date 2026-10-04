<%@ page import="java.sql.Connection,com.mycompany.poo.jsp.biblioteca.util.Conexion" %>
<% request.setCharacterEncoding("UTF-8");
Connection conexion = null;
try { conexion = Conexion.getConexion(); }
catch (Exception error) { response.sendError(503, "No se pudo conectar con bibliotecaudb. Revisa MySQL."); return; }
%>
