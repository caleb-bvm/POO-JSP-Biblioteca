<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.Types" %>
<%-- conexion.jsp debe declarar una variable java.sql.Connection llamada conexion. --%>
<%@ include file="conexion.jsp" %>
<%!
    /** Devuelve el texto sin espacios sobrantes; null se convierte en cadena vacía. */
    private static String limpiar(String texto) {
        return texto == null ? "" : texto.trim();
    }
%>
<jsp:useBean id="libro" class="com.mycompany.poo.jsp.biblioteca.beans.LibroBean" scope="request" />
<jsp:setProperty name="libro" property="*" />
<%
    String mensaje;
    boolean registrado = false;

    // setProperty omite los campos vacíos, así que se normalizan antes de validar.
    libro.setTitulo(limpiar(libro.getTitulo()));
    libro.setAutor(limpiar(libro.getAutor()));
    libro.setIsbn(limpiar(libro.getIsbn()));

    try {
        if (conexion == null) {
            mensaje = "No se pudo conectar con la base de datos. Verifica que MySQL esté en ejecución.";
        } else if (libro.getTitulo().isEmpty() || libro.getAutor().isEmpty() || libro.getIdCategoria() <= 0) {
            mensaje = "Completa los campos obligatorios: título, autor y categoría.";
        } else if (libro.getCantidadDisponible() < 0) {
            mensaje = "La cantidad disponible no puede ser negativa.";
        } else {
            String sql = "INSERT INTO libros (titulo, autor, isbn, id_categoria, cantidad_disponible) "
                    + "VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement consulta = conexion.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                consulta.setString(1, libro.getTitulo());
                consulta.setString(2, libro.getAutor());
                // El ISBN es UNIQUE: un ISBN vacío se guarda como NULL para no chocar con otros libros sin ISBN.
                if (libro.getIsbn().isEmpty()) {
                    consulta.setNull(3, Types.VARCHAR);
                } else {
                    consulta.setString(3, libro.getIsbn());
                }
                consulta.setInt(4, libro.getIdCategoria());
                consulta.setInt(5, libro.getCantidadDisponible());
                consulta.executeUpdate();

                try (ResultSet ids = consulta.getGeneratedKeys()) {
                    if (ids.next()) {
                        libro.setIdLibro(ids.getInt(1));
                    }
                }
            }

            // Se carga el nombre de la categoría para mostrarlo en la confirmación.
            try (PreparedStatement consultaCategoria = conexion.prepareStatement(
                    "SELECT nombre_categoria FROM categorias WHERE id_categoria = ?")) {
                consultaCategoria.setInt(1, libro.getIdCategoria());
                try (ResultSet resultado = consultaCategoria.executeQuery()) {
                    if (resultado.next()) {
                        libro.getCategoria().setNombreCategoria(resultado.getString("nombre_categoria"));
                    }
                }
            }

            registrado = true;
            mensaje = "Libro registrado correctamente.";
        }
    } catch (SQLException e) {
        if (e.getErrorCode() == 1062) { // Entrada duplicada (ISBN repetido)
            mensaje = "Ya existe un libro con ese ISBN. Revisa el número o deja el campo vacío.";
        } else if (e.getErrorCode() == 1452) { // Llave foránea inválida
            mensaje = "La categoría seleccionada ya no existe. Vuelve al formulario y elige otra.";
        } else {
            mensaje = "No se pudo registrar el libro. Revisa los datos y que la base de datos esté disponible.";
        }
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
        </div>
    </main>
</body>
</html>
