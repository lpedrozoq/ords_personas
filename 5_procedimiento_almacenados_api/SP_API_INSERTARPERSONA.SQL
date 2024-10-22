create or replace PROCEDURE SP_API_INSERTARPERSONA 
( icl_request        clob
 ,ocl_response   out clob 
 ,on_status_code out integer) AS 
 
  LN_SECCION                  NUMBER;  
  lv_nombres                  varchar2(50);
  lv_apellidos                varchar2(50);
  lv_numeroidentificacion     varchar2(20);
  lv_tipoidentificacion       varchar2(5);
  lv_email                    varchar2(100);
  ln_salario                  number(10,2);
  lv_estado                   varchar2(10);
  ln_id_respuesta             NUMBER;
  ln_categoria_id_excepcion   NUMBER;
  lv_msj_excepcion            VARCHAR2(200);
  lv_msj_error_tecnico        VARCHAR2(200);
  
  
  ljs_request       JSON_OBJECT_T; 
  ljs_response      JSON_OBJECT_T;
  
  GENERAL_EX    EXCEPTION;
  LV_ERROR      varchar2(1000);

BEGIN
  LN_SECCION  := 5500;
  OWA_UTIL.mime_header('application/json');
  ljs_response   := JSON_OBJECT_T();
  on_status_code := 200;
  
  BEGIN
    LN_SECCION  := 5501;
    ljs_request := JSON_OBJECT_T.PARSE(icl_request);
  EXCEPTION 
    WHEN OTHERS THEN
       on_status_code := 500;
       ljs_response.put('codigo_respuesta',      -1);
       ljs_response.put('categoria_respuesta',   1040);
       ljs_response.put('descripcion_excepcion', 'Mensaje no vàlido');
       ljs_response.put('descripcion_tecnica',   substr(sqlerrm,1,150));
       ocl_response := ljs_response.to_clob;
       return;
  END;

  LN_SECCION               := 5502;
  lv_nombres               := ljs_request.GET_STRING('nombres');
  lv_apellidos             := ljs_request.GET_STRING('apellidos');
  lv_numeroidentificacion  := ljs_request.GET_STRING('numero_identificacion');
  lv_tipoidentificacion    := ljs_request.GET_STRING('tipo_identificacion');
  lv_email                 := ljs_request.GET_STRING('email');
  ln_salario               := ljs_request.get_number('salario');
  lv_estado                := ljs_request.GET_STRING('estado');

  sp_insertarpersona(iv_nombres                 => lv_nombres
                    , iv_pellidos               => lv_apellidos
                    , iv_numeroidentificacion   => lv_numeroidentificacion
                    , iv_tipoidentificacion     => lv_tipoidentificacion
                    , iv_email                  => lv_email
                    , in_salario                => ln_salario
                    , iv_estado                 => lv_estado
                    , on_id_respuesta           => ln_id_respuesta
                    , on_categoria_id_excepcion => ln_categoria_id_excepcion
                    , ov_msj_excepcion          => lv_msj_excepcion
                    , ov_msj_error_tecnico      => lv_msj_error_tecnico);

  ljs_response.put('codigo_respuesta',      ln_id_respuesta);
  ljs_response.put('categoria_respuesta',   ln_categoria_id_excepcion);
  ljs_response.put('descripcion_excepcion', lv_msj_excepcion);
  ljs_response.put('descripcion_tecnica',   lv_msj_error_tecnico);
  ocl_response := ljs_response.to_clob;
  
EXCEPTION
    WHEN OTHERS THEN
       on_status_code := 500;
       ljs_response.put('codigo_respuesta',      -1);
       ljs_response.put('categoria_respuesta',   1040);
       ljs_response.put('descripcion_excepcion', 'Ha ocurrido un error inesperado en la invocación en la api');
       ljs_response.put('descripcion_tecnica',   substr(sqlerrm,1,150));
       ocl_response := ljs_response.to_clob;
END SP_API_INSERTARPERSONA;
/