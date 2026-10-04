package udb.biblioteca;

import com.mycompany.poo.jsp.biblioteca.util.Conexion;
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/*
  JavaBean que representa la tabla libros de la base bibliotecaudb.
  La relación con categorias se modela con un objeto CategoriaBean.
 */
public class LibroBean implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idLibro;
    private String titulo;
    private String autor;
    private String isbn;
    private CategoriaBean categoria = new CategoriaBean();
    private int cantidadDisponible = 1; // Mismo valor por defecto que la tabla

    public LibroBean() {
    }

    public int getIdLibro() {
        return idLibro;
    }

    public void setIdLibro(int idLibro) {
        this.idLibro = idLibro;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getAutor() {
        return autor;
    }

    public void setAutor(String autor) {
        this.autor = autor;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public CategoriaBean getCategoria() {
        return categoria;
    }

    public void setCategoria(CategoriaBean categoria) {
        this.categoria = (categoria != null) ? categoria : new CategoriaBean();
    }

    /*
      Atajo hacia el id de la categoría. Permite que
      jsp:setProperty property="*" asigne el campo idCategoria del formulario.
     */
    public int getIdCategoria() {
        return categoria.getIdCategoria();
    }

    public void setIdCategoria(int idCategoria) {
        categoria.setIdCategoria(idCategoria);
    }

    /* Nombre de la categoría a la que pertenece el libro. */
    public String getNombreCategoria() {
        return categoria.getNombreCategoria();
    }

    public int getCantidadDisponible() {
        return cantidadDisponible;
    }

    public void setCantidadDisponible(int cantidadDisponible) {
        this.cantidadDisponible = cantidadDisponible;
    }

    /*
      Consulta todos los libros junto con su categoría, ordenados por título.
      Cada elemento de la lista ya trae su CategoriaBean completo.
     */
    public List<LibroBean> getListaLibros() throws SQLException, ClassNotFoundException {
        List<LibroBean> libros = new ArrayList<>();
        String sql = "SELECT l.id_libro, l.titulo, l.autor, l.isbn, l.cantidad_disponible, "
                + "c.id_categoria, c.nombre_categoria "
                + "FROM libros l "
                + "INNER JOIN categorias c ON c.id_categoria = l.id_categoria "
                + "ORDER BY l.titulo";

        try (Connection con = Conexion.getConexion();
             PreparedStatement consulta = con.prepareStatement(sql);
             ResultSet resultado = consulta.executeQuery()) {
            while (resultado.next()) {
                CategoriaBean categoria = new CategoriaBean();
                categoria.setIdCategoria(resultado.getInt("id_categoria"));
                categoria.setNombreCategoria(resultado.getString("nombre_categoria"));

                LibroBean libro = new LibroBean();
                libro.setIdLibro(resultado.getInt("id_libro"));
                libro.setTitulo(resultado.getString("titulo"));
                libro.setAutor(resultado.getString("autor"));
                libro.setIsbn(resultado.getString("isbn"));
                libro.setCantidadDisponible(resultado.getInt("cantidad_disponible"));
                libro.setCategoria(categoria);
                libros.add(libro);
            }
        }
        return libros;
    }

    /** Registra el libro y conserva su categoría para la confirmación JSP. */
    public void registrar(Connection con) throws SQLException {
        titulo = titulo == null ? "" : titulo.trim(); autor = autor == null ? "" : autor.trim(); isbn = isbn == null ? "" : isbn.trim();
        if(titulo.isEmpty() || titulo.length()>150 || autor.isEmpty() || autor.length()>100 || isbn.length()>20 || getIdCategoria()<=0 || cantidadDisponible<0)
            throw new IllegalArgumentException("Datos del libro no válidos");
        try(PreparedStatement q=con.prepareStatement("INSERT INTO libros(titulo,autor,isbn,id_categoria,cantidad_disponible) VALUES(?,?,?,?,?)",Statement.RETURN_GENERATED_KEYS)) {
            q.setString(1,titulo); q.setString(2,autor);
            if(isbn.isEmpty()) q.setNull(3,Types.VARCHAR); else q.setString(3,isbn);
            q.setInt(4,getIdCategoria()); q.setInt(5,cantidadDisponible); q.executeUpdate();
            try(ResultSet r=q.getGeneratedKeys()) { if(r.next()) idLibro=r.getInt(1); }
        }
        try(PreparedStatement q=con.prepareStatement("SELECT nombre_categoria FROM categorias WHERE id_categoria=?")) {
            q.setInt(1,getIdCategoria()); try(ResultSet r=q.executeQuery()) { if(r.next()) categoria.setNombreCategoria(r.getString(1)); }
        }
    }
}
