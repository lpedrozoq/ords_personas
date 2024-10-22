# ORDS Personas

Este documento detalla el paso a paso para disponibilizar todos los recursos de la base de datos a partir de los archivos en la carpeta raíz `ords_personas`.

## A tener en cuenta!!!

URI base de la api:
https://gf14df869413d1f-ruma01.adb.us-ashburn-1.oraclecloudapps.com/ords/api/v1/personas

- Nombre de usuario/workspace propietario de los recursos en base de datos:WKSP_RUMA01W1
- La colecciòn postman usa autorizaciòn OAuth2 y ya en ella està incorporada la configuraciòn para obtener el token (dado el client-id y secret-id y URI para obtener token)
- Preferiblemente hacer las pruebas con la colecciòn de postman dada la configuraciòn OAuth2 establecida en ese recurso.

## Pasos para Ejecutar los Archivos en Base de Datos

1. **1_tablas**:

   ```sql
   -- Ejecuta el archivo para crear la tabla PERSONAS
   @1_tablas/PERSONAS.SQL
   ```

2. **2_secuencias**:

   ```sql
   -- Ejecuta el archivo para crear la secuencia SEQ_PERSONAS
   @2_secuencias/SEQ_PERSONAS.sql
   ```

3. **3_triggers**:

   ```sql
   -- Ejecuta los scripts para crear los triggers
   @3_triggers/TRG_PERSONAS_NOMBRES_APELLIDOS.sql
   @3_triggers/TRG_PERSONAS_PK.sql
   ```

4. **4_procedimiento_almcenados_core**:

   ```sql
   -- Ejecuta los procedimientos almacenados core
   @4_procedimiento_almcenados_core/SP_ACTUALIZARPERSONA.SQL
   @4_procedimiento_almcenados_core/SP_AJUSTARSALARIO.SQL
   @4_procedimiento_almcenados_core/SP_INSERTARPERSONA.SQL
   ```

5. **5_procedimiento_almacenados_api**:

   ```sql
   -- Ejecuta los procedimientos almacenados API
   @5_procedimiento_almacenados_api/SP_API_ACTUALIZARPERSONA.SQL
   @5_procedimiento_almacenados_api/SP_API_INSERTARPERSONA.SQL
   ```

6. **6_test_procedimiento_almacenados_core**:

   ```sql
   -- Ejecuta los scripts de prueba para los procedimientos almacenados core
   @6_test_procedimiento_almacenados_core/1-Test-PLSQL-InsertarPersona.sql
   @6_test_procedimiento_almacenados_core/2-Test-PLSQL-ActualizarPersona.sql
   @6_test_procedimiento_almacenados_core/3-Test-PLSQL-BorrarPersona.sql
   @6_test_procedimiento_almacenados_core/4-Test-PLSQL-ActualizarSalarioPersona.sql
   ```

7. **7_scripts_recursos_apis_ords**:
   ```sql
   -- Ejecuta los scripts para crear recursos APIs y OAuth2
   @7_scripts_recursos_apis_ords/1_creacion_recursos_apis_rol_privilegios.sql
   @7_scripts_recursos_apis_ords/2_creacion_client_oauth2.sql
   ```

## Colección Postman

- **Archivo**: `8_coleccion_postman/OCI-Personas-V1.postman_collection.json`

## Documentación Swagger/OpenAPI

Documentación de Swagger/OpenAPI para más detalles sobre los endpoints disponibles:

- **Archivo**: `9_swagger_openapi_documentacion/ords_personas.yaml`
