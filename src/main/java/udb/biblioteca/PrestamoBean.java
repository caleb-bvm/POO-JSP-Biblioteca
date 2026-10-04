package udb.biblioteca;

import com.mycompany.poo.jsp.biblioteca.util.Conexion;
import java.io.Serializable;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/** Representa un préstamo y concentra las reglas de disponibilidad y devolución. */
public class PrestamoBean implements Serializable {
    private static final long serialVersionUID = 1L;
    private int idPrestamo;
    private LibroBean libro = new LibroBean();
    private EstudianteBean estudiante = new EstudianteBean();
    private String fechaPrestamo;
    private String fechaDevolucion;
    private String estado = "Activo";
    public PrestamoBean() {}
    public int getIdPrestamo() { return idPrestamo; }
    public void setIdPrestamo(int valor) { idPrestamo = valor; }
    public LibroBean getLibro() { return libro; }
    public void setLibro(LibroBean valor) { libro = valor == null ? new LibroBean() : valor; }
    public EstudianteBean getEstudiante() { return estudiante; }
    public void setEstudiante(EstudianteBean valor) { estudiante = valor == null ? new EstudianteBean() : valor; }
    public int getIdLibro() { return libro.getIdLibro(); }
    public void setIdLibro(int valor) { libro.setIdLibro(valor); }
    public int getIdEstudiante() { return estudiante.getIdEstudiante(); }
    public void setIdEstudiante(int valor) { estudiante.setIdEstudiante(valor); }
    public String getFechaPrestamo() { return fechaPrestamo; }
    public void setFechaPrestamo(String valor) { fechaPrestamo = valor; }
    public String getFechaDevolucion() { return fechaDevolucion; }
    public void setFechaDevolucion(String valor) { fechaDevolucion = valor; }
    public String getEstado() { return estado; }
    public void setEstado(String valor) { estado = valor; }
    public String getEstadoPrestamo() {
        if ("Devuelto".equals(estado)) return "Devuelto";
        return LocalDate.parse(fechaDevolucion).isBefore(LocalDate.now()) ? "Vencido" : "Vigente";
    }
    /** Actualización condicional y transacción impiden prestar la última copia dos veces. */
    public void registrar(Connection con) throws SQLException {
        LocalDate inicio = LocalDate.parse(fechaPrestamo);
        LocalDate fin = LocalDate.parse(fechaDevolucion);
        if (getIdLibro() <= 0 || getIdEstudiante() <= 0 || fin.isBefore(inicio))
            throw new IllegalArgumentException("Revisa el estudiante, libro y las fechas.");
        con.setAutoCommit(false);
        try {
            try (PreparedStatement q = con.prepareStatement("UPDATE libros SET cantidad_disponible=cantidad_disponible-1 WHERE id_libro=? AND cantidad_disponible>0")) {
                q.setInt(1,getIdLibro());
                if (q.executeUpdate()!=1) throw new IllegalArgumentException("El libro no tiene ejemplares disponibles.");
            }
            try (PreparedStatement q = con.prepareStatement("INSERT INTO prestamos(id_estudiante,id_libro,fecha_prestamo,fecha_devolucion) VALUES(?,?,?,?)",Statement.RETURN_GENERATED_KEYS)) {
                q.setInt(1,getIdEstudiante()); q.setInt(2,getIdLibro());
                q.setDate(3,Date.valueOf(inicio)); q.setDate(4,Date.valueOf(fin)); q.executeUpdate();
                try (ResultSet r=q.getGeneratedKeys()) { if(r.next()) idPrestamo=r.getInt(1); }
            }
            con.commit();
        } catch (SQLException | RuntimeException e) { con.rollback(); throw e; }
        finally { con.setAutoCommit(true); }
    }
    /** El bloqueo de la fila hace que una devolución repetida no aumente el inventario. */
    public boolean devolver(Connection con) throws SQLException {
        con.setAutoCommit(false);
        try {
            int id;
            try (PreparedStatement q=con.prepareStatement("SELECT id_libro,estado FROM prestamos WHERE id_prestamo=? FOR UPDATE")) {
                q.setInt(1,idPrestamo);
                try (ResultSet r=q.executeQuery()) {
                    if(!r.next() || "Devuelto".equals(r.getString("estado"))) { con.rollback(); return false; }
                    id=r.getInt("id_libro");
                }
            }
            try (PreparedStatement q=con.prepareStatement("UPDATE prestamos SET estado='Devuelto' WHERE id_prestamo=?")) { q.setInt(1,idPrestamo); q.executeUpdate(); }
            try (PreparedStatement q=con.prepareStatement("UPDATE libros SET cantidad_disponible=cantidad_disponible+1 WHERE id_libro=?")) { q.setInt(1,id); q.executeUpdate(); }
            con.commit(); estado="Devuelto"; return true;
        } catch(SQLException | RuntimeException e) { con.rollback(); throw e; }
        finally { con.setAutoCommit(true); }
    }
    public List<PrestamoBean> getListaPrestamos() throws SQLException, ClassNotFoundException {
        List<PrestamoBean> lista=new ArrayList<>();
        String sql="SELECT p.*, l.titulo, e.carnet, e.nombre_estudiante FROM prestamos p JOIN libros l ON l.id_libro=p.id_libro JOIN estudiantes e ON e.id_estudiante=p.id_estudiante ORDER BY p.id_prestamo DESC";
        try(Connection con=Conexion.getConexion(); PreparedStatement q=con.prepareStatement(sql); ResultSet r=q.executeQuery()) {
            while(r.next()) {
                PrestamoBean p=new PrestamoBean(); p.setIdPrestamo(r.getInt("id_prestamo"));
                p.setIdLibro(r.getInt("id_libro")); p.libro.setTitulo(r.getString("titulo"));
                p.setIdEstudiante(r.getInt("id_estudiante")); p.estudiante.setCarnet(r.getString("carnet")); p.estudiante.setNombreEstudiante(r.getString("nombre_estudiante"));
                p.setFechaPrestamo(r.getString("fecha_prestamo")); p.setFechaDevolucion(r.getString("fecha_devolucion")); p.setEstado(r.getString("estado")); lista.add(p);
            }
        }
        return lista;
    }
}
