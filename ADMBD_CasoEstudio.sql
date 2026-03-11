-- ============================================================
--  ESQUEMA: Sistema de Atentados Terroristas
--  Base de datos: Oracle 19c Enterprise Edition
--  Generado a partir del diagrama ER
--  Nota: Se infiere tabla ATENTADO como entidad padre de
--        Atentado_aereo y Atentado_maritimo (supertype)
-- ============================================================

-- ============================================================
-- 1. PAIS
-- ============================================================
CREATE TABLE Pais (
    id_pais             NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre              VARCHAR2(50)    NOT NULL,
    area_territorial    NUMBER(10,2),
    numero_habitantes   NUMBER          -- INT equivalente en Oracle es NUMBER
);

-- ============================================================
-- 2. PERSONA
-- ============================================================
CREATE TABLE Persona (
    id_persona      NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre          VARCHAR2(50)    NOT NULL,
    edad            NUMBER,
    altura          NUMBER(5,2),
    peso            NUMBER(5,2),
    estado_civil    VARCHAR2(20),
    celular         VARCHAR2(30)
);

-- ============================================================
-- 3. GRUPO_TERRORISTA
-- ============================================================
CREATE TABLE Grupo_terrorista (
    id_grupo_terrorista NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre              VARCHAR2(50)   NOT NULL,
    fecha_origen        DATE,
    id_pais             NUMBER,
    CONSTRAINT fk_gt_pais FOREIGN KEY (id_pais)
        REFERENCES Pais(id_pais)
);

-- ============================================================
-- 4. PERSONA_GRUPO_TERRORISTA
--    (tabla puente: una persona puede pertenecer a varios grupos)
-- ============================================================
CREATE TABLE Persona_grupo_terrorista (
    id_grupo_terrorista NUMBER      NOT NULL,
    id_persona          NUMBER      NOT NULL,
    fecha_ingreso       DATE,
    fecha_salida        DATE,
    es_lider            NUMBER(1,0) DEFAULT 0 CHECK (es_lider IN (0,1)),   -- BOOL en Oracle
    principal           NUMBER(1,0) DEFAULT 0 CHECK (principal IN (0,1)),  -- BOOL en Oracle
    CONSTRAINT pk_pgt PRIMARY KEY (id_grupo_terrorista, id_persona),
    CONSTRAINT fk_pgt_grupo  FOREIGN KEY (id_grupo_terrorista)
        REFERENCES Grupo_terrorista(id_grupo_terrorista),
    CONSTRAINT fk_pgt_persona FOREIGN KEY (id_persona)
        REFERENCES Persona(id_persona)
);

-- ============================================================
-- 5. AVION
-- ============================================================
CREATE TABLE Avion (
    id_avion    NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    modelo      VARCHAR2(50),
    marca       VARCHAR2(50),
    capacidad   NUMBER(10,2)
);

-- ============================================================
-- 6. OCEANO
-- ============================================================
CREATE TABLE Oceano (
    id_oceano   NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    extension   NUMBER(10,2),
    nombre      VARCHAR2(50)    NOT NULL
);

-- ============================================================
-- 7. TIPO_BARCO
-- ============================================================
CREATE TABLE Tipo_barco (
    id_tipo_barco   NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre          VARCHAR2(50)    NOT NULL
);

-- ============================================================
-- 8. ATENTADO  (supertype / tabla padre inferida)
--    Centraliza el identificador compartido por los subtipos
--    aereo y maritimo. Se usa herencia de tabla por subtipo.
-- ============================================================
CREATE TABLE Atentado (
    id_atentado     NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo          NUMBER,
    fecha           DATE,
    descripcion     VARCHAR2(900)
);

-- ============================================================
-- 9. ATENTADO_AEREO  (subtipo)
-- ============================================================
CREATE TABLE Atentado_aereo (
    id_atentado NUMBER          NOT NULL,
    altura      NUMBER(10,2),
    CONSTRAINT pk_atentado_aereo  PRIMARY KEY (id_atentado),
    CONSTRAINT fk_aa_atentado FOREIGN KEY (id_atentado)
        REFERENCES Atentado(id_atentado)
);

-- ============================================================
-- 10. ATENTADO_MARITIMO  (subtipo)
-- ============================================================
CREATE TABLE Atentado_maritimo (
    id_atentado     NUMBER  NOT NULL,
    id_tipo_barco   NUMBER,
    CONSTRAINT pk_atentado_maritimo PRIMARY KEY (id_atentado),
    CONSTRAINT fk_am_atentado   FOREIGN KEY (id_atentado)
        REFERENCES Atentado(id_atentado),
    CONSTRAINT fk_am_tipo_barco FOREIGN KEY (id_tipo_barco)
        REFERENCES Tipo_barco(id_tipo_barco)
);

-- ============================================================
-- 11. ATENTADO_GRUPO_TERRORISTA
--     (tabla puente entre Atentado y Grupo_terrorista)
-- ============================================================
CREATE TABLE Atentado_grupo_terrorista (
    id_grupo_terrorista NUMBER  NOT NULL,
    id_atentado         NUMBER  NOT NULL,
    CONSTRAINT pk_agt PRIMARY KEY (id_grupo_terrorista, id_atentado),
    CONSTRAINT fk_agt_grupo     FOREIGN KEY (id_grupo_terrorista)
        REFERENCES Grupo_terrorista(id_grupo_terrorista),
    CONSTRAINT fk_agt_atentado  FOREIGN KEY (id_atentado)
        REFERENCES Atentado(id_atentado)
);

-- ============================================================
-- 12. PERSONA_ATENTADO
--     (tabla puente: personas involucradas en un atentado)
--     *** RELACION MARCADA COMO "REVISAR" EN EL DIAGRAMA ***
--     Se mantiene con las columnas visibles en el ER.
--     Verificar si la cardinalidad debe ser N:M o 1:N.
-- ============================================================
CREATE TABLE Persona_atentado (
    id_atentado NUMBER      NOT NULL,
    id_persona  NUMBER      NOT NULL,
    vivo        NUMBER(1,0) DEFAULT 1 CHECK (vivo IN (0,1)),  -- BOOL
    CONSTRAINT pk_pa PRIMARY KEY (id_atentado, id_persona),
    CONSTRAINT fk_pa_atentado FOREIGN KEY (id_atentado)
        REFERENCES Atentado(id_atentado),
    CONSTRAINT fk_pa_persona  FOREIGN KEY (id_persona)
        REFERENCES Persona(id_persona)
);

-- ============================================================
-- INDICES SUGERIDOS (rendimiento en consultas frecuentes)
-- ============================================================
CREATE INDEX idx_pgt_persona      ON Persona_grupo_terrorista(id_persona);
CREATE INDEX idx_pgt_grupo        ON Persona_grupo_terrorista(id_grupo_terrorista);
CREATE INDEX idx_agt_atentado     ON Atentado_grupo_terrorista(id_atentado);
CREATE INDEX idx_pa_persona       ON Persona_atentado(id_persona);
CREATE INDEX idx_atentado_fecha   ON Atentado(fecha);
CREATE INDEX idx_gt_pais          ON Grupo_terrorista(id_pais);

-- ============================================================
-- COMENTARIOS DE TABLA (buenas prácticas Oracle)
-- ============================================================
COMMENT ON TABLE Atentado                    IS 'Supertype de atentados. Subtypes: Atentado_aereo, Atentado_maritimo';
COMMENT ON TABLE Persona_atentado            IS 'REVISAR RELACION: verificar cardinalidad y si aplica herencia de rol (victima/perpetrador)';
COMMENT ON TABLE Persona_grupo_terrorista    IS 'Historial de membresía de personas en grupos terroristas';
COMMENT ON TABLE Atentado_grupo_terrorista   IS 'Grupos responsables de cada atentado';

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================D