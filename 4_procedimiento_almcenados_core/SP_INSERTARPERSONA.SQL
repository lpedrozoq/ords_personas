create or replace PROCEDURE SP_INSERTARPERSONA 
( IV_NOMBRES                IN VARCHAR2
, IV_PELLIDOS               IN VARCHAR2 
, IV_NUMEROIDENTIFICACION   IN VARCHAR2 
, IV_TIPOIDENTIFICACION     IN VARCHAR2 
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
  LN_SECCION                    NUMBER;  
  LE_CHEK_CONSTRAINTS_GENERAL   Exception;
  Pragma Exception_Init(LE_CHEK_CONSTRAINTS_GENERAL, -2290);
  LE_UK                         Exception;
  Pragma Exception_Init(LE_UK, -1);

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
  
  ON_ID_RESPUESTA           := 0;
  ON_CATEGORIA_ID_EXCEPCION := null;
  OV_MSJ_EXCEPCION          := null;
  OV_MSJ_ERROR_TECNICO      := null;
  

  --Validaciòn de paràmetros obligatorios:
  LN_SECCION      := 501;
  if IV_NOMBRES               is null or
     IV_PELLIDOS              is null or
     IV_NUMEROIDENTIFICACION  is null or
     IV_TIPOIDENTIFICACION    is null or
     IV_EMAIL                 is null or
     IN_SALARIO               is null then
     LN_CATEGORIA_ID_EXCEPCION  := 1010;
     RAISE LE_VALIDACION_GENERAL;
  end if;  
  
  --Inserciòn del registro
  LN_SECCION  := 504;
  INSERT INTO personas (
    nombres,
    apellidos,
    numeroidentificacion,
    tipoidentificacion,
    email,
    salario,
    estado
    ) VALUES (
     IV_NOMBRES
    ,IV_PELLIDOS
    ,IV_NUMEROIDENTIFICACION
    ,IV_TIPOIDENTIFICACION
    ,IV_EMAIL
    ,IN_SALARIO
    ,IV_ESTADO
    );
    commit;
EXCEPTION
    WHEN LE_VALIDACION_GENERAL THEN
        ON_ID_RESPUESTA           := -1; 
        ON_CATEGORIA_ID_EXCEPCION := ln_categoria_id_excepcion; 
        OV_MSJ_ERROR_TECNICO      := null;
        OV_MSJ_EXCEPCION          := '(' || ln_seccion ||') - Faltan paràmetros para la transacciòn';
    WHEN LE_CHEK_CONSTRAINTS_GENERAL THEN
        --CHK1: TIPO DE IDENTIFICACION
        --CHK2: ESTADO
        --CHK3: SALARIO
        --Transacciòn con errores
        ON_ID_RESPUESTA             := -1;   
        ON_CATEGORIA_ID_EXCEPCION   := 1030;
        OV_MSJ_ERROR_TECNICO        := sqlerrm;
        if OV_MSJ_ERROR_TECNICO like '%PERSONAS_CHK1%' then
            OV_MSJ_EXCEPCION        := '(' || ln_seccion ||') - Tipo de Identificaciòn no vàlido';                 
        elsif OV_MSJ_ERROR_TECNICO like '%PERSONAS_CHK2%' then
            OV_MSJ_EXCEPCION        := '(' || ln_seccion ||') - Estado no vàlido';                 
        elsif OV_MSJ_ERROR_TECNICO like '%PERSONAS_CHK3%' then
            OV_MSJ_EXCEPCION        := '(' || ln_seccion ||') - Salario debe ser mayor a 0';
        end if;
    WHEN LE_UK THEN
        ON_ID_RESPUESTA           := -1; 
        ON_CATEGORIA_ID_EXCEPCION := 1040; 
        OV_MSJ_EXCEPCION          := '(' || ln_seccion ||') - Nùmero de identificaciòn ya existente';
        OV_MSJ_ERROR_TECNICO      := REPLACE(substr(sqlerrm,1,150),'"', '');
    WHEN OTHERS THEN
        ON_ID_RESPUESTA            := -1;
        ON_CATEGORIA_ID_EXCEPCION  := 1040;
        OV_MSJ_EXCEPCION           := '(' || ln_seccion ||') - Ha ocurrido un error general al salvar los datos';
        OV_MSJ_ERROR_TECNICO       :=  REPLACE(substr(sqlerrm,1,150),'"', '');
END SP_INSERTARPERSONA;
/