-- phpMyAdmin SQL Dump
-- version 5.2.1
-- Host: 127.0.0.1
-- Generation Time: Oct 02, 2026 at 04:26 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bibliotecaudb`
--
-- Base de datos: bibliotecaudb
-- Universidad Don Bosco - Programación Orientada a Objetos, Ciclo II
--
-- Compatible con MySQL 5.7 / 8.x / 9.x y MariaDB 10.x (XAMPP).
-- El script se puede ejecutar varias veces: elimina y recrea únicamente las
-- cuatro tablas del sistema, dejando de nuevo los datos de prueba.

CREATE DATABASE IF NOT EXISTS bibliotecaudb
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE bibliotecaudb;

SET NAMES utf8mb4;

-- Se eliminan primero las tablas hijas para respetar las llaves foráneas.
DROP TABLE IF EXISTS prestamos;
DROP TABLE IF EXISTS libros;
DROP TABLE IF EXISTS estudiantes;
DROP TABLE IF EXISTS categorias;

-- Tabla: categorias
CREATE TABLE categorias (
    id_categoria     INT         NOT NULL AUTO_INCREMENT,
    nombre_categoria VARCHAR(80) NOT NULL,
    CONSTRAINT pk_categorias PRIMARY KEY (id_categoria)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Tabla: libros
-- Un libro no puede quedar con existencias negativas (CHECK) y no se puede
-- eliminar una categoría que todavía tenga libros asociados (RESTRICT).
CREATE TABLE libros (
    id_libro            INT          NOT NULL AUTO_INCREMENT,
    titulo              VARCHAR(150) NOT NULL,
    autor               VARCHAR(100) NOT NULL,
    isbn                VARCHAR(20)  DEFAULT NULL,
    id_categoria        INT          NOT NULL,
    cantidad_disponible INT          NOT NULL DEFAULT 1,
    CONSTRAINT pk_libros PRIMARY KEY (id_libro),
    CONSTRAINT uq_libros_isbn UNIQUE (isbn),
    CONSTRAINT fk_libros_categoria FOREIGN KEY (id_categoria)
        REFERENCES categorias (id_categoria)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_libros_cantidad CHECK (cantidad_disponible >= 0)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;


-- Tabla: estudiantes
CREATE TABLE estudiantes (
    id_estudiante     INT          NOT NULL AUTO_INCREMENT,
    carnet            VARCHAR(10)  NOT NULL,
    nombre_estudiante VARCHAR(100) NOT NULL,
    carrera           VARCHAR(80)  NOT NULL,
    telefono          VARCHAR(9)   DEFAULT NULL,
    CONSTRAINT pk_estudiantes PRIMARY KEY (id_estudiante),
    CONSTRAINT uq_estudiantes_carnet UNIQUE (carnet)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Tabla: prestamos
-- estado: 'Activo' al registrar el préstamo, 'Devuelto' al devolver el libro.
CREATE TABLE prestamos (
    id_prestamo      INT         NOT NULL AUTO_INCREMENT,
    id_estudiante    INT         NOT NULL,
    id_libro         INT         NOT NULL,
    fecha_prestamo   DATE        NOT NULL,
    fecha_devolucion DATE        NOT NULL,
    estado           VARCHAR(20) NOT NULL DEFAULT 'Activo',
    CONSTRAINT pk_prestamos PRIMARY KEY (id_prestamo),
    CONSTRAINT fk_prestamos_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiantes (id_estudiante)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_prestamos_libro FOREIGN KEY (id_libro)
        REFERENCES libros (id_libro)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;


-- Datos de prueba
INSERT INTO categorias (id_categoria, nombre_categoria) VALUES
(1, 'Programación y Desarrollo'),
(2, 'Bases de Datos'),
(3, 'Ingeniería de Software'),
(4, 'Sistemas y Redes');

INSERT INTO libros (id_libro, titulo, autor, isbn, id_categoria, cantidad_disponible) VALUES
(1, 'Java Core Vol. 1',             'Cay S. Horstmann',     '978-0135166307', 1, 3),
(2, 'Aprende SQL en 10 Minutos',    'Sams Publishing',      '978-0672336072', 2, 2),
(3, 'Clean Code',                   'Robert C. Martin',     '978-0132350884', 3, 1),
(4, 'Sistemas Operativos Modernos', 'Andrew S. Tanenbaum',  '978-0133591620', 4, 0),
(5, 'Redes de Computadoras',        'Andrew S. Tanenbaum',  '978-0132126953', 4, 2);

INSERT INTO estudiantes (id_estudiante, carnet, nombre_estudiante, carrera, telefono) VALUES
(1, 'AB123456', 'Juan Pérez',    'Ingeniería en Computación', '7788-9900'),
(2, 'CD654321', 'María López',   'Ingeniería Industrial',     '7123-4567'),
(3, 'EF987654', 'Carlos Gómez',  'Ingeniería en Sistemas',    '7890-1234');

-- Las fechas son relativas al día en que se ejecuta el script, así siempre hay
-- un préstamo vigente, uno vencido y uno devuelto, sin importar cuándo se pruebe.
INSERT INTO prestamos (id_prestamo, id_estudiante, id_libro, fecha_prestamo, fecha_devolucion, estado) VALUES
(1, 1, 1, DATE_SUB(CURDATE(), INTERVAL 1 DAY),  DATE_ADD(CURDATE(), INTERVAL 6 DAY),  'Activo'),   -- vigente
(2, 2, 2, DATE_SUB(CURDATE(), INTERVAL 12 DAY), DATE_SUB(CURDATE(), INTERVAL 5 DAY),  'Devuelto'),  -- devuelto
(3, 3, 3, CURDATE(),                            DATE_ADD(CURDATE(), INTERVAL 7 DAY),  'Activo'),   -- vigente
(4, 1, 5, DATE_SUB(CURDATE(), INTERVAL 21 DAY), DATE_SUB(CURDATE(), INTERVAL 14 DAY), 'Activo');   -- vencido
