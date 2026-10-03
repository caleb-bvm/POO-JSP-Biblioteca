package com.mycompany.poo.jsp.biblioteca.beans;

import java.io.Serializable;
import java.time.LocalDate;

public class PrestamoBean implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idPrestamo;
    private int idEstudiante;
    private int idLibro;
    private LocalDate fechaPrestamo;
    private LocalDate fechaDevolucion;
    private String estado;

    public PrestamoBean() {
    }

    public int getIdPrestamo() {
        return idPrestamo;
    }

    public void setIdPrestamo(int idPrestamo) {
        this.idPrestamo = idPrestamo;
    }

    public int getIdEstudiante() {
        return idEstudiante;
    }

    public void setIdEstudiante(int idEstudiante) {
        this.idEstudiante = idEstudiante;
    }

    public int getIdLibro() {
        return idLibro;
    }

    public void setIdLibro(int idLibro) {
        this.idLibro = idLibro;
    }

    public LocalDate getFechaPrestamo() {
        return fechaPrestamo;
    }

    public void setFechaPrestamo(String fechaPrestamo) {
        if (fechaPrestamo != null && !fechaPrestamo.isEmpty()) {
            this.fechaPrestamo = LocalDate.parse(fechaPrestamo);
        } else {
            this.fechaPrestamo = null;
        }
    }

    public LocalDate getFechaDevolucion() {
        return fechaDevolucion;
    }

    public void setFechaDevolucion(String fechaDevolucion) {
        if (fechaDevolucion != null && !fechaDevolucion.isEmpty()) {
            this.fechaDevolucion = LocalDate.parse(fechaDevolucion);
        } else {
            this.fechaDevolucion = null;
        }
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}