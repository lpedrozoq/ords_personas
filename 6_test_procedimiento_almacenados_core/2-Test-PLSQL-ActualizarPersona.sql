DECLARE
    in_id_persona             number;
    iv_nombres                VARCHAR2(200);
    iv_apellidos              VARCHAR2(200);
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
    in_id_persona               := 3;
    iv_nombres                  := 'Angelita';
    iv_apellidos                 := 'Quiroz de Pedrozo';
    --iv_email                    := 'a@clarap.co';
    --in_salario                  := 1;
    --iv_estado                   := 'ACTIVO';
    sp_actualizarpersona(in_id_persona              => in_id_persona
                        , iv_nombres                => iv_nombres
                        , iv_apellidos              => iv_apellidos
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
