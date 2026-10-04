<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="udb.biblioteca.CategoriaBean" %>
<%@ page import="udb.biblioteca.LibroBean" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%-- Los beans consultan la base de datos por sí mismos (ver util/Conexion.java). --%>
<jsp:useBean id="categoriaBean" class="udb.biblioteca.CategoriaBean" scope="page" />
<jsp:useBean id="libroBean" class="udb.biblioteca.LibroBean" scope="page" />
<%
    List<CategoriaBean> categorias = new ArrayList<>();
    List<LibroBean> libros = new ArrayList<>();
    String errorConsulta = null;

    try {
        categorias = categoriaBean.getListaCategorias();
        libros = libroBean.getListaLibros();
    } catch (SQLException | ClassNotFoundException e) {
        errorConsulta = "No se pudieron cargar las categorías y los libros. Revisa la conexión a la base de datos.";
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Registro de libro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <main class="container py-5" style="max-width: 720px;">
        <h1 class="mb-4">Registro de libro</h1>
        <% if (errorConsulta != null) { %>
            <div class="alert alert-danger"><%= errorConsulta %></div>
            <a href="index.jsp" class="btn btn-link">Volver</a>
        <% } else if (categorias.isEmpty()) { %>
            <div class="alert alert-info">
                Se necesita al menos una categoría para registrar un libro. Agrégala en la tabla categorias de la base de datos.
            </div>
            <a href="index.jsp" class="btn btn-link">Volver</a>
        <% } else { %>
            <form action="controllerLibro.jsp" method="post" class="card card-body gap-3">
                <%-- Los atributos name coinciden con las propiedades de LibroBean (property="*"). --%>
                <div>
                    <label for="titulo" class="form-label">Título</label>
                    <input type="text" class="form-control" id="titulo" name="titulo" maxlength="150" required>
                </div>
                <div>
                    <label for="autor" class="form-label">Autor</label>
                    <input type="text" class="form-control" id="autor" name="autor" maxlength="100" required>
                </div>
                <div>
                    <label for="isbn" class="form-label">ISBN (opcional)</label>
                    <input type="text" class="form-control" id="isbn" name="isbn" maxlength="20" placeholder="978-0135166307">
                </div>
                <div>
                    <label for="idCategoria" class="form-label">Categoría</label>
                    <select id="idCategoria" name="idCategoria" class="form-select" required>
                        <option value="">Selecciona una categoría</option>
                        <% for (CategoriaBean categoria : categorias) { %>
                            <option value="<%= categoria.getIdCategoria() %>"><%= categoria.getNombreCategoria() %></option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label for="cantidadDisponible" class="form-label">Cantidad disponible</label>
                    <input type="number" class="form-control" id="cantidadDisponible" name="cantidadDisponible" min="0" value="1" required>
                </div>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">Guardar libro</button>
                    <a href="index.jsp" class="btn btn-outline-secondary">Volver</a>
                </div>
            </form>

            <h2 class="h4 mt-5 mb-3">Libros registrados</h2>
            <% if (libros.isEmpty()) { %>
                <p class="text-muted">Todavía no hay libros registrados.</p>
            <% } else { %>
                <div class="table-responsive">
                    <table class="table table-sm table-striped align-middle">
                        <thead>
                            <tr>
                                <th>Título</th>
                                <th>Autor</th>
                                <th>ISBN</th>
                                <th>Categoría</th>
                                <th class="text-end">Disponibles</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (LibroBean libro : libros) { %>
                                <tr>
                                    <td><%= libro.getTitulo() %></td>
                                    <td><%= libro.getAutor() %></td>
                                    <td><%= libro.getIsbn() != null ? libro.getIsbn() : "—" %></td>
                                    <td><%= libro.getNombreCategoria() %></td>
                                    <td class="text-end<%= libro.getCantidadDisponible() == 0 ? " text-danger" : "" %>"><%= libro.getCantidadDisponible() %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        <% } %>
    </main>
</body>
</html>
