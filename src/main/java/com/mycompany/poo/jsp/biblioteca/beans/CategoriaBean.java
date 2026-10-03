package com.mycompany.poo.jsp.biblioteca.beans;

import com.mycompany.poo.jsp.biblioteca.util.Conexion;
import java.io.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/* JavaBean que representa la tabla categorias de la base bibliotecaudb. */
public class CategoriaBean implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idCategoria;
    private String nombreCategoria;

    public CategoriaBean() {
    }

    public int getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(int idCategoria) {
        this.idCategoria = idCategoria;
    }

    public String getNombreCategoria() {
        return nombreCategoria;
    }

    public void setNombreCategoria(String nombreCategoria) {
        this.nombreCategoria = nombreCategoria;
    }

    /*
      Consulta todas las categorías registradas, ordenadas por nombre.
      Se usa para llenar el select de categorías en registroLibro.jsp.
     */
    public List<CategoriaBean> getListaCategorias() throws SQLException, ClassNotFoundException {
        List<CategoriaBean> categorias = new ArrayList<>();
        String sql = "SELECT id_categoria, nombre_categoria FROM categorias ORDER BY nombre_categoria";

        try (Connection con = Conexion.getConexion();
             PreparedStatement consulta = con.prepareStatement(sql);
             ResultSet resultado = consulta.executeQuery()) {
            while (resultado.next()) {
                CategoriaBean categoria = new CategoriaBean();
                categoria.setIdCategoria(resultado.getInt("id_categoria"));
                categoria.setNombreCategoria(resultado.getString("nombre_categoria"));
                categorias.add(categoria);
            }
        }
        return categorias;
    }
}