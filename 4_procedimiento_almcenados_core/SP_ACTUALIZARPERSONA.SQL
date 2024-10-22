create or replace PROCEDURE SP_ACTUALIZARPERSONA 
( IN_ID_PERSONA             IN NUMBER
, IV_NOMBRES                IN VARCHAR2
, IV_APELLIDOS              IN VARCHAR2 
, IV_EMAIL                  IN VARCHAR2 
, IN_SALARIO                IN NUMBER 
, IV_ESTADO                 IN VARCHAR2 
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
  LN_SECCION      := 600;
  if IN_ID_PERSONA is  null OR
     IN_ID_PERSONA <=0 THEN
     LN_CATEGORIA_ID_EXCEPCION  := 1010; 
     LV_MSJ_INICIAL             := 'ID de Persona no es vàlido';
     RAISE LE_VALIDACION_GENERAL;
  END IF;   

  --Validaciòn de existencia del registro de de la persona:
  LN_SECCION  := 602;
  select a.numeroidentificacion
  into   LV_NUMEROIDENTIFICACION
  from personas a
  where a.id = in_id_persona;
  
  --Validaciòn de paràmetros a actualizar:
  --(que al menos uno exista)
  LN_SECCION      := 604;
  if IV_NOMBRES                is null and
     IV_APELLIDOS              is null and
     IV_EMAIL                  is null and
     IN_SALARIO                is null then
     LN_CATEGORIA_ID_EXCEPCION  := 1010;
     LV_MSJ_INICIAL             := 'Faltan paràmetros para la transacciòn';
     RAISE LE_VALIDACION_GENERAL;
  end if;  
  
  
  --Actualizacion de registros
  LN_SECCION  := 606;
  UPDATE personas a 
  set a.nombres     = nvl(iv_nombres,a.nombres)
      ,a.apellidos  = nvl(iv_apellidos,a.apellidos)
      ,a.email      = nvl(iv_email,a.email)
      ,a.salario    = nvl(in_salario,a.salario)
      ,a.estado     = nvl(iv_estado,a.estado)
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
        --CHK1: TIPO DE IDENTIFICACION
        --CHK2: ESTADO
        --CHK3: SALARIO
        ON_ID_RESPUESTA            := -1;   
        ON_CATEGORIA_ID_EXCEPCION  := 1030;
        OV_MSJ_ERROR_TECNICO       := sqlerrm;
        if OV_MSJ_ERROR_TECNICO like '%PERSONAS_CHK1%' then
            OV_MSJ_EXCEPCION        := '[' || ln_seccion ||'] - Tipo de Identificaciòn no vàlido';                 
        elsif OV_MSJ_ERROR_TECNICO like '%PERSONAS_CHK2%' then
            OV_MSJ_EXCEPCION        := '[' || ln_seccion ||'] - Estado no vàlido';                 
        elsif OV_MSJ_ERROR_TECNICO like '%PERSONAS_CHK3%' then
            OV_MSJ_EXCEPCION        := '[' || ln_seccion ||'] - Salario debe ser mayor a 0';
        end if;
    when NO_DATA_FOUND then
        ON_ID_RESPUESTA           := -1; 
        ON_CATEGORIA_ID_EXCEPCION := 1020; 
        OV_MSJ_EXCEPCION          := '[' || ln_seccion ||'] - No existe registro a buscar';
        OV_MSJ_ERROR_TECNICO      := null;
    WHEN OTHERS THEN
        rollback;
        ON_ID_RESPUESTA            := -1;
        ON_CATEGORIA_ID_EXCEPCION  := 1040;
        OV_MSJ_EXCEPCION           := '[' || ln_seccion ||'] - Ha ocurrido un error general al salvar los datos';
        OV_MSJ_ERROR_TECNICO       := substr(sqlerrm,1,150);
END SP_ACTUALIZARPERSONA;
/