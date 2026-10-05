<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>No se pudo completar la operación</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <main class="container py-5" style="max-width: 720px;">
        <div class="card card-body">
            <h1 class="h3">No se pudo completar la operación</h1>
            <p>Revisa los datos del formulario y que la base de datos esté disponible.</p>
            <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-outline-secondary align-self-start">Volver al menú</a>
        </div>
    </main>
</body>
</html>
