DECLARE
    iv_nombres                VARCHAR2(200);
    iv_pellidos               VARCHAR2(200);
    iv_numeroidentificacion   VARCHAR2(200);
    iv_tipoidentificacion     VARCHAR2(200);
    iv_email                  VARCHAR2(200);
    in_salario                NUMBER;
    iv_estado                 VARCHAR2(200);
    on_id_respuesta           NUMBER;
    on_categoria_id_excepcion NUMBER;
    ov_msj_excepcion          VARCHAR2(200);
    ov_msj_error_tecnico      VARCHAR2(200);
BEGIN
    iv_nombres                  := 'Leonel';
    iv_pellidos                 := 'Pedrozo';
    iv_numeroidentificacion     := '12400476';
    iv_tipoidentificacion       := 'CC';
    iv_email                    := 'l@clarap.co';
    in_salario                  := 5000;
    iv_estado                   := 'ACTIVO';
    sp_insertarpersona(iv_nombres               => iv_nombres
                    , iv_pellidos               => iv_pellidos
                    , iv_numeroidentificacion   => iv_numeroidentificacion
                    , iv_tipoidentificacion     => iv_tipoidentificacion
                    , iv_email                  => iv_email
                    , in_salario                => in_salario
                    , iv_estado                 => iv_estado
                    , on_id_respuesta           => on_id_respuesta
                    , on_categoria_id_excepcion => on_categoria_id_excepcion
                    , ov_msj_excepcion          => ov_msj_excepcion
                    , ov_msj_error_tecnico      => ov_msj_error_tecnico);
    DBMS_OUTPUT.PUT_LINE('ON_ID_RESPUESTA           = ' || ON_ID_RESPUESTA);
    DBMS_OUTPUT.PUT_LINE('ON_CATEGORIA_ID_EXCEPCION = ' || ON_CATEGORIA_ID_EXCEPCION);
    DBMS_OUTPUT.PUT_LINE('OV_MSJ_EXCEPCION          = ' || OV_MSJ_EXCEPCION);
    DBMS_OUTPUT.PUT_LINE('OV_MSJ_ERROR_TECNICO      = ' || OV_MSJ_ERROR_TECNICO);
END;
