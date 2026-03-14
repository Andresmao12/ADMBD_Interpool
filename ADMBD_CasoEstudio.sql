-- ============================================================
--  CASO DE ESTUDIO: Interpool
--  Base de datos: Oracle 19c Enterprise Edition
-- ============================================================

-- ============================================================
-- CREACION DE TABLAS
-- ============================================================
CREATE TABLE Pais (
    id_pais NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    area_territorial NUMBER(10,2),
    numero_habitantes NUMBER -- INT equivalente en Oracle es NUMBER
);


CREATE TABLE Persona (
    id_persona NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    edad NUMBER,
    altura NUMBER(5,2),
    peso NUMBER(5,2),
    estado_civil VARCHAR2(20),
    celular VARCHAR2(30)
);


CREATE TABLE Grupo_terrorista (
    id_grupo_terrorista NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    fecha_origen DATE,
    id_pais NUMBER,
    CONSTRAINT fk_gt_pais FOREIGN KEY (id_pais)
        REFERENCES Pais(id_pais)
);


CREATE TABLE Persona_grupo_terrorista (
    id_grupo_terrorista NUMBER NOT NULL,
    id_persona NUMBER NOT NULL,
    fecha_ingreso DATE,
    fecha_salida DATE,
    es_lider NUMBER(1,0) DEFAULT 0 CHECK (es_lider IN (0,1)),
    principal NUMBER(1,0) DEFAULT 0 CHECK (principal IN (0,1)),
    CONSTRAINT pk_pgt PRIMARY KEY (id_grupo_terrorista, id_persona),
    CONSTRAINT fk_pgt_grupo FOREIGN KEY (id_grupo_terrorista)
        REFERENCES Grupo_terrorista(id_grupo_terrorista),
    CONSTRAINT fk_pgt_persona FOREIGN KEY (id_persona)
        REFERENCES Persona(id_persona)
);


CREATE TABLE Avion (
    id_avion NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    modelo VARCHAR2(50),
    marca VARCHAR2(50),
    capacidad NUMBER(10,2)
);


CREATE TABLE Oceano (
    id_oceano NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    extension NUMBER(10,2),
    nombre VARCHAR2(50) NOT NULL
);


CREATE TABLE Tipo_barco (
    id_tipo_barco NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL
);


CREATE TABLE Atentado (
    id_atentado NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo NUMBER,
    fecha DATE,
    descripcion VARCHAR2(900)
);


CREATE TABLE Atentado_aereo (
    id_atentado NUMBER NOT NULL,
    altura NUMBER(10,2),
    id_avion NUMBER,
    CONSTRAINT pk_atentado_aereo PRIMARY KEY (id_atentado),
    CONSTRAINT fk_aa_atentado FOREIGN KEY (id_atentado)
        REFERENCES Atentado(id_atentado)
    CONSTRAINT fk_aa_avion FOREIGN KEY (id_avion)
        REFERENCES Avion(id_avion)
);


CREATE TABLE Atentado_maritimo (
    id_atentado NUMBER NOT NULL,
    id_tipo_barco NUMBER,
    id_oceano NUMBER,
    CONSTRAINT pk_atentado_maritimo PRIMARY KEY (id_atentado),
    CONSTRAINT fk_am_atentado FOREIGN KEY (id_atentado)
        REFERENCES Atentado(id_atentado),
    CONSTRAINT fk_am_tipo_barco FOREIGN KEY (id_tipo_barco)
        REFERENCES Tipo_barco(id_tipo_barco),
    CONSTRAINT fk_am_oceano FOREIGN KEY (id_oceano)
        REFERENCES Oceano(id_oceano)
);


CREATE TABLE Atentado_grupo_terrorista (
    id_grupo_terrorista NUMBER NOT NULL,
    id_atentado NUMBER NOT NULL,
    CONSTRAINT pk_agt PRIMARY KEY (id_grupo_terrorista, id_atentado),
    CONSTRAINT fk_agt_grupo FOREIGN KEY (id_grupo_terrorista)
        REFERENCES Grupo_terrorista(id_grupo_terrorista),
    CONSTRAINT fk_agt_atentado FOREIGN KEY (id_atentado)
        REFERENCES Atentado(id_atentado)
);


CREATE TABLE Persona_atentado (
    id_atentado NUMBER NOT NULL,
    id_persona NUMBER NOT NULL,
    vivo NUMBER(1,0) DEFAULT 1 CHECK (vivo IN (0,1)),
    CONSTRAINT pk_pa PRIMARY KEY (id_atentado, id_persona),
    CONSTRAINT fk_pa_atentado FOREIGN KEY (id_atentado)
        REFERENCES Atentado(id_atentado),
    CONSTRAINT fk_pa_persona FOREIGN KEY (id_persona)
        REFERENCES Persona(id_persona)
);



-- ============================================================
-- INDICES
-- ============================================================
CREATE INDEX idx_pgt_persona ON Persona_grupo_terrorista(id_persona);
CREATE INDEX idx_pgt_grupo ON Persona_grupo_terrorista(id_grupo_terrorista);
CREATE INDEX idx_agt_atentado ON Atentado_grupo_terrorista(id_atentado);
CREATE INDEX idx_pa_persona ON Persona_atentado(id_persona);
CREATE INDEX idx_atentado_fecha ON Atentado(fecha);
CREATE INDEX idx_gt_pais ON Grupo_terrorista(id_pais);




-- =============================================================================================================================
--  PARTE 2: DATOS DE PRUEBA, CONSULTAS, FUNCIONES, TRIGGERS Y PROCEDIMIENTOS
-- =============================================================================================================================


-- ============================================================
-- SECCIÓN 1: INSERTAMOS DATOS DE PRUEBA
-- ============================================================

-- PAIS
INSERT INTO Pais (nombre, area_territorial, numero_habitantes)
VALUES ('Afganistán', 652230.00, 38928346);
INSERT INTO Pais (nombre, area_territorial, numero_habitantes)
VALUES ('Siria', 185180.00, 17500658);
INSERT INTO Pais (nombre, area_territorial, numero_habitantes)
VALUES ('Iraq', 438317.00, 40222493);
INSERT INTO Pais (nombre, area_territorial, numero_habitantes)
VALUES ('Yemen', 527968.00, 29825964);
INSERT INTO Pais (nombre, area_territorial, numero_habitantes)
VALUES ('Libia', 1759541.00, 6871292);

-- PERSONA
INSERT INTO Persona (nombre, edad, altura, peso, estado_civil, celular)
VALUES ('Khalid Al-Rashid', 35, 1.78, 75.5, 'Soltero', '+93701234567');
INSERT INTO Persona (nombre, edad, altura, peso, estado_civil, celular)
VALUES ('Omar Ibn Yusuf', 42, 1.82, 82.0, 'Casado', '+9647001234567');
INSERT INTO Persona (nombre, edad, altura, peso, estado_civil, celular)
VALUES ('Hassan Al-Nouri', 28, 1.70, 68.3, 'Soltero', '+9639001234567');
INSERT INTO Persona (nombre, edad, altura, peso, estado_civil, celular)
VALUES ('Tariq Marzouq', 31, 1.75, 71.0, 'Divorciado', '+96712345678');
INSERT INTO Persona (nombre, edad, altura, peso, estado_civil, celular)
VALUES ('Yusuf Al-Farouk', 45, 1.68, 79.2, 'Casado', '+21891234567');
INSERT INTO Persona (nombre, edad, altura, peso, estado_civil, celular)
VALUES ('Ahmed Karimi', 26, 1.80, 73.1, 'Soltero', '+96612345678');

-- GRUPO_TERRORISTA
INSERT INTO Grupo_terrorista (nombre, fecha_origen, id_pais)
VALUES ('Al-Shabaab Norte', DATE '2005-03-15', 1);
INSERT INTO Grupo_terrorista (nombre, fecha_origen, id_pais)
VALUES ('Frente Oscuro', DATE '2011-07-20', 2);
INSERT INTO Grupo_terrorista (nombre, fecha_origen, id_pais)
VALUES ('Brigada del Desierto', DATE '2013-01-10', 3);
INSERT INTO Grupo_terrorista (nombre, fecha_origen, id_pais)
VALUES ('Manos del Caos', DATE '2015-09-05', 4);
INSERT INTO Grupo_terrorista (nombre, fecha_origen, id_pais)
VALUES ('Sombra Roja', DATE '2018-11-22', 5);

-- PERSONA_GRUPO_TERRORISTA
INSERT INTO Persona_grupo_terrorista (id_grupo_terrorista, id_persona, fecha_ingreso, fecha_salida, es_lider, principal)
VALUES (1, 1, DATE '2010-06-01', NULL, 1, 1);
INSERT INTO Persona_grupo_terrorista (id_grupo_terrorista, id_persona, fecha_ingreso, fecha_salida, es_lider, principal)
VALUES (1, 2, DATE '2012-03-15', DATE '2018-08-20', 0, 0);
INSERT INTO Persona_grupo_terrorista (id_grupo_terrorista, id_persona, fecha_ingreso, fecha_salida, es_lider, principal)
VALUES (2, 3, DATE '2013-07-10', NULL, 1, 1);
INSERT INTO Persona_grupo_terrorista (id_grupo_terrorista, id_persona, fecha_ingreso, fecha_salida, es_lider, principal)
VALUES (3, 4, DATE '2014-01-20', NULL, 0, 1);
INSERT INTO Persona_grupo_terrorista (id_grupo_terrorista, id_persona, fecha_ingreso, fecha_salida, es_lider, principal)
VALUES (4, 5, DATE '2016-05-12', NULL, 1, 1);
INSERT INTO Persona_grupo_terrorista (id_grupo_terrorista, id_persona, fecha_ingreso, fecha_salida, es_lider, principal)
VALUES (5, 6, DATE '2019-02-28', NULL, 0, 0);

-- AVION
INSERT INTO Avion (modelo, marca, capacidad)
VALUES ('737-800', 'Boeing', 162.00);
INSERT INTO Avion (modelo, marca, capacidad)
VALUES ('A320', 'Airbus', 150.00);
INSERT INTO Avion (modelo, marca, capacidad)
VALUES ('CRJ-900', 'Bombardier', 90.00);
INSERT INTO Avion (modelo, marca, capacidad)
VALUES ('ATR 72', 'ATR', 70.00);

-- OCEANO
INSERT INTO Oceano (extension, nombre)
VALUES (165250000.00, 'Océano Pacífico');
INSERT INTO Oceano (extension, nombre)
VALUES (106460000.00, 'Océano Atlántico');
INSERT INTO Oceano (extension, nombre)
VALUES (70560000.00, 'Océano Índico');
INSERT INTO Oceano (extension, nombre)
VALUES (14060000.00, 'Océano Ártico');

-- TIPO_BARCO
INSERT INTO Tipo_barco (nombre) VALUES ('Buque de carga');
INSERT INTO Tipo_barco (nombre) VALUES ('Tanquero');
INSERT INTO Tipo_barco (nombre) VALUES ('Portacontenedores');
INSERT INTO Tipo_barco (nombre) VALUES ('Buque de pasajeros');
INSERT INTO Tipo_barco (nombre) VALUES ('Fragata');

-- ATENTADO
INSERT INTO Atentado (codigo, fecha, descripcion)
VALUES (1001, DATE '2019-04-21', 'Atentado aéreo sobre zona urbana al norte');
INSERT INTO Atentado (codigo, fecha, descripcion)
VALUES (1002, DATE '2020-08-04', 'Explosión en puerto marítimo comercial');
INSERT INTO Atentado (codigo, fecha, descripcion)
VALUES (1003, DATE '2021-03-11', 'Intercepción y derribo de aeronave civil');
INSERT INTO Atentado (codigo, fecha, descripcion)
VALUES (1004, DATE '2022-01-15', 'Ataque a buque petrolero en aguas internacionales');
INSERT INTO Atentado (codigo, fecha, descripcion)
VALUES (1005, DATE '2022-11-30', 'Bombardeo aéreo en zona costera');
INSERT INTO Atentado (codigo, fecha, descripcion)
VALUES (1006, DATE '2023-06-10', 'Hundimiento de embarcación de carga');

-- NOTA: Se agregan FK faltantes del diagrama original (necesarias para consultas del negocio) REVISAR <-------
--       id_avion  en Atentado_aereo    (avion victima del atentado)
--       id_oceano en Atentado_maritimo (oceano donde ocurrio)
ALTER TABLE Atentado_aereo    ADD id_avion  NUMBER REFERENCES Avion(id_avion);
ALTER TABLE Atentado_maritimo ADD id_oceano NUMBER REFERENCES Oceano(id_oceano);

-- ATENTADO_AEREO  (con referencia al avion victima)
INSERT INTO Atentado_aereo (id_atentado, altura, id_avion) VALUES (1, 3500.00, 1);
INSERT INTO Atentado_aereo (id_atentado, altura, id_avion) VALUES (3, 8200.00, 2);
INSERT INTO Atentado_aereo (id_atentado, altura, id_avion) VALUES (5, 1200.00, 1);

-- ATENTADO_MARITIMO  (con referencia al oceano donde ocurrio)
INSERT INTO Atentado_maritimo (id_atentado, id_tipo_barco, id_oceano) VALUES (2, 2, 2);
INSERT INTO Atentado_maritimo (id_atentado, id_tipo_barco, id_oceano) VALUES (4, 2, 3);
INSERT INTO Atentado_maritimo (id_atentado, id_tipo_barco, id_oceano) VALUES (6, 1, 2);

-- ATENTADO_GRUPO_TERRORISTA
INSERT INTO Atentado_grupo_terrorista (id_grupo_terrorista, id_atentado) VALUES (1, 1);
INSERT INTO Atentado_grupo_terrorista (id_grupo_terrorista, id_atentado) VALUES (1, 3);
INSERT INTO Atentado_grupo_terrorista (id_grupo_terrorista, id_atentado) VALUES (2, 2);
INSERT INTO Atentado_grupo_terrorista (id_grupo_terrorista, id_atentado) VALUES (3, 4);
INSERT INTO Atentado_grupo_terrorista (id_grupo_terrorista, id_atentado) VALUES (4, 5);
INSERT INTO Atentado_grupo_terrorista (id_grupo_terrorista, id_atentado) VALUES (5, 6);

-- PERSONA_ATENTADO
INSERT INTO Persona_atentado (id_atentado, id_persona, vivo) VALUES (1, 1, 1);
INSERT INTO Persona_atentado (id_atentado, id_persona, vivo) VALUES (1, 2, 0);
INSERT INTO Persona_atentado (id_atentado, id_persona, vivo) VALUES (2, 3, 1);
INSERT INTO Persona_atentado (id_atentado, id_persona, vivo) VALUES (3, 4, 0);
INSERT INTO Persona_atentado (id_atentado, id_persona, vivo) VALUES (4, 5, 1);
INSERT INTO Persona_atentado (id_atentado, id_persona, vivo) VALUES (5, 6, 0);
INSERT INTO Persona_atentado (id_atentado, id_persona, vivo) VALUES (6, 1, 1);

COMMIT;


-- ============================================================
-- SECCIÓN 2: CONSULTAS
-- ============================================================

-- ------------------------------------------------------------
-- CONSULTA 1 (4 JOINs o más):
-- Enunciado: Listar todas las personas que participaron en
-- atentados aéreos, mostrando el nombre de la persona, el grupo
-- terrorista al que pertenece, el país de origen del grupo,
-- la fecha del atentado y la altura a la que ocurrió.
-- ------------------------------------------------------------
SELECT
    p.nombre                    AS persona,
    gt.nombre                   AS grupo_terrorista,
    pa2.nombre                  AS pais_origen,
    a.fecha                     AS fecha_atentado,
    aa.altura                   AS altura_metros,
    pa_link.vivo                AS sobrevivio
FROM Persona_atentado       pa_link
JOIN Persona                p       ON p.id_persona          = pa_link.id_persona
JOIN Atentado               a       ON a.id_atentado         = pa_link.id_atentado
JOIN Atentado_aereo         aa      ON aa.id_atentado        = a.id_atentado
JOIN Atentado_grupo_terrorista agt  ON agt.id_atentado       = a.id_atentado
JOIN Grupo_terrorista       gt      ON gt.id_grupo_terrorista = agt.id_grupo_terrorista
JOIN Pais                   pa2     ON pa2.id_pais            = gt.id_pais
ORDER BY a.fecha;


-- ------------------------------------------------------------
-- CONSULTA 2 (LEFT JOIN):
-- Enunciado: Listar todos los grupos terroristas con la cantidad
-- de atentados que han cometido, incluyendo los grupos que
-- aún no han sido vinculados a ningún atentado registrado.
-- ------------------------------------------------------------
SELECT
    gt.nombre                           AS grupo_terrorista,
    p.nombre                            AS pais,
    COUNT(agt.id_atentado)              AS total_atentados,
    MIN(a.fecha)                        AS primer_atentado,
    MAX(a.fecha)                        AS ultimo_atentado
FROM Grupo_terrorista           gt
LEFT JOIN Pais                  p   ON p.id_pais             = gt.id_pais
LEFT JOIN Atentado_grupo_terrorista agt ON agt.id_grupo_terrorista = gt.id_grupo_terrorista
LEFT JOIN Atentado              a   ON a.id_atentado          = agt.id_atentado
GROUP BY gt.id_grupo_terrorista, gt.nombre, p.nombre
ORDER BY total_atentados DESC;


-- ------------------------------------------------------------
-- CONSULTA 3 (Operaciones entre conjuntos - UNION):
-- Enunciado: Obtener el listado unificado de todos los tipos
-- de atentados ocurridos (aéreos y marítimos), indicando el
-- tipo, la fecha, la descripción y el detalle específico
-- (altura para aéreos, tipo de barco para marítimos).
-- ------------------------------------------------------------
SELECT
    'AEREO'             AS tipo_atentado,
    a.codigo,
    a.fecha,
    a.descripcion,
    TO_CHAR(aa.altura) || ' metros'  AS detalle_especifico
FROM Atentado a
JOIN Atentado_aereo aa ON aa.id_atentado = a.id_atentado

UNION

SELECT
    'MARITIMO'          AS tipo_atentado,
    a.codigo,
    a.fecha,
    a.descripcion,
    tb.nombre           AS detalle_especifico
FROM Atentado a
JOIN Atentado_maritimo  am ON am.id_atentado  = a.id_atentado
JOIN Tipo_barco         tb ON tb.id_tipo_barco = am.id_tipo_barco

ORDER BY fecha;


-- ------------------------------------------------------------
-- CONSULTA 4 (Subconsulta):
-- Enunciado: Obtener el nombre y la edad de las personas que
-- participaron en más de un atentado, junto con el total de
-- atentados en los que estuvieron involucradas.
-- ------------------------------------------------------------
SELECT
    p.nombre,
    p.edad,
    sub.total_atentados
FROM Persona p
JOIN (
    SELECT
        id_persona,
        COUNT(id_atentado) AS total_atentados
    FROM Persona_atentado
    GROUP BY id_persona
    HAVING COUNT(id_atentado) > 1
) sub ON sub.id_persona = p.id_persona
ORDER BY sub.total_atentados DESC;


-- ============================================================
-- SECCIÓN 3: FUNCIÓN, TRIGGER Y PROCEDIMIENTO ALMACENADO
-- ============================================================

-- ------------------------------------------------------------
-- TABLA DE AUDITORÍA (requerida por el trigger)
-- ------------------------------------------------------------
CREATE TABLE Auditoria_atentado (
    id_auditoria    NUMBER          GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_atentado     NUMBER,
    accion          VARCHAR2(10),   -- INSERT / UPDATE / DELETE
    fecha_accion    DATE            DEFAULT SYSDATE,
    descripcion_ant VARCHAR2(900),
    descripcion_nueva VARCHAR2(900),
    usuario         VARCHAR2(50)    DEFAULT USER
);

-- ------------------------------------------------------------
-- TABLA DE RESUMEN POR GRUPO (usada por el procedimiento)
-- Registra estadísticas consolidadas por grupo terrorista.
-- ------------------------------------------------------------
CREATE TABLE Resumen_grupo_terrorista (
    id_grupo_terrorista NUMBER  PRIMARY KEY,
    total_atentados     NUMBER  DEFAULT 0,
    total_victimas      NUMBER  DEFAULT 0,
    victimas_fallecidas NUMBER  DEFAULT 0,
    ultima_actualizacion DATE,
    CONSTRAINT fk_rgt_grupo FOREIGN KEY (id_grupo_terrorista)
        REFERENCES Grupo_terrorista(id_grupo_terrorista)
);

-- Poblar tabla de resumen con los grupos existentes
INSERT INTO Resumen_grupo_terrorista (id_grupo_terrorista, total_atentados, total_victimas, victimas_fallecidas, ultima_actualizacion)
SELECT id_grupo_terrorista, 0, 0, 0, SYSDATE FROM Grupo_terrorista;
COMMIT;


-- ------------------------------------------------------------
-- FUNCIÓN DE USUARIO:
-- Enunciado: Calcular el nivel de peligrosidad de un grupo
-- terrorista según la cantidad de atentados cometidos y el
-- número de víctimas fatales registradas.
-- Retorna: 'BAJO', 'MEDIO', 'ALTO', 'CRÍTICO'
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_nivel_peligrosidad (
    p_total_atentados   IN NUMBER,
    p_victimas_fatales  IN NUMBER
) RETURN VARCHAR2 IS
    v_score NUMBER;
BEGIN
    v_score := (p_total_atentados * 2) + p_victimas_fatales;
    IF    v_score <= 2  THEN RETURN 'BAJO';
    ELSIF v_score <= 6  THEN RETURN 'MEDIO';
    ELSIF v_score <= 12 THEN RETURN 'ALTO';
    ELSE                     RETURN 'CRÍTICO';
    END IF;
END fn_nivel_peligrosidad;
/


-- ------------------------------------------------------------
-- TRIGGER:
-- Enunciado: Registrar automáticamente en la tabla de auditoría
-- cualquier modificación (INSERT, UPDATE, DELETE) realizada
-- sobre la tabla Atentado, guardando el usuario, la fecha
-- y los valores anteriores/nuevos de la descripción.
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_auditoria_atentado
AFTER INSERT OR UPDATE OR DELETE ON Atentado
FOR EACH ROW
DECLARE
    v_accion VARCHAR2(10);
BEGIN
    IF INSERTING THEN
        v_accion := 'INSERT';
        INSERT INTO Auditoria_atentado (id_atentado, accion, descripcion_ant, descripcion_nueva)
        VALUES (:NEW.id_atentado, v_accion, NULL, :NEW.descripcion);

    ELSIF UPDATING THEN
        v_accion := 'UPDATE';
        INSERT INTO Auditoria_atentado (id_atentado, accion, descripcion_ant, descripcion_nueva)
        VALUES (:NEW.id_atentado, v_accion, :OLD.descripcion, :NEW.descripcion);

    ELSIF DELETING THEN
        v_accion := 'DELETE';
        INSERT INTO Auditoria_atentado (id_atentado, accion, descripcion_ant, descripcion_nueva)
        VALUES (:OLD.id_atentado, v_accion, :OLD.descripcion, NULL);
    END IF;
END trg_auditoria_atentado;
/


-- ------------------------------------------------------------
-- PROCEDIMIENTO ALMACENADO:
-- Enunciado: Actualizar el resumen estadístico de todos los
-- grupos terroristas activos, recalculando el total de
-- atentados cometidos, el total de víctimas y las víctimas
-- fatales por grupo. Además evalúa y muestra el nivel de
-- peligrosidad de cada grupo usando la función de usuario.
-- El proceso es atómico: si falla algún grupo, se revierte
-- todo y se registra el error.
-- ------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_actualizar_resumen_grupos IS

    -- Cursor: recorre todos los grupos terroristas
    CURSOR cur_grupos IS
        SELECT id_grupo_terrorista, nombre
        FROM Grupo_terrorista
        ORDER BY id_grupo_terrorista;

    -- Variables de trabajo
    v_total_atentados   NUMBER;
    v_total_victimas    NUMBER;
    v_victimas_fatales  NUMBER;
    v_nivel             VARCHAR2(20);
    v_grupos_procesados NUMBER := 0;
    v_error_msg         VARCHAR2(500);

BEGIN
    -- Punto de inicio de la transacción atómica
    SAVEPOINT sp_inicio_resumen;

    -- Recorrer cada grupo con el cursor
    FOR rec IN cur_grupos LOOP

        -- 1. Contar atentados del grupo
        SELECT COUNT(DISTINCT agt.id_atentado)
        INTO   v_total_atentados
        FROM   Atentado_grupo_terrorista agt
        WHERE  agt.id_grupo_terrorista = rec.id_grupo_terrorista;

        -- 2. Contar total de personas involucradas en esos atentados
        SELECT COUNT(pa.id_persona)
        INTO   v_total_victimas
        FROM   Persona_atentado             pa
        JOIN   Atentado_grupo_terrorista    agt
               ON agt.id_atentado = pa.id_atentado
        WHERE  agt.id_grupo_terrorista = rec.id_grupo_terrorista;

        -- 3. Contar víctimas fallecidas (vivo = 0)
        SELECT COUNT(pa.id_persona)
        INTO   v_victimas_fatales
        FROM   Persona_atentado             pa
        JOIN   Atentado_grupo_terrorista    agt
               ON agt.id_atentado = pa.id_atentado
        WHERE  agt.id_grupo_terrorista = rec.id_grupo_terrorista
          AND  pa.vivo = 0;

        -- 4. Invocar función de usuario para calcular peligrosidad
        v_nivel := fn_nivel_peligrosidad(v_total_atentados, v_victimas_fatales);

        -- 5. Actualizar o insertar en tabla de resumen
        MERGE INTO Resumen_grupo_terrorista rgt
        USING DUAL
        ON (rgt.id_grupo_terrorista = rec.id_grupo_terrorista)
        WHEN MATCHED THEN
            UPDATE SET
                rgt.total_atentados      = v_total_atentados,
                rgt.total_victimas       = v_total_victimas,
                rgt.victimas_fallecidas  = v_victimas_fatales,
                rgt.ultima_actualizacion = SYSDATE
        WHEN NOT MATCHED THEN
            INSERT (id_grupo_terrorista, total_atentados, total_victimas, victimas_fallecidas, ultima_actualizacion)
            VALUES (rec.id_grupo_terrorista, v_total_atentados, v_total_victimas, v_victimas_fatales, SYSDATE);

        v_grupos_procesados := v_grupos_procesados + 1;

        -- 6. Mostrar resultado por grupo (útil en consola SQL Developer)
        DBMS_OUTPUT.PUT_LINE(
            'Grupo: ' || RPAD(rec.nombre, 30) ||
            ' | Atentados: ' || v_total_atentados ||
            ' | Víctimas: '  || v_total_victimas  ||
            ' | Fallecidos: '|| v_victimas_fatales ||
            ' | Nivel: '     || v_nivel
        );

    END LOOP;

    -- Confirmar todos los cambios si todo fue exitoso
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('✔ Resumen actualizado para ' || v_grupos_procesados || ' grupos. COMMIT realizado.');

EXCEPTION
    WHEN OTHERS THEN
        -- Control de errores: revertir hasta el savepoint
        ROLLBACK TO sp_inicio_resumen;
        v_error_msg := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('✘ ERROR en sp_actualizar_resumen_grupos: ' || v_error_msg);
        DBMS_OUTPUT.PUT_LINE('  Transacción revertida. Ningún dato fue modificado.');
        -- Re-lanzar el error para que el caller también lo capture
        RAISE;
END sp_actualizar_resumen_grupos;
/


-- ============================================================
-- SECCIÓN 4: EJECUCIÓN DE PRUEBA
-- ============================================================

-- Activar salida en consola (SQL Developer / SQL*Plus)
SET SERVEROUTPUT ON;

-- Ejecutar el procedimiento
BEGIN
    sp_actualizar_resumen_grupos;
END;
/

-- Verificar resultados del resumen
SELECT
    gt.nombre                               AS grupo,
    r.total_atentados,
    r.total_victimas,
    r.victimas_fallecidas,
    fn_nivel_peligrosidad(
        r.total_atentados,
        r.victimas_fallecidas
    )                                       AS nivel_peligrosidad,
    r.ultima_actualizacion
FROM Resumen_grupo_terrorista r
JOIN Grupo_terrorista gt ON gt.id_grupo_terrorista = r.id_grupo_terrorista
ORDER BY r.total_atentados DESC;

-- Verificar auditoría (el trigger se dispara automáticamente en cambios)
-- Prueba manual del trigger: actualizar un atentado
UPDATE Atentado
SET descripcion = 'Atentado aéreo actualizado - zona norte confirmada'
WHERE id_atentado = 1;
COMMIT;

SELECT * FROM Auditoria_atentado ORDER BY fecha_accion DESC;

-- ============================================================
-- SECCIÓN 5: CONSULTAS DEL NEGOCIO (Caso de Estudio Interpol)
-- ============================================================

-- ------------------------------------------------------------
-- CONSULTA N1 DEL NEGOCIO:
-- Enunciado: ¿Qué personas fallecieron en un atentado dado?
-- Muestra nombre, edad y datos básicos de las personas que
-- perdieron la vida en el atentado con código 1001.
-- ------------------------------------------------------------
SELECT
    p.nombre            AS persona_fallecida,
    p.edad,
    p.estado_civil,
    a.codigo            AS codigo_atentado,
    a.fecha             AS fecha_atentado,
    a.descripcion
FROM Persona_atentado   pa
JOIN Persona            p   ON p.id_persona  = pa.id_persona
JOIN Atentado           a   ON a.id_atentado = pa.id_atentado
WHERE pa.vivo       = 0          -- 0 = fallecido
  AND a.codigo      = 1001;      -- cambiar código según consulta


-- ------------------------------------------------------------
-- CONSULTA N2 DEL NEGOCIO:
-- Enunciado: ¿En cuántos atentados ha participado cada
-- integrante de un grupo terrorista?
-- Lista el integrante, su grupo y la cantidad de atentados
-- en los que estuvo involucrado.
-- ------------------------------------------------------------
SELECT
    p.nombre                        AS integrante,
    gt.nombre                       AS grupo_terrorista,
    COUNT(DISTINCT pa.id_atentado)  AS atentados_participados
FROM Persona_grupo_terrorista   pgt
JOIN Persona                    p   ON p.id_persona          = pgt.id_persona
JOIN Grupo_terrorista           gt  ON gt.id_grupo_terrorista = pgt.id_grupo_terrorista
LEFT JOIN Persona_atentado      pa  ON pa.id_persona          = pgt.id_persona
GROUP BY p.id_persona, p.nombre, gt.id_grupo_terrorista, gt.nombre
ORDER BY atentados_participados DESC;


-- ------------------------------------------------------------
-- CONSULTA N3 DEL NEGOCIO:
-- Enunciado: ¿De qué país es el grupo terrorista que cometió
-- un atentado dado?
-- Muestra el país de origen del grupo responsable del
-- atentado con código 1002.
-- ------------------------------------------------------------
SELECT
    a.codigo            AS codigo_atentado,
    a.fecha             AS fecha_atentado,
    gt.nombre           AS grupo_terrorista,
    pa.nombre           AS pais_origen,
    pa.numero_habitantes,
    pa.area_territorial
FROM Atentado                       a
JOIN Atentado_grupo_terrorista      agt ON agt.id_atentado         = a.id_atentado
JOIN Grupo_terrorista               gt  ON gt.id_grupo_terrorista  = agt.id_grupo_terrorista
JOIN Pais                           pa  ON pa.id_pais              = gt.id_pais
WHERE a.codigo = 1002;             -- cambiar código según consulta


-- ------------------------------------------------------------
-- CONSULTA N4 DEL NEGOCIO:
-- Enunciado: ¿Cuál es el océano con el mayor número de
-- atentados marítimos registrados en la historia?
-- ------------------------------------------------------------
SELECT
    o.nombre                        AS oceano,
    o.extension                     AS extension_km2,
    COUNT(am.id_atentado)           AS total_atentados_maritimos
FROM Oceano                 o
LEFT JOIN Atentado_maritimo am  ON am.id_oceano = o.id_oceano
GROUP BY o.id_oceano, o.nombre, o.extension
ORDER BY total_atentados_maritimos DESC
FETCH FIRST 1 ROW ONLY;          -- el océano con MÁS atentados


-- ------------------------------------------------------------
-- CONSULTA N5 DEL NEGOCIO:
-- Enunciado: ¿Cuál es el tipo de avión (marca y modelo) con
-- la mayor cantidad de atentados aéreos en la historia?
-- Útil para identificar patrones en el caso Malaysian Airlines.
-- ------------------------------------------------------------
SELECT
    av.marca,
    av.modelo,
    av.capacidad,
    COUNT(aa.id_atentado)           AS total_atentados_aereos
FROM Avion                  av
LEFT JOIN Atentado_aereo    aa  ON aa.id_avion = av.id_avion
GROUP BY av.id_avion, av.marca, av.modelo, av.capacidad
ORDER BY total_atentados_aereos DESC
FETCH FIRST 1 ROW ONLY;          -- el tipo de avión con MÁS atentados

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================
