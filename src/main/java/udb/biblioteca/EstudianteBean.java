package udb.biblioteca;

import java.io.Serializable;

/** JavaBean que representa la tabla estudiantes de la base bibliotecaudb. */
public class EstudianteBean implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idEstudiante;
    private String carnet;
    private String nombreEstudiante;
    private String carrera;
    private String telefono;

    public EstudianteBean() {
    }

    public int getIdEstudiante() {
        return idEstudiante;
    }

    public void setIdEstudiante(int idEstudiante) {
        this.idEstudiante = idEstudiante;
    }

    public String getCarnet() {
        return carnet;
    }

    public void setCarnet(String carnet) {
        this.carnet = carnet;
    }

    public String getNombreEstudiante() {
        return nombreEstudiante;
    }

    public void setNombreEstudiante(String nombreEstudiante) {
        this.nombreEstudiante = nombreEstudiante;
    }

    public String getCarrera() {
        return carrera;
    }

    public void setCarrera(String carrera) {
        this.carrera = carrera;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    /** Valida los campos y guarda el estudiante mediante una consulta parametrizada. */
    public void registrar(java.sql.Connection con) throws java.sql.SQLException {
        carnet = carnet == null ? "" : carnet.trim();
        nombreEstudiante = nombreEstudiante == null ? "" : nombreEstudiante.trim();
        carrera = carrera == null ? "" : carrera.trim();
        telefono = telefono == null ? "" : telefono.trim();
        if (carnet.isEmpty() || carnet.length()>10 || nombreEstudiante.isEmpty() || nombreEstudiante.length()>100
                || carrera.isEmpty() || carrera.length()>80 || (!telefono.isEmpty() && !telefono.matches("[0-9]{4}-?[0-9]{4}")))
            throw new IllegalArgumentException("Datos del estudiante no válidos");
        try (java.sql.PreparedStatement q=con.prepareStatement("INSERT INTO estudiantes(carnet,nombre_estudiante,carrera,telefono) VALUES(?,?,?,?)", java.sql.Statement.RETURN_GENERATED_KEYS)) {
            q.setString(1,carnet); q.setString(2,nombreEstudiante); q.setString(3,carrera);
            if(telefono.isEmpty()) q.setNull(4,java.sql.Types.VARCHAR); else q.setString(4,telefono);
            q.executeUpdate();
            try(java.sql.ResultSet r=q.getGeneratedKeys()) { if(r.next()) idEstudiante=r.getInt(1); }
        }
    }
}
