# Comprobación de requisitos de la guía

Revisión del 4 de octubre de 2026 sobre `Guia_de_ejercicios_JSP.pdf`.

## Resultado

Se completaron los requisitos de código y se aprobaron 18 comprobaciones funcionales. El documento explicativo tiene dos páginas. La entrega todavía requiere capturas de pantalla y la defensa grupal. El acceso del navegador al sitio local fue rechazado por permiso denegado; no se generaron capturas ficticias.

La ejecución se comprobó en Apache Tomcat 9.0.109 con JDK 27 y clases compiladas para Java 17. La base utilizada fue MariaDB 10.4.32 de XAMPP con MySQL Connector/J 9.7.0. No se probó un servidor MySQL independiente ni otras versiones de Tomcat.

## Matriz de cumplimiento

| Indicación | Resultado | Evidencia |
|---|---|---|
| Proyecto web en NetBeans | Proyecto Maven WAR preparado para NetBeans; origen de creación no verificable | pom.xml y nb-configuration.xml |
| Driver MySQL en Maven | Cumple | Dependencia mysql-connector-j |
| Bootstrap y línea gráfica | Cumple por revisión de código | Formularios y vistas con Bootstrap 5.3.3 |
| Trabajo grupal y originalidad | Debe confirmar el equipo | No verificable mediante ejecución |
| bibliotecaudb y cuatro tablas | Cumple en MariaDB; MySQL independiente sin probar | Script SQL importado correctamente |
| Tipos, claves, relaciones y valores por defecto | Cumple | DDL de categorias, libros, estudiantes y prestamos |
| Tres registros de prueba por tabla | Cumple | 4 categorías, 5 libros, 3 estudiantes y 4 préstamos |
| Cuatro Beans en udb.biblioteca | Cumple | CategoriaBean, LibroBean, EstudianteBean y PrestamoBean |
| Constructor vacío, atributos privados y get/set públicos | Cumple | Revisión de los cuatro Beans |
| Categorías y libros con consultas y relación | Cumple | getListaCategorias, getListaLibros, getNombreCategoria y CategoriaBean dentro de LibroBean |
| Relaciones y estado en PrestamoBean | Cumple | LibroBean y EstudianteBean internos; getEstadoPrestamo |
| Menú index.jsp | Cumple | Accesos a libros, estudiantes, registro y listado |
| Formularios y selects dinámicos | Cumple funcionalmente | Páginas abiertas y registros comprobados |
| Lista de préstamos completa | Cumple | Carné, estudiante, libro, fechas y estado |
| Tres controladores JSP | Cumple | Registro de libro, estudiante y préstamo |
| useBean, setProperty con property="*" y getProperty | Cumple | Controladores y listado |
| conexion.jsp incluido mediante directiva | Cumple | Controladores incluyen conexión JDBC |
| Devolución e incremento de existencias | Cumple | Devolución probada y repetición sin incremento |
| Validación de disponibilidad en el Bean | Cumple | PrestamoBean.registrar y actualización condicional |
| JDBC con PreparedStatement | Cumple | Consultas e inserciones parametrizadas |
| Formularios mediante POST | Cumple | Registro y devolución; controladores rechazan GET |
| Compilación y ejecución en Tomcat 9 o superior | Cumple en Tomcat 9.0.109 | Maven exitoso y compilación de todas las JSP requeridas |
| Sin Spring, Struts ni Hibernate | Cumple | JSP, JavaBeans y JDBC exclusivamente |
| name de formularios coincide con propiedades | Cumple | Asignación automática verificada en los registros |
| Código comentado y organizado | Cumple | Lógica de registro y transacciones en Beans; JSP para presentación |
| Fuente completa en ZIP con pom.xml | Cumple | POO-JSP-Biblioteca.zip |
| Script SQL para entrega | Cumple | bibliotecaudb.sql en el ZIP y como archivo separado |
| Documento breve de máximo dos páginas | Cumple | Documento_Biblioteca.docx, revisado visualmente mediante conversión con Word |
| Capturas de pantalla | Pendiente | El navegador rechazó el acceso local por permiso denegado |
| Defensa funcional | Pendiente del equipo | Realizar la demostración de registros, listado y devolución |
| Fecha de entrega del docente | Debe confirmar el equipo | La guía no establece una fecha concreta |

## Evaluación

La rúbrica asigna 10 puntos a base de datos, 25 a JavaBeans, 20 a acciones JSP, 15 a formularios y vistas, 10 a JDBC, 10 a documentación y 10 a funcionalidades extra. El código ofrece evidencia para los criterios técnicos y las dos funcionalidades extra. La documentación requiere completar las capturas. La calificación definitiva depende del docente y de la defensa; esta revisión no garantiza 100 puntos.

## Pruebas aprobadas

1. Apertura y compilación de index.jsp.
2. Apertura y compilación de registroLibro.jsp.
3. Apertura y compilación de registroEstudiante.jsp.
4. Apertura y compilación de registroPrestamo.jsp.
5. Apertura y compilación de listaPrestamos.jsp.
6. Registro de estudiante.
7. Registro de libro.
8. Registro de préstamo y descuento de inventario.
9. Bloqueo de préstamo cuando no quedan ejemplares.
10. Listado con datos relacionados y estados Vigente, Vencido y Devuelto.
11. Devolución y recuperación de inventario.
12. Devolución repetida sin incremento adicional.
13. Reversión de transacción por estudiante inexistente.
14. Rechazo de fechas invertidas.
15. Rechazo de valor numérico inválido.
16. Rechazo de carné duplicado.
17. Rechazo de cantidad negativa.
18. Rechazo de GET en un controlador de registro.

## Preparación de la defensa

Importar el SQL solamente en una base de prueba: el script elimina y recrea las cuatro tablas. Configurar Conexion.java si el puerto, usuario o contraseña difieren de localhost:3306, root y contraseña vacía. También pueden proporcionarse las propiedades Java biblioteca.url, biblioteca.usuario y biblioteca.clave. Compilar con Maven y JDK 17 o superior y desplegar el WAR en Tomcat 9.

Registrar un estudiante y un libro con un ejemplar. Registrar un préstamo y comprobar que la cantidad baja a cero. Intentar otro préstamo del mismo libro y comprobar su rechazo. Consultar el listado, devolver el préstamo y verificar que la cantidad vuelve a uno. Repetir la devolución para demostrar que no se agrega otra unidad. Mostrar un préstamo vigente, otro vencido y uno devuelto. Tomar capturas reales del menú, formularios, confirmaciones y listado para adjuntarlas a la entrega.
