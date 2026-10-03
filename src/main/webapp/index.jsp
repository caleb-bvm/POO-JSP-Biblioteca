<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Biblioteca UDB</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

    <main class="container py-5">

        <h1 class="text-center mb-5">
            Biblioteca UDB
        </h1>

        <div class="row justify-content-center g-4">

            <div class="col-md-4">
                <div class="card h-100 shadow-sm">
                    <div class="card-body text-center">
                        <h2 class="h4">Estudiantes</h2>
                        <p>Registrar estudiantes.</p>

                        <a href="registroEstudiante.jsp"
                           class="btn btn-primary">
                            Registrar estudiante
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card h-100 shadow-sm">
                    <div class="card-body text-center">
                        <h2 class="h4">Libros</h2>
                        <p>Registrar libros.</p>

                        <a href="registroLibro.jsp"
                           class="btn btn-primary">
                            Registrar libro
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card h-100 shadow-sm">
                    <div class="card-body text-center">
                        <h2 class="h4">Préstamos</h2>
                        <p>Registrar préstamos.</p>

                        <a href="registroPrestamo.jsp"
                           class="btn btn-primary">
                            Registrar préstamo
                        </a>
                    </div>
                </div>
            </div>

        </div>

    </main>

</body>
</html>