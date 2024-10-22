create or replace PROCEDURE SP_AJUSTARSALARIO 
( IN_ID_PERSONA             IN  NUMBER
, ON_NUEVO_SALARIO          OUT NUMBER
, ON_ID_RESPUESTA           OUT NUMBER 
, ON_CATEGORIA_ID_EXCEPCION OUT NUMBER 
, OV_MSJ_EXCEPCION          OUT VARCHAR2 
, OV_MSJ_ERROR_TECNICO      OUT VARCHAR2
) AS 
  LE_VALIDACION_GENERAL         EXCEPTION;
  LN_CATEGORIA_ID_EXCEPCION     NUMBER;
  LV_MSJ_EXCEPCION              VARCHAR2(100);
  LV_MSJ_INICIAL                VARCHAR2(100);
  LN_SECCION                    NUMBER;  
  LV_NUMEROIDENTIFICACION       VARCHAR2(100);
  LN_SALARIO                    NUMBER(10,2);
  LN_NUEVO_SALARIO              NUMBER(10,2);
  LE_CHEK_CONSTRAINTS_GENERAL   Exception;
  Pragma Exception_Init(LE_CHEK_CONSTRAINTS_GENERAL, -2290);
BEGIN
  /*
  Còdigo de respuesta:
  ON_ID_RESPUESTA =  0   Transacciòn OK
  ON_ID_RESPUESTA = -1   Transacciòn no satisfactoria
  
  Codigo de categorìa de excepciòn:
  ON_CATEGORIA_ID_EXCEPCION = 1010    Paràmetros nulos
  ON_CATEGORIA_ID_EXCEPCION = 1020    No hay datos para consultar 
  ON_CATEGORIA_ID_EXCEPCION = 1030    No se cumplen reglas de negocios 
  ON_CATEGORIA_ID_EXCEPCION = 1040    Error tècnico, por ej: divisiòn por zero
  */
  
  ON_ID_RESPUESTA := 0;

  --Validaciòn de ID de la persona:
  LN_SECCION      := 700;
  if IN_ID_PERSONA is  null OR
     IN_ID_PERSONA <=0 THEN
     LN_CATEGORIA_ID_EXCEPCION  := 1010; 
     LV_MSJ_INICIAL             := 'ID de Persona no es vàlido';
     RAISE LE_VALIDACION_GENERAL;
  END IF;   

  --Validaciòn de existencia del registro de de la persona:
  LN_SECCION  := 702;
  select a.SALARIO
  into   LN_SALARIO
  from personas a
  where a.id = in_id_persona;

  --Validacion de regl de actualizacion de salario:
  LN_SECCION  := 606;
  IF LN_SALARIO < 2000 THEN
     LN_NUEVO_SALARIO := ln_salario *1.1;
     ON_NUEVO_SALARIO := LN_NUEVO_SALARIO;
  ELSIF LN_SALARIO >= 2000 THEN
     LN_CATEGORIA_ID_EXCEPCION  := 1030; 
     LV_MSJ_INICIAL             := 'Salario no actualizado. Por encima del rango para aplicar el incremento';
     ON_NUEVO_SALARIO           := 0;
     RAISE LE_VALIDACION_GENERAL;
  END IF;
  
  LN_SECCION  := 608;
  UPDATE personas a 
  set a.salario    = ON_NUEVO_SALARIO
  where a.id = in_id_persona;
  commit;

EXCEPTION

    WHEN LE_VALIDACION_GENERAL THEN
        ON_ID_RESPUESTA           := -1; 
        ON_CATEGORIA_ID_EXCEPCION := ln_categoria_id_excepcion; 
        OV_MSJ_ERROR_TECNICO      := null;
        OV_MSJ_EXCEPCION          := '[' || ln_seccion ||'] - ' || LV_MSJ_INICIAL;
    WHEN LE_CHEK_CONSTRAINTS_GENERAL THEN
        rollback;
        ON_ID_RESPUESTA            := -1;   
        ON_CATEGORIA_ID_EXCEPCION  := 1030; 
        OV_MSJ_ERROR_TECNICO       := sqlerrm;
        OV_MSJ_EXCEPCION           := '[' || ln_seccion ||'] - Salario debe ser mayor a 0';
    when NO_DATA_FOUND then
        ON_ID_RESPUESTA           := -1; 
        ON_CATEGORIA_ID_EXCEPCION := 1020; 
        OV_MSJ_EXCEPCION          := '[' || ln_seccion ||'] - No existe registro a buscar';
        OV_MSJ_ERROR_TECNICO      := null;
    WHEN OTHERS THEN
        rollback;
        ON_ID_RESPUESTA            := -1;
        ON_CATEGORIA_ID_EXCEPCION  := 1040; 
        OV_MSJ_EXCEPCION           := '[' || ln_seccion ||'] - Ha ocurrido un error general al actualizar el salario';
        OV_MSJ_ERROR_TECNICO       := substr(sqlerrm,1,150);
END SP_AJUSTARSALARIO;
/